require("control-functions")

local building_tiers = {
	compact = "compression-compact-buildings",
	nanite = "compression-nanite-buildings",
	quantum = "compression-quantum-buildings",
	singularity = "compression-singularity-buildings"
}

script.on_load(function()
	log("on_load")
end)

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

local function get_relative_tier(recipe_name, offset)
	offset = offset or 1
	local is_omniperm = recipe_name:find("%-omniperm")
	local pattern = "%-(%a)" .. (is_omniperm and "(%-omniperm%-%d%-%d)" or "(.?)") .. "$"
	local tier = recipe_name:match(pattern)
	if tier then
		tier = string.char(string.byte(tier) + offset)
		return recipe_name:gsub(pattern, "-" .. tier .. "%2")
	end
end

local function update_building_recipes()
	--log("Updating buildings that use tiered recipes")
	-- User preference
	if not settings.global["omnilib-autoupdate"].value then
		return
	end
	-- Make sure every entity using a tiered recipe (i.e. omnitraction) is up to the current tier
	local correlated_recipes = global.omni.correlated_recipes
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
							local upgrade = recipe_meta.upgrade and force_recs[recipe_meta.upgrade]
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

function omnidate(technology)
	local game = game
	-- Record time spent
	local profiler = game.create_profiler()
	local logger = global.omni and global.omni.log_to_chat and game.print or log
	-- Clear cached lists
	local clear_caches = global.omni and global.omni.clear_caches
	-- Check every recipe/tech
	local full_iter = global.omni and global.omni.full_iter
	-- Globals
	if clear_caches then
		global.omni = {}
		global.omni.correlated_recipes = {}
		global.omni.recipe_techs = {}
		global.omni.stock_recs = {}
	end
	-- Make sure we don't trigger ourselves
	global.omni.needs_update = true
	-- No omnicompression, no omnimatter
	if not settings.startup["omnicompression_one_list"] and not settings.startup["omnimatter-infinite"] then
		profiler.stop()
		global.omni.needs_update = false
		return
	end
	logger("Beginning omnidate" .. (clear_caches and " (full)" or "") .. (full_iter and " (partial)" or ""))
	-- Proxies
	local correlated_recipes = global.omni.correlated_recipes	
	local recipe_techs = global.omni.recipe_techs	
	local stock_recs = global.omni.stock_recs
	-- Game items
	local forces = game.forces
	local cached_protos = memoize(game.recipe_prototypes)
	local cached_techs = memoize(game.technology_prototypes)
	-- Conditional (if we're just doing one tech)
	local tech_force = technology and technology.force or nil
	--
	-- Here we go!
	--

	-- Skip the stuff we don't need to re-do if we aren't clearing caches
	if clear_caches then
		-- First, build a list of categories
		local cat_filters = {}
		for category in pairs(game.recipe_category_prototypes) do
			if category:find("%-compressed$") then
				cat_filters[#cat_filters+1] = {filter = "category", category = category}
			end
		end

		--[[
			base_or_compressed_or_building={
				base = recipe_name,
				compressed = compressed_name,
				upgrade = next_tier_name,
				downgrade = previous_tier_name,
				compact = compact_recipe_name
			}
		]]
		-- Second, build a table of recipes, correlating compressed and uncompressed variants
		for recipe_name in pairs(game.get_filtered_recipe_prototypes(cat_filters)) do
			local rmeta = correlated_recipes[recipe_name] or {}
			-- A, check tiered buildings
			if recipe_name:find("%-compressed-") then
				-- Base recipe i.e. assembling-machine-1
				local original_recipe = recipe_name:gsub("%-compressed%-[^%-]+$", "")
				-- Compressed building i.e. assembling-machine-1-compact
				local variant = recipe_name:match("[^%-]+$")
				local cached_rec = cached_protos[original_recipe]
				if cached_rec and building_tiers[variant] then
					-- Store base name and compressed name in meta
					if correlated_recipes[original_recipe] then
						rmeta = correlated_recipes[original_recipe]
					else-- Link (pointer) for other possible lookup names
						correlated_recipes[original_recipe] = rmeta
					end
					rmeta.base = original_recipe
					rmeta[variant] = recipe_name
					if cached_rec.enabled then
						stock_recs[#stock_recs+1] = rmeta
					end
				end
			else -- B, check compressed recipes
				-- Base recipe i.e. iron-plate
				local uncompressed_recipe = recipe_name:gsub("%-compression", "")
				local cached_rec = cached_protos[uncompressed_recipe]
				if cached_rec then
					if correlated_recipes[uncompressed_recipe] then
						rmeta = correlated_recipes[uncompressed_recipe]
					else-- Link (pointer) for other possible lookup names
						correlated_recipes[uncompressed_recipe] = rmeta
					end
					-- Store base name and compressed name in meta
					rmeta.base = uncompressed_recipe
					rmeta.compressed = recipe_name
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

		-- Third, list techs and their base variants
		for tech_name, tech in pairs(game.technology_prototypes) do
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
			-- nothing
		end
	end

	-- Act as if cache has been cleared from here if specified
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
		local has_compression = force_techs["compression-recipes"] and force_techs["compression-recipes"].researched
		local technology_name = technology and technology.name or ""
		-- If we're just a single tech, we can end here if we don't meet the criteria
		if technology then
			local tech_level = technology.level
			local tech_researched = technology.researched
			-- Sync status between compressed and non-compressed techs
			local variant = (
				force_techs[string.format("omnipressed-%s", technology_name)] or 
				force_techs[technology_name:gsub("^omnipressed%-", "")] or 
				{}
			)
			if technology.level then
				variant.level = technology.level
			end
			variant.researched = tech_researched
			-- We can stop here if we're on a compressed variant, the rest will happen since we triggered the unlock
			if technology_name:match("^omnipressed%-") then
				break
			end
		end

		-- Don't bother with any building tiers that aren't unlocked, better than checking within the loop
		local tiers_unlocked = {}
		local is_tier_unlock = false
		local tier_num = 0
		for tier_name, tier_tech in pairs(building_tiers) do
			if technology and tier_tech == technology_name then
				is_tier_unlock = true
			end
			local tech = force_techs[tier_tech]
			if tech then
				tiers_unlocked[tier_name] = tech.researched
				-- Hide or show techs based on setting
				tier_num = tier_num + 1
				tech.enabled = tier_num <= settings.startup["omnicompression_building_levels"].value
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
					local compressed_downgrade = cached_recs[correlated_recipes[downgrade_rec.name].compressed]
					compressed_downgrade.enabled = has_compression and not toggle
				end
			end
		end
		-- If we just unlocked compression-recipes, or we're doing a full update
		if technology or clear_caches then			
			local tech_status = technology and technology.researched
			local is_compression_unlock = (technology_name == "compression-recipes")
			if clear_caches or is_compression_unlock or is_tier_unlock then
				-- Deal with stock recs if necessary
				if not is_tier_unlock then
					for rec_name, rec_meta in pairs(stock_recs) do
						process_rec(rec_name, rec_meta, has_compression)
					end
				end
				-- Iterate techs, set their given recipe state
				for tech_name, tech_recipes in pairs(recipe_techs) do
					if force_techs[tech_name].researched then
						for recipe_name, recipe_meta in pairs(tech_recipes) do
							process_rec(recipe_name, recipe_meta, force_techs[tech_name].researched)
						end
					end
				end
			else
				for recipe_name, recipe_meta in pairs(recipe_techs[technology_name] or {}) do
					process_rec(recipe_name, recipe_meta, tech_status)
				end
			end
		end
	end
	update_building_recipes()
	logger({
		"",
		"Omnidate completed. ",
		profiler
	})
	global.omni.needs_update = false
	global.omni.clear_caches = false
	global.omni.full_iter = false
end

script.on_event(defines.events.on_console_chat, function(event)
	log("on_console_chat\n\t"..serpent.block(event))
	if event.player_index and game.players[event.player_index] then
		if event.message=="omnidate" then
			global.omni = global.omni or {}
			global.omni.log_to_chat = true
			global.omni.needs_update = true
		elseif event.message=="omnidatefull" then
			global.omni = global.omni or {}
			global.omni.log_to_chat = true
			global.omni.needs_update = true
			global.omni.clear_caches = true
		elseif event.message=="omnilog" then
			global.omni = global.omni or {}
			log(
				"Memory usage: " .. math.ceil(collectgarbage("count")) .. "K"
			)
			--log(serpent.block(global.omni.recipe_techs))
		end
	end
end)

script.on_configuration_changed(function(event)
	log("on_configuration_changed\n\t"..serpent.block(event))
	global.omni = global.omni or {}
	global.omni.needs_update = true
	global.omni.clear_caches = true
end)
script.on_init(function(event)
	global.omni = global.omni or {}
	global.omni.needs_update = true
	global.omni.clear_caches = true
end)
local update_queue = {
	finished = {},
	reversed = {}
}
script.on_event(defines.events.on_tick, function(event)
	if global.omni and global.omni.needs_update then
		omnidate()
	elseif update_queue then
		for _, technology in pairs(update_queue.finished) do
			omnidate(technology)
		end
		update_queue.finished = {}
		for _, technology in pairs(update_queue.reversed) do
			omnidate(technology)
		end
		update_queue.reversed = {}
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	if global.omni and global.omni.needs_update then
		return
	end
	log("on_research_finished\n\t"..serpent.block(event))
	local finished = update_queue.finished
	finished[#finished+1] = event.research
	if #finished >= 3 then -- If our queue is getting too big just do a full omnidate
		finished = {}
		global.omni.needs_update = true
		global.omni.full_iter = true
	end
	--omnidate(false, event.research)
end)

script.on_event(defines.events.on_research_reversed, function(event)
	--log("on_research_reversed\n\t"..serpent.block(event))
	if global.omni and global.omni.needs_update then
		return
	end
	local reversed = update_queue.reversed
	reversed[#reversed+1] = event.research
	if #reversed >= 3 then -- If our queue is getting too big just do a full omnidate
		reversed = {}
		global.omni.needs_update = true
	end
	--omnidate(false, event.research)
end)

script.on_event(defines.events.on_force_created, function(event)
	global.omni.needs_update = true
end)

script.on_event(defines.events.on_force_reset, function(event)
	global.omni.needs_update = true
end)

script.on_event(defines.events.on_player_created, function(event)
	local ply = game.players[event.player_index]
	if (settings.startup["angels-enable-tech"] or {}).value then
		ply.print{"message.omni-angelstech", {200,15,15}}
	else
		ply.print{"message.omni-difficulty"}
	end
end)