require("prototypes.functions.functions-mod-data")

local mod_data = prototypes.mod_data.omnimods.data

local building_tiers = {
    ["compression-compact-buildings"] = "compact",
    ["compression-nanite-buildings"] = "nanite",
    ["compression-quantum-buildings"] = "quantum",
    ["compression-singularity-buildings"] = "singularity"
}
local tier_numbers = {
    compact = 1,
    nanite = 2,
    quantum = 3,
    singularity = 4
}

local function memoize(source)
    local t = {}
    setmetatable(t, {
        __index = function(self, index)
            rawset(self, index, source[index])
            return rawget(self, index)
        end
    })
    return t
end

local update_queue = {
    finished = {},
    reversed = {}
}

local function get_relative_tier(recipe_name, offset)
    offset = offset or 1
    local is_omniperm = recipe_name:find("%-omniperm")
    local is_omnifluid = recipe_name:find("%-T%-")
    local pattern = "%-(%a)" .. ((is_omniperm and "(%-omniperm%-%d%-%d)") or (is_omnifluid and "%-T%-%d+") or "(.?)") .. "$"
    local pos = recipe_name:find(pattern)
    if pos and recipe_name:match("omni") then -- Let's not break other mods upgrades
        local tier = recipe_name:sub(pos+1,pos+1)
        local new_tier = string.char(string.byte(tier) + offset)
        return recipe_name:sub(1, pos) .. new_tier .. recipe_name:sub(pos+2)
    end
end

local function update_building_recipes()
    --log("Updating buildings that use tiered recipes")
    -- User preference
    if not settings.global["omnilib-autoupdate"].value then
        return
    end
    -- Make sure every entity using a tiered recipe (i.e. omnitraction) is up to the current tier
    local correlated_recipes = storage.omni.correlated_recipes
    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered({type="assembling-machine"})) do
            for _, force in pairs(game.forces) do
                local force_recs = memoize(force.recipes)
                if entity.force == force then
                    local current_recipe = entity.get_recipe()
                    if current_recipe then
                        local current_recipe_name = current_recipe.name
                        -- Iterate until we hit a locked recipe
                        local function find_top(candidate, best)
                            local recipe_meta = correlated_recipes[candidate] or {}
                            local is_compressed = recipe_meta.compressed == candidate
                            local upgrade = recipe_meta.upgrade -- If we're using compressed make sure we get the right upgrade
                            upgrade = upgrade and (is_compressed and correlated_recipes[upgrade].compressed or upgrade)
                            upgrade = upgrade and force_recs[upgrade]
                            if upgrade then
                                local upgrade_name = upgrade.name
                                return find_top(upgrade_name, upgrade.enabled and upgrade_name or best) -- tail call
                            else -- We may have cases where the we unlock several techs and the enabled recipes aren't contiguous
                                return best
                            end
                        end
                        local new_recipe = find_top(current_recipe_name, current_recipe_name)
                        -- Work to do?
                        if new_recipe and new_recipe ~= current_recipe_name then
                            local ingredients = {}
                            if entity.is_crafting() then
                                ingredients = current_recipe.ingredients or {}
                            end
                            entity.set_recipe(new_recipe)
                            local updated_ingredients = 0
                            for _, ingredient in pairs(ingredients) do
                                if ingredient.type == "item" then
                                    updated_ingredients = updated_ingredients + entity.insert({
                                        name = ingredient.name,
                                        count = ingredient.amount
                                    })
                                elseif ingredient.type == "fluid" then
                                    updated_ingredients = updated_ingredients + entity.insert_fluid({
                                        name = ingredient.name,
                                        amount = ingredient.amount
                                    })
                                end
                            end
                            log("\tSet " .. entity.name .. " from recipe \"" .. current_recipe_name .. "\" to \"" .. new_recipe .. "\"")
                            if updated_ingredients ~= 0 then
                                log("\t\tMigrated " .. updated_ingredients .. " ingredients")
                            end
                        end
                    end
                end
            end
        end
    end
    --log("Building update complete")
end

