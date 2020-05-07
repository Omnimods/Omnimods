BuildGen:create("omnimatter_research","burner-omnicosm"):
	setSubgroup("omnitractor"):
	setIcons("omnicosm"):
	setIngredients({
		{"omnicium-plate", 4},
		{"omnicium-gear-wheel", 6},
		{"copper-plate", 3},
		{"iron-plate", 3}}):
	setEnergy(10):
	setBurner(0.3,1):
	setUsage(150):
	setEnabled():
	setReplace("omnicosm"):
	setStacksize(10):
	setSize(3):
	setCrafting({"omnicosm"}):
	setSpeed(1):
	allowProductivity():
	setSoundWorking("ore-crusher",nil,"omnimatter"):
	setSoundVolume(2):
	setAnimation({
	layers={
	{
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
          priority = "high",
          line_length = 8,
          width = 78,
          height = 117,
          frame_count = 64,
          shift = util.by_pixel(0, 0),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B.png",
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 156,
            height = 234,
            frame_count = 64,
            shift = util.by_pixel(0, 0)
          }
        },
	},
	}):
	setFluidBox("XWX.XXX.XKX"):
	extend()

	local cost = OmniGen:create():
	building():
	setMissConstant(2):
	setPreRequirement("burner-omnicosm"):
	setQuant("circuit",5):
	setQuant("omniplate",20):
	setQuant("gear-box",10,-1)

if mods["bobplates"] then
	cost:setQuant("bearing",5,-1)
end

BuildChain:create("omnimatter_research","omnicosm"):
	setSubgroup("omnitractor"):
	setIcons("omnicosm"):
	setLocName("omnicosm"):
	setIngredients(cost:ingredients()):
	setEnergy(5):
	setUsage(function(level,grade) return (100+25*grade).."kW" end):
	addElectricIcon():
	setTechName("omnitractor-electric"):
	setReplace("omnicosm"):
	setStacksize(10):
	setSize(3):
	setLevel(omni.max_tier):
	setSoundWorking("ore-crusher",nil,"omnimatter"):
	setSoundVolume(2):
	allowProductivity():
	setModSlots(function(levels,grade) return grade end):
	setCrafting({"omnicosm"}):
	setSpeed(function(levels,grade) return 0.5+grade/2 end):
	setAnimation({
	layers={
	{
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
          priority = "high",
          line_length = 8,
          width = 78,
          height = 117,
          frame_count = 64,
          shift = util.by_pixel(0, 0),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B.png",
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 156,
            height = 234,
            frame_count = 64,
            shift = util.by_pixel(0, 0)
          }
        },
	},
	}):
	setFluidBox("WXW.XXX.KXK",true):
	extend()

BuildGen:create("omnimatter_research","burner-research_facility"):
	setSubgroup("omnitractor"):
	setIcons("research_facility"):
	setIngredients({
		{"omnicium-plate", 5},
		{"iron-plate", 3}}):
	setEnergy(10):
	setBurner(0.3,1):
	setUsage(150):
	setEnabled():
	setReplace("research_facility"):
	setStacksize(10):
	setSize(3):
	setCrafting({"research-facility"}):
	setSpeed(1):
	setSoundWorking("ore-crusher",nil,"omnimatter"):
	setSoundVolume(2):
	setAnimation({
		filename = "__omnimatter_research__/graphics/entity/research-facility.png",
		priority = "high",
		width = 128,
		height = 128,
		frame_count = 29,
		line_length = 6,
		animation_speed = 1,
		shift = {0,-0.3}
	}):
	setFluidBox("WXW.XXX.KXK"):
	extend()
log("WHY TOK!?")

    
local cost = OmniGen:create():
building():
setMissConstant(2):
setPreRequirement("burner-research_facility"):
setQuant("circuit",5):
setQuant("omniplate",10):
setQuant("pipe",10):
setQuant("gear-box",5)

log("I HAVE ARRIVED!")

BuildChain:create("omnimatter_research","research_facility"):
setSubgroup("omnitractor"):
setIcons("research_facility"):
setLocName("research_facility"):
setIngredients(cost:ingredients()):
setEnergy(5):
addElectricIcon():
setReplace("research_facility"):
setUsage(function(level,grade) return (100+25*grade).."kW" end):
setTechName("omnitractor-electric"):
setStacksize(10):
setSize(3):
setLevel(omni.max_tier):
setSoundWorking("ore-crusher",nil,"omnimatter"):
setSoundVolume(2):
allowProductivity():
setModSlots(function(levels,grade) return grade end):
setCrafting({"research-facility"}):
setSpeed(function(levels,grade) return 0.5+grade/2 end):
setAnimation({
    filename = "__omnimatter_research__/graphics/entity/research-facility.png",
    priority = "high",
    width = 128,
    height = 128,
    frame_count = 29,
    line_length = 6,
    animation_speed = 1,
    shift = {0,-0.3}
}):
setFluidBox("WXW.XXX.KXK"):
extend()

log("I HAVE DEPARTED!")
