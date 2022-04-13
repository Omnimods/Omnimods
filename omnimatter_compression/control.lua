local tiers = {"compact","nanite","quantum","singularity"}
local items_per_tier = settings.startup["omnicompression_multiplier"].value

local function find_tier(class_name)
    for index, tier in pairs(tiers) do
        if class_name:find(tier .. "$") then -- Only look at end
            return index, tier
        end
    end
end

local function flying_text(entity, say_string)
    entity.surface.create_entity{
        name = "tutorial-flying-text",
        position = entity.position,
        text = say_string
    }
end

script.on_event("decompress-stack", function(event)
    local player = game.players[event.player_index]
    if player.force.technologies["compression-hand"].researched == true then
        if player.cursor_stack and player.cursor_stack.valid_for_read then
            local item = player.cursor_stack 
            if item.name:find("^compressed%-") then
                local decompressed = item.name:gsub("^compressed%-", "")
                if player.can_insert(decompressed) then
                    flying_text(player, "+[img=item."..decompressed.."]")
                    --flying_text(player, "-[img=item."..item.name.."]")
                    if item.count > 1 then
                        item.count=item.count-1
                    else
                        item.clear()
                    end
                    player.insert({
                        name = decompressed,
                        count = math.min(game.item_prototypes[decompressed].stack_size, 65535)
                    })-- Defaults to a stack?
                    return -- Don't bother continuing
                end
            end
            local tier_num, tier_name = find_tier(item.name)
            if tier_num and tiers[tier_num-1] then-- Remove tier, repl with previous tier
                local decompressed = item.name:gsub(tier_name .. "$", tiers[tier_num-1])
                if player.can_insert(decompressed) then
                    flying_text(player, "+[img=item."..decompressed.."]")
                    --flying_text(player, "-[img=item."..item.name.."]")
                    if item.count > 1 then
                        item.count=item.count-1
                    else
                        item.clear()
                    end
                    player.insert({
                        name = decompressed,
                        count = items_per_tier
                    })-- Defaults to a stack?
                end
            end
        end
    end
end)

local function compression_planner(event, log_only)
    if event.item == "compression-planner" then
        local player = game.players[event.player_index]
        local surface = player.surface
        local entities = game.entity_prototypes
        local items = game.item_prototypes
        local remainder, iremainder = 0, 0
        local result_table = {}
        for key, entity in pairs(event.entities) do
            if entity.valid and entity.type == "resource" and #entity.prototype.mineable_properties.products > 0 and not
            (entity.name:find("^compressed") or entity.name:find("^concentrated")) then
                local results = entity.prototype.mineable_properties.products
                local result = results[1]
                -- Store the relevant entity properties, we'll add to this table as we calculate
                local ent = {
                    position = entity.position,
                    force = entity.force
                }
                local size
                local min = entity.initial_amount
                local amount = entity.amount
                local output_amount = amount
                if result.type == "item" and entities["compressed-resource-"..entity.name] then
                    size = items[result.name].stack_size
                    ent.name = "compressed-resource-" .. entity.name
                elseif result.type == "fluid" and entities["concentrated-resource-"..entity.name] then
                    size = 50
                    ent.name = "concentrated-resource-" .. entity.name
                end

                if size then -- We have valid output, continue
                    -- Do our final division
                    if min then
                        output_amount = (amount / min) * min
                        min = min / size
                        iremainder = iremainder + (min % 1) -- New remainder, add what floor removes
                        if iremainder > 1 then -- We'll add if we're greater than 1
                            min = min + math.floor(iremainder)
                            iremainder = iremainder % 1
                        end
                        min = math.floor(min)
                    end
                    output_amount = output_amount / size
                    if result.type == "item" then -- If not infinite, we'll add to our remainder.
                        remainder = remainder + (output_amount % 1) -- New remainder, add what floor removes
                        if remainder > 1 then -- We'll add if we're greater than 1
                            output_amount = output_amount + math.floor(remainder)
                            remainder = remainder % 1
                        end
                        output_amount = math.floor(output_amount)
                    end
                    -- Floor our actual output
                    --output_amount = math.max(1, math.floor(output_amount))
                    -- Apply to infinite or non-infinite respectively
                    ent.initial_amount = min
                    ent.amount = output_amount
                    if not log_only then-- Actually do the thing
                        entity.destroy()
                        if output_amount >= 1 then
                            local res = surface.create_entity(ent)
                            if ent.initial_amount and ent.initial_amount > 0 then
                                res.initial_amount = ent.initial_amount
                            end
                        end
                    else -- Or don't do the thing
                        result_table[result.name] = result_table[result.name] or {}
                        -- Alias and store
                        local res_table = result_table[result.name]
                        res_table.source_amount = (res_table.source_amount or 0) + entity.amount
                        res_table.dest_name = (
                            result.type == "item" and "compressed-" .. result.name or
                            "concentrated-" .. result.name
                        )
                        res_table.dest_amount = (res_table.dest_amount or 0) + (output_amount >= 1 and ent.amount or 0)
                        res_table.type = result.type
                    end
                end
            end
        end
        if log_only then
            for source_name, properties in pairs(result_table) do
                if properties.dest_amount >= 1 then
                    player.print(string.format(
                        "[img=entity.%s](%d)->[img=%s.%s](%d), ratio is %d:1.",
                        source_name,
                        properties.source_amount,
                        properties.type,
                        properties.dest_name,
                        properties.dest_amount,
                        math.floor(properties.source_amount/properties.dest_amount+0.5)--Equiv to rounding
                    ))
                end
            end
        end
    end
