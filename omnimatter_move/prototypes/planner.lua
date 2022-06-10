data:extend({
  {
    type = "selection-tool",
    name = "ore-move-planner",
    icon = "__omnimatter_move__/graphics/planner.png",
      icon_size = 32,
    stack_size = 1,
    stackable = false,
    subgroup = "tool",
    order = "c[automated-construction]-d[dirty-planner]",
    flags = {"only-in-cursor", "spawnable"},
    selection_color = {r = 1.0, g = 0.2, b = 1.0, a = 0.3},
    alt_selection_color = {r = 0.2, g = 0.8, b = 0.3, a = 0.3},
    selection_mode = "any-entity",
    alt_selection_mode = "any-entity",
    selection_cursor_box_type = "entity",
    alt_selection_cursor_box_type = "entity"
  },
  {
    type = "custom-input",
    name = "give-ore-move-planner",
    key_sequence = "ALT + M",
    consuming = "game-only",
    action = "lua"
  },
  {
    type = "shortcut",
    name = "ore-move-planner-shortcut",
    localised_name = {"item-name.ore-move-planner"},
    action = "lua",
    associated_control_input = "give-ore-move-planner",
      icon = {
      filename = "__omnimatter_move__/graphics/planner-shortcut.png",
      size = 128,
      scale = 1,
      flags = {"gui-icon"}
    },
    disabled_icon = {
      filename = "__omnimatter_move__/graphics/planner-shortcut-white.png",
      size = 128,
      scale = 1,
      flags = {"gui-icon"}
    },
    small_icon = {
      filename = "__omnimatter_move__/graphics/planner-shortcut-white.png",
      size = 128,
      scale = 1,
      flags = {"gui-icon"}
    },
  }
})