require("prototypes.fuel")
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

RecGen:import("burner-inserter"):setIngredients({"omnitor",1},{"iron-plate",1}):setTechName("basic-automation"):extend()

RecGen:import("inserter"):setIngredients({"burner-inserter",1},{"omnitor",1}):
	setEnabled(false):
	setTechName("automation"):extend()

RecGen:import("boiler"):setTechName("steam-power"):
	setTechCost(120):
	addIngredients("burner-omnitractor"):
	setTechLocName("steam-power"):
	setTechPrereq("logistic-science-pack"):
	setTechIcon("omnimatter_energy","steam-power"):
	equalize("burner-omnitractor"):
	setEnabled(false):
	setTechPacks(2):extend()
	
omni.lib.add_unlock_recipe("steam-power", "purified-omnite")
omni.lib.add_unlock_recipe("steam-power", "burner-filter-inserter-2")
omni.lib.add_unlock_recipe("steam-power", "burner-inserter-2")
	
if mods["angelsindustries"] and angelsmods.industries.components then
	RecGen:import("steam-engine"):
	equalize("omni-heat-burner"):
	setEnabled(false):
	setTechName("steam-power"):extend()

	RecGen:import("electric-mining-drill"):
	setTechName("anbaric-mining"):
	setTechCost(100):
	setTechIcon("omnimatter_energy","anbaric-mining"):
	setTechPacks(1):
	setEnabled(false):
	setTechPrereq("anbaricity"):extend()
else
	RecGen:import("steam-engine"):
	setIngredients(
      {type="item", name="iron-plate", amount=10},
      {type="item", name="iron-gear-wheel", amount=5},
      {type="item", name="anbaric-omnitor", amount=3},
	  {type="item",name="omni-heat-burner",amount=1}):
	  equalize("omni-heat-burner"):
	  setEnabled(false):
	  setTechName("steam-power"):extend()
	  
	RecGen:import("electric-mining-drill"):
	setIngredients(
      {type="item", name="iron-gear-wheel", amount=4},
      {type="item", name="anbaric-omnitor", amount=2},
      {type="item", name="burner-mining-drill", amount=1}):
	setTechName("anbaric-mining"):
	setTechCost(100):
	setTechIcon("omnimatter_energy","anbaric-mining"):
	setTechPacks(1):
	setEnabled(false):
	setTechPrereq("anbaricity"):extend()
end
	
