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
	icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/omnide-salt.png"}
	icons[#icons+1] = {icon = data.raw.item[metal].icon,scale=0.4,shift={-10,10}}
    return icons
end

local crystalines = {}
if not mods["angelsrefining"] then
	local turn_to_plate = {}
	local cat = {
		type = "item-subgroup",
		name = "omnide-salts",
		group = "omnicrystal",
		order = "aa",
	}
	crystalines[#crystalines+1]=cat
	for _,rec in pairs(data.raw.recipe) do
		if string.find(rec.name,"crystal") and omni.lib.end_with(rec.name,"omnitraction") and rec.category=="omnite-extraction" then
			local ore = rec.normal.results[1].name
			local metal = ""
			local plate = ""
			if ore == "quartz" then
				plate = "quartz"
				metal=plate
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
				metal=string.sub(ore,1,string.len(ore)-string.len("-ore"))
			end
			rec.normal.results[1].name=plate
			rec.icon=data.raw.item[plate].icon
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
				subgroup = "omnide-salts",
				enabled = false,
				ingredients = {
				{type="item",name=ore,amount=1},
				{type="fluid",name="hydromnic-acid",amount=120},
				},
				order = "a[angelsore1-crushed]",
				icons = ic,
				icon_size = 32,
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
--[[omni.crystal.generate_control_crystal("omnine","iron","copper",nil,1)
if mods["bobplates"] then
	omni.crystal.generate_control_crystal("copper","lead","tin",nil,1)
	omni.crystal.generate_control_crystal("bauxite","lead","zinc","copper",2)
	if mods["angelssmelting"] then
		omni.crystal.generate_control_crystal("manganese","rutile","cobalt","chrome",2)
	end
end]]

--omnimatter_crystal
--[[
data.raw["inserter"]["filter-inserter"].hand_base_picture.filename="__omnimatter_crystal__/graphics/inserter/filter-inserter-hand-base.png"
data.raw["inserter"]["filter-inserter"].hand_base_picture.hr_version.filename="__omnimatter_crystal__/graphics/inserter/hr-filter-inserter-hand-base.png"
data.raw["inserter"]["filter-inserter"].hand_closed_picture.filename="__omnimatter_crystal__/graphics/inserter/filter-inserter-hand-closed.png"
data.raw["inserter"]["filter-inserter"].hand_closed_picture.hr_version.filename="__omnimatter_crystal__/graphics/inserter/hr-filter-inserter-hand-closed.png"
data.raw["inserter"]["filter-inserter"].hand_open_picture.filename="__omnimatter_crystal__/graphics/inserter/filter-inserter-hand-open.png"
data.raw["inserter"]["filter-inserter"].hand_open_picture.hr_version.filename="__omnimatter_crystal__/graphics/inserter/hr-filter-inserter-hand-open.png"
data.raw["inserter"]["filter-inserter"].platform_picture.sheet.filename="__omnimatter_crystal__/graphics/inserter/filter-inserter-platform.png"
data.raw["inserter"]["filter-inserter"].platform_picture.sheet.hr_version.filename="__omnimatter_crystal__/graphics/inserter/hr-filter-inserter-platform.png"
data.raw["inserter"]["filter-inserter"].icon="__omnimatter_crystal__/graphics/icons/filter-inserter.png"
data.raw.item["filter-inserter"].icon = "__omnimatter_crystal__/graphics/icons/filter-inserter.png"
]]
