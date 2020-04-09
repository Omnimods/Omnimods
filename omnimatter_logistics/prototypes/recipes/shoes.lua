data:extend({
   {
    type = "item-subgroup",
    name = "shoes",
	group = "omnilogistics",
	order = "aa",
  },
{
    type = "recipe",
    name = "omni-shoes-1",
    icon = "__omnimatter_logistics__/graphics/icons/omni-shoes-1.png",
    icon_size = 32,
    subgroup = "shoes",
    order = "g[hydromnic-acid]",
	energy_required = 2,
    enabled = false,
    ingredients =
    {
      {type = "item", name = "iron-plate", amount = 12},
      {type = "item", name = "electronic-circuit", amount = 5},
      {type = "item", name = "copper-cable", amount = 30},
    },
    results =
    {
      {type = "item", name = "omni-shoes-1", amount = 1},
    },
  }
})