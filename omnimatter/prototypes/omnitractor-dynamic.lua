BuildGen:create("omnimatter","omnitractor"):
	setSubgroup("omnitractor"):
	setIngredients({
	{name="omnicium-gear-wheel", amount=2},
	{name="omnicium-plate", amount=4},
	{name="iron-plate", amount=3}}):
	setEnergy(10):
	setBurner(1,1):
	setUsage(100):
	setEnabled():
	setReplace("omnitractor"):
	setStacksize(10):
	setSize(3):
	setCrafting({"omnite-extraction-both","omnite-extraction-burner"}):
	setSpeed(1):
	setSoundWorking("ore-crusher"):
	setSoundVolume(2):
	setAnimation({
	layers={
	{
        filename = "__omnimatter__/graphics/entity/buildings/tractor.png",
		priority = "extra-high",
        width = 160,
        height = 160,
        frame_count = 36,
		line_length = 6,
        shift = {0.00, -0.05},
		scale = 0.90,
		animation_speed = 0.5
	},
	},
	}):setOverlay("tractor-over",0):
	setFluidBox("WXW.XXX.KXK",true):
	extend()

local get_pure_req = function(levels,i)
	local r = {}
	for j,tier in pairs(omnisource) do
		if tonumber(j) < i and tonumber(j) >= i-3 then
			for _,ore in pairs(tier) do
				r[#r+1]="omnitech-extraction-"..ore.name.."-"..omni.pure_levels_per_tier*(i-ore.tier-1)+omni.pure_dependency
			end
		end
		if tonumber(j) == i then
			for _,ore in pairs(tier) do
				r[#r+1]="omnitech-focused-extraction-"..ore.name.."-"..omni.impure_dependency
			end
		end
	end
	if i>1 and i*omni.fluid_levels_per_tier < omni.fluid_levels then
		--r[#r+1]="omnitech-solvation-omniston-"..(i-2)*omni.fluid_levels_per_tier+omni.fluid_dependency
		--r[#r+1]="omnitech-omnic-acid-hydrolyzation-"..(i-2)*omni.fluid_levels_per_tier+omni.fluid_dependency
		--r[#r+1]="omnitech-omnisolvent-omnisludge-"..(i-2)*omni.fluid_levels_per_tier+omni.fluid_dependency
	end
	if i == 2 then
		r[#r+1]="omnitech-omnisolvent-omnisludge-"..(i-2)*omni.fluid_levels_per_tier+omni.fluid_dependency
	end
	for j,tier in pairs(omnifluid) do
		if tonumber(j) < i and tonumber(j) >= i-3 then
			for _,fluid in pairs(tier) do
				if omni.fluid_levels_per_tier*(i-fluid.tier-1)+omni.fluid_dependency <= omni.fluid_levels then
					r[#r+1]="omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels_per_tier*(i-fluid.tier-1)+omni.fluid_dependency
				elseif omni.fluid_levels_per_tier*(i-fluid.tier-1)+omni.fluid_dependency > omni.fluid_levels then
					r[#r+1]="omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels
				end
			end
		end
	end
	return r
end

function timestier(row,col)
	local first_row = {1,0.5,0.2}
	if row == 1 then
		return first_row[col]
	elseif col == 3 then
		return 0.2
	else
		return timestier(row-1,col)+timestier(row-1,col+1)
	end	
end

local get_tech_times = function(levels,tier)
	local t = 50*timestier(tier,1)
	return t
end

local techcost = function(lvl,tier)
	local c = {}
	local size = tier+((lvl-1)-(lvl-1)%omni.pure_levels_per_tier)/omni.pure_levels_per_tier
	local length = math.min(size,#omni.sciencepacks)
	for l=1,length do
		local q = 0
		if omni.linear_science then
			q = 1+omni.science_constant*(size-l)
		else
			q=round(math.pow(omni.science_constant,size-l))
		end
		c[#c+1] = {omni.sciencepacks[l],q}
	end
	return c
end

local cost = OmniGen:create():
	building():
	setMissConstant(2):
	setPreRequirement("burner-omnitractor"):
	setQuant("circuit",5):
	setQuant("omniplate",20):
	setQuant("gear-box",10)
	

if mods["bobplates"] then
	cost:setQuant("bearing",5,-1)
end


--log("omnitractor testing")
BuildChain:create("omnimatter","omnitractor"):
	setSubgroup("omnitractor"):
	setIcons("omnitractor","omnimatter"):
	setLocName("omnitractor"):
	setIngredients(cost:ingredients()):
	setEnergy(5):
	setUsage(function(level,grade) return (100+25*grade).."kW" end):
	setTechPrereq(get_pure_req):
	addElectricIcon():
	setTechSuffix("electric"):
	setTechIcon("omnimatter","omnitractor-electric"):
	setTechCost(get_tech_times):
	setTechPacks(function(levels,grade) return grade end):
	setReplace("omnitractor"):
	setTechTime(function(levels,grade) return 15*grade end):
	ifModsAddTechPrereq("omnimatter_crystal",function(levels,grade) if grade > 2 and (grade-2)*omni.fluid_levels_per_tier+omni.fluid_dependency<=omni.fluid_levels then return "omnitech-omnisolvent-omnisludge-"..(grade-2)*omni.fluid_levels_per_tier+omni.fluid_dependency else return nil end end):
	setTechLocName("electric-omnitractor"):
	setStacksize(10):
	allowProductivity():
	setLevel(settings.startup["omnimatter-max-tier"].value):
	setSoundWorking("ore-crusher"):
	setSoundVolume(2):
	setModSlots(function(levels,grade) return grade end):
	setCrafting({"omnite-extraction-both","omnite-extraction"}):
	setSpeed(function(levels,grade) return 0.5+grade/2 end):
	setFluidBox("WXW.XXX.KXK",true):
	setAnimation({
	layers={
	{
        filename = "__omnimatter__/graphics/entity/buildings/tractor.png",
		priority = "extra-high",
        width = 160,
        height = 160,
        frame_count = 36,
		line_length = 6,
        shift = {0.00, -0.05},
		scale = 0.90,
		animation_speed = 0.5
	},
	},
	}):setOverlay("tractor-over"):
	extend()
