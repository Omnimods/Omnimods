data:extend({
{
    type = "item-subgroup",
    name = "omni-logistics",
	group = "omnilogistics",
	order = "aa",
  },
  {
    type = "recipe",
    name = "omni-logistic-roboport",
    icon = "__omnimatter_logistics__/graphics/icons/omni-logistic-roboport.png",
    subgroup = "omni-logistics",
    order = "g[hydromnic-acid]",
	energy_required = 10,
    enabled = true,
    ingredients =
    {
      {type = "item", name = "steel-plate", amount = 20},
      {type = "item", name = "iron-gear-wheel", amount = 10},
      {type = "item", name = "electronic-circuit", amount = 30},
    },
    results =
    {
      {type="item", name="omni-logistic-roboport", amount=1},
    },
  }

})