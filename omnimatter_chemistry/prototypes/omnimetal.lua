cost = OmniGen:create():
		setYield("omnirgyrum"):
		setIngredients({"omnisite",2},{type="fluid",name="peromnic-acid",amount=120}):
		setWaste("gas-sulfur-dioxide","omnic-waste"):
		linearPercentOutput(180,0.45)
	
RecChain:create("omnimatter_chemistry","omnirgyrum"):
	fluid():
	setBothColour(1,0,0.5):
	setTechName("basic-omnirgyrum-processing"):
	setTechPacks(function(levels,grade) return math.floor(grade*4/omni.chem.levels)+1 end):
	setTechIcon("omnimatter_chemistry","omni-processing"):
	setTechPrereq(function(levels,grade)
		local req = {}
		if grade == 1 then
			req = {"omnitech-basic-thiomni-processing-1","omnitech-basic-oxomni-processing-1"}
		end
		return req
	end):
	setTechLocName("basic-omnirgyrum-processing"):
	setCategory("omniplant"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnioxygen"):
	setLevel(omni.chem.levels):
	setEnergy(2.5):extend()