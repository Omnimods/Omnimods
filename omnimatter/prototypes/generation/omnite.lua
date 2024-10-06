--Create omnite item
ItemGen:create("omnimatter","omnite"):
    setFuelValue(2):
    setStacksize(500):
    setIcons({{icon = "omnite",icon_size = 64}}, "omnimatter"):
    setItemPictures({
        {
            filename = "__omnimatter__/graphics/icons/omnite.png",
            scale = 0.25,
            size = 64
        },
        {
            filename = "__omnimatter__/graphics/icons/omnite-1.png",
            scale = 0.25,
            size = 64
        },
        {
            filename = "__omnimatter__/graphics/icons/omnite-2.png",
            scale = 0.25,
            size = 64
        },
        {
            filename = "__omnimatter__/graphics/icons/omnite-3.png",
            scale = 0.25,
            size = 64
        }
    }):
    extend()


local resource_autoplace = require("resource-autoplace")

-- Initialize the core patch sets in a predictable order
resource_autoplace.initialize_patch_set("omnite", true)

data:extend(
{
    {
        type = "optimized-particle",
        name = "omnite-particle",
        --flags = {"not-on-map"},
        life_time = 180,
        pictures =
        {
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-1.png",
                priority = "extra-high",
                tint = {r=0.21, g=0.25, b=0.24},
                width = 5,
                height = 5,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-2.png",
                priority = "extra-high",
                tint = {r=0.55, g=0.51, b=0.30},
                width = 7,
                height = 5,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-3.png",
                priority = "extra-high",
                tint = {r=0.54, g=0.55, b=0.62},
                width = 6,
                height = 7,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-4.png",
                priority = "extra-high",
                tint = {r=0.75, g=0.75, b=0.75},
                width = 9,
                height = 8,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-5.png",
                priority = "extra-high",
                tint = {r=0.68, g=0.18, b=0.16},
                width = 5,
                height = 5,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-6.png",
                priority = "extra-high",
                tint = {r = 0.75, g = 0.5, b = 0.25},
                width = 6,
                height = 4,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-7.png",
                priority = "extra-high",
                tint = {r=0.21, g=0.80, b=0.24},
                width = 7,
                height = 8,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-8.png",
                priority = "extra-high",
                tint = {r=0.21, g=0.25, b=0.24},
                width = 6,
                height = 5,
                frame_count = 1
            }
        },
        shadows =
        {
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-shadow-1.png",
                priority = "extra-high",
                width = 5,
                height = 5,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-shadow-2.png",
                priority = "extra-high",
                width = 7,
                height = 5,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-shadow-3.png",
                priority = "extra-high",
                width = 6,
                height = 7,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-shadow-4.png",
                priority = "extra-high",
                width = 9,
                height = 8,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-shadow-5.png",
                priority = "extra-high",
                width = 5,
                height = 5,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-shadow-6.png",
                priority = "extra-high",
                width = 6,
                height = 4,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-shadow-7.png",
                priority = "extra-high",
                width = 7,
                height = 8,
                frame_count = 1
            },
            {
                filename = "__omnimatter__/graphics/entity/ores-particle/ore-particle-shadow-8.png",
                priority = "extra-high",
                width = 6,
                height = 5,
                frame_count = 1
            }
        }
    }
}
)
data:extend({
    {
        type = "autoplace-control",
        name = "omnite",
        localised_name = {"", "[entity=omnite] ", {"entity-name.omnite"}},
        richness = true,
        category = "resource",
        order = "b-a"
    },
    -- {
    --     type = "noise-layer",
    --     name = "omnite"
    -- },
    {
        type = "resource",
        name = "omnite",
        icon = "__omnimatter__/graphics/icons/omnite.png",
        icon_size = 64,
        flags = {"placeable-neutral"},
        tree_removal_probability = 0.8,
        tree_removal_max_distance = 32 * 32,
        infinite_depletion_amount = 10,
        resource_patch_search_radius = 10,
        order="b-a",
        infinite = false,
        minable = {
            mining_particle = "omnite-particle",
            mining_time = 1,
            results = {
                {
                type = "item",
                name = "omnite",
                amount_min = 1,
                amount_max = 1
                }
            }
        },
        collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
        selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
        autoplace = resource_autoplace.resource_autoplace_settings({
            name = "omnite",
            patch_set_name = "omnite",
            autoplace_control_name = "omnite",
            order = "b-aa",
            has_starting_area_placement = true,
            base_density = 35,    -- ~richness
            base_spots_per_km2 = 10, -- ~frequency
            regular_rq_factor_multiplier = 1.8, --Size
            starting_rq_factor_multiplier = 2.4,
            richness_multiplier_distance_bonus = 20,
            base_spots_per_km2 = 10, -- ~frequency
            -- peaks = {
            -- {
            --     noise_layer = "omnite",
            --     noise_octaves_difference = -1.5,
            --     noise_persistence = 0.3,
            -- },
            -- },
        }),
        stage_counts = {1000, 600, 400, 200, 100, 50, 20, 1},
        stages = {
        sheet = {
            filename = "__omnimatter__/graphics/entity/ores/omnite.png",
            priority = "extra-high",
            width = 128,
            height = 128,
            frame_count = 8,
            variation_count = 8,
        }
        },
        stages_effect = {
        sheet = {
            filename = "__omnimatter__/graphics/entity/ores/omnite-glow.png",
            priority = "extra-high",
            width = 128,
            height = 128,
            frame_count = 8,
            variation_count = 8,
            blend_mode = "additive",
            flags = {"light"},
        }
        },
        effect_animation_period = 5,
        effect_animation_period_deviation = 1,
        effect_darkness_multiplier = 4.6,
        min_effect_alpha = 0.3,
        max_effect_alpha = 0.5,
        map_color = {r=0.34, g=0.00, b=0.51}
    }
})

--Add omnite to nauvis autoplace control
data.raw.planet["nauvis"]["map_gen_settings"]["autoplace_controls"]["omnite"] = {}


--Apply preset configs to omnite and infinite omnite if it exists
function omni.matter.apply_presets(resource)
    local presets = {
        ["rich-resources"] = {richness = "very-good"},
        ["rail-world"] = {frequency = 0.33333333333, size = 3},
        ["ribbon-world"] = {frequency = 3, size = 0.5, richness = 2}
    }

    for preset, conf in pairs(presets) do
        local set = data.raw["map-gen-presets"]["default"][preset]
        if set and set.basic_settings and set.basic_settings.autoplace_controls then
            set.basic_settings.autoplace_controls[resource] = conf
        end
    end
end

omni.matter.apply_presets("omnite")