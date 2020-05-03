cost = OmniGen:create():
		setYield("omnicarbide"):
		setIngredients({"omniwood",2},{type="fluid",name="omnic-acid",amount=100}):
		ifAddIngredients(mods["angelspetrochem"],{"solid-coke",1}):
		ifAddIngredients(not mods["angelspetrochem"],{"coal",4}):
		setWaste("omnic-waste"):
		linearPercentOutput(5,0.4)
	
RecChain:create("omnimatter_chemistry","omnicarbide"):
	setTechName("basic-carbomni-processing"):
	setSubgroup("omnicarbon"):
	setTechIcon("omnimatter_chemistry","carbomni"):
	setTechPacks(function(levels,grade) return math.max(math.floor(grade*4/omni.chem.levels),1) end):
	setTechPrereq(function(levels,grade)
		local req = {}
		if grade == 1 then
			req = {"omnitech-omnic-acid-hydrolyzation-1"}
		end
		return req
	end):
	setTechLocName("basic-carbomni-processing"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setLevel(omni.chem.levels):
	setStacksize(100):
	setEnergy(2):extend()
	
RecGen:create("omnimatter_chemistry","coal-crushed"):
	setGenerationCondition(data.raw.item["coal-crushed"]==nil):
	setFuelValue(2):
	setIngredients({"coal",1}):
	setResults({"coal-crushed",2}):
	setEnergy(1):extend()
	

	
cost = OmniGen:create():
		setYield("omnixylic-acid"):
		setIngredients({"omnicarbide",2},{type="fluid",name="omnion", amount=180}):
		setWaste("omnic-waste"):
		linearPercentOutput(200,0.4)
	
RecChain:create("omnimatter_chemistry","omnixylic-acid"):
	fluid():
	setBothColour(1,0,1):
	setTechName("basic-carbomni-processing"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omnicarbon"):
	setLevel(omni.chem.levels):
	setEnergy(2):extend()
		
cost = OmniGen:create():
		setYield("orthomnide"):
		setIngredients({"lead-ore",1},{type="fluid",name="omnixylic-acid",amount=120}):
		setWaste("coal-crushed","omnic-waste"):
		linearPercentOutput(3,0.4)
	
RecChain:create("omnimatter_chemistry","orthomnide"):
	setTechName("basic-carbomni-processing"):
	setSubgroup("omnipure"):
	setCategory("omniphlog"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setLevel(omni.chem.levels):
	setStacksize(100):
	setEnergy(1.5):extend()