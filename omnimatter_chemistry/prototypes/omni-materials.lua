local cost = OmniGen:create()
		cost:setYield("omnion"):
		setIngredients({"omnite",20},{type="fluid",name="omnic-acid", amount=240}):
		setWaste("omnic-waste"):
		linearPercentOutput(240,0.3)
	
RecChain:create("omnimatter_chemistry","omnion"):
	fluid():
	setBothColour(1,0,1):
	resetItemName():
	setTechName("basic-omni-processing"):
	setTechPacks(function(levels,grade) return math.floor(grade*3/omni.chem.levels)+1 end):
	setTechIcon("omnimatter_chemistry","omni-processing"):
	setTechPrereq(function(levels,grade)
		local req = {}
		if grade == 1 then
			req = {"omnitech-omnic-acid-hydrolyzation-1", "omnization-chamber-1"}
		end
		return req
	end):
	setTechLocName("basic-omni-processing"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnipure"):
	setLevel(omni.chem.levels):
	setEnergy(3):extend()
	
cost = OmniGen:create():
		setYield("omnirous-acid"):
		setIngredients({type="fluid",name="water-purified",amount=270},{type="fluid",name="omniperoxide",amount=90}):
		setWaste("oxomni"):
		linearPercentOutput(360,0.5)
		
RecChain:create("omnimatter_chemistry","omnirous-acid"):
	fluid():
	setMain("omnirous-acid"):
	setBothColour(1,0,0.5):
	setTechName("advanced-omni-processing"):
	setTechPacks(function(levels,grade) return 2+math.floor(grade*3/omni.chem.levels)+1 end):
	setTechIcon("omnimatter_chemistry","omni-processing-advanced"):
	setTechPrereq("omnitech-basic-omni-processing-3","omnitech-omnitractor-electric-3"):
	setTechLocName("advanced-omni-processing"):
	setCategory("omniplant"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnioxygen"):
	setLevel(omni.chem.levels):
	setEnergy(2.5):extend()
	
cost = OmniGen:create()
		cost:setYield("omnirium"):
		setIngredients({"omnite",15},{"uranium-ore",5},{name="omnic-waste",amount = 240, type="fluid"}):
		setWaste():
		linearPercentOutput(20,0.5)
		
RecChain:create("omnimatter_chemistry","omnirium"):
	setTechName("advanced-omni-processing"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	marathon():
	setSubgroup("omnipure"):
	setLevel(omni.chem.levels):
	setEnergy(1):extend()
	
RecGen:create("omnimatter_chemistry","omnirium-primitive"):
	setTechName("advanced-omni-processing"):
	setCategory("omnization"):
	setMain("omnirium"):
	setIngredients({"omnite",25},{"omnine",5},{"omnirium",5},{name="omnic-waste",amount = 600, type="fluid"},{name="omnic-water",amount = 1000, type="fluid"}):
	setResults({"stone-crushed",20},{"omnirium",10}):
	marathon():
	setSubgroup("omnipure"):
	setEnergy(1.5):extend()
	
cost = OmniGen:create()
		cost:setYield("omnic-mutagen"):
		setIngredients({"shattered-omnine",5},{"omnirium",5},{name="omnic-waste",amount = 600, type="fluid"}):
		setWaste():
		linearPercentOutput(360,0.5)
		
RecChain:create("omnimatter_chemistry","omnic-mutagen"):
	fluid():
	setTechName("advanced-omni-processing"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnipure"):
	setLevel(omni.chem.levels):
	setEnergy(1):extend()
	
ItemGen:create("omnimatter_chemistry","crystalline-wood"):
		setSubgroup("omnimutator"):
		setStacksize(200):
		extend()

--[[RecGen:create("omnimatter_chemistry","heavy-mutation"):
	setSubgroup("omnimutator"):
	setCategory("bob-greenhouse"):
	marathon():
	setIcons("omniwood"):
	setEnergy(60):
	setIngredients({
      {type = "item", name = "omniseedling", amount = 5},
      {type = "fluid", name = "omnic-water", amount = 50},
      {type = "fluid", name = "omnic-mutagen", amount = 100},
    }):
	setTechName("omnitech-crystallology-2"):
	setResults({type = "item", name = "omniwood", amount_min = 20, amount_max = 60},
		{type = "item", name = "crystalline-wood", amount_min = 5, amount_max = 20}
	):extend()]]
