require("prototypes.functions")


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

function omniwateradd(element,gain,tier,const,input,t1_enabled)
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
		--setEnabled(false):
		setEnabled(function(levels,grade) if ((grade == 1) and (t1_enabled==true)) then return true else return false end end):
		setCategory("omnite-extraction-both"):
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
local c = 1
if mods["omnimatter_compression"] then c = 1/3 end
omniwateradd("omnic-water",1728*2*c,1,72,c,true)

if mods["angelsrefining"] then
	omniwateradd("water-viscous-mud",1728/2,1,144,false)
	for _,fluid in pairs(data.raw.fluid) do
		if omni.lib.start_with(fluid.name,"water") and omni.lib.end_with(fluid.name,"waste") then
			omniwateradd(fluid.name,1728/6,2,288,false)
		end
	end
end
