require("controlFunctions")
--
    --
        --
            -- 
                --
                    --
                        --
                            --
                                --
                                    -- RIP MT. OMNISSIAH
                                --
                            --
                        --
                    --
                --
            --
        --
    --
--

local function get_recipe_family(recipe)
	local metadata = global.omni.recipes[recipe.name]
	if not metadata then
		return
	end
	local recipe_tree = global.omni.force_recipes[recipe.force.name][metadata.base]
	if not recipe_tree then
		return
	end
	return recipe_tree, metadata
end

local function update_last_tier(recipe, full_refresh)
	if not recipe.valid or not recipe.enabled then
		return
	end
	full_refresh = full_refresh or global.omni.need_update
	local recipe_tree, metadata = get_recipe_family(recipe)
	if not recipe_tree then
		return
	end
	-- We're the top of the tree!
	if recipe_tree and metadata.variant == "" and recipe_tree.active_tier < metadata.tier then
		local I = full_refresh and 97 or recipe_tree.active_tier
		local research_status = not not (recipe.force.technologies["compression-recipes"] or {}).researched
		repeat
			for variant, recipe_name in pairs(recipe_tree[I]) do
				local force_recipe = recipe.force.recipes[recipe_name]
				local is_compressed = global.omni.recipes[recipe.name].compressed
				local desired_status = is_compressed and research_status or (I == metadata.tier) -- True if we're on the final tier, false otherwise
				if force_recipe.enabled ~= desired_status then
					--log((desired_status and "Enabled" or "Disabled") .. " recipe: " .. force_recipe.name)
					force_recipe.enabled = desired_status
				end
			end
			I = I + 1
		until I > metadata.tier
		-- Update our current tier
		recipe_tree.active_tier = metadata.tier
	end
end

local function get_last_tier(recipe)
	local recipe_tree, metadata = get_recipe_family(recipe)
	if not recipe_tree then
		return
	end
	local active_recipe = recipe_tree[recipe_tree.active_tier][metadata.variant]
	if not active_recipe then
		return
	end
	return recipe.force.recipes[active_recipe]
end

local function update_recipe(recipe, enabled_override)
	if not recipe.valid then
		return
	end
	local name = recipe.name
	local force_techs = recipe.force.technologies
	local recipe_tree, metadata = get_recipe_family(recipe)
	if recipe.enabled and recipe_tree and metadata.tier < recipe_tree.active_tier then-- Irrelevant recipe!
		enabled_override = false
	end
	if enabled_override ~= nil then
		recipe.enabled = enabled_override
		if not recipe.enabled then -- Nothing further to do if we killed it
			return
		end
	end
	-- Update according to compression research status
	if not recipe_tree and 
		force_techs["compression-recipes"] and
		force_techs["compression-recipes"].researched and 
		not recipe.category:find("-compressed", nil, true) and 
		not name:find("concentrated", nil, true) then
		local recipes = recipe.force.recipes
		-- Handle both compressed and permuted recipes.
		local compressed, permuted_compressed = recipes[string.format("%s-compression",name)], recipes[name:gsub("omniperm","compression-omniperm")]
		if compressed then
			compressed.enabled = true
		end
		if permuted_compressed then
			permuted_compressed.enabled = true
		end
		-- Deal with generator variants
		for tier=1, math.huge do
			local compressed_recipe = recipes[string.format("%s-concentrated-grade-%i", name, tier)]
			if compressed_recipe then
				compressed_recipe.enabled = true
			else
				break
			end
		end
	end
	if recipe.enabled then
		update_last_tier(recipe)
	end
end

local building_tiers = {
	compact = "compression-compact-buildings",
	nanite = "compression-nanite-buildings",
	quantum = "compression-quantum-buildings",
	singularity = "compression-singularity-buildings"
}

