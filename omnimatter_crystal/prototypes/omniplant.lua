local function timestier(row,col)
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

-- Burner Omniplant
--SETTING VANILLA INGREDIENTS FIRST
local pipe="pipe"
local electronic="electronic-circuit"
if mods["boblogistics"] then pipe="copper-pipe" end
if mods["bobelectronics"] then electronic="basic-circuit-board" end

local burner_ings = {}
if mods["angelsindustries"] and angelsmods.industries.components then
    burner_ings = {
    {name="block-construction-1", amount=5},
    {name="block-electronics-0", amount=3},
    {name="block-fluidbox-1", amount=5},
    {name="block-omni-0", amount=5}
    }
else
    burner_ings = {{pipe,15},{"omnicium-plate",5},{electronic,5},{"omnite-brick",10},{"iron-gear-wheel",10}}
end

BuildGen:create("omnimatter_crystal","omniplant"):
    noTech():
    setBurner(0.75,2):
    setEmissions(3.5):
    setSubgroup("omniplant"):
    setOrder("a[omniplant-burner]"):
    setIngredients(burner_ings):
    setEnergy(5):
    setUsage(function(level,grade) return "750kW" end):
    --setTechName("omnitech-omnitractor-electric-1"): --Done in final-fixes for now
    setReplace("omniplant"):
    setNextUpgrade("omniplant-1"):
    setStacksize(20):
    setSize(5):
    setCrafting({"omniplant"}):
    setSpeed(1):
    setSoundWorking("oil-refinery",1,"base"):
    setSoundVolume(2):
    setAnimation({
    layers={
    {
        filename = "__omnimatter_crystal__/graphics/buildings/omni-plant.png",
        priority = "extra-high",
        width = 224,
        height = 224,
        frame_count = 36,
        line_length = 6,
        shift = {0.00, -0.05},
        scale = 1,
        animation_speed = 0.5
    },
    }
    }):
    setOverlay("omni-plant-overlay"):
    setFluidBox("XWXWX.XXXXX.XXXXX.XXXXX.XKXKX"):
    setEnabled(false):
    extend()

local dif = 1
if not mods["bobelectronics"] then dif=0 end

local cost_plant = OmniGen:create():
    building():
    setMissConstant(3)
if mods["angelsindustries"] and angelsmods.industries.components then
    cost_plant:setQuant("construction-block",5):
    setQuant("electric-block",2):
    setQuant("fluid-block",5):
    setQuant("energy-block",1):
    setQuant("omni-block",1)
else
    cost_plant:setQuant("pipe",15,2):
    setQuant("omniplate",10):
    setQuant("gear-wheel",10):
    setQuant("circuit",5,dif)
end

--Omniplant
BuildChain:create("omnimatter_crystal","omniplant"):
    setSubgroup("omniplant"):
    setLocName("omniplant"):
    setIngredients(cost_plant:ingredients()):
    setEnergy(5):
    setUsage(function(level,grade) return (200+50*grade).."kW" end):
    setEmissions(function(level,grade) return math.max(2.6 - ((grade-1) * 0.2), 0.1) end):
    addElectricIcon():
    setTechName(function(levels,grade) if grade == 1 then return "omnitech-omnic-acid-hydrolyzation-1" else return "omnitech-crystallology" end end):
    setTechIcons("crystallology","omnimatter_crystal"):
    setTechCost(get_tech_times):
    setTechPacks(function(levels,grade) return grade end):
    setTechPrereq(function(levels,grade)
        local req = {}
        if grade < omni.max_tier then req[#req+1]="omnitech-omnitractor-electric-"..grade end
        if grade > 2 then req[#req+1]="omnitech-crystallology-"..(grade-2) end
        return req end):
    setReplace("omniplant"):
    setTechTime(function(levels,grade) return 15*grade end):
    setStacksize(20):
    setSize(5):
    setLevel(omni.max_tier):
    setModSlots(function(levels,grade) return grade end):
    setCrafting({"omniplant"}):
    setSpeed(function(levels,grade) return 0.5+grade/2 end):
    setSoundWorking("oil-refinery",1,"base"):
    setSoundVolume(2):
    allowProductivity():
    setAnimation({
    layers={
    {
        filename = "__omnimatter_crystal__/graphics/buildings/omni-plant.png",
        priority = "extra-high",
        width = 224,
        height = 224,
        frame_count = 36,
        line_length = 6,
        shift = {0.00, -0.05},
        scale = 1,
        animation_speed = 0.5
    },
    }
    }):
    setOverlay("omni-plant-overlay"):
    setFluidBox("XWXWX.XXXXX.XXXXX.XXXXX.XKXKX"):
    extend()

RecGen:import("omniplant-1"):
    addIngredients({"burner-omniplant",1}):
    extend()