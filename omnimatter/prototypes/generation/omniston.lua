data:extend(
{
  {
    type = "noise-layer",
    name = "omniston"
  },
  {
    type = "autoplace-control",
    name = "omniston",
    richness = true,
    order = "b-e"
  },
  {
    type = "resource",
    name = "omniston",
    icon = "__omnimatter__/graphics/icons/liquid-omniston.png",
    icon_size = 32,
    flags = {"placeable-neutral"},
    category = "basic-fluid",
    --category = "angels-natural-gas",
    order="a-b-a",
    infinite = true,
    minimum = 2500,
    normal =10000,
    minable =
    {
      hardness = 1,
      mining_time = 1,
      results =
      {
        {
          type = "fluid",
          name = "omniston",
          amount_min = 2,
          amount_max = 2,
          probability = 1
        },
      }
    },
    collision_box = {{ -1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
    autoplace =
    {
      control = "omniston",
      sharpness = 0.99,
      max_probability = 0.04,
      richness_base = 6000,
      richness_multiplier = 30000,
      richness_multiplier_distance_bonus = 10,
      coverage = 0.01,
      peaks =
      {
        {
          noise_layer = "omniston",
          noise_octaves_difference = -2,
          noise_persistence = 0.4,
        }
      }
    },
    stage_counts = {0},
    stages =
    {
      sheet =
      {
        filename = "__omnimatter__/graphics/entity/patches/gas.png",
		tint = {r = 0.00, g = 0.75, b = 0.67},
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 4,
        variation_count = 1
      }
    },
    map_color = {r = 0.00, g = 0.75, b = 0.67},
    map_grid = false
  }
})