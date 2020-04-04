data:extend(
{
  -----------------------------------------------------------------------------
  -- OMNI BLOCKS --------------------------------------------------------------
  -----------------------------------------------------------------------------
  {
    type = "item",
    name = "block-omni-0",
    icons = {
			{icon = "__angelsindustries__/graphics/icons/block-bprocessing-4.png",
			tint = {255,0,255}},
			{icon = "__omnilib__/graphics/lvl0.png"}
			},
    icon_size = 32,
    subgroup = "omnitractor",
    order = "a",
    stack_size = 200,
  },
  {
    type = "recipe",
    name = "block-omni-0",
    enabled = true,
    category = "crafting",
    energy_required = 5,
    ingredients =
    {
      {type="item", name = "construction-frame-1", amount = 1},
      {type="item", name = "omnicium-plate", amount = 2},
    },
    results=
    {
      {type="item", name="block-omni-0", amount=1},
    },
    icon_size = 32,
  }
})

for i=1,5 do
	plate_index = math.min(i,#component["omniplate"])
	gbox_index = math.min(i,#component["gear-box"])
	data:extend(
	{
		{
			type = "item",
			name = "block-omni-"..i,
			icons = {
				{icon = "__angelsindustries__/graphics/icons/block-bprocessing-4.png",
				tint = {255,0,255}},
				{icon = "__omnilib__/graphics/lvl"..i..".png"}
				},
			icon_size = 32,
			subgroup = "omnitractor",
			order = "a",
			stack_size = 200,
		},
		{
			type = "recipe",
			name = "block-omni-"..i,
			enabled = false,
			category = "crafting",
			energy_required = 5,
			ingredients =
			{
			  {type="item", name = "block-omni-"..i-1, amount = 1},
			  {type="item", name = component["omniplate"][plate_index], amount = 4},
			  {type="item", name = component["gear-box"][gbox_index], amount = 2},
			},
			results=
			{
			  {type="item", name="block-omni-"..i, amount=1},
			},
			icon_size = 32,
		}
	})
end