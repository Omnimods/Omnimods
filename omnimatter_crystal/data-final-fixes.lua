
--[[
if mods["SpaceMod"] and mods["angelssmelting"] and mods["bobplates"]then
	omni.lib.replace_recipe_ingredient("drydock-assembly","processing-unit",omni.crystal.find_crystallonic({"manganese","rutile","cobalt","chrome"},2))
	omni.lib.replace_recipe_ingredient("space-thruster","processing-unit",omni.crystal.find_crystallonic({"manganese","rutile","cobalt","chrome"},2))
	omni.lib.replace_recipe_ingredient("fuel-cell","processing-unit",omni.crystal.find_crystallonic({"manganese","rutile","cobalt","chrome"},2))
	omni.lib.replace_recipe_ingredient("habitation","processing-unit",omni.crystal.find_crystallonic({"manganese","rutile","cobalt","chrome"},2))
	omni.lib.replace_recipe_ingredient("life-support","processing-unit",omni.crystal.find_crystallonic({"manganese","rutile","cobalt","chrome"},2))
	omni.lib.replace_recipe_ingredient("command","processing-unit",omni.crystal.find_crystallonic({"manganese","rutile","cobalt","chrome"},2))
	omni.lib.replace_recipe_ingredient("astrometrics","processing-unit",omni.crystal.find_crystallonic({"manganese","rutile","cobalt","chrome"},2))
	omni.lib.replace_recipe_ingredient("ftl-drive","processing-unit",omni.crystal.find_crystallonic({"manganese","rutile","cobalt","chrome"},2))
end

if mods["bobplates"] then
	omni.crystal.generate_hybrid_circuit({"copper","lead","tin",1},"advanced-circuit","Logic")
	omni.crystal.generate_hybrid_circuit({"bauxite","lead","zinc","copper",2},"processing-unit","Processing")
	if mods["angelssmelting"] then
		omni.crystal.generate_hybrid_circuit({"manganese","rutile","cobalt","chrome",2},"processing-unit","Processing")
	end
end]]

if angelsmods and angelsmods.refining then
	----log("test: "..settings.startup["omnicrystal-sloth"].value)
	--"angelsore7-crystallization-"
	if not settings.startup["omnicrystal-sloth"].value then
		for _,rec in pairs(data.raw.recipe) do
			if omni.lib.start_with(rec.name,"slag-processing-") and not omni.lib.recipe_result_contains(rec.name,{"slag-slurry","mineral-sludge"}) and rec.name ~= "slag-processing-stone" then
				omni.lib.remove_recipe_all_techs(rec.name)
				rec.enabled = false
			end
		end
	end
end


local omnitem = {}
local check_items = {}
local base_items = {}
local excluded_items = {}
for _,item in pairs(data.raw.item) do
	if string.find(item.name,"plate") then
		omnitem[#omnitem+1]={name=item.name,cost=12/13}
	elseif not string.find(item.name,"ore") and not omni.lib.is_in_table(item.name,excluded_items) then
		check_items[#check_items+1]=item.name
	end
end

for i=2,4 do
	if not (data.raw.technology["crystallonics-"..i-1].enabled and data.raw.technology["crystallonics-"..i].effects and #data.raw.technology["crystallonics-"..i].effects>0) then
		--data.raw.technology["crystallonics-"..i].enabled = false
	end
end
