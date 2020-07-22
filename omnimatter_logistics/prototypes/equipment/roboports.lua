data:extend({
{
    type = "recipe",
    name = "omni-roboport-equipment",
    icons={{icon = "__omnimatter_logistics__/graphics/icons/omni-roboport-equipment.png", icon_size=32}},
    icon_size = 32,
    subgroup = "early-armours",
    order = "g[hydromnic-acid]",
	  energy_required = 10,
    enabled = false,
    ingredients =
    {
      {type = "item", name = "steel-plate", amount = 15},
      {type = "item", name = "electronic-circuit", amount = 5},
      {type = "item", name = "steam-engine", amount = 1},
    },
    results =
    {
      {type = "item", name = "omni-roboport-equipment", amount = 1},
    },
  },
  {
    type = "item",
    name = "omni-roboport-equipment",
    icon = "__omnimatter_logistics__/graphics/icons/omni-roboport-equipment.png",
    icon_size = 32,
    placed_as_equipment_result = "omni-roboport-equipment",
    flags = {},
    order = "a[angels-burner-generator-vequip]",
    stack_size = 10,
    default_request_amount = 10
  },
  {
    type = "roboport-equipment",
    name = "omni-roboport-equipment",
    take_result = "omni-roboport-equipment",
    icon_size = 32,
    sprite =
    {
      filename = "__omnimatter_logistics__/graphics/equipment/omni-roboport-equipment.png",
      width = 64,
      height = 64,
      priority = "medium"
    },
    shape =
    {
      width = 2,
      height = 2,
      type = "full"
    },
    energy_source =
    {
      type = "electric",
      buffer_capacity = "10MJ",
      input_flow_limit = "1500KW",
      usage_priority = "secondary-input"
    },
    charging_energy = "1000kW",

    robot_limit = 5,
    construction_radius = 10,
    spawn_and_station_height = 0.4,
    charge_approach_distance = 2.6,

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
    recharging_light = {intensity = 0.4, size = 5},
    stationing_offset = {0, -0.6},
    charging_station_shift = {0, 0.5},
    charging_station_count = 1,
    charging_distance = 1.6,
    charging_threshold_distance = 5,
    categories = {"omni-armour"}
  },
 })