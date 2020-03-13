	data:extend(
{
	--Omniston
	{
    type = "technology",
    name = "crystallology-2",
    icon = "__omnimatter_crystal__/graphics/technology/crystallology.png",
	icon_size = 128,
	prerequisites =
    {
		"crystallology-1","omni-sorting-electric-2",
    },
    effects =
    {
    },
    unit =
    {
      count = 250,
      ingredients = {
	  {"science-pack-1", 1},
	  {"science-pack-2", 1},
	  {"science-pack-3", 1},
	  },
      time = 40
    },
    order = "c-a"
    },	
	{
    type = "technology",
    name = "crystallology-3",
    icon = "__omnimatter_crystal__/graphics/technology/crystallology.png",
	icon_size = 128,
	prerequisites =
    {
		"crystallology-2","omni-sorting-electric-3",
    },
    effects =
    {
    },
    unit =
    {
      count = 450,
      ingredients = {
	  {"science-pack-1", 1},
	  {"science-pack-2", 1},
	  {"science-pack-3", 1},
	  },
      time = 40
    },
    order = "c-a"
    },	
	{
    type = "technology",
    name = "crystallology-4",
    icon = "__omnimatter_crystal__/graphics/technology/crystallology.png",
	icon_size = 128,
	prerequisites =
    {
		"crystallology-3",
    },
    effects =
    {
    },
    unit =
    {
      count = 450,
      ingredients = {
	  {"science-pack-1", 1},
	  {"science-pack-2", 1},
	  {"science-pack-3", 1},
	  },
      time = 40
    },
    order = "c-a"
    },	
	
	{
    type = "technology",
    name = "crystallonics-1",
    icon = "__omnimatter_crystal__/graphics/technology/crystallonics.png",
	icon_size = 128,
	prerequisites =
    {
		"crystallology-1",
		"advanced-electronics",
    },
    effects =
    {
    },
    unit =
    {
      count = 150,
      ingredients = {
	  {"science-pack-1", 1},
	  {"science-pack-2", 1},
	  {"science-pack-3", 1},
	  },
      time = 10
    },
    order = "c-a"
    },	
	{
    type = "technology",
    name = "crystallonics-2",
    icon = "__omnimatter_crystal__/graphics/technology/crystallonics.png",
	icon_size = 128,
	prerequisites =
    {
		"crystallology-2",
		"crystallonics-1",
		"advanced-electronics",
    },
    effects =
    {
    },
    unit =
    {
      count = 300,
      ingredients = {
	  {"science-pack-1", 1},
	  {"science-pack-2", 1},
	  {"science-pack-3", 1},
	  },
      time = 20
    },
    order = "c-a"
    },	
	{
    type = "technology",
    name = "crystallonics-3",
    icon = "__omnimatter_crystal__/graphics/technology/crystallonics.png",
	icon_size = 128,
	prerequisites =
    {
		"crystallology-3",
		"crystallonics-2",
		"advanced-electronics",
    },
    effects =
    {
    },
    unit =
    {
      count = 500,
      ingredients = {
	  {"science-pack-1", 1},
	  {"science-pack-2", 1},
	  {"science-pack-3", 1},
	  {"production-science-pack", 1},
	  },
      time = 40
    },
    order = "c-a"
    },	
	{
    type = "technology",
    name = "crystallonics-4",
    icon = "__omnimatter_crystal__/graphics/technology/crystallonics.png",
	icon_size = 128,
	prerequisites =
    {
		"crystallology-4",
		"crystallonics-3",
		"advanced-electronics",
    },
    effects =
    {
    },
    unit =
    {
      count = 750,
      ingredients = {
	  {"science-pack-1", 1},
	  {"science-pack-2", 1},
	  {"science-pack-3", 1},
	  {"production-science-pack", 1},
	  {"high-tech-science-pack", 1},
	  },
      time = 80
    },
    order = "c-a"
    },	
}
)