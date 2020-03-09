data:extend(
{
  {
    type = "particle",
    name = "omnite-particle",
    flags = {"not-on-map"},
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
data:extend{
  	{
	type = "autoplace-control",
	name = "omnite",
	richness = true,
    category = "resource",
	order = "b-e"
	},
	{
	type = "noise-layer",
	name = "omnite"
	},
  {
    type = "resource",
    name = "omnite",
    icon = "__omnimatter__/graphics/icons/omnite.png",
    icon_size = 32,
    flags = {"placeable-neutral"},
    order="a-b-e",
    minable =
    {
      hardness = 0.9,
      mining_particle = "stone-particle",
      mining_time = 1,
      result = "omnite",
      --fluid_amount = 10,
      --required_fluid = "sulfuric-acid"
    },
    collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
    autoplace =
    {
      control = "omnite",
      sharpness = 1,
      richness_multiplier = 2000,
      richness_multiplier_distance_bonus = 15,
      richness_base = 1000,
      coverage = 0.03,
      peaks =
      {
        {
          noise_layer = "omnite",
          noise_octaves_difference = -1.5,
          noise_persistence = 0.3,
        },
      },
      starting_area_size = 600 * 0.01,
      starting_area_amount = 1000
    },
    stage_counts = {1000, 600, 400, 200, 100, 50, 20, 1},
    stages =
    {
      sheet =
      {
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
    stages_effect =
    {
      sheet =
      {
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
    },
    effect_animation_period = 5,
    effect_animation_period_deviation = 1,
    effect_darkness_multiplier = 3.6,
    min_effect_alpha = 0.2,
    max_effect_alpha = 0.3,
    map_color = {r=0.34, g=0.00, b=0.51},
  }

}