if mods["bobassembly"] and settings.startup["bobmods-assembly-burner"].value then
	omni.lib.add_prerequisite("basic-automation", "simple-automation")
	omni.lib.remove_prerequisite("automation", "basic-automation")
	BuildGen:import("omnitor-assembling-machine"):setSpeed(0.1):setFuelCategory("omnite"):extend()
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

		RecGen:import("assembling-machine-1"):setIngredients(
			{type="item", name="iron-gear-wheel", amount=4},
			{type="item", name="anbaric-omnitor", amount=1},
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
		RecGen:import("assembling-machine-1"):setIngredients(
			{type="item", name="iron-gear-wheel", amount=4},
			{type="item", name="anbaric-omnitor", amount=1},
			{type="item", name="omnitor-assembling-machine", amount=1}):
			setEnabled(false):
			setTechName("automation"):
			setTechCost(15):extend()
	end
end

if mods["bobpower"] then
	omni.lib.add_prerequisite("bob-steam-engine-2", "steam-power")
	omni.lib.add_prerequisite("bob-boiler-2", "steam-power")
	RecGen:import("bob-burner-generator"):setEnabled(false):extend()
end

if mods["bobmining"] then
	omni.lib.add_prerequisite("bob-drills-1", "anbaric-mining")
end

omni.lib.add_prerequisite("fast-inserter", "burner-filter")

--Move All Electric Automation Recipes behind logistic science
omni.lib.add_prerequisite("automation", "logistic-science-pack")

local incScience = {
	"automation",
    "electronics",
	"fast-inserter",
}

for _,tech in pairs(data.raw.technology) do 
    for _,inctech in pairs(incScience) do
        if tech.name == inctech  then
            omni.lib.add_science_pack(tech.name,"logistic-science-pack")
        end
	end
end

--Move the Basic Inserter to its own tech (Red Packs only) to avoid deadlocks
RecGen:import("inserter"):setEnabled(false):
	setTechName("anbaric-inserter"):
	setTechCost(60):
	setTechIcon("__base__/graphics/technology/demo/electric-inserter.png"):
	setTechPacks(1):
	setTechPrereq("anbaricity"):extend()

	omni.lib.remove_unlock_recipe("automation", "inserter")
	omni.lib.add_prerequisite("logistic-science-pack", "anbaric-inserter")

if mods["angelsindustries"] and angelsmods.industries.components then

else
	local i=2
	while data.raw.recipe["assembling-machine-"..i] do
		RecGen:import("assembling-machine-"..i):addIngredients({"anbaric-omnitor",i}):extend()
		i=i+1
	end

	if mods["angelsrefining"] then
		RecGen:import("burner-ore-crusher"):setIngredients({type="item", name="omnite-brick", amount=4},
			{type="item", name="iron-plate", amount=4},
			{type="item", name="omnitor", amount=1}):extend()
		
		RecGen:import("ore-sorting-facility"):setIngredients({type="item", name="omnite-brick", amount=30},
			{type="item", name="iron-plate", amount=15},
			{type="item", name="anbaric-omnitor", amount=5}):
			setTechPrereq("anbaricity"):extend() --not working...

			omni.lib.add_prerequisite("ore-crushing", "anbaricity")
	end
end
	  
RecGen:import("basic-circuit-board"):setEnabled(false):setTechName("anbaricity"):extend()

--Check if the vanilla lab is locked behind a tech /disabled. If yes, modify the tech
if data.raw.recipe["lab"].enabled == false then
	RecGen:import("lab"):
		setTechLocName("anbaric-lab"):
		addIngredients({"omnitor-lab",1}):
		setTechIcon("omnimatter_energy","anbaric-lab"):
		setTechCost(100):extend()

	omni.lib.add_prerequisite(omni.lib.get_tech_name("lab"), "anbaricity")
else
--Create a new tech
	RecGen:import("lab"):setEnabled(false):
		setTechName("anbaric-lab"):
		setTechLocName("anbaric-lab"):
		addIngredients({"omnitor-lab",1}):
		setTechCost(100):
		setTechIcon("omnimatter_energy","anbaric-lab"):
		setTechPacks(1):
		setTechPrereq("anbaricity"):extend()
end

--Stuff to manually remove from the Omnitor Lab
local packs = {
	"token-bio",
	"omni-pack"
}

for i,inputs in pairs(data.raw["lab"]["omnitor-lab"].inputs) do
	for _,pack in pairs(packs) do
		if inputs == pack then
			table.remove(data.raw["lab"]["omnitor-lab"].inputs,i, pack)
		end
	end
end

RecGen:import("omnicium-plate-pure"):multiplyIngredients(0.5):extend()
RecGen:import("omnicium-plate-mix"):multiplyIfModsIngredients(0.5,"angelsrefining"):extend()
RecGen:import("omnite-smelting"):multiplyIngredients(0.5):extend()
RecGen:import("omnicium-processing"):multiplyIngredients(0.5):extend()

-- Deadlock compatibility
if data.raw.technology["basic-transport-belt-beltbox"] then
	omni.lib.add_unlock_recipe("basic-belt-logistics", "basic-transport-belt-loader")
	TechGen:import("basic-transport-belt-beltbox"):
	setPrereq("basic-splitter-logistics","basic-underground-logistics"):
	extend()
end

--Miniloader compatibility
--(The Chute recipe is based on basic belt ingredients (mostly just iron), so we need to add omnitors to that recipe aswell)
if data.raw.recipe["chute-miniloader"] then
	omni.lib.add_recipe_ingredient("chute-miniloader",{type = "item", name ="omnitor", amount = 2})
end

if data.raw.technology["logistics-0"] then
	-- Finally removing logistics-0
	omni.lib.remove_prerequisite("logistics","logistics-0")
	data.raw.technology["logistics-0"] = nil
end

require("prototypes.bobs_burner_phase")