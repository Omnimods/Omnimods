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

<<<<<<< HEAD
RecGen:import("omniplant-1"):addIngredients({"burner-omniplant",1}):extend()
<<<<<<< HEAD
=======
=======
--RecGen:import("omniplant-1"):addIngredients({"burner-omniplant",1}):extend()
>>>>>>> parent of 9210a31... revert2
-- Add the Burner Omniplant to the omnitractor tech here until the tech is moved out of final fixes in omnimatter
RecGen:import("burner-omniplant"):setTechName("omnitractor-electric-1"):extend()
>>>>>>> parent of 5910ed9... moved the building generation from dff to data
