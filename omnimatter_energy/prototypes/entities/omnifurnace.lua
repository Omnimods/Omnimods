BuildGen:import("burner-omni-furnace"):
    setLocName("entity-name.omni-furnace-1"):
    addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
    setOrder("a[omni-furnace-1]"):
    setFuelCategories("omnite"):
    setNextUpgrade("omni-furnace-2"):
    setReplace("furnace"):
    extend()

RecGen:import("burner-omni-furnace"):
    setLocName("entity-name.omni-furnace-1"):
    addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
    setOrder("a[omni-furnace-1]"):
    extend()

ItemGen:import("burner-omni-furnace"):
    setLocName("entity-name.omni-furnace-1"):
    addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
    extend()

BuildGen:import("burner-omni-furnace"):
    setName("omni-furnace-2","omnimatter_energy"):
    addIcon("__omnilib__/graphics/icons/small/lvl2.png"):
    setSpeed(2.0):
    setEmissions(4.0):
    setOrder("a[omni-furnace-2]"):
    setFuelCategories("chemical"):
    setIngredients({"burner-omni-furnace",1},{"omnicium-iron-alloy",15},{"iron-plate",20},{"omnicium-iron-gear-box",20}):
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
    setEmissions(1.0):
    setStacksize(50):
    setInventory(255):
    setSubgroup("omni-buildings"):
    setOrder("a[omni-furnace-3]"):
    setCrafting("smelting","omnifurnace"):
    setIngredients({"omni-furnace-2",1},{"omnicium-steel-alloy",15},{"steel-plate",20}):
    ifAddIngredients(mods["bobplates"],{"omnicium-steel-gear-box",20}):
    ifAddIngredients(not mods["bobplates"],{"omnicium-iron-gear-box",20}):
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
                shift = util.by_pixel(15.0, 0.0),
                hr_version = {
                    filename = "__omnimatter_energy__/graphics/entity/buildings/hr-electric-omni-furnace.png",
                    priority = "high",
                    width = 239,
                    height = 219,
                    frame_count = 1,
                    shift = util.by_pixel(0.75, 5.75),
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
                shift = util.by_pixel(13.5, 0),
                hr_version = {
                    filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-shadow.png",
                    priority = "high",
                    width = 227,
                    height = 171,
                    frame_count = 1,
                    draw_as_shadow = true,
                    shift = util.by_pixel(11.25, 7.75),
                    scale = 0.5
                }
            },
        },
        }):
    extend()