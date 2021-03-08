local mutator_cost = {}
if mods["angelsindustries"] and angelsmods.industries.components then
	mutator_cost = {
		{name="block-construction-2", amount=5},
		{name="block-electronics-1", amount=3},
		{name="block-fluidbox-1", amount=2},
		{name="block-omni-1", amount=5}
	}
else
	mutator_cost = {
      {type = "item", name = "omnicium-plate", amount = 10},
      {type = "item", name = "iron-plate", amount = 5},
      {type = "item", name = "copper-plate", amount = 5},
      {type = "item", name = "burner-omniphlog", amount = 1},}
end

local b = BuildGen:create("omnimatter_wood","omnimutator"):
	setIngredients(mutator_cost):
	setEnergy(10):
	setUsage(250):
	setReplace("omnimutator"):
	setStacksize(10):
	setSize(3):
	setSubgroup("omnimutator"):
	setOrder("a[omnimutator"):
	setCrafting({"omnimutator"}):
	setFluidBox("XWX.XXX.XSX"):
	setTechName("omnitech-omnimutator"):
	setTechIcons("mutator","omnimatter_wood"):
	setTechCost(50):
	setTechTime(15):
	setTechPrereq({"omnitech-omnic-acid-hydrolyzation-1"}):
	setSpeed(1):
	setAnimation({
      filename = "__omnimatter_wood__/graphics/entity/buildings/omni-mutator.png",
      width = 113,
      height = 91,
      frame_count = 1,
      shift = {0.2, 0.15}
	}):
	setWorkVis({
      {
        light = {intensity = 1, size = 6},
        animation =
        {
          filename = "__omnimatter_wood__/graphics/entity/buildings/mutator-light.png",
          width = 113,
          height = 91,
          frame_count = 1,
          shift = {0.2, 0.15}
        }
      }
    }):extend()

RecGen:create("omnimatter_wood","wasteMutation"):
	setFuelValue(2):
	setSubgroup("omnimutator-items"):
	setStacksize(100):
	setIcons("omniwood","omnimatter_wood"):
	setCategory("omniphlog"):
	marathon():
	setEnergy(2):
	setIngredients({
      {type = "item", name = "wood", amount = 2},
      {type = "fluid", name = "omnic-waste", amount = 600},
    }):
	setResults({type = "item", name = "omniwood", amount=5}):
	setEnabled():extend()

RecGen:create("omnimatter_wood","wood-omnitraction"):
	setIcons("wood"):
	setEnergy(2):
	setEnabled():
	setSubgroup("omnimutator-items"):
	setCategory("omnite-extraction-both"):
	marathon():
	setIngredients({type = "item", name = "omniwood", amount = 6}):
	setResults({type = "item", name = "wood", amount=8}):extend()


RecGen:create("omnimatter_wood","basic-wood-mutation"):
	setIcons("omniwood"):
	setCategory("omnimutator"):
	marathon():
	setEnergy(20):
	setIngredients({
      {type = "item", name = "omnite", amount = 5},
      {type = "item", name = "wood", amount = 1},
      {type = "fluid", name = "omnic-acid", amount = 10},
      {type = "fluid", name = "omnic-water", amount = 100}
    }):
	setResults({
      {type = "item", name = "wood", amount_min = 1, amount_max = 3},
      {type = "item", name = "omniwood", amount_min = 5, amount_max = 15},
    }):
	setReqNoneMods("bobgreenhouse","angelsbioprocessing"):
	setTechName("omnitech-omnimutator"):extend()
	
	RecGen:create("omnimatter_wood","omniseedling"):
	setFuelValue(0.7):
	setSubgroup("omnimutator-items"):
	setStacksize(100):
	marathon():
	setCategory("omnimutator"):
	setEnergy(2):
	setIngredients({
      {type = "item", name = "omnite", amount = 5},
      {type = "item", name = "wood", amount = 1},
      {type = "fluid", name = "omnic-acid", amount = 20},
      {type = "fluid", name = "omnic-water", amount = 100}
    }):
	setTechName("bob-greenhouse"):
	setGenerationCondition(mods["bobgreenhouse"]~=nil or mods["Bio_Industries"]~=nil):
	setResults({type = "item", name = "omniseedling", amount_min = 6, amount_max = 8}):extend()

	RecGen:create("omnimatter_wood","basic-omniwood-growth"):
	setSubgroup("omnimutator-items"):
	setCategory("bob-greenhouse"):
	marathon():
	setIcons("omniwood"):
	setEnergy(40):
	setIngredients({
      {type = "item", name = "omniseedling", amount = 5},
      {type = "fluid", name = "omnic-water", amount = 50}
    }):
	setTechName("omnitech-omnimutator"):
	setGenerationCondition(mods["bobgreenhouse"]~= nil and not mods["angelsbioprocessing"]):
	setResults({type = "item", name = "omniwood", amount_min = 10, amount_max = 30}):extend()


	RecGen:create("omnimatter_wood","fertilized-omniwood-growth"):
	setSubgroup("omnimutator-items"):
	setCategory("bob-greenhouse"):
	marathon():
	setIcons("omniwood"):
	setEnergy(30):
	setIngredients({
      {type = "item", name = "omniseedling", amount = 5},
      {type = "fluid", name = "omnic-water", amount = 50},
      {type = "item", name = "fertiliser", amount = 5}
    }):
	setTechName("bob-greenhouse"):
	setGenerationCondition(mods["bobgreenhouse"]~= nil and not mods["angelsbioprocessing"]):
	setResults({type = "item", name = "omniwood", amount_min = 20, amount_max = 60}):extend()

--Nerf normal wood´s fuel value
ItemGen:import("wood"):
	setFuelValue(1.3):
	extend()