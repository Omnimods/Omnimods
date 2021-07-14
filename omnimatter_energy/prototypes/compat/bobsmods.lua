-- if mods["boblogistics"] and settings.startup["bobmods-logistics-beltoverhaul"].value then
-- 	log("OmniEnergy: Bobs Belt Overhaul found")
-- 	--Create seperate techs for Basic Belt, Splitter and UG
-- 	RecGen:import("basic-transport-belt"):
-- 		setEnabled(false):
-- 		setTechName("omnitech-basic-belt-logistics"):
-- 		setTechIcons("logistics","omnimatter_energy"):
-- 		setTechPrereq():
-- 		ifAddTechPrereq(data.raw.technology["basic-automation"], "basic-automation"):
-- 		ifAddTechPrereq(not data.raw.technology["basic-automation"], "omnitech-simple-automation"):
-- 		setTechPacks(1):
-- 		setTechCost(25):
-- 		setIngredients(
--       {type="item", name="iron-plate", amount=1},
--       {type="item", name="omnitor", amount=1}):
-- 		setResults({"basic-transport-belt",3}):extend()
	
-- 	RecGen:import("basic-splitter"):
-- 		setEnabled(false):
-- 		setTechName("omnitech-basic-splitter-logistics"):
-- 		setTechLocName("omnitech-basic-splitter-logistics"):
-- 		setTechIcons("logistics","omnimatter_energy"):
-- 		setTechPrereq("omnitech-basic-belt-logistics"):
-- 		setTechPacks(1):
-- 		setTechCost(30):extend()

-- 	RecGen:import("basic-underground-belt"):
-- 		setEnabled(false):
-- 		setTechName("omnitech-basic-underground-logistics"):
-- 		setTechLocName("omnitech-basic-underground-logistics"):
-- 		setTechIcons("logistics","omnimatter_energy"):
-- 		setTechPrereq("omnitech-basic-belt-logistics"):
-- 	 	setTechPacks(1):
-- 		setTechCost(30):extend()

-- 	--Add new Techs as Prereq for vanilla logistics
-- 	omni.lib.set_prerequisite("logistics", "omnitech-anbaricity")

-- 	--Move all Techs that have logistics-0 as Prereq behind Basic Splitter & UG Techs
-- 	for _,t in pairs(data.raw.technology) do
-- 		if omni.lib.is_in_table("logistics-0",t.prerequisites) then
-- 			omni.lib.remove_prerequisite(t.name,"logistics-0")
-- 			omni.lib.add_prerequisite(t.name,"omnitech-basic-splitter-logistics")
-- 			omni.lib.add_prerequisite(t.name,"omnitech-basic-underground-logistics")
-- 		end
-- 	end

-- 	--Move all remaining logistic-0 unlocks to belt logistics
-- 	for _,eff in pairs(data.raw.technology["logistics-0"].effects) do
-- 		if eff and eff.type == "unlock-recipe" and not (string.find(eff.recipe,"splitter") or string.find(eff.recipe,"underground") or string.find(eff.recipe,"transport-belt")) then
-- 			omni.lib.add_unlock_recipe("omnitech-basic-belt-logistics", eff.recipe)
-- 		end
-- 	end

-- 	--Remove logistics-0 Tech
-- 	TechGen:import("logistics-0"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()
-- else
-- 	--Create seperate techs for Belt, Splitter and UG
-- 	RecGen:import("transport-belt"):
-- 		setEnabled(false):
-- 		setTechName("omnitech-belt-logistics"):
-- 		setTechIcons("logistics","omnimatter_energy"):
-- 		setTechPrereq():
-- 		ifAddTechPrereq(data.raw.technology["basic-automation"], "basic-automation"):
-- 		ifAddTechPrereq(not data.raw.technology["basic-automation"], "omnitech-simple-automation"):
-- 		setTechPacks(1):
-- 		setTechCost(25):
-- 		setIngredients(
--       {type="item", name="iron-plate", amount=1},
--       {type="item", name="omnitor", amount=1}):extend()
	
-- 	RecGen:import("splitter"):
-- 		setEnabled(false):
-- 		setTechName("omnitech-splitter-logistics"):
-- 		setTechIcons("logistics","omnimatter_energy"):
-- 		setTechPrereq("omnitech-belt-logistics"):
-- 		setTechPacks(1):
-- 		setTechCost(30):extend()

-- 	RecGen:import("underground-belt"):
-- 		setEnabled(false):
-- 		setTechName("omnitech-underground-logistics"):
-- 		setTechIcons("logistics","omnimatter_energy"):
-- 		setTechPrereq("omnitech-belt-logistics"):
-- 		setTechPacks(1):
-- 		setTechCost(30):extend()

-- 	--Move all Techs that have logistics as Prereq behind Splitter & UG Techs
-- 	for _,t in pairs(data.raw.technology) do
-- 		if omni.lib.is_in_table("logistics",t.prerequisites) then
-- 			omni.lib.remove_prerequisite(t.name,"logistics")
-- 			omni.lib.add_prerequisite(t.name,"omnitech-splitter-logistics")
-- 			omni.lib.add_prerequisite(t.name,"omnitech-underground-logistics")
-- 		end
-- 	end

-- 	--Move all remaining logistic unlocks to belt logistics
-- 	for _,eff in pairs(data.raw.technology["logistics"].effects) do
-- 		if eff and eff.type == "unlock-recipe" and not (string.find(eff.recipe,"splitter") or string.find(eff.recipe,"underground") or string.find(eff.recipe,"transport-belt")) then
-- 			omni.lib.add_unlock_recipe("omnitech-belt-logistics", eff.recipe)
-- 		end
-- 	end
-- 	--Remove logistics Tech
-- 	TechGen:import("logistics"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()
-- end


if mods["bobpower"] then
    omni.lib.add_prerequisite("bob-steam-engine-2", "omnitech-steam-power")
    omni.lib.add_prerequisite("bob-boiler-2", "omnitech-steam-power")
    RecGen:import("bob-burner-generator"):setEnabled(false):extend()
else
    omni.lib.add_recipe_ingredient("steam-turbine",{"anbaric-omnitor",10})
end




if mods["bobmining"] then
    omni.lib.add_prerequisite("bob-drills-1", "omnitech-anbaric-mining")
end