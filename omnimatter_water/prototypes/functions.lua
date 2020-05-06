local water_levels = settings.startup["water-levels"].value
local tier_levels = settings.startup["omnimatter-fluid-lvl-per-tier"].value
local watering={}



local get_solvation_tech_cost = function(lvl)
	local c = {}
	local size = 2+((lvl-1)-(lvl-1)%tier_levels)/tier_levels
	local length = math.min(size,#sciencepacks)
	for l=1,length do
		c[#c+1] = {sciencepacks[l],1}
	end
	return c
end

local omniwater_prereq = function(levels,grade,element,tier)
	local req = {}
	if grade> 1 and grade%tier_levels~=1 then
		req[#req+1]="omnitech-"..element.."-omnitraction-"..grade-1
	end
	if grade%tier_levels==1 and (math.floor((grade-1)/tier_levels)+1)<=omni.max_tier then
		req[#req+1]="omnitractor-electric-"..math.min((math.floor((grade-1)/tier_levels)+tier),omni.max_tier)
	end
	return req
end

local cat = "chemistry"
if mods["omnimatter_crystal"] then cat = "omniplant" end

function omniwateradd(element,gain,tier,const,input)
	local cost = OmniGen:create():
		setInputAmount(12*(input or 1)):
		setYield(element):
		setIngredients("omnite"):
		setWaste("omnic-waste"):
		--setLocName("fluid-name."..element):
		yieldQuant(function(levels,grade) return gain+(grade-1)*gain/(levels-1) end):
		wasteQuant(function(levels,grade) return gain-(grade-1)*gain/(levels-1) end)
	--log("making omniwater "..element)
	RecChain:create("omnimatter",element):
		setIngredients("omnite"):
		setIcons(element):
		setIngredients(cost:ingredients()):
		setResults(cost:results()):
		setEnabled(false):
		setCategory(cat):
		setSubgroup("omni-fluids"):
		setLocName("recipe-name.water-waste-omnitraction",{"fluid-name."..element}):
		setLevel(water_levels):
		setEnergy(5*(input or 1)):
		setTechIcon("omnimatter_water",element):
		setTechSuffix("omnitraction"):
		setTechCost(function(levels,grade) return const*get_tier_mult(levels,grade,1) end):
		setTechPrereq(function(levels,grade) if grade == 1  then return {"omnitractor-electric-"..tier} else return nil end end):
		setTechTime(15):
		setTechPacks(function(levels,grade) return math.floor((grade-1)/tier_levels)+1 end):
		setTechLocName("water-based-omnitraction",{"fluid-name."..element}):
		extend()
end