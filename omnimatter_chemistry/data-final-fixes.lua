
RecGen:create("omnimatter_chemistry","crystallo-mutation"):
	setSubgroup("omnimutator"):
	setCategory("omni-mutator"):
	ifCategory("bobgreenhouse","bob-greenhouse"):
	ifCategory("angelsbioprocessing","angels-arboretum"):
	marathon():
	setIcons("crystalline-wood"):
	setEnergy(30):
	ifSetIngredients("bobgreenhouse",{
      {type = "item", name = "omniseedling", amount = 5},
      {type = "fluid", name = "omnic-water", amount = 30},
      {type = "fluid", name = "omnic-mutagen", amount = 120},
    }):
	ifSetIngredients("angelsbioprocessing",{
      {type="item", name="tree-seed", amount=2},
      {type="item", name="solid-soil", amount=5},
      {type = "fluid", name = "omnic-water", amount = 30},
      {type = "fluid", name = "omnic-mutagen", amount = 120},
    }):
	setTechName("crystallology-2"):
	setResults({type = "item", name = "omniwood", amount_min = 5, amount_max = 10},
		{type = "item", name = "crystalline-wood", amount_min = 40, amount_max = 100}
	):extend()
	
RecGen:create("omnimatter_chemistry","carbomnilline"):
	setSubgroup("omnimutator"):
	setCategory("smelting"):
	setEnergy(5):
	setIngredients({
      {type = "item", name = "crystalline-wood", amount = 5},
    }):
	setTechName("crystallology-2"):
	setResults({type = "item", name = "carbomnilline", amount = 5}
	):extend()
	
RecGen:create("omnimatter_chemistry","tree-making"):
	setSubgroup("omnimutator"):
	setCategory("angels-tree"):
	setEnergy(5):
	setGenerationCondition(mods["angelsbioprocessing"]~=nil):
	setIngredients({
      {type="item", name="tree-seed", amount=1},
      {type="item", name="solid-soil", amount=5},
      {type = "fluid", name = "omnic-water", amount = 120},
      {type = "fluid", name = "omnic-mutagen", amount = 120},
    }):
	setTechName("crystallology-2"):
	setResults(
		{type = "item", name = "temperate-tree", amount = 1,probability=0.02},
		{type = "item", name = "swamp-tree", amount = 1,probability=0.02},
		{type = "item", name = "desert-tree", amount = 1,probability=0.02}
	):extend()
	
	
BuildChain:find("omniplant"):setFluidBox("XWXWX.AXXXD.XXXXX.JXXXL.XKXKX"):extend()
--log(serpent.block(data.raw["assembling-machine"]["omniplant-1"]))

--[[local i=1
while data.raw["assembling-machine"]["omniplant-"..i] do
	BuildGen:import("omniplant-"..i):setFluidBox("XWXWX.XXXXX.AXXXL.XXXXX.XKXXKX"):extend()
	i=i+1
end]]