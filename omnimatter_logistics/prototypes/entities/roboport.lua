local infra = {}
infra[#infra+1]={
    type = "item-subgroup",
    name = "infrastructure",
	group = "omnilogistics",
	order = "aa",
  }
  
infra[#infra+1]={
    type = "item",
    name = "omni-roboport",
    icon = "__omnimatter_logistics__/graphics/icons/omni-roboport.png",
    icon_size = 32,
    flags = {},
    subgroup = "infrastructure",
    order = "b[angels-relay-station]",
    place_result = "omni-roboport",
    stack_size = 50
    }
infra[#infra+1]={
    type = "recipe",
    name = "omni-roboport",
    enabled = false,
	icon_size = 32,
    energy_required = 5,
    ingredients ={
      {"steel-plate", 20},
      {"stone-brick", 10},
      {"iron-gear-wheel", 20},
      {"electronic-circuit", 20}
	},
    results=
    {
      {type="item", name="omni-roboport", amount=1},
    },
    }
infra[#infra+1]={
    type = "roboport",
    name = "omni-roboport",
    icon = "__omnimatter_logistics__/graphics/icons/omni-roboport.png",
    flags = {"placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "omni-roboport"},
    max_health = 500,
	icon_size = 32,
    corpse = "big-remnants",
    collision_box = {{-1.7, -1.7}, {1.7, 1.7}},
    selection_box = {{-2, -2}, {2, 2}},
    resistances =
    {
      {
        type = "fire",
        percent = 60
      },
      {
        type = "impact",
        percent = 30
      }
    },
    dying_explosion = "medium-explosion",
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      input_flow_limit = "2MW",
      buffer_capacity = "20MJ"
    },
    recharge_minimum = "1MJ",
    energy_usage = "500kW",
    -- per one charge slot
    charging_energy = "1.5MW",
    logistics_radius = 5,
    construction_radius = 15,
    charge_approach_distance = 5,
    robot_slots_count = 7,
    material_slots_count = 7,
    stationing_offset = {0, 0},
    charging_offsets =
    {
      {-1.5, -0.5}, {1.5, -0.5}, {1.5, 1.5}, {-1.5, 1.5},
    },
    base =
    {
      filename = "__omnimatter_logistics__/graphics/entity/omni-roboport-base.png",
      width = 143,
      height = 135,
      shift = {0.5, 0.25}
    },
    base_patch =
    {
      filename = "__omnimatter_logistics__/graphics/entity/omni-roboport-base-patch.png",
      priority = "medium",
      width = 69,
      height = 50,
      frame_count = 1,
      shift = {0.03125, 0.203125}
    },
    base_animation =
    {
      filename = "__base__/graphics/entity/roboport/roboport-base-animation.png",
      priority = "medium",
      width = 42,
      height = 31,
      frame_count = 8,
      animation_speed = 0.5,
      shift = {-0.5315, -1.9375}
    },
    door_animation_up =
    {
      filename = "__base__/graphics/entity/roboport/roboport-door-up.png",
      priority = "medium",
      width = 52,
      height = 20,
      frame_count = 16,
      shift = {0.015625, -0.890625}
    },
    door_animation_down =
    {
      filename = "__base__/graphics/entity/roboport/roboport-door-down.png",
      priority = "medium",
      width = 52,
      height = 22,
      frame_count = 16,
      shift = {0.015625, -0.234375}
    },
    recharging_animation =
    {
      filename = "__base__/graphics/entity/roboport/roboport-recharging.png",
      priority = "high",
      width = 37,
      height = 35,
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
    recharging_light = {intensity = 0.4, size = 5, color = {r = 1.0, g = 1.0, b = 1.0}},
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
    --circuit_connector_sprites = get_circuit_connector_sprites({0.59375, 1.3125}, nil, 18),
    circuit_wire_max_distance = 9,
    default_available_logistic_output_signal = {type = "virtual", name = "signal-X"},
    default_total_logistic_output_signal = {type = "virtual", name = "signal-Y"},
    default_available_construction_output_signal = {type = "virtual", name = "signal-Z"},
    default_total_construction_output_signal = {type = "virtual", name = "signal-T"},
  }
  
  
infra[#infra+1]={
    type = "item",
    name = "omni-zone-expander",
    icon_size = 32,
    icon = "__omnimatter_logistics__/graphics/icons/omni-zone-expander.png",
    flags = {},
    subgroup = "infrastructure",
    order = "b[angels-relay-station]",
    place_result = "omni-zone-expander",
    stack_size = 50
    }
infra[#infra+1]={
    type = "recipe",
    name = "omni-zone-expander",
    enabled = false,
	icon_size = 32,
    energy_required = 5,
    ingredients ={
	  {"iron-plate", 5},
      {"electronic-circuit", 2},
	  {"steel-plate", 5},
	},
    results=
    {
      {type="item", name="omni-zone-expander", amount=1},
    },
    }
infra[#infra+1]={
    type = "roboport",
    name = "omni-zone-expander",
    icon = "__omnimatter_logistics__/graphics/icons/omni-zone-expander.png",
	icon_size = 32,
    flags = {"placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "omni-zone-expander"},
    fast_replaceable_group = "roboport",
    max_health = 500,
    corpse = "small-remnants",
	--collision_mask = {"ghost-layer"},
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    dying_explosion = "medium-explosion",
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      input_flow_limit = "500kW",
      buffer_capacity = "1MW"
    },
	charging_energy = "0kW",
	recharge_minimum = "0MJ",
	energy_usage = "100kW",
    logistics_radius = 10,
    construction_radius = 0,
	charge_approach_distance = 0,
    robot_slots_count = 0,
    material_slots_count = 0,
    -- stationing_offset = {0, 0},
    -- charging_offsets = {{0, 0}},
    base =
    {
      filename = "__omnimatter_logistics__/graphics/entity/zone-expander/zone-expander-base.png",
      width = 128,
      height = 224,
      shift = {0.25, -1},
	  scale = 0.5,
    },
	base_animation =
    {
      filename = "__omnimatter_logistics__/graphics/entity/zone-expander/zone-expander.png",
      priority = "medium",
      width = 128,
      height = 224,
      frame_count = 16,
	  line_length = 4,
      shift = {0.25, -1},
	  scale = 0.5,
	  animation_speed = 0.5
    },
	base_patch =
	{
      filename = "__omnilib__/graphics/blank.png",
      width = 1,
      height = 1,
      frame_count = 1,
    },
	door_animation =
    {
      filename = "__omnilib__/graphics/blank.png",
      width = 1,
      height = 1,
      frame_count = 1,
    },
    door_animation_up =
    {
      filename = "__omnilib__/graphics/blank.png",
      width = 1,
      height = 1,
      frame_count = 1,
    },
    door_animation_down =
    {
      filename = "__omnilib__/graphics/blank.png",
      width = 1,
      height = 1,
      frame_count = 1,
    },
    recharging_animation =
    {
      filename = "__omnilib__/graphics/blank.png",
      width = 1,
      height = 1,
      frame_count = 1,
    },
	recharging_light = {intensity = 0, size = 0},
    request_to_open_door_timeout = 0,
    spawn_and_station_height = 0,
    draw_logistic_radius_visualization = true,
    draw_construction_radius_visualization = true,
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
    --circuit_connector_sprites = get_circuit_connector_sprites({0.59375, 1.3125}, nil, 18),
    circuit_wire_max_distance = 10,
    default_available_logistic_output_signal = {type = "virtual", name = "signal-X"},
    default_total_logistic_output_signal = {type = "virtual", name = "signal-Y"},
    default_available_construction_output_signal = {type = "virtual", name = "signal-Z"},
    default_total_construction_output_signal = {type = "virtual", name = "signal-T"},
  }
data:extend(infra)