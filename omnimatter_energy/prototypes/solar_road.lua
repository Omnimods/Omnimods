--Crystal Panels
RecGen:create("omnimatter_energy","crystal-panel"):
	setStacksize(50):
	setCategory("crafting"):
	setSubgroup("omnienergy-solar"):
	setOrder("a[crystal-panel]"):
	setEnergy(2):
	setIngredients({"iron-ore-crystal",2},{"copper-ore-crystal",3},{"basic-crystallonic",3}):
	setEnabled(false):
	setTechName("solar-energy"):extend()


data:extend({
	--- Solar Mat
  {
	type = "item",
	name = "omni-solar-road",
	icon = "__omnimatter_energy__/graphics/icons/omni-solar-tile.png",
	icon_size = 32,
	flags = {},
	subgroup = "energy",
    order = "ad[solar-panel]-aa[solar-panel-1-a]",
	stack_size = 400,
	place_as_tile =
		 {
		  result = "omni-solar-road",
		  condition_size = 4,
		  condition = { "water-tile" }
		 }
  },
  {
	type = "recipe",
	name = "omni-solar-road",
	icon = "__omnimatter_energy__/graphics/icons/omni-solar-tile.png",
	icon_size = 32,
	category = "crafting",
	subgroup = "omnienergy-solar",
	energy_required = 3.0,
	enabled=false,
	order = "ad[solar-panel]-aa[solar-panel-1-a]",
	ingredients = 
		{
			{type = "item",name = "crystal-panel", amount = 4},
			{type = "item",name = "small-omnicium-electric-pole", amount = 1},
			{type = "item",name = "refined-concrete", amount = 4}
		},
	results = {{type = "item",name = "omni-solar-road", amount = 4}}
  },
  {
	  type = "tile",
	  name = "omni-solar-road",
	  icon = "__omnimatter_energy__/graphics/icons/omni-solar-tile.png",
	  icon_size = 32,
	  needs_correction = false,
	  minable = {hardness = 0.1, mining_time = 0.25, result = "omni-solar-road"},
	  mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
	  collision_mask = {"ground-tile", "not-colliding-with-itself"},
	  collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
	  walking_speed_modifier = 1.45,
	  layer = 62,
	  pollution_absorption_per_second=0,
	  decorative_removal_probability = 1,
	  variants =
	  {
		main =
		{	
		 {
			picture = "__omnimatter_energy__/graphics/entity/tiles/solar1.png",
			count = 1,
			size = 1,
			probability = 1,
		  },
		},
		inner_corner =
		{
		  picture = "__omnimatter_energy__/graphics/entity/tiles/solar-inner-corner.png",
		  count = 8
		},
		outer_corner =
		{
		  picture = "__omnimatter_energy__/graphics/entity/tiles/solar-outer-corner.png",
		  count = 8
		},
		side =
		{
		  picture = "__omnimatter_energy__/graphics/entity/tiles/solar-side.png",
		  count = 8
		},
		u_transition =
		{
		  picture = "__omnimatter_energy__/graphics/entity/tiles/solar-u.png",
		  count = 8
		},
		o_transition =
		{
		  picture = "__omnimatter_energy__/graphics/entity/tiles/solar-o.png",
		  count = 1
		}
	  },
	  walking_sound =
	  {
		{
		  filename = "__base__/sound/walking/concrete-01.ogg",
		  volume = 1.2
		},
		{
		  filename = "__base__/sound/walking/concrete-02.ogg",
		  volume = 1.2
		},
		{
		  filename = "__base__/sound/walking/concrete-03.ogg",
		  volume = 1.2
		},
		{
		  filename = "__base__/sound/walking/concrete-04.ogg",
		  volume = 1.2
		}
	  },
	  map_color={r=93, g=138, b=168},
	  ageing=0,
	  vehicle_friction_modifier = dirt_vehicle_speed_modifer
	},
	{
		type = "item",
		name = "omni-solar-road-pole",
		icon = "__omnimatter_energy__/graphics/icons/omni-solar-tile.png",
		icon_size = 32,
		flags = {"hidden"},
		subgroup = "energy-pipe-distribution",
		order = "x[bi]-a[bi_bio_farm]",
		place_result = "omni-solar-road-pole",
		stack_size = 50,
		enable = false,
	},
	{
    type = "electric-pole",
    name = "omni-solar-road-pole",
    icon = "__omnimatter_energy__/graphics/icons/omni-solar-tile.png",
	icon_size = 32,
	flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map", "not-repairable"},
	selectable_in_game = false,
    max_health = 1,
    resistances = {{type = "fire", percent = 100}},
	collision_mask = {"ground-tile"},
    collision_box = {{-0.0, -0.0}, {0.0, 0.0}},
    selection_box = {{0, 0}, {0, 0}},
	
    maximum_wire_distance = 1,
    supply_area_distance = 2,
    pictures =
    {
      filename = "__omnimatter_energy__/graphics/icons/empty.png",
      priority = "low",
      width = 1,
      height = 1,
	  frame_count = 1,
      axially_symmetrical = false,
      direction_count = 4,
	  shift = {0.75, 0},
    },
	 connection_points =
    {
      {
        shadow =
        {

        },
        wire =
        {
          copper_wire = {-0, -0},

        }
      },
      {
        shadow =
        {

        },
        wire =
        {
          copper_wire = {-0, -0},

        }
      },
      {
        shadow =
        {

        },
        wire =
        {
          copper_wire = {-0, -0},

        }
      },
      {
        shadow =
        {

        },
        wire =
        {
          copper_wire = {-0, -0},

        }
      }
    },
    radius_visualisation_picture =
    {
      filename = "__omnimatter_energy__/graphics/icons/empty.png",
      width = 1,
      height = 1,
      priority = "low"
    },
  },
	{
		type = "item",
		name = "omni-solar-road-panel",
		icon = "__omnimatter_energy__/graphics/icons/omni-solar-tile.png",
		icon_size = 32,
		flags = {"hidden"},
		subgroup = "energy",
		order = "x[bi]-a[bi_bio_farm]",
		place_result = "omni-solar-road-panel",
		stack_size = 50,
		enable = false,
	},
  {
    type = "solar-panel",
    name = "omni-solar-road-panel",
    icon = "__omnimatter_energy__/graphics/icons/omni-solar-tile.png",
	icon_size = 32,
	flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map", "not-repairable"},
	selectable_in_game = false,
    max_health = 1,
    resistances = {{type = "fire", percent = 100}},
	collision_mask = {"ground-tile"},
    collision_box = {{-0.0, -0.0}, {0.0, 0.0}},
    selection_box = {{0, 0}, {0, 0}},
    energy_source =
    {
      type = "electric",
      usage_priority = "solar"
    },
    picture =
    {
      filename = "__omnimatter_energy__/graphics/icons/empty.png",
      priority = "low",
      width = 1,
      height = 1,
    },
    production = "10kW"
  },
})