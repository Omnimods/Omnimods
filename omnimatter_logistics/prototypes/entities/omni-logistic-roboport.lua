  data:extend(
  {   
   {
    type = "item",
    name = "omni-logistic-roboport",
    icon = "__omnimatter_logistics__/graphics/icons/omni-logistic-roboport.png",
    icon_size = 32,
    flags = {},
    subgroup = "omni-logistics",
    order = "a[cargo-roboport]",
    place_result = "omni-logistic-roboport",
    stack_size = 20
  },
  {
    type = "roboport",
    name = "omni-logistic-roboport",
    icon = "__omnimatter_logistics__/graphics/icons/omni-logistic-roboport.png",
    icon_size = 32,
    flags = {"placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "omni-logistic-roboport"},
    max_health = 1000,
    corpse = "big-remnants",
    collision_box = {{-3.4, -3.4}, {3.4, 3.4}},
    selection_box = {{-3.5, -3.5}, {3.5, 3.5}},
    dying_explosion = "medium-explosion",
    energy_source =
    {
      type = "burner",
      effectivity = 0.4,
      fuel_inventory_size = 2,
      emissions = 0.01,
      smoke =
      {
        {
          name = "smoke",
          deviation = {0.1, 0.1},
          frequency = 5,
          position = {1.0, -0.8},
          starting_vertical_speed = 0.08,
          starting_frame_deviation = 60
        }
      },
      --usage_priority = "secondary-input",
      --input_flow_limit = "2MW",
      buffer_capacity = "48MJ",
    },
    recharge_minimum = "20MJ",
    energy_usage = "300kW",
    -- per one charge slot
    charging_energy = "100kW",
    logistics_radius = 6.5,
    construction_radius = 0,
    charge_approach_distance = 10,
    robot_slots_count = 7,
    material_slots_count = 7,
    stationing_offset = {-0, 0},
    charging_offsets =
    {
      {-3, -1}, {3, -1}, {1.5, 1}, {-1.5, 1}, {1.5, -3}, {-1.5, -3},
    },
    base =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport.png",
      width = 320,
      height = 320,
      shift = {0.5, -0.25}
    },
    base_patch =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport-patch.png",
      priority = "medium",
      width = 96,
      height = 96,
      frame_count = 1,
      shift = {0, -0.25}
    },
    base_animation =
    {
      filename = "__omnilib__/graphics/blank.png",
      priority = "medium",
      width = 1,
      height = 1,
      frame_count = 1,
      shift = {0, 0}
    },
    door_animation_up =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport-door-up.png",
      priority = "medium",
      width = 64,
      height = 32,
      frame_count = 16,
      shift = {0, -1}
    },
    door_animation_down =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport-door-down.png",
      priority = "medium",
      width = 64,
      height = 32,
      frame_count = 16,
      shift = {0, 0}
    },
    recharging_animation =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargoroboport-recharging.png",
      priority = "high",
      width = 74,
      height = 70,
      frame_count = 16,
      scale = 1.5,
      animation_speed = 0.5
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound = { filename = "__base__/sound/roboport-working.ogg", volume = 0.6 },
      max_sounds_per_type = 3,
      audible_distance_modifier = 0.5,
      probability = 1 / (5 * 60) -- average pause between the sound is 5 seconds
    },
    recharging_light = {intensity = 0.4, size = 10},
    request_to_open_door_timeout = 15,
    spawn_and_station_height = -0.1,
    draw_logistic_radius_visualization = true,
    draw_construction_radius_visualization = true,
    open_door_trigger_effect =
    {
      {
        type = "play-sound",
        sound = { filename = "__base__/sound/roboport-door.ogg", volume = 1.2 }
      },
    },
    close_door_trigger_effect =
    {
      {
        type = "play-sound",
        sound = { filename = "__base__/sound/roboport-door.ogg", volume = 0.75 }
      },
    },
    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {1.17188, 1.98438},
        green = {1.04688, 2.04688}
      },
      wire =
      {
        red = {0.78125, 1.375},
        green = {0.78125, 1.53125}
      }
    },
    circuit_connector_sprites = get_circuit_connector_sprites({0.59375, 1.3125}, nil, 18),
    circuit_wire_max_distance = 10,
    default_available_logistic_output_signal = {type = "virtual", name = "signal-X"},
    default_total_logistic_output_signal = {type = "virtual", name = "signal-Y"},
    default_available_construction_output_signal = {type = "virtual", name = "signal-Z"},
    default_total_construction_output_signal = {type = "virtual", name = "signal-T"},
  },
  }
  )