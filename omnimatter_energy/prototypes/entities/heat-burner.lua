BuildGen:create("omnimatter_energy", "omni-heat-burner"):
    setType("burner-generator"):
    setSize(5, 3):
    setIcons("omnium-turbine","omnimatter_energy"):
    setIngredients({{"anbaric-omnitor",4},{"burner-omni-furnace",1},{"iron-gear-wheel",4},{"omnicium-plate",2}}):
    setReplace("heat-burner"):
    setSubgroup("omnienergy-power"):
    setStacksize(20):
    setOrder("aa"):
    setTechName("omnitech-anbaricity"):
    setAnimation({
        north = {
            layers = {
                {
                    filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-turbine-h.png",
                    frame_count = 36,
                    height = 160,
                    line_length = 6,
                    run_mode = "backward",
                    shift = {
                    0,
                    -0.078125
                    },
                    width = 224
                },
                {
                    draw_as_shadow = true,
                    filename = "__base__/graphics/entity/steam-turbine/steam-turbine-H-shadow.png",
                    frame_count = 1,
                    height = 74,
                    line_length = 1,
                    repeat_count = 36,
                    run_mode = "backward",
                    shift = {
                    0.8984375,
                    0.5625
                    },
                    width = 217
                }
            }
        },
        east =
        {
            layers = {
                {
                    filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-turbine-v.png",
                    frame_count = 36,
                    height = 224,
                    line_length = 6,
                    run_mode = "backward",
                    shift = {
                    -0.07,
                    0.25
                    },
                    scale = 0.92,
                    width = 160
                },
                {
                    draw_as_shadow = true,
                    filename = "__base__/graphics/entity/steam-turbine/steam-turbine-V-shadow.png",
                    frame_count = 1,
                    height = 131,
                    line_length = 1,
                    repeat_count = 36,
                    run_mode = "backward",
                    shift = {
                        1.234375,
                        0.765625
                        },
                    width = 151
                }
            }
        }}):
    extend()


--Set special attributes that we dont have in our lib
local turbine = data.raw["burner-generator"]["omni-heat-burner"]
turbine.max_power_output = "1MW"
turbine.energy_source = {
    type = "electric",
    usage_priority = "primary-output",
}
turbine.burner = {
    type = "burner",
    fuel_categories = {"omnite", "chemical"},
    effectivity = 0.75,
    fuel_inventory_size = 3,
    emissions_per_minute = 40,
    light_flicker =
    {
        minimum_light_size = 1,
        light_intensity_to_size_coefficient = 0.35,
        color = {r = 0.63, g = 0.03, b = 0.52},
        minimum_intensity = 0.05,
        maximum_intensity = 0.3
    },
    smoke =
    {
        {
            name = "smoke",
            north_position = util.by_pixel(5, -80),
            south_position = util.by_pixel(5, -80),
            east_position = util.by_pixel(5, -80),
            west_position = util.by_pixel(5, -80),
            frequency = 35,
            starting_vertical_speed = 0.0,
            starting_frame_deviation = 60,
            deviation = {-1, 1},
        }
    }
}
turbine.working_sound = {
    sound =
    {
        filename = "__base__/sound/furnace.ogg",
        volume = 1.6
    },
    max_sounds_per_type = 3
}
turbine.min_perceived_performance = 0.25
turbine.performance_to_sound_speedup = 0.5