BuildGen:import("burner-omni-furnace"):
    setLocName("entity-name.omni-furnace-1"):
    addIconLevel(1):
    setOrder("a[omni-furnace-1]"):
    setFuelCategories("omnite"):
    setNextUpgrade("omni-furnace-2"):
    setReplace("furnace"):
    extend()

RecGen:import("burner-omni-furnace"):
    setLocName("entity-name.omni-furnace-1"):
    addIconLevel(1):
    setOrder("a[omni-furnace-1]"):
    extend()

ItemGen:import("burner-omni-furnace"):
    setLocName("entity-name.omni-furnace-1"):
    addIconLevel(1):
    setOrder("a[omni-furnace-1]"):
    extend()

BuildGen:import("burner-omni-furnace"):
    setName("omni-furnace-2","omnimatter_energy"):
    addIconLevel(2):
    setSpeed(2.0):
    setEmissions(4.0):
    setOrder("a[omni-furnace-2]"):
    setFuelCategories("chemical"):
    setIngredients({"burner-omni-furnace",1},{"omnium-plate",15},{"iron-plate",20},{"omnium-iron-gear-box",20}):
    setEnabled(false):
    setTechName("advanced-material-processing"):
    setReplace("furnace"):
    extend()

BuildGen:import("electric-furnace"):
    setName("omni-furnace-3","omnimatter_energy"):
    setAssembler():
    setIcons({{icon = "__omnimatter_energy__/graphics/icons/electric-omni-furnace.png", icon_size = 64}}):
    addIconLevel(3):
    setSpeed(3.0):
    setUsage(160):
    setEmissions(1.0):
    setStacksize(50):
    setInventory(255):
    setSubgroup("omni-buildings"):
    setOrder("a[omni-furnace-3]"):
    setCrafting("smelting","omnifurnace"):
    setIngredients({"omni-furnace-2",1},{"omnium-steel-alloy",15},{"steel-plate",20}):
    ifAddIngredients(mods["bobplates"],{"omnium-steel-gear-box",20}):
    ifAddIngredients(not mods["bobplates"],{"omnium-iron-gear-box",20}):
    setEnabled(false):
    setTechName("advanced-material-processing-2"):
    setReplace("furnace"):
    setGraphics({
        animation = {
            layers = {
                {
                    filename = "__omnimatter_energy__/graphics/entity/buildings/electric-omni-furnace.png",
                    priority = "high",
                    width = 239,
                    height = 219,
                    frame_count = 1,
                },
                {
                    filename = "__base__/graphics/entity/electric-furnace/electric-furnace-shadow.png",
                    priority = "high",
                    width = 227,
                    height = 171,
                    frame_count = 1,
                    draw_as_shadow = true,
                    shift = util.by_pixel(13.5, 0),
                }
            }
        }
    }):
    extend()