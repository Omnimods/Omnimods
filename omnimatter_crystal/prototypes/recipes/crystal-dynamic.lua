data:extend({
{
    type = "recipe",
    name = "hydrolization-omnic-acid",
    icon = "__omnimatter_crystal__/graphics/icons/hydromnic-acid.png",
    subgroup = "omni-mutator-items",
    order = "g[hydromnic-acid]",
    category = "chemistry",
	energy_required = 1,
    enabled = "true",
    ingredients =
    {
      {type = "fluid", name = "omnic-acid", amount = 300},
    },
    results =
    {
      {type = "fluid", name = "hydromnic-acid", amount = 200},
    },
  },
})
