local function boiler_images(tier)
    local boilername = "boiler"
    if tier and type(tier) == "number" and tier > 1 and tier < 6 then
        boilername = "boiler_"..tier
    end
    return {
        animation = make_4way_animation_from_spritesheet({
        layers = {
            {
                filename = "__omnimatter_fluid__/graphics/"..boilername.."/boiler-off.png",
                width = 160,
                height = 160,
                frame_count = 1,
                shift = util.by_pixel(-5, -4.5),
                },
            }
        }),
        working_visualisations =
        {
            {
            north_position = util.by_pixel(35, -23),-- 30,-24
            west_position = util.by_pixel(1, -49.5), -- 1, -49.5
            south_position = util.by_pixel(-35, -48), -- -30, -48
            east_position = util.by_pixel(-11, -1),-- -11, -1
            apply_recipe_tint = "primary",
            {
                apply_recipe_tint = "tertiary",
                north_position = {0, 0},
                west_position = {0, 0},
                south_position = {0, 0},
                east_position = {0, 0},
                north_animation =
                {
                    filename = "__omnimatter_fluid__/graphics/"..boilername.."/boiler-north-off.png",
                    frame_count = 1,
                    width = 160,
                    height = 160,
                },
                east_animation =
                {
                    filename = "__omnimatter_fluid__/graphics/"..boilername.."/boiler-east-off.png",
                    frame_count = 1,
                    width = 160,
                    height = 160,
                },
                west_animation =
                {
                    filename = "__omnimatter_fluid__/graphics/"..boilername.."/boiler-west-off.png",
                    frame_count = 1,
                    width = 160,
                    height = 160,
                },
                south_animation =
                {
                    filename = "__omnimatter_fluid__/graphics/"..boilername.."/boiler-south-off.png",
                    frame_count = 1,
                    width = 160,
                    height = 160,
                }
            }
        }
    },
    }
end
omni.fluid.exchanger_images =    {
    animation = make_4way_animation_from_spritesheet({
    layers = {
        {
            filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-off.png",
            width = 160,
            height = 160,
            frame_count = 1,
            shift = util.by_pixel(-5, -4.5),
            },
        }
    }),
    working_visualisations =
    {
        {
        --north_position = util.by_pixel(-16, -16),
        --west_position = util.by_pixel(1, -49.5),
        --south_position = util.by_pixel(-30, -48),
        --east_position = util.by_pixel(-11, -1),
        apply_recipe_tint = "primary",
        {
            apply_recipe_tint = "tertiary",
            north_position = {0, 0},
            west_position = {0, 0},
            south_position = {0, 0},
            east_position = {0, 0},
            north_animation =
            {
                filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-south-off.png",
                frame_count = 1,
                width = 160,
                height = 160,
            },
            east_animation =
            {
                filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-west-off.png",
                frame_count = 1,
                width = 160,
                height = 160,
            },
            west_animation =
            {
                filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-east-off.png",
                frame_count = 1,
                width = 160,
                height = 160,
            },
            south_animation =
            {
                filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-north-off.png",
                frame_count = 1,
                width = 160,
                height = 160,
            }
        }
    }
},
}
omni.fluid.heat_pipe_images = {
    connections =
    {
        {
            position = {0, 1},
            direction = defines.direction.south
        }
    },
    pipe_covers =
        make_4way_animation_from_spritesheet(
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-endings.png",
            width = 64,
            height = 64,
            direction_count = 4,
        }),
    heat_pipe_covers =
        make_4way_animation_from_spritesheet(
        apply_heat_pipe_glow{
            filename = "__base__/graphics/entity/heat-exchanger/heatex-endings-heated.png",
            width = 64,
            height = 64,
            direction_count = 4,
        }),
    heat_picture =
    {
        north = apply_heat_pipe_glow
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-N-heated.png",
            priority = "extra-high",
            width = 44,
            height = 6,
            shift = util.by_pixel(-1, 16),
        },
        east = apply_heat_pipe_glow
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-E-heated.png",
            priority = "extra-high",
            width = 80,
            height = 80,
            shift = util.by_pixel(-36, -20),
        },
        south = apply_heat_pipe_glow
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-S-heated.png",
            priority = "extra-high",
            width = 28,
            height = 40,
            shift = util.by_pixel(-1, -55),
        },
        west = apply_heat_pipe_glow
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-W-heated.png",
            priority = "extra-high",
            width = 64,
            height = 76,
            shift = util.by_pixel(40, -21),
        }
    },
    heat_glow =
    {
        north = apply_heat_pipe_glow
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-N-heated.png",
            priority = "extra-high",
            width = 44,
            height = 96,
            shift = util.by_pixel(-1, 8*2),
        },
        east = apply_heat_pipe_glow
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-E-heated.png",
            priority = "extra-high",
            width = 80,
            height = 80,
            shift = util.by_pixel(-21, -13*2),
        },
        south = apply_heat_pipe_glow
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-S-heated.png",
            priority = "extra-high",
            width = 28,
            height = 40,
            shift = util.by_pixel(-1, -30*2),
        },
        west = apply_heat_pipe_glow
        {
            filename = "__base__/graphics/entity/heat-exchanger/heatex-W-heated.png",
            priority = "extra-high",
            width = 64,
            height = 76,
            shift = util.by_pixel(23, -13*2),
        }
    }
}

return boiler_images