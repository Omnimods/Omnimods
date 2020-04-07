require("prototypes.omnium-cycle")

RecGen:import("omni-furnace"):replaceIngredients("stone-brick","omnite-brick"):setFuelCategory("omnite"):extend()
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
	  
RecGen:import("electric-furnace"):addIngredients({"steel-furnace", 1}):extend()

RecGen:import("burner-inserter"):setIngredients({"omnitor",1},{"iron-plate",1}):setTechName("basic-automation"):extend()
data.raw.inserter["burner-inserter"].energy_source.fuel_category="omnite"

RecGen:import("inserter"):setIngredients({"burner-inserter",1},{"omnitor",1}):
	setEnabled(false):
	setTechName("automation"):extend()

RecGen:import("boiler"):setTechName("steam-power"):
	setTechCost(150):
	addIngredients("burner-omnitractor"):
	setTechLocName("steam-power"):
	setTechPrereq("anbaricity"):
	setTechIcon("omnimatter_energy","steam-power"):
	equalize("burner-omnitractor"):
	setEnabled(false):
	setTechPacks(1):extend()
	
TechGen:importIf("bob-steam-engine-2"):addPrereq("steam-power"):extend()
TechGen:importIf("bob-boiler-2"):addPrereq("steam-power"):extend()
TechGen:importIf("fast-inserter"):addPrereq("burner-filter"):extend()

RecGen:import("steam-engine"):setIngredients(
      {type="item", name="iron-plate", amount=10},
      {type="item", name="iron-gear-wheel", amount=5},
      {type="item", name="anbaric-omnitor", amount=3},
	  {type="item",name="omni-heat-burner",amount=1}):
	  equalize("omni-heat-burner"):
	  setEnabled(false):
	  setTechName("steam-power"):extend()

	  
RecGen:import("electric-mining-drill"):setIngredients(
      {type="item", name="iron-gear-wheel", amount=4},
      {type="item", name="anbaric-omnitor", amount=2},
      {type="item", name="burner-mining-drill", amount=1}):
	setTechName("anbaric-mining"):
	setTechCost(100):
	setTechIcon("omnimatter_energy","anbaric-mining"):
	setTechPacks(1):
	setEnabled(false):
	setTechPrereq("anbaricity"):extend()
	  
RecGen:import("assembling-machine-1"):setIngredients(
      {type="item", name="iron-gear-wheel", amount=4},
      {type="item", name="anbaric-omnitor", amount=1},
      {type="item", name="omnitor-assembling-machine", amount=1}):
	  setEnabled(false):
	  setTechName("automation"):extend()

local i=2

while data.raw.recipe["assembling-machine-"..i] do
	RecGen:import("assembling-machine-"..i):addIngredients({"anbaric-omnitor",i}):extend()
	i=i+1
end

RecGen:importIf("burner-ore-crusher"):setIngredients({type="item", name="stone-brick", amount=4},
      {type="item", name="iron-plate", amount=4},
      {type="item", name="omnitor", amount=1}):extend()
	  
RecGen:importIf("ore-sorting-facility"):setIngredients({type="item", name="stone-brick", amount=30},
      {type="item", name="iron-plate", amount=15},
      {type="item", name="anbaric-omnitor", amount=5}):extend()
	  
TechGen:import("automation"):setPrereq("basic-automation"):extend()

RecGen:import("basic-circuit-board"):setEnabled(false):setTechName("anbaricity"):extend()

RecGen:import("lab"):setEnabled(false):
	setTechName("anbaric-lab"):
	addIngredients({"omnitor-lab",1}):
	setTechCost(100):
	setTechIcon("omnimatter_energy","anbaric-lab"):
	setTechPacks(1):
	setTechPrereq("anbaricity"):extend()
	
TechGen:import("automation"):setPrereq("basic-automation","anbaricity"):extend()

RecGen:import("assembling-machine-1"):setTechName("automation"):extend()
	
TechGen:importIf("bob-drills-1"):addPrereq("anbaric-mining"):extend()

RecGen:import("omnicium-plate-pure"):multiplyIngredients(0.5):extend()
RecGen:import("omnicium-plate-mix"):multiplyIfModsIngredients(0.5,"angelsrefining"):extend()
RecGen:import("omnite-smelting"):multiplyIngredients(0.5):extend()
RecGen:import("omnicium-processing"):multiplyIngredients(0.5):extend()

