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

local function get_tech_times(levels,tier)
    local t = 50*timestier(tier,1)
    return t
end

local dif = 1
if not mods["bobelectronics"] then dif=0 end

local cost_omnizer = OmniGen:create():
    building():
    setMissConstant(3)

if mods["angelsindustries"] and angelsmods.industries.components then
    cost_omnizer:setQuant("construction-block",5):
    setQuant("electric-block",2):
    setQuant("fluid-block",5):
    setQuant("enhancement-block",1):
    setQuant("omni-block",1)
else
    cost_omnizer:setQuant("pipe",15,2):
    setQuant("omniplate",10):
    setQuant("gear-wheel",10):
    setQuant("circuit",5,dif)
end

local tmp = {{"advanced-circuit"}}
BuildChain:create("omnimatter_crystal","crystallomnizer"):
    setSubgroup("crystallomnizer"):
    setIcons({"crystallomnizer", 32}):
    setLocName("crystallomnizer"):
    setIngredients(cost_omnizer:ingredients()):
    setEnergy(5):
    setUsage(function(level,grade) return (200+50*grade).."kW" end):
    setEmissions(function(level,grade) return math.max(2.0 - ((grade-1) * 0.2), 0.1) end):
    addElectricIcon():
    allowProductivity():
    setTechName("omnitech-crystallonics"):
    setTechIcons("crystallonics","omnimatter_crystal"):
    setTechCost(get_tech_times):
    setTechPacks(function(levels,grade) return grade + 1 end):
    setReplace("crystallomnizer"):
    setTechTime(function(levels,grade) return 15*grade end):
    setTechPrereq(function(levels,grade)
        local tmp = {"omnitech-crystallology-"..math.min(grade,omni.max_tier-1)}
        if grade == 1 then
            tmp[#tmp+1]="advanced-circuit"
        else
            tmp[#tmp+1]="omnitech-crystallonics-"..(grade-1)
        end
        return tmp end):
    setStacksize(20):
    setSize(3):
    setLevel(omni.max_tier):
    setModSlots(function(levels,grade) return grade end):
    setCrafting({"crystallomnizer"}):
    setSpeed(function(levels,grade) return 0.5+grade/2 end):
    setSoundWorking("oil-refinery",1,"base"):
    setSoundVolume(2):
    setAnimation({
    layers={
    {
        filename = "__omnimatter_crystal__/graphics/buildings/iron-curtain.png",
        priority = "extra-high",
        width = 164,
        height = 162,
        frame_count = 36,
        line_length = 6,
        shift = {0.00, -0.8},
        scale = 0.8,
        animation_speed = 0.3
    },
    }
    }):
    setFluidBox("XWX.XXX.XKX"):
    extend()