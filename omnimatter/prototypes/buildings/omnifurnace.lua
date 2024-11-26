local omnifurnace = BuildGen:create("omnimatter","burner-omni-furnace"):
    setBurner(1,1):
    noTech():
    setEnergy(5):
    setEmissions(2.0):
    setIngredients({ "omnicium-plate", 2},{ "omnite-brick", 8},{ "stone-furnace", 1}):
    setStacksize(50):
    setWeight(40000):
    setSubgroup("omni-buildings"):
    setSize(2):
    setCrafting("smelting","omnifurnace"):
    setUsage(45):
    setEnabled():
    setIcons({"burner-omni-furnace", 32}):
    setSoundWorking("steel-furnace"):
    setGraphics({
        animation = {
            layers = {
                {
                    filename = "__omnimatter__/graphics/entity/buildings/hr-omni-furnace.png",
                    priority = "high",
                    width = 171,
                    height = 174,
                    frame_count = 1,
                    shift = util.by_pixel(-1.25, 2),
                    scale = 0.5
                },
                {
                    filename = "__base__/graphics/entity/steel-furnace/steel-furnace-shadow.png",
                    priority = "high",
                    width = 277,
                    height = 85,
                    frame_count = 1,
                    draw_as_shadow = true,
                    shift = util.by_pixel(39.25, 11.25),
                    scale = 0.5
                },
            },
        },
        working_visualisations = {{
                {
                    north_position = {0.0, 0.0},
                    east_position = {0.0, 0.0},
                    south_position = {0.0, 0.0},
                    west_position = {0.0, 0.0},
                    animation = {
                        filename = "__base__/graphics/entity/steel-furnace/steel-furnace-fire.png",
                        priority = "high",
                        line_length = 8,
                        width = 57,
                        height = 81,
                        frame_count = 48,
                        axially_symmetrical = false,
                        direction_count = 1,
                        shift = util.by_pixel(-0.75, 5.75),
                        scale = 0.5
                    }
                },
                light = {intensity = 1, size = 1, color = {r = 1.0, g = 1.0, b = 1.0}}
            },
            {
                north_position = {0.0, 0.0},
                east_position = {0.0, 0.0},
                south_position = {0.0, 0.0},
                west_position = {0.0, 0.0},
                effect = "flicker", -- changes alpha based on energy source light intensity
                animation =
                {
                    filename = "__base__/graphics/entity/steel-furnace/steel-furnace-glow.png",
                    priority = "high",
                    width = 60,
                    height = 43,
                    frame_count = 1,
                    shift = {0.03125, 0.640625},
                    blend_mode = "additive"
                }
            },
            {
                north_position = {0.0, 0.0},
                east_position = {0.0, 0.0},
                south_position = {0.0, 0.0},
                west_position = {0.0, 0.0},
                effect = "flicker", -- changes alpha based on energy source light intensity
                animation =
                {
                    filename = "__base__/graphics/entity/steel-furnace/steel-furnace-working.png",
                    priority = "high",
                    line_length = 8,
                    width = 128,
                    height = 150,
                    frame_count = 1,
                    axially_symmetrical = false,
                    direction_count = 1,
                    shift = util.by_pixel(0, -4.25),
                    blend_mode = "additive",
                    scale = 0.5
                },
            }
        }
    }):
    setReplace("furnace")
omnifurnace.energy_source.burnt_inventory_size = 1
omnifurnace:extend()