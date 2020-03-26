
omni.crystal.metals = {}


local shard_icons = function(metal)
	math.randomseed(string.byte(metal,1))
	local nr = math.random(3,6)
    --Build the icons table
    local icons = {}
	for i=1,nr do
		icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/"..metal.."-crystal.png",icon_size=32,scale=0.2,shift={5*math.cos(((i-1)/nr+0.5)*2*math.pi),5*math.sin(((i-1)/nr+0.5)*2*math.pi)}}
	end
    return icons
end

local metal_omnide_icon = function(metal)
	local nr = 5
    --Build the icons table
    local icons = {}
	icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/omnide-solution.png",icon_size=32}
	icons[#icons+1] = {icon = data.raw.item[metal].icon,icon_size=omni.crystal.get_ore_ic_size(metal),scale=0.4*32/omni.crystal.get_ore_ic_size(metal),shift={-10,10}}
    return icons
end

local salt_omnide_icon = function(metal)
	local nr = 5
    --Build the icons table
    local icons = {}
	icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/omnide-salt.png",icon_size=32}
	icons[#icons+1] = {icon = data.raw.item[metal].icon,icon_size=omni.crystal.get_ore_ic_size(metal),scale=0.4*32/omni.crystal.get_ore_ic_size(metal),shift={-10,10}}
    return icons
end



omni.crystal.add_crystal=function(metal,name,recipe)
	if data.raw.item[metal] then
		omni.crystal.metals[#omni.crystal.metals+1]=data.raw.item[metal]

		RecGen:create("omnimatter_crystal",metal.."-crystal"):
			setLocName("item-name.crystal",name):
			setFuelValue(35):
			setFuelCategory("crystal"):
			setSubgroup("crystallization"):
			setStacksize(500):
			marathon():
			setCategory("omniplant"):
			setIngredients({
				{type = "item", name = "omnine-shards", amount = 1},
				{type = "fluid", name = metal.."-omnide-solution", amount = 120},
				{type = "fluid", name = "omnisludge", amount = 120},
				}):
			setResults({type = "item", name = metal.."-crystal", amount=10}):
			setEnergy(2.5):extend()

		ItemGen:create("omnimatter_crystal",metal.."-omnide-salt"):
			setLocName("item-name.omnide-salt",name):
			setIcons("omnide-salt"):
			addSmallIcon(metal,3):
			setSubgroup("crystallization"):
			setStacksize(200):extend()


		RecGen:create("omnimatter_crystal",metal.."-omnide-solution"):
			setLocName("ore-solvation",name):
			fluid():
			setBothColour(1,1,1):
			setSubgroup("solvation"):
			marathon():
			setIcons("omnide-solution"):
			addSmallIcon(metal,3):
			setCategory("omniplant"):
			setIngredients({
				{type = "item", name = metal.."-omnide-salt", amount = 1},
				{type = "fluid", name = "water", amount = 100},
				}):
			setResults({type = "fluid", name = metal.."-omnide-solution", amount=120}):
			setEnergy(2.5):extend()

		RecGen:create("omnimatter_crystal",metal.."-crystal-omnitraction"):
			setLocName("crystal-omnitraction","item-name."..metal):
			setSubgroup("traction"):
			marathon():
			setIcons(metal):
			setCategory("omnite-extraction"):
			addProductivity():
			setIngredients({type = "item", name = metal.."-crystal", amount=3}):
			setResults({type = "item", name = metal, amount=4}):
			setEnergy(1.5):extend()

		--[[local ic = shard_icons(metal)
		local shard =   {
		type = "item",
		name = metal.."-shard",
		icon_size = 32,
		icons = ic,
		flags = {"goes-to-main-inventory"},
		subgroup = "crystallization",
		stack_size = 200
		}]]
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
			--order = "aa",
			order = data.raw["item-subgroup"]["solvation"].order, -- set the order of the "solvation" subgroup to be able to control the order of all created subgroups
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
		--icon_size = 32,
		results = res,
		energy_required = 5,
	}
	crystalines[#crystalines+1]=solution

	data:extend(crystalines)
end
