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
	  group = "omnienergy",
	  order = "a",
  },
  {
    type = "item-subgroup",
    name = "omnienergy-components",
	group = "omnienergy",
	order = "b",
  },
  {
    type = "item-subgroup",
    name = "omnienergy-power",
	group = "omnienergy",
	order = "c",
  },
  {
    type = "item-subgroup",
    name = "omnienergy-solar",
	group = "omnienergy",
	order = "d",
  },
  {
    type = "item-subgroup",
    name = "hydromnide",
	group = "omnienergy",
	order = "e",
  },
  {
    type = "item-subgroup",
    name = "omnicell",
	group = "omnienergy",
	order = "f",
  },
  {
    type = "item-subgroup",
    name = "omnienergy-fuel",
	group = "omnienergy",
	order = "g",
  },
})