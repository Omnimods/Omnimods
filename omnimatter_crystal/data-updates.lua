--colours=Set{add_colour}

require("prototypes.recipes.bobs")
require("prototypes.recipes.angels")

--omni.lib.remove_recipe_all_techs("omniplant-1")
--omni.lib.add_unlock_recipe("omnitech-omnic-acid-hydrolization-1","omniplant-1")

omni.crystal.add_crystal("iron-ore","Iron")
omni.crystal.add_crystal("copper-ore","Copper")
omni.crystal.add_crystal("uranium-ore","Uranium")

if mods["Yuoki"] then
	omni.crystal.add_crystal("y-res1","Durotal")
	omni.crystal.add_crystal("y-res2","Nuatreel")
end

if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("omnine-distillation-quick")
	omni.marathon.exclude_recipe("omnine-distillation-slow")
end

local salt_omnide_icon = function(metal)
	--Build the icons table
	local icons = util.combine_icons(
		{{
			icon = "__omnimatter_crystal__/graphics/icons/omnide-salt.png",
			icon_size = 32
		}},
		omni.icon.of(data.raw.item[metal]),
		{}
	)
	for I=2, #icons do
		icons[I].scale = 0.4 * 32 / icons[I].icon_size
		icons[I].shift = {-10, 10}
	end
	return icons
end

if data.raw.item["angels-copper-pebbles-crystal"] then
	for _,metal in pairs({"iron","copper"}) do
		for _,type in pairs({"-pebbles","-slag","-nugget"}) do
			for _,style in pairs({"-omnide-solution","-crystal-omnitraction","-crystal"}) do
				omni.lib.add_unlock_recipe("omnitech-crystallology-1", "angels-"..metal..type..style)
				omni.lib.add_unlock_recipe("omnitech-crystallology-1", metal.."-ore"..style)
			end
		end
	end
end

--Non Angels case
if not mods["angelsrefining"] then
	local added_ores = {}

	for _,rec in pairs(data.raw.recipe) do
		if string.find(rec.name,"crystal") and omni.lib.end_with(rec.name,"omnitraction") and rec.category=="omnite-extraction" then
			local ore = rec.normal.results[1].name
			added_ores[#added_ores+1] = ore
			local metal = string.sub(ore,1,string.len(ore)-string.len("-ore"))

			--Create crystal powder item if it doesnt exist yet
			if not data.raw.item["crystal-powder-"..metal] then
				ItemGen:create("omnimatter_crystal", "crystal-powder-"..metal):
					setLocName({"item-name.crystal-powder", {metal}}):
					setIcons({{
						icon = "__omnimatter_crystal__/graphics/icons/crystal-powder.png",
						icon_size = 32,
						tint = omni.lib.ore_tints[metal] or {r = 1, g = 1, b = 1, a = 1}
						}}):
					extend()	
			end

			--Replace the ore with crystal powder
			rec.normal.results[1].name = "crystal-powder-"..metal
			rec.icon=nil
			rec.icon_size=nil
			rec.icons = omni.icon.of(data.raw.item["crystal-powder-"..metal])
			rec.localised_name = {"item-name.crystal-powder", {metal}}

			local tier = 1
			for i,t in pairs(omnisource) do
				for _,o in pairs(t) do
					if o.name == ore then
						tier = o.tier
					end
				end
			end
			
			RecGen:create("omnimatter_crystal", ore.."-salting"):
				setIngredients({
					{type="item",name=ore,amount=1},
					{type="fluid",name="hydromnic-acid",amount=120}}):
				setResults(ore.."-omnide-salt"):
				setEnabled(false):
				setTechName("omnitech-crystallology-"..tier):
				setIcons(salt_omnide_icon(ore)):
				setLocName({"recipe-name.omnide-salting", {"item-name."..ore}}):
				setLocDesc({"recipe-description.pure_extraction", {"item-name."..ore}}):
				setSubgroup("salting"):
				setOrder("a[omnide-salting]"..ore):
				setStacksize(200):
				setEnergy(5):
				setCategory("omniplant"):
				extend()

			omni.lib.add_unlock_recipe("omnitech-crystallology-"..tier, ore.."-omnide-solution")
			omni.lib.add_unlock_recipe("omnitech-crystallology-"..tier, ore.."-crystal-omnitraction")
			omni.lib.add_unlock_recipe("omnitech-crystallology-"..tier, ore.."-crystal")
		end
	end

	for _,rec in pairs(data.raw.recipe) do
		for _,ore in pairs(added_ores) do

			--Copy all smelting / processing recipes, make a copy and replace the ore ingredient with crystal-powder
			if omni.lib.recipe_ingredient_contains(rec.name, ore) then --and (string.find(rec.name, "plate") or string.find(rec.name, "processing") ) then
				local metal = string.sub(ore,1,string.len(ore)-string.len("-ore"))
				
				RecGen:import(rec):
					setName("crystal-powder-"..rec.name):
					replaceIngredients(ore, "crystal-powder-"..metal):
					setEnabled(false):
					setTechName(omni.lib.get_tech_name(ore.."-crystal")):
					extend()
			end
		end
	end
end