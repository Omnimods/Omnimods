if mods["boblogistics"] and settings.startup["bobmods-logistics-beltoverhaul"].value then
	log("OmniEnergy: Bobs Belt Overhaul found")

	--Remove logistics-0 Tech
	TechGen:import("logistics-0"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()

	--Create seperate techs for Basic Belt, Splitter and UG
	RecGen:import("basic-transport-belt"):
		setEnabled(false):
		setTechName("omnitech-basic-belt-logistics"):
		setTechIcons("logistics","omnimatter_energy"):
		setTechPrereq():
		ifAddTechPrereq(data.raw.technology["basic-automation"], "basic-automation"):
		ifAddTechPrereq(not data.raw.technology["basic-automation"], "omnitech-simple-automation"):
		setTechPacks(1):
		setTechCost(25):
		setIngredients(
      {type="item", name="iron-plate", amount=1},
      {type="item", name="omnitor", amount=1}):
		setResults({"basic-transport-belt",3}):extend()
	
	RecGen:import("basic-splitter"):
		setEnabled(false):
		setTechName("omnitech-basic-splitter-logistics"):
		setTechIcons("logistics","omnimatter_energy"):
		setTechPrereq("omnitech-basic-belt-logistics"):
		setTechPacks(1):
		setTechCost(25):extend()

	RecGen:import("basic-underground-belt"):
		setEnabled(false):
		setTechName("omnitech-basic-underground-logistics"):
		setTechIcons("logistics","omnimatter_energy"):
		setTechPrereq("omnitech-basic-belt-logistics"):
	 	setTechPacks(1):
		setTechCost(25):extend()

	--Add new Techs as Prereq for vanilla logistics
	omni.lib.set_prerequisite("logistics",{"omnitech-basic-splitter-logistics","omnitech-basic-underground-logistics"})

	--Move all Techs that have logistics-0 as Prereq behind Basic Splitter & UG Techs
	for _,t in pairs(data.raw.technology) do
		if omni.lib.is_in_table("logistics-0",t.prerequisites) then
			omni.lib.remove_prerequisite(t.name,"logistics-0")
			omni.lib.add_prerequisite(t.name,"omnitech-basic-splitter-logistics")
			omni.lib.add_prerequisite(t.name,"omnitech-basic-underground-logistics")
		end
	end

else
	--Remove logistics Tech
	TechGen:import("logistics"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()

	--Create seperate techs for Belt, Splitter and UG
	RecGen:import("transport-belt"):
		setEnabled(false):
		setTechName("omnitech-belt-logistics"):
		setTechIcons("logistics","omnimatter_energy"):
		setTechPrereq():
		ifAddTechPrereq(data.raw.technology["basic-automation"], "basic-automation"):
		ifAddTechPrereq(not data.raw.technology["basic-automation"], "omnitech-simple-automation"):
		setTechPacks(1):
		setTechCost(25):
		setIngredients(
      {type="item", name="iron-plate", amount=1},
      {type="item", name="omnitor", amount=1}):extend()
	
	RecGen:import("splitter"):
		setEnabled(false):
		setTechName("omnitech-splitter-logistics"):
		setTechIcons("logistics","omnimatter_energy"):
		setTechPrereq("omnitech-belt-logistics"):
		setTechPacks(1):
		setTechCost(25):extend()

	RecGen:import("underground-belt"):
		setEnabled(false):
		setTechName("omnitech-underground-logistics"):
		setTechIcons("logistics","omnimatter_energy"):
		setTechPrereq("omnitech-belt-logistics"):
		setTechPacks(1):
		setTechCost(25):extend()

	--Move all Techs that have logistics as Prereq behind Splitter & UG Techs
	for _,t in pairs(data.raw.technology) do
		if omni.lib.is_in_table("logistics",t.prerequisites) then
			omni.lib.remove_prerequisite(t.name,"logistics")
			omni.lib.add_prerequisite(t.name,"omnitech-splitter-logistics")
			omni.lib.add_prerequisite(t.name,"omnitech-underground-logistics")
		end
	end	

end

RecGen:create("omnimatter_energy","omni-tablet"):
	setIngredients("omnite-brick"):
	setStacksize(200):
	setSubgroup("omnienergy-intermediates"):
	setEnabled():
	setEnergy(0.5):extend()
	
if mods["angelsindustries"] and angelsmods.industries.components then
	BuildGen:import("burner-mining-drill"):
		setIngredients(
		{type="item", name="stone-furnace", amount=1},
		{type="item", name="mechanical-parts", amount=3},
		{type="item", name="construction-frame-1", amount=3}):setEnabled():extend()
else
	BuildGen:import("burner-mining-drill"):
		setIngredients(
		{type="item", name="omnite-brick", amount=4},
		{type="item", name="iron-plate", amount=4},
		{type="item", name="omnitor", amount=1}):setEnabled():extend()
end

RecGen:create("omnimatter_energy","heat"):
	fluid():
	setIcons("__omnilib__/graphics/icons/small/burner.png"):
	setBothColour(1,0,0):
	setCategory("omnite-extraction-burner"):
	setSubgroup("omnienergy-power"):
	setOrder("ab"):
	setEnergy(20):
	setMaxTemp(250):
	setFuelCategory("thermo"):
	setCapacity(1):
	setTechName("omnitech-anbaricity"):
	setTechCost(40):
	setTechIcons("electric-engine"):
	setTechPrereq():
	ifAddTechPrereq(settings.startup["bobmods-logistics-beltoverhaul"] and settings.startup["bobmods-logistics-beltoverhaul"].value,
	"omnitech-basic-splitter-logistics","omnitech-basic-underground-logistics"
	):
	ifAddTechPrereq(not (settings.startup["bobmods-logistics-beltoverhaul"] and settings.startup["bobmods-logistics-beltoverhaul"].value),
	"omnitech-splitter-logistics","omnitech-underground-logistics"
	):
	setTechPacks(1):	
	setResults({type="fluid",name="heat",amount=2*60+1,temperature=250}):
	extend()
data.raw.fluid.heat.auto_barrel = false

local regular_cost = {}
local expensive cost = {}
if mods["angelsindustries"] and angelsmods.industries.components then
	regular_cost = {{"stone-furnace", 1}, {"block-omni-1", 4}, {"construction-frame-1", 4}, {"block-fluidbox-1", 4}}
	expensive_cost = {{"stone-furnace", 2}, {"block-omni-1", 10}, {"construction-frame-1", 10}, {"block-fluidbox-1", 10}}
else
	regular_cost = {{"anbaric-omnitor",4},{"omnicium-gear-wheel",5},{"stone-furnace",1}}
	expensive_cost = {{"anbaric-omnitor",9},{"omnicium-gear-wheel",12},{"stone-furnace",2}}
end
BuildGen:import("steam-turbine"):
	setName("omni-heat-burner","omnimatter_energy"):
	--setFluidBox("XTX.XXX.XXX.XXX.XGX","heat",400)
	setLocName():
	setFilter("heat"):
	nullIngredients():
	setNormalIngredients(regular_cost):
	setExpensiveIngredients(expensive_cost):
	setReplace("heat-burner"):
	setSubgroup("omnienergy-power"):
	setOrder("aa"):
	setTechName("omnitech-anbaricity"):
	setFluidConsumption(1):
	setEffectivity(2/13.5/2):
	setMaxTemp(250):
	setNextUpgrade():extend()

RecGen:create("omnimatter_energy","omnitor"):
	setStacksize(100):
	addMask(197/255,58/255,97/255):
	setCategory("crafting"):
	setSubgroup("omnienergy-intermediates"):
	setOrder("a"):
	setEnergy(0.75):
	setIngredients({type="item", name="omnicium-plate", amount=1},{type="item", name="omnicium-gear-wheel", amount=1}):
	addProductivity():
	setEnabled():extend()

RecGen:create("omnimatter_energy","anbaric-omnitor"):
	setStacksize(100):
	addMask(0/255,186/255,184/255):
	setCategory("crafting"):
	setSubgroup("omnienergy-intermediates"):
	setOrder("b"):
	setEnergy(0.75):
	setTechName("omnitech-anbaricity"):
	setIngredients({type="item", name="omnicium-plate", amount=2},{type="item", name="copper-cable", amount=2},{type="item", name="omnitor", amount=1}):
	addProductivity():extend()
	

if mods["angelsindustries"] and angelsmods.industries.components then
	-- Add omnitors to omniblocks
	omni.lib.replace_recipe_ingredient("block-omni-0",component["omniplate"][1],"omnitor")
	omni.lib.replace_recipe_ingredient("block-omni-1",component["omniplate"][1],"anbaric-omnitor")
end

RecGen:import("small-electric-pole"):setEnabled(false):setTechName("omnitech-anbaricity"):extend()

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
	setEnabled(false):
	setTechName("omnitech-anbaricity"):extend()
	
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
	setEnabled(false):
	setTechName("omnitech-anbaricity"):extend()

	--Temp sound fix until lib is fixed
	data.raw["electric-pole"]["small-iron-electric-pole"].working_sound = nil
	data.raw["electric-pole"]["small-omnicium-electric-pole"].working_sound = nil

local ings = {}
if mods["angelsindustries"] and angelsmods.industries.components then
	ings = {{"block-omni-0", 2}, {"construction-frame-1"}}
else
	ings = {{"omnitor",1},{"iron-plate",2},{"burner-inserter",1}}
end

BuildGen:import("assembling-machine-1"):
	setBurner(0.9,1):
	setName("omnitor-assembling-machine"):
	setIcons("omnitor-assembling-machine","omnimatter_energy"):
	setEnabled(false):
	setTechName("omnitech-simple-automation"):
	setTechIcons("automation"):
	setTechPrereq():
	setTechPacks(1):
	setTechCost(10):
	setInventory(3):
	setCrafting("crafting", "basic-crafting"):
	setFuelCategory("omnite"):
	setSpeed(0.25):
	setIngredients(ings):
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
	setNextUpgrade("assembling-machine-1"):extend()

if mods["angelsindustries"] and angelsmods.industries.components then
	regular_cost = {{"block-omni-0", 4}, {"cable-harness-1", 5}, {"omnite-brick", 5}}
	expensive_cost = {{"block-omni-0", 8}, {"cable-harness-1", 15}, {"omnite-brick", 9}}
else
	regular_cost = {{"omnitor", 10},{"copper-plate", 10},{"omnite-brick", 5}}
	expensive_cost = {{"omnitor", 20},{"copper-plate", 30},{"omnite-brick", 9}}
end

BuildGen:import("lab"):
	setBurner(0.9):
	setName("omnitor-lab"):
	setIcons("omnitor-lab","omnimatter_energy"):
	setEnabled():
	setInputs("automation-science-pack"):
	setFuelCategory("omnite"):
	setNormalIngredients(regular_cost):
	setExpensiveIngredients(expensive_cost):
	setReplace("lab"):
	setNextUpgrade("lab"):
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

--Set fast replaceable group for the vanilla lab
if data.raw["lab"]["lab"] then
	data.raw["lab"]["lab"].fast_replaceable_group = "lab"
end

InsertGen:create("omnimatter_energy","burner-filter-inserter-1"):
	setIngredients({"burner-inserter",1},{"omnitor",2},{"omnicium-gear-wheel",2}):
	setIcons("burner-filter-inserter","omnimatter_energy"):
	addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
	setFilter(1):
	setSpeed(0.0214, 0.01): --vanilla burner inserter speed
	setAnimation("burner-filter-inserter"):
	setFuelCategory("omnite"): --not working...
	setBurner(0.75,1):
	setNextUpgrade("burner-filter-inserter-2"):
	setSubgroup("inserter"):
	setOrder("ab[burner-filter-inserter-1]"):
	setTechName("omnitech-burner-filter-1"):
	setTechLocName("omnitech-burner-filter-1"):
	setTechIcons("burner-filter","omnimatter_energy"):
	setTechPacks(1):
	setTechCost(50):
	ifAddTechPrereq(data.raw.technology["omnitech-basic-belt-logistics"], "omnitech-basic-belt-logistics"):
	ifAddTechPrereq(data.raw.technology["omnitech-belt-logistics"], "omnitech-belt-logistics"):extend()

--Create a second tier filter and normal burner inserter that accepts omnified fuel
InsertGen:create("omnimatter_energy","burner-filter-inserter-2"):
	setIngredients({"burner-filter-inserter-1",1},{"omnicium-plate",2}):
	setIcons("burner-filter-inserter","omnimatter_energy"):
	addIcon("__omnilib__/graphics/icons/small/lvl2.png"):
	setFilter(1):
	setSpeed(0.03, 0.014): --vanilla inserter speed
	setAnimation("burner-filter-inserter"):
	setEnabled(false):
	setFuelCategory("chemical"):
	setBurner(0.75,1):
	setNextUpgrade("filter-inserter"):
	setSubgroup("inserter"):
	setOrder("ab[burner-filter-inserter-2]"):
	setTechName("omnitech-burner-filter-2"):
	setTechLocName("omnitech-burner-filter-2"):
	setTechPacks(1):
	setTechCost(50):
	setTechIcons("burner-filter","omnimatter_energy"):
	setTechPrereq("omnitech-burner-filter-1"):extend()

InsertGen:create("omnimatter_energy","burner-inserter-2"):
	setIngredients({"burner-inserter",1},{"omnicium-plate",2}):
	setIcons("burner-inserter","base"):
	addIcon("__omnilib__/graphics/icons/small/lvl2.png"):
	setSpeed(0.03, 0.014): --vanilla inserter speed
	setAnimation("burner-inserter"):
	setEnabled(false):
	setFuelCategory("chemical"):
	setBurner(0.75,1):
	setNextUpgrade("inserter"):
	setSubgroup("inserter"):
	setOrder("aa[burner-inserter-2]"):
	setTechName("omnitech-burner-filter-2"):extend()

RecGen:import("burner-inserter"):
	addBurnerIcon():
	addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
	setLocName("entity-name.burner-inserter-1"):
	setSubgroup("inserter"):
	setOrder("aa[burner-inserter-1]"):extend()

	data.raw["inserter"]["burner-inserter"].energy_source.fuel_category = "omnite"
	data.raw["inserter"]["burner-inserter"].next_upgrade= "burner-inserter-2"