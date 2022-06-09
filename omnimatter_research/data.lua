require("prototypes.parts")
require("prototypes.omnicosm")
require("prototypes.omniphlog")
require("prototypes.categories")

BuildGen:create("omnimatter_research","omnicosm"):
    setSubgroup("omnitractor"):
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
    
BuildGen:create("omnimatter_research","research_facility"):
    setSubgroup("omnitractor"):
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
