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
if mods["Krastorio2"] then
	omni.crystal.add_crystal("raw-imersite","Imersite")
	omni.crystal.add_crystal("raw-rare-metals","Rare metals")
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
		omni.lib.icon.of(data.raw.item[metal]),
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
			local metal = string.gsub(ore,"-ore","")

			local tier = 1
			for i,t in pairs(omni.matter.omnisource) do
				for _,o in pairs(t) do
					if o.name == ore then
						tier = math.min(o.tier,omni.max_tier - 1)
					end
				end
			end
			
			--Create salting recipes
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
			omni.lib.replace_recipe_result(rec.name, ore, "crystal-powder-"..metal)
			rec.icon=nil
			rec.icon_size=nil
			rec.icons = omni.lib.icon.of(data.raw.item["crystal-powder-"..metal])
			rec.localised_name = {"recipe-name.crystal-powder", {metal}}
			rec.localised_name = {"recipe-name.crystal-powder", {"item-name." .. metal}}
		end
	end

	--Copy all smelting / processing recipes, make a copy and replace the ore ingredient with crystal-powder (exclude salting recipes!!!)
	for _,rec in pairs(data.raw.recipe) do
		if rec.subgroup ~= "salting" and not string.find(rec.name, "crystal%-powder") then
			local found = false
			--Check if the recipe contains any ores
			for _,ore in pairs(added_ores) do
				if omni.lib.recipe_ingredient_contains(rec.name, ore) then
					found = true
					break
				end	
			end

			--If yes, copy the recipe
			if found == true then
				local r = RecGen:import(rec.name)
				local iproto = omni.lib.find_prototype(rec.name)
				r:setName("crystal-powder-"..rec.name):
				setLocName({"recipe-name.crystalline", omni.lib.locale.of(rec).name}):
				setEnabled(false):
				setOrder((rec.order or (iproto and iproto.order) or "ab-") .. "[crystalline]")

				--Check the recipe ingredients for all ores and replace them with powder
				for _,ore in pairs(added_ores) do
					if omni.lib.recipe_ingredient_contains(rec.name, ore) then
						local metal = string.gsub(ore,"-ore","")
						r:replaceIngredients(ore, "crystal-powder-"..metal)

						if (rec.hidden and rec.hidden == true) or (rec.normal and rec.normal.hidden and rec.normal.hidden ==true) then
							r:setHidden(rec.hidden)
						else
							r:setTechName(omni.lib.get_tech_name(ore.."-crystal"))
						end
					end
				end
				r:extend()
			end
		end
	end
end