require("controlFunctions")

local function get_last_tier(index, force, disable_obsolete)
	local next_rec = global.omni.recipes[index]
	if next_rec and force.recipes[next_rec] and force.recipes[next_rec].enabled then
		if disable_obsolete then
			if #force.recipes[index].products == #force.recipes[next_rec].products then -- Make sure we keep old recipes if they have different outputs
				force.recipes[index].enabled = false
			end
		end
		return get_last_tier(next_rec, force, disable_obsolete)
	else
		return index
	end
end

local function updateRecipe(recipe)
	if not recipe.valid then return end
	local enabled_status = not not (recipe.force.technologies["compression-recipes"] or {}).researched--Cast as bool
	local name = recipe.name
	if enabled_status and not recipe.category:find("-compressed", nil, true) and not name:find("concentrated", nil, true) then
		local recipes = recipe.force.recipes
		-- Handle both compressed and permuted recipes.
		local compressed, permuted_compressed = recipes[name.."-compression"], recipes[name:gsub("omniperm","compression-omniperm")]
		if compressed then
			compressed.enabled = true
		end
		if permuted_compressed then
			permuted_compressed.enabled = true
		end
		-- Deal with generator variants
		for tier=1, math.huge do
			local compressed_recipe = recipes[name.."-concentrated-grade-"..tier]
			if compressed_recipe then
				compressed_recipe.enabled = true
			else
				break
			end
		end
	end
end

local building_tiers = {
	"compact",
	"nanite",
	"quantum",
	"singularity"
}

local function updateTech(tech)
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
							tech.force.recipes[recipe_name].enabled = true
						end
					else
						break -- Tiers in order, don't continue once we hit one that's locked
					end
				end
				updateRecipe(effect.recipe)
			end
		end
	end
end

local function updateForce(force)
	if not force.valid then return end
	log("Updating force: " .. force.name)
	log("\tSyncing compressed and standard tech research states")
	for _, tech in pairs(force.technologies) do
		updateTech(tech)
	end
	log("\tSetting enabled flag on compressed recipes according to research")
	for _, recipe in pairs(force.recipes) do
		updateRecipe(recipe)
	end
end

local function updateBuildingRecipes()
	log("Updating buildings that use tiered recipes")
	-- Make sure every entity using a tiered recipe (i.e. omnitraction) is up to the current tier
	for _, surface in pairs(game.surfaces) do
		for _, entity in pairs(surface.find_entities_filtered({type="crafting-machine"})) do
			local recipe = entity.get_recipe()
			if recipe then
				local new_recipe = get_last_tier(recipe.name, entity.force, true)
				if new_recipe and new_recipe ~= recipe.name and settings.global["omnilib-autoupdate"].value then-- Let's follow the user's preference :^)
					local ingredients
					if entity.is_crafting() then
						ingredients = recipe.ingredients or {}
					end
					entity.set_recipe(new_recipe)
					for _, ingredient in pairs(ingredients) do
						if type == "item" then
							entity.insert({
								name = ingredient.name,
								count = ingredient.amount
							})
						elseif type == "fluid" then
							entity.insert_fluid({
								name = ingredient.name,
								amount = ingredient.amount
							})
						end
					end
					log("Set " .. entity.name .. " from recipe \"" .. recipe.name .. "\" to \"" .. new_recipe .. "\"")
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
		updateForce(force)
	end
	updateBuildingRecipes()
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
function acquireData(game)
	local perm = {}
	local i = 0
	for name, recipe in pairs(game.recipe_prototypes) do
		--Omniperm stuff
		--[[
		if string.find(name,"omniperm") then
			local s,e = string.find(name,"omniperm")
			local v = split(string.sub(name,e+2,string.len(name)),"-")
			local name = string.sub(name,1,s-2)
			if not perm[name] then perm[name]={ingredient=1,result=1} end
			if tonumber(v[1])>perm[name].ingredient then perm[name].ingredient = tonumber(v[1]) end
			if tonumber(v[2])>perm[name].result then perm[name].result = tonumber(v[2]) end
		end]]
		-- Recipe tier map
		local recipes = {}
		for _, pattern in pairs(patterns) do
			local match = select(3,name:find(pattern))-- We only care about match position, denoted by ()
			if match and recipe.category and recipe.category:find("omni", nil, true) then-- KR2 recipe names will screw us otherwise
				--[[
					recipe-name-a-omniperm -> recipe-name-b-omniperm where a and b are the tiers
					[1] = recipe-name-
					[2] = b
					[3] = -omniperm           
				]]--
				local newname = table.concat({
					name:sub(1, match-1),
					name:sub(match, match):increment(),
					name:sub(match+1) 
				})
				if game.recipe_prototypes[newname] then -- We only add this tier if it *actually* exists
					i = i + 1
					recipes[name] = newname
				end
				break
			end
		end
	end
	log("Recipe map count: " .. i)
	global.omni.recipes = recipes
	global.omni.perm = perm
end

script.on_configuration_changed( function(conf)
	if not global.omni then
		global.omni={}
	end
	acquireData(game)
	global.omni.need_update=true
end)

script.on_init( function(conf)
	global.omni = {}
	acquireData(game)
	global.omni.need_update=false
end)

script.on_event(defines.events.on_tick, function(event)
	if global.omni.need_update then
		acquireData(game)
		omni_update(game, true)
		global.omni.need_update = false
		global.omni.update_buildings = false
	elseif global.omni.update_buildings then
		updateBuildingRecipes()
		global.omni.update_buildings = false
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	if not initializing then
		local tech = event.research
		updateTech(tech)
		if tech.name:find("^omnitech") and not tech.name:find("^omnipressed") then
			global.omni.update_buildings = true
		end
	end
end)


script.on_event(defines.events.on_player_created, function(event)
	game.players[event.player_index].print{"message.omni-difficulty"}
end)
