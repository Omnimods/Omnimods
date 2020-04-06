
if mods["boblogistics"] and settings.startup["bobmods-logistics-beltoverhaul"].value then
	for _,t in pairs(data.raw.technology) do
		if omni.lib.is_in_table("bob-logistics-0",t.prerequisites) then
			omni.lib.remove_prerequisite(t.name,"bob-logistics-0")
			omni.lib.add_prerequisite(t.name,"splitter-logistics")
			omni.lib.add_prerequisite(t.name,"underground-logistics")
		end
	end
	
	data.raw.technology["bob-logistics-0"]=nil

	TechGen:import("basic-logistics"):setPrereq():setUpgrade(false):setEnabled(true):removeUnlocks("transport-belt"):extend()
	
	log(serpent.block(data.raw.technology["basic-logistics"]))
	
	RecGen:import("basic-transport-belt"):
		setEnabled(false):
		setTechName("basic-logistics"):
		setTechIcon("base","logistics"):
		setTechPacks(1):
		setTechCost(25):
		setIngredients(
      {type="item", name="iron-plate", amount=1},
      {type="item", name="omnitor", amount=1}):
		setResults({"basic-transport-belt",3}):extend()
	
	RecGen:import("basic-splitter"):setEnabled(false):
		setTechName("basic-splitter-logistics"):
		setTechIcon("base","logistics"):
		setTechPrereq("basic-logistics"):
		setTechLocName():
		setTechPacks(1):
		setTechCost(25):extend()
	RecGen:import("basic-underground-belt"):setEnabled(false):
		setTechName("basic-underground-logistics"):
		setTechIcon("base","logistics"):
		setTechLocName():
		setTechPrereq("basic-logistics"):
		setTechPacks(1):
		setTechCost(25):extend()
		
	TechGen:import("logistics"):setPrereq("basic-logistics","basic-splitter-logistics","basic-underground-logistics"):extend()
else
	TechGen:import("logistics"):nullUnlocks():extend()
	
	for _,t in pairs(data.raw.technology) do
		if omni.lib.is_in_table("logistics",t.prerequisites) then
			omni.lib.remove_prerequisite(t.name,"logistics")
			omni.lib.add_prerequisite(t.name,"splitter-logistics")
			omni.lib.add_prerequisite(t.name,"underground-logistics")
		end
	end
	
	RecGen:import("transport-belt"):
		setEnabled(false):
		setTechName("logistics"):
		setTechIcon("base","logistics"):
		setTechPacks(1):
		setTechPrereq():
		setTechCost(25):
		setIngredients(
      {type="item", name="iron-plate", amount=1},
      {type="item", name="omnitor", amount=1}):extend()
	
	RecGen:import("splitter"):setEnabled(false):setTechName("basic-logistics"):
		setTechName("underground-logistics"):
		setTechIcon("base","logistics"):
		setTechPrereq("logistics"):
		setTechPacks(1):
		setTechCost(25):extend()
	RecGen:import("underground-belt"):setEnabled(false):
		setTechName("splitter-logistics"):
		setTechIcon("base","logistics"):
		setTechPrereq("logistics"):
		setTechPacks(1):
		setTechCost(25):extend()
end

RecGen:create("omnimatter_energy","omni-tablet"):
	setIngredients("omnite-brick"):
	setStacksize(200):
	setEnabled():
	setEnergy(0.5):extend()
	
BuildGen:import("burner-mining-drill"):
	setIngredients(
      {type="item", name="stone-brick", amount=4},
      {type="item", name="iron-plate", amount=4},
      {type="item", name="omnitor", amount=1}):setEnabled():extend()

RecGen:create("omnimatter_energy","omnitor"):
	setStacksize(50):
	addMask(197/255,58/255,97/255):
	setCategory("crafting"):
	setSubgroup("omnienergy-intermediates"):
	setOrder("a"):
	setEnergy(0.75):
	setIngredients({type="item", name="omnicium-plate", amount=2},{type="item", name="omnicium-gear-wheel", amount=1}):
	addProductivity():
	setEnabled():extend()

RecGen:create("omnimatter_energy","anbaric-omnitor"):
	setStacksize(50):
	addMask(0/255,186/255,184/255):
	setCategory("crafting"):
	setSubgroup("omnienergy-intermediates"):
	setOrder("b"):
	setEnergy(0.75):
	setTechName("anbaricity"):
	setIngredients({type="item", name="omnicium-plate", amount=2},{type="item", name="copper-cable", amount=2},{type="item", name="omnitor", amount=1}):
	addProductivity():extend()

