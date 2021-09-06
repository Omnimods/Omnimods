
omni.crystal.metals = {}


local shard_icons = function(metal)
	math.randomseed(string.byte(metal,1))
	local nr = math.random(3,6)
    --Build the icons table
    local icons = {}
	for i=1,nr do
		icons[#icons+1] = {
			icon = "__omnimatter_crystal__/graphics/icons/"..metal.."-crystal.png",
			icon_size=32,
			scale=0.2,
			shift={5*math.cos(((i-1)/nr+0.5)*2*math.pi),5*math.sin(((i-1)/nr+0.5)*2*math.pi)}
		}
	end
    return icons
end

local metal_omnide_icon = function(metal)
    --Build the icons table
    local icons = util.combine_icons(
		{{
			icon = "__omnimatter_crystal__/graphics/icons/omnide-solution.png",
			icon_size = 32
		}},
		omni.lib.icon.of(data.raw.item[metal]),
		{}
	)
	for I=2, #icons do
		icons[I].scale = 0.4 * 32 / icons[I].icon_size
		icons[I].shift = {-10, 10}
	end
    return icons
end

local salt_omnide_icon = function(metal)
	--Build the icons table
	local icons = util.combine_icons(
		{{
			icon = "__omnimatter_crystal__/graphics/icons/omnide-salt.png",
			icon_size = 32
		}},
		omni.lib.icon.of(data.raw.item[metal]),
		{}
	)
	for I=2, #icons do
		icons[I].scale = 0.4 * 32 / icons[I].icon_size
		icons[I].shift = {-10, 10}
	end
	return icons
end



omni.crystal.add_crystal=function(metal,name,recipe)
	if data.raw.item[metal] and not data.raw.recipe[metal.."-crystal"] then
		omni.crystal.metals[#omni.crystal.metals+1]=data.raw.item[metal]

		RecGen:create("omnimatter_crystal",metal.."-crystal"):
			setLocName("recipe-name.crystal",name):
			setFuelValue(35):
			setFuelCategory("crystal"):
			setSubgroup("crystallization"):
			setOrder("a["..metal.."-crystal]"):
			setStacksize(500):
			marathon():
			setIcons(metal.."-crystal"):
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
			setLocName("recipe-name.ore-solvation",name):
			fluid():
			setBothColour(1,1,1):
			setSubgroup("solvation"):
			setOrder("a["..metal.."-omnide-solution]"):
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
			setLocName("recipe-name.crystal-omnitraction","item-name."..metal):
			setSubgroup("traction"):
			setOrder("a["..metal.."-crystal-omnitraction]"):
			marathon():
			setIcons(metal):
			setCategory("omnite-extraction"):
			addProductivity():
			setIngredients({type = "item", name = metal.."-crystal", amount=3}):
			setResults({type = "item", name = metal, amount=4}):
			setMain(metal):
			setEnergy(1.5):extend()
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


--Dead function ?
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
			order = data.raw["item-subgroup"]["solvation"].order, -- set the order of the "solvation" subgroup to be able to control the order of all created subgroups
		}
		crystalines[#crystalines+1]=cat
	end
	----log(recipe..":"..metal..","..data.raw.recipe[recipe].subgroup.."-omnide")
	local solution = {
		type = "recipe",
		name = metal.."-salting",
		localised_name = {"recipe-name.omnide-salting", metal},
		localised_description = {"recipe-description.pure_extraction", metal},
		category = "omniplant",
		subgroup = data.raw.recipe[recipe].subgroup.."-omnide",
		order = data.raw.recipe[recipe].order,
		enabled = false,
		ingredients = ing,
		icons = ic,
		results = res,
		energy_required = 5,
	}
	crystalines[#crystalines+1]=solution

	data:extend(crystalines)
end
