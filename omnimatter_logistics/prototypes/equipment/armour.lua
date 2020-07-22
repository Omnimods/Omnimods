data:extend({
{
    type = "armor",
    name = "primitive-armour",
    icons ={{icon= "__omnimatter_logistics__/graphics/icons/primitive-armor.png", icon_size = 32}},
    icon_size=32,
    flags = {},
    resistances =
    {
    },
    durability = 1000,
    subgroup = "armor",
    order = "c[modular-armor]",
    stack_size = 1,
    equipment_grid = "primitive-equipment-grid",
    inventory_size_bonus = 0
  },
  --[[{
	type = "item",
	name = "battery-steam",
	icon = "__omnimatter_logistics__/graphics/icons/battery-steam.png",
    icon_size = 32,
	placed_as_equipment_result = "battery-steam",
	flags = {},
	order = "a[angels-burner-generator-vequip]",
	stack_size = 10,
	default_request_amount = 10
  },
  {
    type = "recipe",
    name = "battery-steam",
    icon_size = 32,
    enabled = false,
    energy_required = 10,
    ingredients ={
      {"boiler", 1},
      {"storage-tank", 2},
	},
    results=
    {
      {type="item", name="battery-steam", amount=1},
    },
    },
  {
    type = "battery-equipment",
    name = "battery-steam",
    sprite = 
    {
      filename = "__bobwarfare__/graphics/equipment/battery-mk3-equipment.png",
      width = 32,
      height = 64,
      priority = "medium"
    },
    shape =
    {
      width = 1,
      height = 2,
      type = "full"
    },
    energy_source =
    {
      type = "electric",
      buffer_capacity = "1MJ",
      input_flow_limit = "120kW",
      output_flow_limit = "1.2MW",
      usage_priority = "terciary"
    },
    categories = {"omni-armour"}
  }]]
})