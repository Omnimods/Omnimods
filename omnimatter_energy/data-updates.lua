require("prototypes.fuel")
require("prototypes.solar_panels")
--require("prototypes.compat.omnium-cycle")

RecGen:import("repair-pack"):
	setNormalIngredients({type="item", name="omnicium-plate", amount=6},{type="item", name="omni-tablet", amount=2}):
	setExpensiveIngredients({type="item", name="omnicium-plate", amount=15},{type="item", name="omni-tablet", amount=7}):extend()

RecGen:import("engine-unit"):setIngredients({type="item", name="steel-plate", amount=2},
      {type="item", name="iron-gear-wheel", amount=2},
      {type="item", name="pipe", amount=2},
      {type="item", name="omnitor", amount=1}):extend()

RecGen:import("electric-engine-unit"):setIngredients({type="fluid", name="lubricant", amount=40},
      {type="item", name="electronic-circuit", amount=1},
      {type="item", name="anbaric-omnitor", amount=1},
      {type="item", name="engine-unit", amount=1}):extend()

omni.lib.add_recipe_ingredient("electric-furnace", {"steel-furnace", 1})

RecGen:import("burner-inserter"):
	setIngredients({"omnitor",1},{"iron-plate",1},{"iron-gear-wheel",1}):
	addBurnerIcon():
	extend()

--Move the Basic Inserter to its own tech (Red Packs only) to avoid deadlocks
--mod check
local condition=3
if mods["PyCoalTBaA"] then
	condition=1
elseif mods["bobelectronics"] then
	condition=2
end
RecGen:import("inserter"):
	setIngredients({"burner-inserter",1},{"anbaric-omnitor",1}):
	ifAddIngredients(condition==1,{"pcb1",1}):
	ifAddIngredients(condition==2,{"basic-circuit-board",1}):
	ifAddIngredients(condition==3,{"electronic-circuit",1}):
	setEnabled(false):
	setTechName("omnitech-anbaric-inserter"):
	setTechCost(60):
	setTechIcons("electric-inserter","omnimatter_energy"):
	setTechPacks(1):
	setTechPrereq("omnitech-anbaricity"):extend()

	omni.lib.add_prerequisite("logistic-science-pack", "omnitech-anbaric-inserter")

RecGen:import("boiler"):
	setTechName("omnitech-steam-power"):
	setTechCost(120):
	addIngredients("burner-omnitractor"):
	setTechLocName("omnitech-steam-power"):
	setTechPrereq("logistic-science-pack","omnitech-basic-omnium-power"):
	setTechIcons("steam-power","omnimatter_energy"):
	equalize("burner-omnitractor"):
	setEnabled(false):
	setTechPacks(2):extend()
	
if mods["angelsindustries"] and angelsmods.industries.components then
	RecGen:import("steam-engine"):
	equalize("omni-heat-burner"):
	setEnabled(false):
	setTechName("omnitech-steam-power"):extend()

	RecGen:import("electric-mining-drill"):
	setTechName("omnitech-anbaric-mining"):
	setTechCost(100):
	setTechIcons("mining-drill","omnimatter_energy"):
	setTechPacks(1):
	setEnabled(false):
	setTechPrereq("omnitech-anbaricity"):extend()
else
	RecGen:import("steam-engine"):
	setIngredients(
      {type="item", name="iron-plate", amount=10},
      {type="item", name="iron-gear-wheel", amount=5},
      {type="item", name="anbaric-omnitor", amount=3},
	  {type="item",name="omni-heat-burner",amount=1}):
	  equalize("omni-heat-burner"):
	  setEnabled(false):
	  setTechName("omnitech-steam-power"):extend()
	  
	RecGen:import("electric-mining-drill"):
	setIngredients(
      {type="item", name="iron-gear-wheel", amount=4},
      {type="item", name="anbaric-omnitor", amount=2},
      {type="item", name="burner-mining-drill", amount=1}):
	setTechName("omnitech-anbaric-mining"):
	setTechCost(100):
	setTechIcons("mining-drill","omnimatter_energy"):
	setTechPacks(1):
	setEnabled(false):
	setTechPrereq("omnitech-anbaricity"):extend()
end
	
if mods["bobassembly"] and settings.startup["bobmods-assembly-burner"].value then
	omni.lib.add_prerequisite("basic-automation", "omnitech-simple-automation")
	omni.lib.remove_prerequisite("automation", "basic-automation")
	BuildGen:import("omnitor-assembling-machine"):
		setSpeed(0.1):
		setFuelCategory("omnite"):extend()
	if mods["angelsindustries"] and angelsmods.industries.components then
		RecGen:import("burner-assembling-machine"):
			setTechCost(15):extend()
		RecGen:import("steam-assembling-machine"):
			setTechCost(15):extend()
		RecGen:import("assembling-machine-1"):
			setEnabled(false):
			setTechName("automation"):
			setTechCost(20):extend()
	else
		RecGen:import("burner-assembling-machine"):
			addIngredients({type="item", name="omnitor", amount=1},{type="item", name="omnitor-assembling-machine", amount=1}):
			setTechCost(15):extend()

		RecGen:import("steam-assembling-machine"):
			addIngredients({type="item", name="omnitor", amount=1},{type="item", name="omnitor-assembling-machine", amount=1}):
			setTechCost(15):extend()

		RecGen:import("assembling-machine-1"):
			setIngredients(
				{type="item", name="iron-gear-wheel", amount=4},
				{type="item", name="anbaric-omnitor", amount=2},
				{type="item", name="burner-assembling-machine", amount=1}):
			setEnabled(false):
			setTechName("automation"):
			setTechCost(20):extend()
	end