local function update_tech(tech)
	local force_recs, tiered_buildings
	local force_techs = tech.force.technologies
	local variant = (
		force_techs[string.format("omnipressed-%s", tech.name)] or 
		force_techs[tech.name:gsub("^omnipressed%-", "")] or 
		{}
	)
	-- Handle compressed techs
	if tech.researched or variant.researched or tech.level then
		if tech.level then
			variant.level = tech.level
		else
			tech.researched, variant.researched = true, true
		end
		force_recs = tech.force.recipes
		tiered_buildings = global.omni.tiered_buildings
		for _, effect in pairs(tech.effects) do
			if effect.type == "unlock-recipe" then
				if tiered_buildings[effect.recipe] then					
					for tier, tech_name in pairs(building_tiers) do
						if force_techs[tech_name] and force_techs[tech_name].researched then
							local recipe_name = string.format("%s-compressed-%s", effect.recipe, tier)
							update_recipe(force_recs[recipe_name], true)
						end
						break -- Tiers in order, don't continue once we hit one that's locked
					end
				end
				update_recipe(force_recs[effect.recipe], true)
			end
		end
		if tech.name == "compression-recipes" then -- Generator fluids
			for name in pairs(global.omni.stock_fluids) do
				if force_recs[name] and not force_recs[name].enabled then
					force_recs[name].enabled = true
				end
			end
		end
	end
end

local function update_force(force, silent)
	if not force.valid then return end
	if #force.players == 0 then return end
	if not global.omni.force_recipes[force.name] then
		global.omni.force_recipes[force.name] = util.copy(global.omni.recipe_map)
	end
	local profiler = not silent and game.create_profiler()
	--log("Updating force: " .. force.name)
	--log("\tSyncing compressed and standard tech research states")
	for _, tech in pairs(force.technologies) do
		update_tech(tech)
	end
	if profiler then
		game.print({
			"",
			string.format(
				"%s for force \"%s\" updated. ",	
				"Technologies", 
				force.name
			),
			profiler
		})
		profiler:reset()
	end
	--log("Updating any default recipes")
	for recipe_name in pairs(global.omni.stock_recipes) do
		if force.recipes[recipe_name] then
			update_recipe(force.recipes[recipe_name])
		end
	end
	if profiler then
		game.print({
			"",
			string.format(
				"%s for force \"%s\" updated. ",	
				"Recipes", 
				force.name
			),
			profiler
		})
	end
end

local function update_building_recipes(silent)
	--log("Updating buildings that use tiered recipes")
	-- Make sure every entity using a tiered recipe (i.e. omnitraction) is up to the current tier
	local profiler = not silent and game.create_profiler()
	for _, surface in pairs(game.surfaces) do
		for _, entity in pairs(surface.find_entities_filtered({type="assembling-machine"})) do
			local recipe = entity.get_recipe()
			if recipe then
				local new_recipe = get_last_tier(recipe)
				if new_recipe and
					(new_recipe.name ~= recipe.name) and
					settings.global["omnilib-autoupdate"].value -- Let's follow the user's preference :^)
				then
					local ingredients
					if entity.is_crafting() then
						ingredients = recipe.ingredients or {}
					end
					entity.set_recipe(new_recipe.name)
					local updated_ingredients = 0
					for _, ingredient in pairs(ingredients) do
						if type == "item" then
							updated_ingredients = updated_ingredients + entity.insert({
								name = ingredient.name,
								count = ingredient.amount
							})
						elseif type == "fluid" then
							updated_ingredients = updated_ingredients + entity.insert_fluid({
								name = ingredient.name,
								amount = ingredient.amount
							})
						end
					end
					log("\tSet " .. entity.name .. " from recipe \"" .. recipe.name .. "\" to \"" .. new_recipe.name .. "\"")
					if updated_ingredients ~= 0 then
						log("\t\tMigrated " .. updated_ingredients .. " ingredients")
					end
				end
			end
		end
		if profiler then
			logstr = 
			game.print({
				"",
				string.format(
					"%s for surface \"%s\" updated. ",
					"Building recipes",
					surface.name
				),
				profiler
			})
			profiler:reset()
		end
	end
	--log("Building update complete")
end

local initializing = false
function omni_update(game, silent)
	initializing = true
	--log("Beginning omnidate")
	local profiler = game.create_profiler()
	for _, force in pairs(game.forces) do
		update_force(force, silent)
	end	
	update_building_recipes(silent)
	local printer = silent and log or game.print
	printer({
		"",
		"Omnidate completed. ",
		profiler
	})
initializing = false
end

