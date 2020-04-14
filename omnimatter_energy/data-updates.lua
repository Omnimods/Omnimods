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
	  
RecGen:import("electric-furnace"):addIngredients({"steel-furnace", 1}):extend()

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
	  
if mods["bobassembly"] then
	omni.lib.add_prerequisite("basic-automation", "simple-automation")
	omni.lib.remove_prerequisite("automation", "basic-automation")

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
else

	RecGen:import("assembling-machine-1"):setIngredients(
      	{type="item", name="iron-gear-wheel", amount=4},
     	{type="item", name="anbaric-omnitor", amount=1},
      	{type="item", name="omnitor-assembling-machine", amount=1}):
		setEnabled(false):
		setTechName("automation"):
	 	setTechCost(15):extend()
end

if mods["bobpower"] then
	omni.lib.add_prerequisite("bob-steam-engine-2", "steam-power")
	omni.lib.add_prerequisite("bob-boiler-2", "steam-power")
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

local i=2
while data.raw.recipe["assembling-machine-"..i] do
	RecGen:import("assembling-machine-"..i):addIngredients({"anbaric-omnitor",i}):extend()
	i=i+1
end

RecGen:importIf("burner-ore-crusher"):setIngredients({type="item", name="omnite-brick", amount=4},
      {type="item", name="iron-plate", amount=4},
      {type="item", name="omnitor", amount=1}):extend()
	  
RecGen:importIf("ore-sorting-facility"):setIngredients({type="item", name="omnite-brick", amount=30},
      {type="item", name="iron-plate", amount=15},
      {type="item", name="anbaric-omnitor", amount=5}):extend()
	  
RecGen:import("basic-circuit-board"):setEnabled(false):setTechName("anbaricity"):extend()

RecGen:import("lab"):setEnabled(false):
	setTechName("anbaric-lab"):
	addIngredients({"omnitor-lab",1}):
	setTechCost(100):
	setTechIcon("omnimatter_energy","anbaric-lab"):
	setTechPacks(1):
	setTechPrereq("anbaricity"):extend()
	
RecGen:import("omnicium-plate-pure"):multiplyIngredients(0.5):extend()
RecGen:import("omnicium-plate-mix"):multiplyIfModsIngredients(0.5,"angelsrefining"):extend()
RecGen:import("omnite-smelting"):multiplyIngredients(0.5):extend()
RecGen:import("omnicium-processing"):multiplyIngredients(0.5):extend()