--RecGen:create("omnimatter_energy","cokomni"):
--	setSubgroup("omni-basic"):
--	setStacksize(200):
--	setCategory("omnifurnace"):
--	setFuelCategory("omnite"):
--	setFuelValue(2.4):
--	setEnergy(0.5):
--	setFuelCategory("omnite"):
--	setTechName("anbaricity"):
--	setIngredients({type="item", name="crushed-omnite", amount=4}):
--	setResults({type="item", name="cokomni", amount=2}):extend()
	
	RecGen:create("omnimatter_energy","heat"):
	fluid():
	setIcons("burner","omnilib"):
	setBothColour(1,0,0):
	setCategory("omnite-extraction-burner"):
	setEnergy(20):
	setMaxTemp(250):
	setFuelCategory("thermo"):
	setCapacity(1):
	setTechName("anbaricity"):
	setTechCost(50):
	setTechIcon("base","electric-engine"):
	setTechPrereq("basic-automation"):
	ifAddTechPrereq(settings.startup["bobmods-logistics-beltoverhaul"] and settings.startup["bobmods-logistics-beltoverhaul"].value,
	"basic-splitter-logistics","basic-underground-logistics"
	):
	ifAddTechPrereq(not (settings.startup["bobmods-logistics-beltoverhaul"] and settings.startup["bobmods-logistics-beltoverhaul"].value),
	"splitter-logistics","underground-logistics"
	):
	setTechPacks(1):	
	setResults({type="fluid",name="heat",amount=2*60+1,temperature=250}):
	extend()

data.raw.fluid.heat.auto_barrel = false

BuildGen:import("steam-turbine"):
	setName("omni-heat-burner","omnimatter_energy"):
	--setFluidBox("XTX.XXX.XXX.XXX.XGX","heat",400)
	setLocName():
	setFilter("heat"):
	nullIngredients():
	setNormalIngredients({"anbaric-omnitor",4},{"omnicium-gear-wheel",5},{"stone-furnace",1}):
	setExpensiveIngredients({"anbaric-omnitor",9},{"omnicium-gear-wheel",12},{"stone-furnace",2}):
	setReplace("heat-burner"):
	setTechName("anbaricity"):
	setFluidConsumption(1):
	setEffectivity(2/13.5/2):
	setMaxTemp(250):extend()
	
log("test")
RecGen:import("small-electric-pole"):setTechName("anbaricity"):extend()
BuildGen:import("small-electric-pole"):
	setName("small-iron-electric-pole"):
	setIngredients({"iron-plate", 1},{"copper-cable", 1}):
	setPictures({
      filename = "__omnimatter_energy__/graphics/entity/small-iron-electric-pole.png",
      priority = "extra-high",
      width = 119,
      height = 124,
      direction_count = 4,
      shift = {1.4, -1.1}
    }):
	setTechName("anbaricity"):extend()
	
BuildGen:import("small-electric-pole"):
	setName("small-omnicium-electric-pole"):
	setIngredients({"omnicium-plate", 1},{"copper-cable", 1}):
	setArea(3.5):
	setWireDistance(9):
	setPictures({
      filename = "__omnimatter_energy__/graphics/entity/small-omnicium-electric-pole.png",
      priority = "extra-high",
      width = 119,
      height = 124,
      direction_count = 4,
      shift = {1.4, -1.1}
    }):
	setTechName("anbaricity"):extend()
	
BuildGen:import("assembling-machine-1"):
	setBurner(0.9,1):
	setName("omnitor-assembling-machine"):
	setIcons("omnitor-assembling-machine","omnimatter_energy"):
	--setFluidBox("XWX.XXX.XXX"):
	--setFilter("heat"):
	--setFluidBurn():
	setEnabled(false):
	setTechName("basic-automation"):
	setTechIcon("base","automation"):
	setTechPrereq():
	setTechPacks(1):
	setTechCost(10):
	setInventory(3):
	setCrafting("crafting", "basic-crafting"):
	setFuelCategory("omnite"):
	setFuelCategory("chemical"):
	setIngredients({"omnitor",2},{"iron-plate",5},{"burner-inserter",1}):
	setAnimation(
	{layers={{
	  filename = "__omnimatter_energy__/graphics/entity/omnitor-assembling-machine/omnitor-assembling-machine.png",
	  priority="high",
	  width = 107,
	  height = 113,
	  frame_count = 32,
	  line_length = 8,
	  shift = util.by_pixel(0, 2),
	  hr_version = {
		filename = "__omnimatter_energy__/graphics/entity/omnitor-assembling-machine/hr-omnitor-assembling-machine.png",
		priority="high",
		width = 214,
		height = 226,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(0, 2),
		scale = 0.5
	  }
	}}}
	):
	extend()


