BuildGen:import("burner-omni-furnace"):
setLocName("entity-name.omni-furnace-1"):
addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
setFuelCategory("omnite"):
setNextUpgrade("omni-furnace-2"):
setReplace("furnace"):
extend()

RecGen:import("burner-omni-furnace"):
setLocName("entity-name.omni-furnace-1"):
addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
extend()

ItemGen:import("burner-omni-furnace"):
setLocName("entity-name.omni-furnace-1"):
addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
extend()

BuildGen:import("burner-omni-furnace"):
setName("omni-furnace-2","omnimatter_energy"):
addIcon("__omnilib__/graphics/icons/small/lvl2.png"):
setSpeed(2.0):
setFuelCategory("chemical"):
setIngredients({"burner-omni-furnace",1},{"omnicium-iron-alloy",15},{"iron-plate",20},{"omnicium-iron-gear-box",60}):
setEnabled(false):
setTechName("advanced-material-processing"):
setReplace("furnace"):
extend()

BuildGen:import("electric-furnace"):
setName("omni-furnace-3","omnimatter_energy"):
setAssembler():
setIcons({
    {icon = "__omnimatter_energy__/graphics/icons/electric-omni-furnace.png", icon_size = 64},
    {icon = "__omnilib__/graphics/icons/small/lvl3.png", icon_size = 32}}):
setSpeed(3.0):
setUsage(160):
setStacksize(20):
setSubgroup("omni-buildings"):
setCrafting("smelting","omnifurnace"):
setIngredients({"omni-furnace-2",1},{"omnicium-steel-alloy",25},{"steel-plate",30},{"omnicium-iron-gear-box",150}):
setEnabled(false):
setTechName("advanced-material-processing-2"):
setReplace("furnace"):
setAnimation({
    layers = {
      {
        filename = "__omnimatter_energy__/graphics/entity/buildings/electric-omni-furnace.png",
        priority = "high",
        width = 129,
        height = 100,
        frame_count = 1,
        shift = util.by_pixel(1.5, 4.0),
        shift = {0.46875, 0},
        hr_version = {
          filename = "__omnimatter_energy__/graphics/entity/buildings/hr-electric-omni-furnace.png",
          priority = "high",
          width = 239,
          height = 219,
          frame_count = 1,
          shift = util.by_pixel(1.25, 6.5),
          scale = 0.5
        }
      },
      {
        filename = "__base__/graphics/entity/electric-furnace/electric-furnace-shadow.png",
        priority = "high",
        width = 129,
        height = 100,
        frame_count = 1,
        draw_as_shadow = true,
        shift = util.by_pixel(39.5, 11.5),
        shift = {0.46875, 0},

        hr_version = {
          filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-shadow.png",
          priority = "high",
          width = 227,
          height = 171,
          frame_count = 1,
          draw_as_shadow = true,
          shift = util.by_pixel(39.25, 11.25),
          scale = 0.5
        }
      },
    },
  }):extend()