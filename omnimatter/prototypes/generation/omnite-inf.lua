local resource_autoplace = require("resource-autoplace")

-- Initialize the core patch sets in a predictable order
resource_autoplace.initialize_patch_set("infinite-omnite", false)

local mine={}
if settings.startup["omnimatter-infinite-omnic-acid"].value then
    mine = {
        mining_particle = "omnite-particle",
        mining_time = 1,
        fluid_amount = 10,
        required_fluid = "omnic-acid",
        results = {
            {
                type = "item",
                name = "omnite",
                amount_min = 1,
                amount_max = 1
            }
        }
    }
else
    mine = {
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
    }
end

data:extend({
    {
        type = "autoplace-control",
        name = "infinite-omnite",
        localised_name = {"", "[entity=omnite] ", {"entity-name.infinite-omnite"}},
        richness = true,
        order = "a-b-infinite-omnite",
        category = "resource"
    },
    {
        type = "resource",
        name = "infinite-omnite",
        icon = "__omnimatter__/graphics/icons/omnite.png",
        icon_size = 64,
        flags = {"placeable-neutral"},
        tree_removal_probability = 0.8,
        tree_removal_max_distance = 32 * 32,
        infinite_depletion_amount = 10,
        resource_patch_search_radius = 10,
        order="a-b-infinite-omnite",
        infinite=true,
        minimum = 375,
        normal = 1500,
        minable = mine,
        collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
        selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
        autoplace = resource_autoplace.resource_autoplace_settings({
            has_starting_area_placement = false,
            name ="infinite-omnite",
            patch_set_name = "infinite-omnite",
            autoplace_control_name = "infinite-omnite",
            order = "b-aa",
            base_density = 25, -- ~ richness
            base_spots_per_km2 = 7, --base spots of of normal omnite is 10, if this is the same roughly every patch has infinite omnite
            regular_rq_factor_multiplier = 0.4,
            starting_rq_factor_multiplier = 0.5,
            richness_multiplier_distance_bonus = 20,
            peaks = {
                {
                    noise_layer = "omnite",
                    noise_octaves_difference = -1.5,
                    noise_persistence = 0.3,
                },
            },
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
        effect_darkness_multiplier = 8.0,
        min_effect_alpha = 0.1,
        max_effect_alpha = 0.1,
        map_color = {r=0.22, g=0.00, b=0.255}
    }
})

--Add infinite omnite to nauvis autoplace control
data.raw.planet["nauvis"]["map_gen_settings"]["autoplace_controls"]["infinite-omnite"] = {}
data.raw.planet["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["infinite-omnite"] = {}

omni.matter.apply_presets("infinite-omnite")