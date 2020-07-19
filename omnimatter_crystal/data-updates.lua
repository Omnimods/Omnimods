--colours=Set{add_colour}

require("prototypes.recipes.bobs")
require("prototypes.recipes.angels")

--omni.lib.remove_recipe_all_techs("omniplant-1")
--omni.lib.add_unlock_recipe("omnitech-omnic-acid-hydrolization-1","omniplant-1")

if mods["Yuoki"] then
	omni.crystal.add_crystal("y-res1","Durotal")
	omni.crystal.add_crystal("y-res2","Nuatreel")
end

omni.crystal.add_crystal("iron-ore","Iron")
omni.crystal.add_crystal("copper-ore","Copper")
omni.crystal.add_crystal("uranium-ore","Uranium")
if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("omnine-distillation-quick")
	omni.marathon.exclude_recipe("omnine-distillation-slow")
end

local salt_omnide_icon = function(metal)
	local nr = 5
	--Build the icons table
	local icons = {}
	icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/omnide-salt.png",icon_size=32}
	icons[#icons+1] = {
		icon = data.raw.item[metal].icon or data.raw.item[metal].icons[1].icon,
		icon_size=omni.crystal.get_ore_ic_size(metal),
		scale=0.4*32/omni.crystal.get_ore_ic_size(metal),
		shift={-10,10}
	}
	return icons
end

if data.raw.item["angels-copper-pebbles-crystal"] then
	for _,metal in pairs({"iron","copper"}) do
		for _,type in pairs({"-pebbles","-slag","-nugget"}) do
			for _,style in pairs({"-omnide-solution","-crystal-omnitraction","-crystal"}) do
				omni.lib.add_unlock_recipe("crystallology-1", "angels-"..metal..type..style)
				omni.lib.add_unlock_recipe("crystallology-1", metal.."-ore"..style)
			end
		end
	end
end

local crystalines = {}
if not mods["angelsrefining"] then
	local turn_to_plate = {}
	for _,rec in pairs(data.raw.recipe) do
		if string.find(rec.name,"crystal") and omni.lib.end_with(rec.name,"omnitraction") and rec.category=="omnite-extraction" then
			local ore = rec.normal.results[1].name
			local metal = ""
			local plate = ""
			if ore == "quartz" then
				plate = "silicon"
				metal= "silicon-plate"
			elseif ore == "bauxite-ore" then
				plate = "aluminium-plate"
				metal="aluminium"
			elseif ore == "rutile-ore" then
				plate = "titanium-plate"
				metal="titanium"
			elseif ore == "uranium-ore" then
				plate = "uranium-235"
				metal="uranium"
			elseif ore== "thorium-ore" then
				plate= "thorium-232"
				metal="thorium"
			else
				plate = string.sub(ore,1,string.len(ore)-string.len("-ore")).."-plate"
				metal = string.sub(ore,1,string.len(ore)-string.len("-ore"))
			end
			rec.normal.results[1].name=plate
			rec.icon=data.raw.item[plate].icon
			rec.icon_size=data.raw.item[plate].icon_size
			rec.localised_name = {"recipe-name.item", {"item-name."..plate}}
			local tier = 1
			for i,t in pairs(omnisource) do
				for _,o in pairs(t) do
					if o.name == ore then
						tier = o.tier
					end
				end
			end
			--omni.lib.add_unlock_recipe("crystallology-"..tier, rec.name)
			local ic = salt_omnide_icon(ore)
			local solution = {
				type = "recipe",
				name = ore.."-salting",
				localised_name = {"recipe-name.omnide-salting", {"item-name."..ore}},
				localised_description = {"recipe-description.pure_extraction", {"item-name."..ore}},
				category = "omniplant",
				subgroup = "salting",
				enabled = false,
				ingredients = {
				{type="item",name=ore,amount=1},
				{type="fluid",name="hydromnic-acid",amount=120},
				},
				order = "a[angelsore1-crushed]",
				icons = ic,
				icon_size = omni.crystal.get_ore_ic_size(ore),--32,
				results = {
				{type="item",name=ore.."-omnide-salt",amount=1},
				},
				energy_required = 5,
			}

			crystalines[#crystalines+1]=solution
			omni.lib.add_unlock_recipe("crystallology-"..tier, ore.."-salting")
			omni.lib.add_unlock_recipe("crystallology-"..tier, ore.."-omnide-solution")
			omni.lib.add_unlock_recipe("crystallology-"..tier, ore.."-crystal-omnitraction")
			omni.lib.add_unlock_recipe("crystallology-"..tier, ore.."-crystal")

		end
	end
	data:extend(crystalines)
	--data.raw.technology["crystallology-4"].enabled=false
end
