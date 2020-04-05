data:extend({
{
    type = "item",
    name = "omni-shoes-1",
    icon = "__omnimatter_logistics__/graphics/icons/omni-shoes-1.png",
    placed_as_equipment_result = "omni-shoes-1",
    flags = {},
    order = "a[angels-burner-generator-vequip]",
    icon_size = 32,
    stack_size = 10,
    default_request_amount = 10
  },
  {
    type = "movement-bonus-equipment",
    name = "omni-shoes-1",
    sprite =
    {
      filename = "__omnimatter_logistics__/graphics/equipment/omni-shoes-1.png",
      width = 64,
      height = 30,
      priority = "medium"
    },
    shape =
    {
      width = 2,
      height = 1,
      type = "full"
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_consumption = "400kW",
    movement_bonus = 0.1,
    categories = {"omni-armour"}
  },
 })