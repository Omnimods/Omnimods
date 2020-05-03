cost = OmniGen:create():
		setYield("omnisite"):
		setIngredients({"omnite",3},{"sulfur",1}):
		setWaste("omnic-waste"):
		linearPercentOutput(6,0.3)
	
RecChain:create("omnimatter_chemistry","omnisite"):
	setTechName("basic-thiomni-processing"):
	setSubgroup("omnisulphur"):
	setTechIcon("omnimatter_chemistry","thiomni"):
	setTechPacks(function(levels,grade) return math.floor(grade/3)+1 end):
	setTechPrereq(function(levels,grade)
		local req = {}
		if grade == 1 then
			if mods["angelspetrochem"] then
				req[#req+1]="angels-sulfur-processing-1"
			else
				req[#req+1]="sulfur-processing"
			end
		end
		return req
	end):
	setTechLocName("basic-thiomni-processing"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setLevel(omni.chem.levels):
	setStacksize(100):
	setEnergy(3):extend()
	
cost = OmniGen:create():
		setYield("thiomnine"):
		setIngredients({"sulfur",1},{"omnisite",1},{type="fluid",name="hydromnic-acid",amount=120}):
		setWaste("omnic-waste"):
		linearPercentOutput(2,0.3)
	
RecChain:create("omnimatter_chemistry","thiomnine"):
	setTechName("basic-thiomni-processing"):
	setSubgroup("omnisulphur"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setLevel(omni.chem.levels):
	setStacksize(100):
	setEnergy(3):extend()
	
	