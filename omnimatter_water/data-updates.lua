data:extend({
	{
    type = "recipe",
    name = "water-extraction",
    icon = "__base__/graphics/icons/fluid/water.png",
    icon_size = 32,
    subgroup = "omni-basic",
    order = "g[wood-extraction]",
    category = "omniphlog",
	energy_required = 5,
    enabled = false,
    ingredients =
    {
      {type = "fluid", name = "omnic-waste", amount = 200},
    },
    results =
    {
      {type = "fluid", name = "water", amount=150},
    },
  }
	})
	omni.add_omniwaste()
	omni.lib.add_unlock_recipe("omniwaste","water-extraction")
if mods["aai-industry-sp0"] then
	industry.add_tech("omniwaste")
end