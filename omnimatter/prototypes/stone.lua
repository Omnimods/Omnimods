if not data.raw.item["stone-crushed"] then
data:extend(
{
  {
    type = "item",
    name = "stone-crushed",
    icon = "__base__/graphics/icons/stone.png",
    flags = {"goes-to-main-inventory"},
	subgroup = "omni-basic",
    icon_size = 32,
    stack_size = 200
  },
	{
    type = "recipe",
    name = "stone-crushed",
    category = "crafting",
	subgroup = "omni-basic",
    energy_required = 0.5,
    --icon_size = 64,
	enabled = "true",
    ingredients ={{"stone-crushed", 2}},
    results=
    {
      {type="item", name="stone", amount=1},
    },
	main_product = "stone",
    icon = "__base__/graphics/icons/stone.png",
    order = "c[stone-crushed]",
	},
}
)
end
