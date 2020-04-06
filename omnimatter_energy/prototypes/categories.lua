data:extend({
    {
        type = "fuel-category",
        name = "omni-electro"
    },
    {
        type = "fuel-category",
        name = "omnite"
    },
    {
      type = "fuel-category",
      name = "omni-0"
  },
	{
    type = "item-group",
    name = "omnienergy",
    order = "z",
    inventory_order = "z",
    icon = "__omnimatter_energy__/graphics/technology/omnicell.png",
	icon_size = 128,
  },
  {
    type = "item-subgroup",
    name = "omnienergy-intermediates",
	  group = "intermediate-products",
	  order = "a",
  },
  {
    type = "item-subgroup",
    name = "omnicell",
	group = "omnienergy",
	order = "a",
  },
  {
    type = "item-subgroup",
    name = "zolar-panel",
	group = "omnienergy",
	order = "a",
  },
  {
    type = "item-subgroup",
    name = "electro-components",
	group = "omnienergy",
	order = "a",
  },
  {
    type = "item-subgroup",
    name = "hydromnide",
	group = "omnienergy",
	order = "c",
  },
  {
    type = "item-subgroup",
    name = "omnielectrobuildings",
	group = "omnienergy",
	order = "d",
  },
})