end

script.on_event(defines.events.on_rocket_launched, function(event)
    local rocket = event.rocket
    local silo = event.rocket_silo
    local player = event.player_index
    if not rocket or not silo then
        return
    end
    -- Silo has packs, rocket has satellite
    local silo_inv = silo.get_inventory(defines.inventory.rocket_silo_result)
    local rocket_inv = rocket.get_inventory(defines.inventory.rocket)
    if rocket_inv and silo_inv then
        -- There can be many things!
        for satellite in pairs(rocket_inv.get_contents()) do
            if satellite:find("^compressed%-") and #game.item_prototypes[satellite].rocket_launch_products > 0 then
                -- Naughty naughty!
                if not rocket.prototype.name:find("^compressed%-") then
                    local result_array = game.item_prototypes[satellite].rocket_launch_products or {}
                    local uncomp_satellite = satellite:gsub("^compressed%-", "")
                    local uncomp_result_array = game.item_prototypes[uncomp_satellite].rocket_launch_products
                    local has_spilled_satellites = false
                    -- Time to spill
                    for i, result in pairs(result_array) do
                        -- Science
                        local normal_result = uncomp_result_array[i]
                        silo.surface.spill_item_stack(
                            silo.position,
                            {
                                name = normal_result.name,
                                count = normal_result.amount
                            }
                        )
                        silo_inv.remove(result.name)
                        -- Satellites, if we haven't already
                        if not has_spilled_satellites then
                            local satellite_remainder = game.item_prototypes[normal_result.name].stack_size * result.amount -- Convert to uncompressed count
                            satellite_remainder = satellite_remainder / normal_result.amount -- Divide by result size
                            satellite_remainder = math.max(0, satellite_remainder - 1) -- Get our actual remainder
                            silo.surface.spill_item_stack(
                                silo.position,
                                {
                                    name = uncomp_satellite,
                                    count = satellite_remainder
                                }
                            )
                            has_spilled_satellites = true
                        end
                    end
                end
            end
        end
    end
end )

script.on_event(defines.events.on_player_selected_area, compression_planner)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
    compression_planner(event, true)
end)

-------------------------
---Planner spawn logic---
-------------------------

local function get_planner_status(player)
    --return ["compression-mining"].researched
    return not not player.force.technologies["compression-mining"].researched
end