else
	if mods["angelsindustries"] and angelsmods.industries.components then
		RecGen:import("assembling-machine-1"):
			setEnabled(false):
			setTechName("automation"):
			setTechCost(15):extend()
	else
		RecGen:import("assembling-machine-1"):
			setIngredients(
				{type="item", name="iron-gear-wheel", amount=4},
				{type="item", name="anbaric-omnitor", amount=2},
				{type="item", name="omnitor-assembling-machine", amount=1}):
			setEnabled(false):
			setTechName("automation"):
			setTechCost(15):extend()
	end
end

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

omni.lib.add_prerequisite("fast-inserter", "burner-filter")

--Move All Electric Automation Recipes behind logistic science / anbaricity
if mods["angelsindustries"] and angelsmods.industries.tech then
	--skip if angels tech overhaul
else
	--Low tier techs, early needed, just needs electricity
	local logsp = {
    	"automation",
    	"electronics",
    	"fast-inserter"
  	}

  	for _,tech in pairs(data.raw.technology) do 
		for _,inctech in pairs(logsp) do
			if tech.name == inctech  then
				omni.lib.add_science_pack(tech.name,"logistic-science-pack")
				omni.lib.add_prerequisite(tech.name, "logistic-science-pack")
		 	end
	 	end	
	end
end

if mods["angelsindustries"] and angelsmods.industries.components then
	--Move water treatment behind anbaricity(red sp only) since its required for reds (inserters)
	omni.lib.replace_prerequisite("water-treatment","electronics","omnitech-anbaricity")
	omni.lib.replace_prerequisite("omnitech-anbaric-inserter","omnitech-anbaricity","tech-red-circuit")
else
	if mods["angelsrefining"] then
		RecGen:import("burner-ore-crusher"):
			setIngredients({type="item", name="omnite-brick", amount=4},
			{type="item", name="iron-plate", amount=4},
			{type="item", name="omnitor", amount=1}):
			extend()
		
		RecGen:import("ore-sorting-facility"):
			setIngredients({type="item", name="omnite-brick", amount=30},
			{type="item", name="iron-plate", amount=15},
			{type="item", name="anbaric-omnitor", amount=5}):
			setTechPrereq("omnitech-anbaricity"):
			extend() --not working...

			omni.lib.add_prerequisite("ore-crushing", "omnitech-anbaricity")
	end

	if mods["angelssmelting"] then
		omni.lib.add_prerequisite("angels-metallurgy-1", "omnitech-basic-omnium-power")
	end	
end

omni.lib.add_unlock_recipe("omnitech-anbaricity", "basic-circuit-board")

--Check if the vanilla lab is locked behind a tech /disabled. If yes, modify the tech
if data.raw.recipe["lab"].enabled == false then
	RecGen:import("lab"):
		setTechLocName("omnitech-anbaric-lab"):
		addIngredients({"omnitor-lab",1}):
		setTechIcons("lab","omnimatter_energy"):
		setTechCost(100):
		extend()

	omni.lib.add_prerequisite(omni.lib.get_tech_name("lab"), "omnitech-anbaricity")
else
--Create a new tech
	RecGen:import("lab"):
		setEnabled(false):
		setTechName("omnitech-anbaric-lab"):
		setTechLocName("omnitech-anbaric-lab"):
		addIngredients({"omnitor-lab",1}):
		setTechCost(100):
		setTechIcons("lab","omnimatter_energy"):
		setTechPacks(1):
		setTechPrereq("omnitech-anbaricity"):
		extend()
end

--Add omnitors to various recipes
--omnitor
omni.lib.add_recipe_ingredient("gun-turret",{"omnitor",4})
--anbaric omnitor
omni.lib.add_recipe_ingredient("radar",{"anbaric-omnitor",2})
omni.lib.add_recipe_ingredient("lab",{"anbaric-omnitor",4})
omni.lib.add_recipe_ingredient("centrifuge",{"anbaric-omnitor",25})
omni.lib.add_recipe_ingredient("artillery-turret",{"anbaric-omnitor",15})
omni.lib.add_recipe_ingredient("artillery-wagon",{"anbaric-omnitor",15})
omni.lib.add_recipe_ingredient("laser-turret",{"anbaric-omnitor",8})

--Stuff to manually remove from the Omnitor Lab
local packs = {
	"token-bio"
}

for i,inputs in pairs(data.raw["lab"]["omnitor-lab"].inputs) do
	for _,pack in pairs(packs) do
		if inputs == pack then
			table.remove(data.raw["lab"]["omnitor-lab"].inputs,i, pack)
		end
	end
end

--Miniloader compatibility
--(The Chute recipe is based on basic belt ingredients (mostly just iron), so we need to add omnitors to that recipe aswell)
if data.raw.recipe["chute-miniloader"] then
	omni.lib.add_recipe_ingredient("chute-miniloader",{type = "item", name ="omnitor", amount = 2})
	omni.lib.add_science_pack("miniloader","logistic-science-pack")
end

if data.raw.technology["logistics-0"] then
	-- Finally removing logistics-0
	omni.lib.remove_prerequisite("logistics","logistics-0")
	data.raw.technology["logistics-0"] = nil
end

require("prototypes.compat.bobs_burner_phase")
require("prototypes.compat.py")
require("prototypes.compat.krastorio2")