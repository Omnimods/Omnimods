--GFX by Arch666Angel
local b = BuildGen:create("omnimatter_compression","auto-compressor"):
	setStacksize(50):
	setFlags({"placeable-neutral", "placeable-player", "player-creation"}):
	setSubgroup("production-machine"):
	setIngredients({{"steel-plate", 15}, {"electronic-circuit", 5}, {"stone-brick", 10}}):
	setEnergy(10):
	setModSlots(0):
	setModEffects():
	setUsage(225):
	setSpeed(3):
	setFurnace():
	setSize(3):
	setCrafting({"compression"}):
	setAnimation({
      filename = "__omnimatter_compression__/graphics/auto-compressor-sheet.png",
      priority = "high",
      width = 160,
      height = 160,
      frame_count = 25,
      line_length = 5,
      shift = {0.0, 0.0},
      animation_speed = 0.25
    }):extend()
	
	local b = BuildGen:create("omnimatter_compression","auto-concentrator"):
	setStacksize(50):
	setFlags({"placeable-neutral", "placeable-player", "player-creation"}):
	setSubgroup("production-machine"):
	setIngredients({{"steel-plate", 50}, {"electronic-circuit", 20}, {"stone-brick", 40}}):
	setEnergy(10):
	setModSlots(0):
	setModEffects():
	setUsage(225):
	setSpeed(3):
	setFurnace():
	setSize(3):
	setFluidBox("XWX.XXX.XKX"):
	setCrafting({"fluid-concentration"}):
	setAnimation({
      filename = "__omnimatter_compression__/graphics/buildings/auto-concentrator.png",
      priority = "high",
      width = 160,
      height = 160,
      frame_count = 30,
      line_length = 10,
      shift = {0.0, 0.0},
      animation_speed = 0.25
	}):extend()
	
	local b = BuildGen:create("omnimatter_compression","auto-condensator"):
	setStacksize(50):
	setFlags({"placeable-neutral", "placeable-player", "player-creation"}):
	setSubgroup("production-machine"):
	setIngredients({{"steel-plate", 50}, {"electronic-circuit", 20}, {"stone-brick", 40}}):
	setEnergy(10):
	setModSlots(0):
	setModEffects():
	setUsage(225):
	setSpeed(3):	
	setIcons("auto-concentrator"):
	setSize(3):
	setFluidBox("XWX.XXX.XKX"):
	setCrafting({"fluid-condensation"}):
	setAnimation({
      filename = "__omnimatter_compression__/graphics/liquifier.png",
      priority = "high",
      width = 160,
      height = 160,
      frame_count = 30,
      line_length = 10,
      shift = {0.0, 0.0},
      animation_speed = 0.25
    }):extend()
	