local function refresh_planner_status()
    for _, ply in pairs(game.players) do
        ply.set_shortcut_available("compression-planner-shortcut", get_planner_status(ply))
    end
end

local function spawn_planner(player_index)
    local player = game.players[player_index]
    local stack = player.cursor_stack
    --check if the cursor is valid and clear it before inserting (lets not void held items :) )
    if stack and stack.valid then
        player.clear_cursor()
        player.cursor_stack.set_stack({type="selection-tool",name = "compression-planner",count=1})
    end
end

--unlock compression planner after the tech is researtched
script.on_event(defines.events.on_research_finished, function(event)
    local research = event.research
    if research.name == "compression-mining" then
        refresh_planner_status()
    end
end)

--Refresh planner activation when a player is created (doesnt work for sp, thanks cutscene)
script.on_event(defines.events.on_player_created, function(event)
    refresh_planner_status()
end)

--Refresh planner activation when the cutscene is canceled
script.on_event(defines.events.on_cutscene_cancelled, function(event)
    refresh_planner_status()
end)

--Refresh planner activation when tech effects are reset
script.on_event(defines.events.on_technology_effects_reset, function(event)
    refresh_planner_status()
end)

--Refresh planner activation when omnidate is activated
script.on_event(defines.events.on_console_chat, function(event)
    if event.player_index and game.players[event.player_index] then
        if event.message == "omnidate" then
            refresh_planner_status()
        end
    end
end)

--spawn compression planner when a player clicks the shortcut
script.on_event(defines.events.on_lua_shortcut, function(event)
    -- dont need to check unlock status here since we enable/disable the button
    if event.prototype_name and event.prototype_name == "compression-planner-shortcut" then 
        spawn_planner(event.player_index)
    end
end)

--spawn compression planner when the hotkey is pressed (check unlock status)
script.on_event("give-compression-planner", function(event)
    if get_planner_status(game.players[event.player_index]) == true then
        spawn_planner(event.player_index)
    end
end)
-- Resync compressed and uncompressed techs
commands.add_command(
    "omnidatetechs",
    "Peforms a full resync of the tech tree. Will freeze the game for up to a few seconds.",
    function(command)
        for force_name, force in pairs(game.forces) do
            local force_techs = force.technologies
            for technology_name, tech in pairs(force_techs) do
                local variant = (
                    force_techs[string.format("omnipressed-%s", technology_name)] or 
                    force_techs[technology_name:gsub("^omnipressed%-", "")] or 
                    {}
                )
                if variant.researched ~= tech.researched then
                    if variant.researched then
                        tech.researched = true
                    else
                        variant.researched = true
                    end
                end
                if tech.level and tech.level ~= variant.level then
                    if tech.level > variant.level then
                        variant.level = tech.level
                    else
                        tech.level = variant.level
                    end
                end
            end
        end
        game.print("Technology resync complete.")
    end
)

-- Disco science ╰(*°▽°*)╯
local function init_discoscience()
    if 
        not remote.interfaces.DiscoScience 
        or not remote.interfaces.DiscoScience.setIngredientColor 
        or not remote.interfaces.DiscoScience.getIngredientColor
    then
        log("DiscoScience not found, skipping compat")
        return
    end
    local sciencePackPrototypes = game.get_filtered_item_prototypes({{
        filter = "type",
        type = "tool"
    }})
    for name, proto in pairs(sciencePackPrototypes) do
        if not name:find("^compressed%-") then goto continue end

        local uncompressed_pack = sciencePackPrototypes[name:gsub("^compressed%-","")]
        if not uncompressed_pack then goto continue end

        local original_color = remote.call("DiscoScience", "getIngredientColor", uncompressed_pack.name)
        if not original_color then goto continue end

        log("Registering DiscoScience color for " .. name)
        remote.call("DiscoScience", "setIngredientColor", name, original_color)

        ::continue::
    end
end
script.on_init(init_discoscience)
script.on_configuration_changed(init_discoscience)