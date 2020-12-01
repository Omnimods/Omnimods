if settings.startup["omnimatter-infinite"].value then
    local mine={}
    if settings.startup["omnimatter-infinite-omnic-acid"].value then
        mine = {
            hardness = 1,
            mining_particle = "omnite-particle",
            mining_time = 1.0,
            result = "omnite",
            fluid_amount = 10,
            required_fluid = "omnic-acid"
        }
    else
        mine = {
            hardness = 1,
            mining_particle = "omnite-particle",
            mining_time = 1.0,
            result = "omnite"
        }
    end

    data:extend({
        {
            type = "autoplace-control",
            name = "infinite-omnite",
            richness = true,
            order = "b-e",
            category = "resource",
        },
        {
            type = "noise-layer",
            name = "infinite-omnite"
        },
        {
            type = "resource",
            name = "infinite-omnite",
            icon = "__omnimatter__/graphics/icons/omnite.png",
            icon_size = 32,
            flags = {"placeable-neutral"},
            order="a-b-a",
            --map_color = {r=0.34, g=0.00, b=0.51},
            map_color = {r=0.22, g=0.00, b=0.255},
            infinite=true,
            minimum=375,
            normal=1500,
            maximum=6000,
            minable = mine,
            collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
            selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
            autoplace ={
                control = "infinite-omnite",
                sharpness = 1,
                richness_multiplier = 5000,
                richness_multiplier_distance_bonus = 20,
                richness_base = 2000,
                coverage = 0.01,
                peaks = {
                    {
                        noise_layer = "infinite-omnite",
                        noise_octaves_difference = -2.5,
                        noise_persistence = 0.3,
                        starting_area_weight_optimal = 0,
                        starting_area_weight_range = 0,
                        starting_area_weight_max_range = 2,
                    },
                    {
                        noise_layer = "infinite-omnite",
                        noise_octaves_difference = -2,
                        noise_persistence = 0.3,
                        starting_area_weight_optimal = 1,
                        starting_area_weight_range = 0,
                        starting_area_weight_max_range = 2,
                    },
                    {
                        influence = 0.15,
                        starting_area_weight_optimal = 0,
                        starting_area_weight_range = 0,
                        starting_area_weight_max_range = 2,
                    }
                }
            },
            stage_counts = {1000, 600, 400, 200, 100, 50, 20, 1},
            stages = {
                sheet = {
                    filename = "__omnimatter__/graphics/entity/ores/omnite.png",
                    priority = "extra-high",
                    width = 64,
                    height = 64,
                    frame_count = 8,
                    variation_count = 8,
                    hr_version = {
                        filename = "__omnimatter__/graphics/entity/ores/hr-omnite.png",
                        priority = "extra-high",
                        width = 128,
                        height = 128,
                        frame_count = 8,
                        variation_count = 8,
                        scale = 0.5
                    }
                }
            },
            stages_effect = {
                sheet = {
                    filename = "__omnimatter__/graphics/entity/ores/omnite-glow.png",
                    priority = "extra-high",
                    width = 64,
                    height = 64,
                    frame_count = 8,
                    variation_count = 8,
                    blend_mode = "additive",
                    flags = {"light"},
                    hr_version = {
                        filename = "__omnimatter__/graphics/entity/ores/hr-omnite-glow.png",
                        priority = "extra-high",
                        width = 128,
                        height = 128,
                        frame_count = 8,
                        variation_count = 8,
                        scale = 0.5,
                        blend_mode = "additive",
                        flags = {"light"},
                    }
                }
            }
        }
    })
end