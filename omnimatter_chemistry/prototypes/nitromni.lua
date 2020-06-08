cost = OmniGen:create():
		setYield("nitromni"):
		setIngredients({"omnite",2},{type="fluid",name="gas-nitrogen",amount=120}):
		setWaste("omnic-waste","gas-nitrogen-monoxide"):
		linearPercentOutput(180,0.45)
	
RecChain:create("omnimatter_chemistry","nitromni"):
	fluid():
	setBothColour(1,0,0.5):
	setTechName("basic-nitromni-processing"):
	setTechPacks(function(levels,grade) return math.floor(grade*4/omni.chem.levels)+1 end):
	setTechIcon("omnimatter_chemistry","nitromni"):
	setTechPrereq(function(levels,grade)
		local req = {}
		if grade == 1 then
			req = {"omnitech-basic-omni-processing-1","omnismelter-1"}
			if mods["angelspetrochem"] then
				req[#req+1]="angels-nitrogen-processing-1"
			else
				req[#req+1]="oil-processing"
			end
		end
		return req
	end):
	setTechLocName("basic-nitromni-processing"):
	setCategory("omnization"):
	setIngredients(cost:ingredients()):
	setResults(cost:results()):
	setSubgroup("omninitrogen"):
	setLevel(omni.chem.levels):
	setEnergy(2.5):extend()