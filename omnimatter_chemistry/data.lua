omni.add_omniwaste()
if not omni.chem then omni.chem={} end

omni.chem.levels = settings.startup["omnichemistry-levels"].value
omni.chem.pack = settings.startup["omnichemistry-levels-per-pack"].value

--omnirec-impure-"..omnisource[i].ore.name.."-extraction-"..l
--"omnitech-impure-"..omnisource[i].ore.name.."-extraction-"..l

local cost = OmniGen:create():
    building():
    setMissConstant(2):
    setQuant("circuit",15):
    setQuant("omniplate",20):
    setQuant("gear-box",10)
    
if mods["bobplates"] then
    cost:setQuant("bearing",15)
end

BuildChain:create("omnimatter_chemistry","omnismelter"):
    setSubgroup("omnitractor"):
    setLocName("omnismelter"):
    setIngredients(cost:ingredients()):
    setEnergy(5):
    setUsage(function(level,grade) return (200+50*grade).."kW" end):
    setTechPrereq(function(levels,grade) return "omnitech-omnitractor-electric-"..grade end):
    setTechIcon("omnimatter_chemistry","omnismelter"):
    setTechCost(function(levels,grade) return 50+75*grade+math.pow(2,grade) end):
    setTechPacks(function(levels,grade) return grade+1 end):
    setReplace("omnismelter"):
    setTechTime(function(levels,grade) return 15*grade end):
    setTechLocName("omnismelter"):
    setStacksize(10):
    setLevel(omni.max_tier):
    setSoundWorking("oil-refinery",1,"base"):
    setSoundVolume(2):
    setModSlots(function(levels,grade) return grade end):
    setCrafting({"omnismelter"}):
    setSpeed(function(levels,grade) return 0.75+grade/4 end):
    setFluidBox("WXW.XXX.KXK"):
    setAnimation({
    layers={
    {
        filename = "__omnimatter_chemistry__/graphics/entities/omnismelter.png",
        priority = "extra-high",
        width = 224,
        height = 224,
        frame_count = 42,
        line_length = 6,
        shift = {0.00, -0.05},
        scale = 0.50,
        animation_speed = 0.5
    },
    },
    }):--setOverlay("tractor-over"):
    extend()

cost = OmniGen:create():
    building():
    setMissConstant(3):
    setQuant("circuit",5):
    setQuant("omniplate",20):
    setQuant("gear-box",10)
    
if mods["bobplates"] then
    cost:setQuant("bearing",10,-1)
end

BuildChain:create("omnimatter_chemistry","omnization-chamber"):
    setSubgroup("omnitractor"):
    setLocName("omnization-chamber"):
    setIngredients(cost:ingredients()):
    setEnergy(5):
    setUsage(function(level,grade) return (100+50*grade).."kW" end):
    setTechPrereq(function(levels,grade) return "omnitech-omnitractor-electric-"..grade end):
    setTechIcon("omnimatter_chemistry","omnichem"):
    setTechCost(function(levels,grade) return 50+75*grade+math.pow(2,grade) end):
    setTechPacks(function(levels,grade) return grade end):
    setReplace("omnization-chamber"):
    setTechTime(function(levels,grade) return 15*grade end):
    setTechLocName("omnization-chamber"):
    setStacksize(10):
    setLevel(omni.max_tier):
    setSoundWorking("oil-refinery",1,"base"):
    setSoundVolume(2):
    setModSlots(function(levels,grade) return grade end):
    setCrafting({"omnization"}):
    setSpeed(function(levels,grade) return 0.75+grade/4 end):
    setFluidBox("WXXW.AXXX.XXXL.KXXK"):
    setAnimation({
    layers={
    {
        filename = "__omnimatter_chemistry__/graphics/entities/omnization-chamber.png",
        priority = "extra-high",
        width = 320,
        height = 384,
        frame_count = 30,
        line_length = 6,
        shift = {0.00, -0.05},
        scale = 0.50,
        animation_speed = 0.5
    },
    },
    }):--setOverlay("tractor-over"):
    extend()
    
cost = OmniGen:create():
    building():
    setMissConstant(3):
    setQuant("circuit",7,2):
    setQuant("omniplate",10,1):
    setQuant("gear-box",5):
    setQuant("pipe",5,3)


BuildChain:create("omnimatter_chemistry","omni-refinery"):
    setSubgroup("omnitractor"):
    setLocName("omni-refinery"):
    setIngredients(cost:ingredients()):
    setEnergy(5):
    setUsage(function(level,grade) return (200+50*grade).."kW" end):
    setTechName("omni-refining"):
    setTechPrereq(function(levels,grade) if grade +2 < omni.max_tier then return "omnitech-omnitractor-electric-"..(grade+2) else return nil end end):
    setTechIcon("omnimatter_chemistry","omnirefining"):
    setTechCost(function(levels,grade) return 150+100*grade+20*math.pow(2,grade) end):
    setTechPacks(function(levels,grade) return math.floor(grade/2)+3 end):
    setTechTime(function(levels,grade) return 15*grade end):
    setTechLocName("omni-refining"):
    setReplace("omnirefinery"):
    setStacksize(10):
    setLevel(omni.max_tier):
    setSoundWorking("oil-refinery",1,"base"):
    setSoundVolume(2):
    setModSlots(function(levels,grade) return grade end):
    setCrafting({"omnirefining"}):
    setSpeed(function(levels,grade) return 0.75+grade/4 end):
    setFluidBox("XXWXX.XXXXX.JXXXL.XXXXX.XXSXX"):
    setAnimation({
    layers={
    {
        filename = "__omnimatter_chemistry__/graphics/entities/omnirefinery.png",
        priority = "extra-high",
        width = 224,
        height = 244,
        frame_count = 30,
        line_length = 6,
        shift = {0.00, -0.00},
        scale = 1.00,
        animation_speed = 0.5
    },
    },
    }):--setOverlay("tractor-over"):
    extend()
    
require("prototypes/carbomni")
require("prototypes/thiomni")
require("prototypes/oxomni")
require("prototypes/nitromni")
require("prototypes/categories")
require("prototypes/omni-materials")
require("prototypes/organomnimetals")
require("prototypes/omnimetal")
require("prototypes/biomni")