---@param technology LuaTechnology
local function omnidate(technology)
    log("beginning omnidate")
    local game = game
    -- Clear cached lists?
    local clear_caches = storage.omni and storage.omni.clear_caches
    -- Check every recipe/tech?
    local full_iter = storage.omni and storage.omni.full_iter
     -- Record time spent
    local profiler = helpers.create_profiler()
    local logger = storage.omni and storage.omni.log_to_chat and game.print or log
    local logmsg = {"", -- clear_caches is overriden below, so we store the log message here
        "Omnidate ",
        "(",
        ((clear_caches and "full") or (technology and technology.name) or ""),
        ")",
        (full_iter and " (partial)" or ""),
        " completed. ",
        profiler
    }
    -- Storages
    if clear_caches then
        storage.omni = {}
        storage.omni.correlated_recipes = {}
        storage.omni.recipe_techs = {}
        storage.omni.stock_recs = {}
    end
    -- Make sure we don't trigger ourselves
    storage.omni.needs_update = true
    -- No omnicompression, no omnimatter
    if not settings.startup["omnicompression_one_list"] and not settings.startup["omnimatter-beginner-multiplier"] then
        profiler.stop()
        storage.omni.needs_update = false
        return
    end

    -- Proxies
    local correlated_recipes = storage.omni.correlated_recipes
    local recipe_techs = storage.omni.recipe_techs
    local stock_recs = storage.omni.stock_recs
    local relevant_techs = {} -- only used when doing a full update, is a join of recipe_techs and mod_data.technologies
    -- Game items
    local forces = game.forces
    local cached_protos = memoize(prototypes.recipe)
    local cached_techs = memoize(prototypes.technology)
    -- Conditional (if we're just doing one tech)
    local tech_force = technology and technology.force or nil
    --
    -- Here we go!
    --
    -- Skip the stuff we don't need to re-do if we aren't clearing caches
    if clear_caches then
        --[[
            base_or_compressed_or_building={
                base = recipe_name,
                compressed = compressed_name,
                upgrade = next_tier_name,
                downgrade = previous_tier_name,
                compact = compact_recipe_name
            }
        ]]
        -- First, build a table of recipes, correlating compressed and uncompressed variants
        for recipe_name, recipe_mod_data in pairs(mod_data.compressed_recipes) do
            local rmeta = correlated_recipes[recipe_name] or {}
            for relation_type, related_recipe_name in pairs(recipe_mod_data) do
                local cached_rec = cached_protos[related_recipe_name]
                if not cached_rec then
                    log(string.format("WARNING: invalid recipe \"%s\" found in mod-data", related_recipe_name))
                else-- Link (pointer) for other possible lookup names
                    rmeta[relation_type] = related_recipe_name
                    correlated_recipes[related_recipe_name] = rmeta
                    -- If it's unlocked by default, make sure we know that
                    if cached_rec.enabled then
                        stock_recs[#stock_recs+1] = rmeta
                    end
                end
            end
            if rmeta.base then -- If we've found recipes, see if they have relative tiers
                local upgrade = get_relative_tier(rmeta.base) or ""
                upgrade = cached_protos[upgrade] and upgrade or nil
                rmeta.upgrade = upgrade
                local downgrade = get_relative_tier(rmeta.base, -1) or ""
                downgrade = cached_protos[downgrade] and downgrade or nil
                rmeta.downgrade = downgrade
                correlated_recipes[recipe_name] = rmeta
            end
        end

        -- Second, list techs that unlock recipes
        for tech_name, tech in pairs(prototypes.technology) do
            local techrec = recipe_techs[tech_name] or {}
            local has_added = false
            for _, effect in pairs(tech.effects) do
                if effect.type == "unlock-recipe" then
                    local effect_recipe = effect.recipe
                    has_added = true
                    techrec[effect_recipe] = correlated_recipes[effect_recipe]
                end
            end
            if has_added then
                recipe_techs[tech_name] = techrec
            end
        end

        -- Third, build a list of the two combined for iteration
        for tech_name in pairs(recipe_techs) do
            relevant_techs[tech_name] = true
        end
        for tech_name, tech_meta in pairs(mod_data.compressed_technologies) do
            -- only enter uncompressed techs
            if tech_meta.base == tech_name and tech_meta.compressed ~= nil then
                relevant_techs[tech_name] = true
            end
        end
    end

    -- Act as if cache has been cleared from here forward, if full_iter was specified
    clear_caches = clear_caches or full_iter or false

    -- Now we see which forces we actually need to check
    local force_queue = {}
    if tech_force then
        force_queue[tech_force.name] = tech_force
    else -- Add any forces with players otherwise
        for force_name, force in pairs(forces) do
            if #force.players > 0 or force_name == "player" then
                force_queue[force_name] = force
            end
        end
    end

    -- Iterate each (valid) force
    for force_name, force in pairs(force_queue) do
        -- Localise where applicable
        local cached_recs = memoize(force.recipes)
        local force_techs = memoize(force.technologies)
        local has_compression = force_techs["compression-recipes"] and force_techs["compression-recipes"].researched or false
        local technology_name = technology and technology.name or ""
        -- If we're just a single compressed tech, we can just mark the sister tech for processing on the next tick and exit
        if technology and omni.lib.is_compressed_tech(technology_name) then
            -- Sync status between compressed and non-compressed techs
            local variant = force_techs[omni.lib.uncompressed_tech_of(technology_name) or ""]
            if variant then
                local tech_level = technology.level
                if tech_level and variant.level ~= tech_level then
                    variant.level = tech_level
                end
                local tech_researched = technology.researched
                if tech_researched ~= variant.researched then
                    variant.researched = tech_researched
                end
                local queue = update_queue[tech_researched and 'finished' or 'reversed']
                queue[#queue+1] = variant
                break
            end
        end
        -- Mark which building tiers are unlocked, used when checking recipes later
        local tiers_unlocked = {}
        for tier_tech, tier_name in pairs(building_tiers) do
            local tech = force_techs[tier_tech]
            local compressed_tech = force_techs[omni.lib.compressed_tech_of(tier_tech) or ""]
            if tech then
                tiers_unlocked[tier_name] = tech.researched -- TODO: See if it works when unlocking via compressed tech
                -- Also hide tiers that are locked out by the setting
                tech.enabled = tier_numbers[tier_name] <= settings.startup["omnicompression_building_levels"].value
                if compressed_tech then
                    compressed_tech.enabled = tech.enabled
                end
            end
        end
        -- It's defined here since scope --_(v-v)_--
        local function process_rec(rec_name, rec_meta, toggle)
            toggle = not not toggle
            for key_name, key_value in pairs(rec_meta) do
                local is_tier = tiers_unlocked[key_name]
                if is_tier ~= nil then
                    cached_recs[key_value].enabled = toggle and is_tier
                elseif key_name == "compressed" then
                    cached_recs[key_value].enabled = toggle and has_compression
                elseif key_name == "downgrade" then -- If we're enabled, disable downgrade
                    local downgrade_rec = cached_recs[key_value]
                    downgrade_rec.enabled = not toggle
                    -- Compressed version as well
                    local compressed_downgrade = correlated_recipes[downgrade_rec.name].compressed
                    if compressed_downgrade then
                        compressed_downgrade = cached_recs[compressed_downgrade]
                        compressed_downgrade.enabled = has_compression and not toggle
                    end
                end
            end
        end
        -- Handle tech syncing, either all techs (/omnidatefull) or one tech (research or editor mode unlock/re-lock)
        local techs_to_iterate = (clear_caches and relevant_techs) or (technology and {[technology_name] = true})
        for tech_name in pairs(techs_to_iterate) do
            local tech = force_techs[tech_name]
            local tech_researched = tech.researched
            local variant = force_techs[omni.lib.compressed_tech_of(tech_name) or ""]
            -- If there's a variant, sync the two. Here we assume unlocks have priority over locks.
            if variant then
                local tech_level = tech.level
                local variant_level = variant.level
                if tech_level and tech_level ~= variant_level then -- level-tiered techs
                    if technology then -- single-tech omnidate means we use whichever status this tech has
                        variant.level = tech_level
                    elseif tech_level > variant_level then -- setting involves an API call, so we do this to save time
                        variant.level = tech_level
                    else
                        tech.level = variant_level
                    end
                end
                if tech_researched ~= variant.researched then
                    if technology then
                        variant.researched = tech_researched
                    elseif tech_researched then
                        variant.researched = true
                    else
                        tech.researched = true
                    end
                end
            end
            -- Now that the variant is done, sync the recipes
            local recipes = recipe_techs[tech_name]
            if recipes then
                for recipe_name, recipe_meta in pairs(recipes) do
                    process_rec(recipe_name, recipe_meta, tech_researched)
                end
            end
        end
        -- now deal with the fallout from a full update
        if clear_caches or (technology_name == "compression-recipes") or building_tiers[technology_name] then
            -- sync stock recipe status
            for rec_name, rec_meta in pairs(stock_recs) do
                process_rec(rec_name, rec_meta, has_compression)
            end
            if clear_caches then -- clear the update queue, we'll have already handled any newly-unlocked techs
                update_queue.finished = {}
                update_queue.reversed = {}
            else -- If we just unlocked compressed recipes or a new building tier
                -- Iterate recipe techs, set their given recipe state
                -- We could include this above but that overcomplicates the logic, imo
                for tech_name, tech_recipes in pairs(recipe_techs) do
                    local tech = force_techs[tech_name]
                    if tech and tech.researched then
                        for recipe_name, recipe_meta in pairs(tech_recipes) do
                            process_rec(recipe_name, recipe_meta, tech.researched)
                        end
                    end
                end
            end
        end
    end
    if clear_caches then -- otherwise it's done by the event caller
        update_building_recipes()
    end
    logger(logmsg)
    storage.omni.needs_update = false
    storage.omni.clear_caches = false
    storage.omni.full_iter = false
end


-------------
---Events---
------------
--Disable warnings for the event part, the lua lang server seems wonky here
---@diagnostic disable

script.on_init(function(event)
    storage.omni = storage.omni or {}
    storage.omni.needs_update = true
    storage.omni.clear_caches = true
end)

script.on_configuration_changed(function(event)
    log("on_configuration_changed\n\t"..serpent.block(event))
    mod_data = prototypes.mod_data.omnimods.data
    storage.omni = storage.omni or {}
    storage.omni.needs_update = true
    storage.omni.clear_caches = true
end)

commands.add_command("omnidate", "Refreshes control-time data like if you researched a new compression tier", function(command)
    storage.omni = storage.omni or {}
    storage.omni.log_to_chat = true
    storage.omni.full_iter = true
    storage.omni.needs_update = true
end)
commands.add_command("omnidatefull", "Refreshes control-time data like if you started a new game", function(command)
    storage.omni = storage.omni or {}
    storage.omni.log_to_chat = true
    storage.omni.needs_update = true
    storage.omni.clear_caches = true
end)
commands.add_command("omnilog", "Tells you how much memory omnilib is using", function(command)
    storage.omni = storage.omni or {}
    game.print(
        "Memory usage: " .. math.ceil(collectgarbage("count")) .. "K"
    )
end)

script.on_event(defines.events.on_tick, function(event)
    if storage.omni and storage.omni.needs_update then
        omnidate()
    elseif update_queue and (#update_queue.finished + #update_queue.reversed) > 0 then
        for _, technology in pairs(update_queue.finished) do
            omnidate(technology)
        end
        update_queue.finished = {}
        for _, technology in pairs(update_queue.reversed) do
            omnidate(technology)
        end
        update_queue.reversed = {}
        -- once the queue is done, then we search for buildings to update
        update_building_recipes()
    end
end)

script.on_event(defines.events.on_research_finished, function(event)
    if storage.omni and storage.omni.needs_update then
        return
    end
    --log("on_research_finished\n\t"..serpent.block(event))
    local finished = update_queue.finished
    finished[#finished+1] = event.research
    --omnidate(false, event.research)
end)

script.on_event(defines.events.on_research_reversed, function(event)
    --log("on_research_reversed\n\t"..serpent.block(event))
    if storage.omni and storage.omni.needs_update then
        return
    end
    local reversed = update_queue.reversed
    reversed[#reversed+1] = event.research
    --omnidate(false, event.research)
end)

script.on_event(defines.events.on_force_created, function(event)
    storage.omni.needs_update = true
end)

script.on_event(defines.events.on_force_reset, function(event)
    storage.omni.needs_update = true
end)

script.on_event(defines.events.on_player_created, function(event)
    local ply = game.players[event.player_index]
    if (settings.startup["angels-enable-tech"] or {}).value then
        ply.print{"message.omni-angelstech", {200,15,15}}
    else
        ply.print{"message.omni-difficulty"}
    end
end)

---@diagnostic enable