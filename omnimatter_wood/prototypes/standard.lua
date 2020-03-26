local b = BuildGen:create("omnimatter_wood","omnimutator"):
	setSubgroup("omnitractor"):
	setIngredients({
      {type = "item", name = "omnicium-plate", amount = 10},
      {type = "item", name = "iron-plate", amount = 5},
      {type = "item", name = "copper-plate", amount = 5},
      {type = "item", name = "burner-omniphlog", amount = 1},}):
	setEnergy(10):
	setUsage(250):
	setReplace("omnimutator"):
	setStacksize(10):
	setSize(3):
	setCrafting({"omnimutator"}):
	setFluidBox("XWX.XXX.XSX"):
	setTechName("omnimutator"):
	setTechIcon("omnimatter_wood","mutator"):
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
	setFuelValue(3):
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
	setTechName("omnimutator"):extend()
	RecGen:create("omnimatter_wood","omniseedling"):
	setFuelValue(1):
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
	setResults({type = "item", name = "omniseedling", amount_min = 2, amount_max = 8}):extend()

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
	setTechName("omnimutator"):
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
	