BuildGen:import("lab"):
	setBurner(0.9):
	setName("omnitor-lab"):
	setIcons("omnitor-lab","omnimatter_energy"):
	setEnabled():
	setInputs("automation-science-pack"):
	setFuelCategory("omnite"):
	setNormalIngredients({type="item", name="omnitor", amount=10},{type="item", name="copper-plate", amount=10},{type="item", name="omnite-brick", amount=5}):
	setExpensiveIngredients({type="item", name="omnitor", amount=20},{type="item", name="copper-plate", amount=30},{type="item", name="omnite-brick", amount=9}):
	setOnAnimation({
  layers =
  {
    {
      filename = "__omnimatter_energy__/graphics/entity/omnitor-lab/omnitor-lab.png",
      width = 97,
      height = 87,
      frame_count = 33,
      line_length = 11,
      animation_speed = 1 / 3,
      shift = util.by_pixel(0, 1.5),
      hr_version = {
        filename = "__omnimatter_energy__/graphics/entity/omnitor-lab/hr-omnitor-lab.png",
        width = 194,
        height = 174,
        frame_count = 33,
        line_length = 11,
        animation_speed = 1 / 3,
        shift = util.by_pixel(0, 1.5),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/lab/lab-integration.png",
      width = 122,
      height = 81,
      frame_count = 1,
      line_length = 1,
      repeat_count = 33,
      animation_speed = 1 / 3,
      shift = util.by_pixel(0, 15.5),
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-integration.png",
        width = 242,
        height = 162,
        frame_count = 1,
        line_length = 1,
        repeat_count = 33,
        animation_speed = 1 / 3,
        shift = util.by_pixel(0, 15.5),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/lab/lab-shadow.png",
      width = 122,
      height = 68,
      frame_count = 1,
      line_length = 1,
      repeat_count = 33,
      animation_speed = 1 / 3,
      shift = util.by_pixel(13, 11),
      draw_as_shadow = true,
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-shadow.png",
        width = 242,
        height = 136,
        frame_count = 1,
        line_length = 1,
        repeat_count = 33,
        animation_speed = 1 / 3,
        shift = util.by_pixel(13, 11),
        scale = 0.5,
        draw_as_shadow = true
      }
    }
  }
}):setOffAnimation({
  layers =
  {
    {
      filename = "__omnimatter_energy__/graphics/entity/omnitor-lab/omnitor-lab.png",
      width = 97,
      height = 87,
      frame_count = 1,
      shift = util.by_pixel(0, 1.5),
      hr_version = {
        filename = "__omnimatter_energy__/graphics/entity/omnitor-lab/hr-omnitor-lab.png",
        width = 194,
        height = 174,
        frame_count = 1,
        shift = util.by_pixel(0, 1.5),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/lab/lab-integration.png",
      width = 122,
      height = 81,
      frame_count = 1,
      shift = util.by_pixel(0, 15.5),
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-integration.png",
        width = 242,
        height = 162,
        frame_count = 1,
        shift = util.by_pixel(0, 15.5),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/lab/lab-shadow.png",
      width = 122,
      height = 68,
      frame_count = 1,
      shift = util.by_pixel(13, 11),
      draw_as_shadow = true,
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-shadow.png",
        width = 242,
        height = 136,
        frame_count = 1,
        shift = util.by_pixel(13, 11),
        draw_as_shadow = true,
        scale = 0.5
      }
    }
  }
}):extend()

InsertGen:create("omnimatter_energy","burner-filter-inserter"):
	--setName("burner-filter-inserter"):
	setIngredients({"burner-inserter",1},{"omnitor",2},{"omnicium-gear-wheel",2}):
	setSubgroup("inserter"):
	setOrder("z"): --doesnt do shit?
	setTechName("burner-filter"):
	setTechCost(100):
	setTechIcon("burner-filter"):
	setTechPacks(1):
	setTechPrereq("logistics"):
	setFilter(1):
	setAnimation("burner-filter-inserter"):
	setFuelCategory("omnite"): --not working...
	setBurner(0.75,1):extend()
	data.raw["inserter"]["burner-burner-filter-inserter"].energy_source.fuel_category = "omnite"

	