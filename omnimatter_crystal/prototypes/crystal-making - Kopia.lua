
omni.crystal.metals = {}


local shard_icons = function(metal)
	math.randomseed(string.byte(metal,1))
	local nr = math.random(3,6)
    --Build the icons table
    local icons = {}
	for i=1,nr do
		icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/"..metal.."-crystal.png",scale=0.2,shift={5*math.cos(((i-1)/nr+0.5)*2*math.pi),5*math.sin(((i-1)/nr+0.5)*2*math.pi)}}
	end
    return icons
end

local metal_omnide_icon = function(metal)
	local nr = 5
    --Build the icons table
    local icons = {}
	icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/omnide-solution.png"}
	icons[#icons+1] = {icon = data.raw.item[metal].icon,scale=0.4,shift={-10,10}}
    return icons
end

local salt_omnide_icon = function(metal)
	local nr = 5
    --Build the icons table
    local icons = {}
	icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/omnide-salt.png"}
	icons[#icons+1] = {icon = data.raw.item[metal].icon,scale=0.4,shift={-10,10}}
    return icons
end



omni.crystal.add_crystal=function(metal,name,recipe)
	if data.raw.item[metal] then
		omni.crystal.metals[#omni.crystal.metals+1]=data.raw.item[metal]
		
		RecGen("omnimatter_crystal",metal.."-crystal"):
		setLocName("crystal",name):
		setFuelValue(35):
		setFuelCategory("crystal"):
		setSubgroup("crystallization"):
		setStacksize(500)
		
		
		local loc_key = {name}
		local crystal =   {
		type = "item",
		name = metal.."-crystal",
		icon_size = 32,
		localised_name = {"item-name.crystal", loc_key},
		localised_description = {"recipe-description.pure_extraction", loc_key},
		icon = "__omnimatter_crystal__/graphics/icons/"..metal.."-crystal.png",
		flags = {"goes-to-main-inventory"},
		subgroup = "crystallization",
		fuel_category = "crystal",
		fuel_value = "35MJ",
		stack_size = 500
		}
		crystalines[#crystalines+1]=crystal
		
		local ic = shard_icons(metal)
		local shard =   {
		type = "item",
		name = metal.."-shard",
		icon_size = 32,
		icons = ic,
		flags = {"goes-to-main-inventory"},
		subgroup = "crystallization",
		stack_size = 200
		}
		crystalines[#crystalines+1]=shard
		
		ic = metal_omnide_icon(metal)
		local omnide = {
		type = "fluid",
		name = metal.."-omnide-solution",
		icon_size = 32,
		localised_name = {"fluid-name.omnide-solution", loc_key},
		icons = ic,
		default_temperature = 25,
		heat_capacity = "0.1KJ",
		base_color = {r = 1, g = 1, b = 1},
		flow_color = {r = 1, g = 1, b = 1},
		max_temperature = 100,
		pressure_to_speed_ratio = 0.4,
		flow_to_energy_ratio = 0.59,
		}
		crystalines[#crystalines+1]=omnide
		
		omni.lib.create_barrel(omnide)
		
		ic = salt_omnide_icon(metal)
		local salt = {
			type = "item",
			name = metal.."-omnide-salt",
			icon_size = 32,
			localised_name = {"item-name.omnide-salt", loc_key},
			icons = ic,
			flags = {"goes-to-main-inventory"},
			subgroup = "crystallization",
			stack_size = 200
		}
		crystalines[#crystalines+1]=salt
		
		--ing[#ing+1]={type = fluid, name = metal.."-omnide-solution", amount = 120}
				
		local crystalization = {
			type = "recipe",
			name = metal.."-crystalization",
			localised_name = {"recipe-name.crystallization", loc_key},
			localised_description = {"recipe-description.pure_extraction", loc_key},
			category = "omniplant",
			subgroup = "crystallization",
			enabled = false,
			ingredients = {
			{type = "item", name = "omnine-shards", amount = 1},
			{type = "fluid", name = metal.."-omnide-solution", amount = 120},
			{type = "fluid", name = "omni-sludge", amount = 120},
			},
			order = "a[angelsore1-crushed]",
			icon = "__omnimatter_crystal__/graphics/icons/"..metal.."-crystal.png",
			icon_size = 32,
			results = {{type = "item", name = metal.."-crystal", amount=10}},
			energy_required = 2.5,
			}
		crystalines[#crystalines+1]=crystalization
		
		ic = metal_omnide_icon(metal)
		local solvation = {
			type = "recipe",
			name = metal.."-solvation",
			localised_name = {"recipe-name.ore-solvation", loc_key},
			localised_description = {"recipe-description.pure_extraction", loc_key},
			category = "omniplant",
			subgroup = "solvation",
			enabled = false,
			ingredients = {
			{type = "item", name = metal.."-omnide-salt", amount = 1},
			{type = "fluid", name = "water", amount = 100},
			},
			order = "a[angelsore1-crushed]",
			icons = ic,
			icon_size = 32,
			results = {{type = "fluid", name = metal.."-omnide-solution", amount=120}},
			energy_required = 2.5,
			}
		crystalines[#crystalines+1]=solvation
		
		local omnitraction = {
			type = "recipe",
			name = metal.."-omnitraction",
			localised_name = {"item-name."..metal},
			localised_description = {"recipe-description.pure_extraction", loc_key},
			category = "omnite-extraction",
			subgroup = "traction",
			enabled = false,
			ingredients = {
			{type = "item", name = metal.."-crystal", amount=3}
			},
			order = "a[angelsore1-crushed]",
			icon = data.raw.item[metal].icon,
			icon_size = 32,
			results = {{type = "item", name = metal, amount=4}},
			energy_required = 2.5,
			}
		crystalines[#crystalines+1]=omnitraction
		
		data:extend(crystalines)
	end
end 

local ingrediences_solvation=function(recipe)
	local ing = {}
	ing[#ing+1]={type = "fluid", name = "hydromnic-acid", amount = 120}
	for _, i in pairs(data.raw.recipe[recipe].ingredients) do
		if i.name ~= "catalysator-brown" then
			ing[#ing+1]=i
		end
	end
	return ing
end
local results_solvation=function(recipe)
	local ing = {}
	--ing[#ing+1]={type = "fluid", name = "hydromnic-acid", amount = 120}
	for _, i in pairs(data.raw.recipe[recipe].results) do
		--log(recipe..":"..i.name)
		if i.name ~= "slag" then
			ing[#ing+1]={type = "item", name=i.name.."-omnide-salt", amount = 5*i.amount}
		end
	end
	return ing
end

omni.crystal.add_recipe=function(recipe,name)
	crystalines={}
	local ing = ingrediences_solvation(recipe)
	local res = results_solvation(recipe)
	local metal = name
	if not name then metal = data.raw.recipe[recipe].ingredients[1].name end
	local ic = salt_omnide_icon(metal)
	if not data.raw["item-subgroup"][data.raw.recipe[recipe].subgroup.."-omnide"] then
		local cat = {
			type = "item-subgroup",
			name = data.raw.recipe[recipe].subgroup.."-omnide",
			group = "omnicrystal",
			order = "aa",
		}
		crystalines[#crystalines+1]=cat
	end
	----log(recipe..":"..metal..","..data.raw.recipe[recipe].subgroup.."-omnide")
	
	local solution = {
		type = "recipe",
		name = metal.."-salting",
		localised_name = {"recipe-name.omnide-salting", loc_key},
		localised_description = {"recipe-description.pure_extraction", loc_key},
		category = "omniplant",
		subgroup = data.raw.recipe[recipe].subgroup.."-omnide",
		enabled = false,
		ingredients = ing,
		order = "a[angelsore1-crushed]",
		icons = ic,
		icon_size = 32,
		results = res,
		energy_required = 5,
	}
	crystalines[#crystalines+1]=solution

	data:extend(crystalines)
end
