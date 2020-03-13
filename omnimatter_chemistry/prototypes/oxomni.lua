cost = OmniGen:create():
		setYield("oxomni"):
		setIngredients({"omnisite",2},{type="fluid",name="gas-oxygen",amount=120}):
		setWaste("gas-sulfur-dioxide"):
		linearPercentOutput(120,0.4)
	
RecChain:create("omnimatter_chemistry","oxomni"):
	fluid():
	setBothColour(1,0,0.5):
	setTechName("basic-oxomni-processing"):
	setTechPacks(function(levels,grade) return math.floor(grade/4)+1 end):
	setTechIcon("omnimatter_chemistry","oxomni"):
	setTechPrereq(function(levels,grade)
		local req = {}
		if grade == 1 then
			req = {"omnitech-basic-thiomni-processing-1"} --"omnitech-omnic-water-omnitraction-2"
		end
		return req
	end):setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnioxygen"):
	setLevel(omni.chem.levels):
	setEnergy(1.5):extend()
	
cost = OmniGen:create():
		setYield("peromnic-acid"):
		setIngredients({"ingot-copper",1},{type="fluid",name="omnic-acid",amount=120},{type="fluid",name="oxomni",amount=120},{type="fluid",name="omnion",amount=120}):
		setWaste("omnic-waste"):
		linearPercentOutput(360,0.4,2/3)
		
RecChain:create("omnimatter_chemistry","peromnic-acid"):
	fluid():
	setMain("peromnic-acid"):
	setBothColour(1,0,0.5):
	setTechName("basic-oxomni-processing"):
	setCategory("omniplant"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnioxygen"):
	setLevel(omni.chem.levels):
	setEnergy(2.5):extend()
	
cost = OmniGen:create():
		setYield("oxomnithiol"):
		setIngredients({"thiomnine",2},{type="fluid",name="oxomni",amount=120}):
		setWaste("gas-sulfur-dioxide"):
		linearPercentOutput(180,0.45)
	
RecChain:create("omnimatter_chemistry","oxomnithiol"):
	fluid():
	setBothColour(1,0,0.5):
	setTechName("basic-oxomni-processing"):
	setCategory("omniplant"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnioxygen"):
	setLevel(omni.chem.levels):
	setEnergy(2.5):extend()
	
cost = OmniGen:create():
		setYield("omniperoxide"):
		setIngredients({type="fluid",name="peromnic-acid",amount=180},{type="fluid",name="oxomni",amount=180}):
		setWaste("gas-hydrogen","gas-oxygen"):
		linearPercentOutput(360,0.4,2/3)
		
RecChain:create("omnimatter_chemistry","omniperoxide"):
	fluid():
	setMain("omniperoxide"):
	setBothColour(1,0,0.5):
	setTechName("advanced-oxomni-processing"):
	setTechPacks(function(levels,grade) return 2+math.floor(grade*3/omni.chem.levels)+1 end):
	setTechIcon("omnimatter_chemistry","oxomni-advanced"):
	setTechPrereq("omnitech-basic-oxomni-processing-3","omnitractor-electric-3"):
	setCategory("omniplant"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnioxygen"):
	setLevel(omni.chem.levels):
	setEnergy(2.5):extend()
	
cost = OmniGen:create():
		setYield("oxomnithiolic-acid"):
		setIngredients(
		{type="fluid",name="oxomnithiol", amount=60},
		{type="fluid",name="omnixylic-acid", amount=60}):
		setWaste("omnic-waste"):
		linearPercentOutput(120,0.4)
	
RecChain:create("omnimatter_chemistry","oxomnithiolic-acid"):
	setSubgroup("raw-material"):
	fluid():
	setMain("oxomnithiolic-acid"):
	setTechName("basic-oxomnithiol-processing"):
	setTechPacks(function(levels,grade) return 2+math.floor(grade*3/omni.chem.levels) end):
	setTechIcon("omnimatter_chemistry","oxomnithiol"):
	setTechPrereq("omnitech-basic-oxomni-processing-3","omnitech-basic-thiomni-processing-3"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setLevel(omni.chem.levels):
	setEnergy(1.5):extend()