script.on_event(defines.events.on_console_chat, function(event)
	if event.player_index and game.players[event.player_index] then
		if event.message=="omnidate" then
			omni_update(game)
		end
	end
end)

local patterns = {
    "%-()%a$",
    "%-()%a%-omniperm",
    "%-()%a%-compression"
}
function acquire_data(game)
	-- Recipe tier map
	local recipes = {}
	local recipe_map = {}
	local stock_recipes = {}
	local stock_fluids = {}
	local tiered_buildings = {}
	for name, recipe in pairs(game.recipe_prototypes) do
		for index, pattern in pairs(patterns) do
			local match = select(3,name:find(pattern))-- We only care about match position, denoted by ()
			if match and recipe.category and recipe.category:find("omni") then-- KR2 recipe names will screw us otherwise
				local base = name:sub(1, match-1)
				local tier = name:sub(match, match):byte()
				local variant = name:sub(match+1)
				recipes[name] = {
					base = base, -- The entry name in the common table
					tier = tier,
					variant = variant,
					compressed = (index == 3)
				}
				recipe_map[base] = recipe_map[base] or {}
				recipe_map[base].active_tier = math.min(97, recipe_map[base].active_tier or tier)
				recipe_map[base][tier] = recipe_map[base][tier] or {}				
				recipe_map[base][tier][variant] = name
				break
			end
		end
		-- Comes unlocked
		if recipe.enabled then
			stock_recipes[name] = true
		end
		-- Generator variant
		if recipe.category == "fluid-condensation" then
			stock_fluids[name] = true
		end
		-- Compact, nanite, etc buildings. Doing this work now makes it much faster when onidate is triggered.
		if name:find("-compressed%-") then		
			local base_building = name:gsub("-compressed%-%a+", "")
			tiered_buildings[base_building] = tiered_buildings[base_building] or {}
			tiered_buildings[base_building][name:gsub(".+compressed%-", "")] = name
		end
	end
	global.omni.force_recipes = {}
	for name in pairs(game.forces) do
		global.omni.force_recipes[name] = util.copy(recipe_map)
	end
	global.omni.recipe_map = recipe_map
	global.omni.recipes = recipes
	global.omni.stock_recipes = stock_recipes
	global.omni.stock_fluids = stock_fluids
	global.omni.tiered_buildings = tiered_buildings

end

script.on_configuration_changed( function(conf)
	if not global.omni then
		global.omni = {}
	end
	acquire_data(game)
	global.omni.need_update=true
end)

script.on_init( function(conf)
	global.omni = {}
	acquire_data(game)
	global.omni.need_update=false
end)

script.on_event(defines.events.on_tick, function(event)
	if global.omni.need_update then
		omni_update(game, true)
		global.omni.need_update = false
		global.omni.update_buildings = false
	elseif global.omni.update_buildings then
		update_building_recipes()
		global.omni.update_buildings = false
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	if not initializing then
		local tech = event.research
		if tech.name == "compression-recipes" then
			global.omni.need_update = true
		elseif not global.omni.need_update then -- If we need_update we'll be iterating everything anyway.
			update_tech(tech)
			if tech.name:find("^omnitech") and not tech.name:find("^omnipressed") then
				global.omni.update_buildings = true
			end
		end
	end
end)

script.on_event(defines.events.on_technology_effects_reset, function(event)
	global.omni.need_update = true
end)

script.on_event(defines.events.on_force_created, function(event)
	global.omni.force_recipes[event.force.name] = util.copy(global.omni.recipe_map)
	global.omni.need_update = true
end)

script.on_event(defines.events.on_forces_merged, function(event)
	global.omni.force_recipes[event.source_name] = nil
	global.omni.force_recipes[event.destination.name] = util.copy(global.omni.recipe_map)
	global.omni.need_update = true
end)

script.on_event(defines.events.on_force_reset, function(event)
	global.omni.force_recipes[event.force.name] = util.copy(global.omni.recipe_map)
	global.omni.need_update = true
end)

script.on_event(defines.events.on_player_changed_force, function(event)
	global.omni.need_update = true
end)

script.on_event(defines.events.on_player_created, function(event)
	game.players[event.player_index].print{"message.omni-difficulty"}
end)
