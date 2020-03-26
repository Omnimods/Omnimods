if not omni then omni={} end
if not omni.crystal then omni.crystal={} end
require("prototypes.crystallonics")
require("prototypes.crystal-making")
require("prototypes.categories")
require("prototypes.fuel-category")

--require("prototypes.circuit")
--require("prototypes.technology.crystallology")
require("functions")

local pipeadd="pipe" --vanilla set
local elecadd="electronic-circuit" --vanilla set
if data.raw.item["copper-pipe"] then
	pipeadd="copper-pipe"
end
if data.raw.item["basic-circuit-board"] then
	elecadd="basic-circuit-board"
end
BuildGen:create("omnimatter_crystal","omniplant"):
	setSubgroup("omniplant"):
	setLocName("omniplant-burner"):
	setIcons("omniplant","omnimatter_crystal"):
	setIngredients({pipeadd,15},{"omnicium-plate",5},{elecadd,5},{"omnite-brick",10},{"iron-gear-wheel",10}):
	setBurner(0.75,2):
	setEnergy(25):
	setUsage(function(level,grade) return "750kW" end):
	setTechName("omnitractor-electric-1"):
	setReplace("omniplant"):
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
	extend()
