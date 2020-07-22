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

local function update_last_tier(recipe, full_refresh)
	if not recipe.enabled then
		return
	end
	local metadata = global.omni.recipes[recipe.name]
	if not metadata then
		return
	end
	local recipe_tree = global.omni.force_recipes[recipe.force.name][metadata.base]
	if not recipe_tree then
		return
	end
	-- We're the top of the tree!
	if recipe_tree and not recipe_tree[metadata.tier][metadata.variant] and recipe_tree.active_tier < metadata.tier then
		local I = full_refresh and 97 or recipe_tree.active_tier
		local research_status = not not (recipe.force.technologies["compression-recipes"] or {}).researched
		repeat
			for variant, recipe_name in pairs(recipe_tree[I]) do
				local force_recipe = recipe.force.recipes[recipe_name]
				local is_compressed = global.omni.recipes[recipe.name].compressed
				local desired_status = is_compressed and research_status or (I == metadata.tier) -- True if we're on the final tier, false otherwise
				if force_recipe.enabled ~= desired_status then
					log((desired_status and "Enabled" or "Disabled") .. " recipe: " .. force_recipe.name)
				end
			end
			I = I + 1
		until I > metadata.tier
		-- Update our current tier
		recipe_tree.active_tier = metadata.tier
	end
end

local function update_recipe(recipe, enabled_override)
	if not recipe.valid then
		return
	end
	local name = recipe.name
	if enabled_override ~= nil then
		recipe.enabled = enabled_override
	end
	-- Update according to compression research status
	if recipe.force.technologies["compression-recipes"] and
		recipe.force.technologies["compression-recipes"].researched and 
		not recipe.category:find("-compressed", nil, true) and 
		not name:find("concentrated", nil, true) then

		local recipes = recipe.force.recipes
		-- Deal with generator variants
		for tier=1, 10 do
			local compressed_recipe = recipes[name.."-concentrated-grade-"..tier]
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
	"compact",
	"nanite",
	"quantum",
	"singularity"
}

local function update_tech(tech)
	local variant = tech.force.technologies["omnipressed-" .. tech.name] or tech.force.technologies[tech.name:gsub("^omnipressed%-", "")] or {}
	-- Handle compressed techs
	if tech.researched or variant.researched then
		tech.researched, variant.researched = true, true
		for _, effect in pairs(tech.effects) do
			if effect.type == "unlock-recipe" then
				for _, tier in pairs(building_tiers) do
					local tier_tech = tech.force.technologies[string.format("compression-%s-buildings", tier)]
					if tier_tech and tier_tech.researched then
						local recipe_name = string.format("%s-compressed-%s", effect.recipe, tier)
						if tech.force.recipes[recipe_name] then
							update_recipe(tech.force.recipes[recipe_name], true)
						end
					else
						break -- Tiers in order, don't continue once we hit one that's locked
					end
				end
				update_recipe(tech.force.recipes[effect.recipe], true)
			end
		end
	end
end

local function update_force(force)
	if not force.valid then return end
	log("Updating force: " .. force.name)
	log("\tSyncing compressed and standard tech research states")
	for _, tech in pairs(force.technologies) do
		update_tech(tech)
	end
	log("\tHandling obsolete recipes")
	for name, objects in pairs(global.omni.force_recipes[force.name]) do
		if objects.active_tier > 97 then
			for I=97, objects.active_tier-1 do
				for _, recipe_name in pairs(objects[I]) do
					force.recipes[recipe_name].enabled = false
				end
			end
		end
	end
	--[[
	for _, recipe in pairs(force.recipes) do
		update_recipe(recipe)
	end]]
end

local function update_building_recipes()
	log("Updating buildings that use tiered recipes")
	-- Make sure every entity using a tiered recipe (i.e. omnitraction) is up to the current tier
	for _, surface in pairs(game.surfaces) do
		for _, entity in pairs(surface.find_entities_filtered({type="assembling-machine"})) do
			local recipe = entity.get_recipe()
			if recipe then
				local metadata = global.omni.recipes[recipe_name]
				local recipe_table = metadata and global.omni.force_recipes[recipe.force.name][metadata.base]
				local new_recipe_name = recipe_table and recipe_table[recipe_table.active_tier][metadata.variant]
				local new_recipe = new_recipe_name and recipe.force.recipes[new_recipe_name]
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
				else
					log("\tSkipped updating " .. entity.name .. " with recipe " .. new_recipe.name .. " from " .. recipe.name)
				end
			end
		end
	end
	log("Building update complete")
end

local initializing = false
function omni_update(game, silent)
	initializing = true
	log("Beginning omnidate")
	local profiler = game.create_profiler()
	for _, force in pairs(game.forces) do
		update_force(force)
	end
	update_building_recipes()
	if not silent then
		game.print({
			"",
			"Omnidate completed. ",
			profiler
		})
	else
		log({
			"",
			"Omnidate completed. ",
			profiler
		})
	end
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
				if index > 1 then -- Any compressed or permuted recipes					
					recipe_map[base][tier][variant] = name
				end
				break
			end
		end
	end
	global.omni.force_recipes = {}
	for name in pairs(game.forces) do
		global.omni.force_recipes[name] = util.copy(recipe_map)
	end
	global.omni.recipe_map = recipe_map
	global.omni.recipes = recipes
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
		update_tech(tech, true)
		if tech.name == "compression-recipes" then
			global.omni.need_update = true
		elseif tech.name:find("^omnitech") and not tech.name:find("^omnipressed") then
			global.omni.update_buildings = true
		end
	end
end)


script.on_event(defines.events.on_player_created, function(event)
	game.players[event.player_index].print{"message.omni-difficulty"}
end)
