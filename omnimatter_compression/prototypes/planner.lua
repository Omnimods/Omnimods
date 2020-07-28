data:extend({

  {
    type = "selection-tool",
    name = "compression-planner",
    icon = "__omnimatter_compression__/graphics/planner.png",
	  icon_size = 32,
    stack_size = 1,
    stackable = false,
    subgroup = "tool",
    order = "c[automated-construction]-d[dirty-planner]",
    flags = {"only-in-cursor"},
    selection_color = {r = 1.0, g = 0.2, b = 1.0, a = 0.3},
    selection_cursor_box_type = "copy",
    alt_selection_cursor_box_type = "copy",
    alt_selection_color = {r = 0.2, g = 0.8, b = 0.3, a = 0.3},
    always_include_tiles = true,  
    selection_mode = "any-entity",
    entity_type_filters = {"resource"},
    entity_filter_mode = "whitelist",
    alt_entity_type_filters = {"resource"},
    alt_entity_filter_mode = "whitelist",
    alt_selection_mode = "any-entity"
  },
  {
    type = "recipe",
    name = "compression-planner",
	icon_size = 32,
    enabled = false,
    energy_required = 1,
    ingredients =
    {
		{"blueprint", 1},
    },
    result = "compression-planner"
  }
})