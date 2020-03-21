local recipe = {
    type = "recipe",
    name = "auto-compressor",
    ingredients = {{"steel-plate", 15}, {"electronic-circuit", 5}, {"stone-brick", 10}},
    result = "auto-compressor",
    energy_required = 10,
    enabled = false
}

--GFX by Arch666Angel
local item = {
    type = "item",
    name = "auto-compressor",
    icon = "__omnimatter_compression__/graphics/auto-compressor-icon.png",
    flags = {"goes-to-quickbar"},
    place_result = "auto-compressor",
    stack_size = 50,
    subgroup = "production-machine",
    order = "d[auto-compressor]",
}

--GFX by Arch666Angel
local auto_compressor = table.deepcopy(data.raw["furnace"]["electric-furnace"])
auto_compressor.name = "auto-compressor"
auto_compressor.module_specification.module_slots = 0
auto_compressor.icon = "__omnimatter_compression__/graphics/auto-compressor-icon.png"
auto_compressor.crafting_categories = {"compression"}
auto_compressor.minable = {mining_time = 5, result = "auto-compressor"}
auto_compressor.allowed_effects = {"consumption", "speed", "pollution"}
auto_compressor.crafting_speed = 3
auto_compressor.energy_usage = "225kW"
auto_compressor.animation =
    {
      filename = "__omnimatter_compression__/graphics/auto-compressor-sheet.png",
      priority = "high",
      width = 160,
      height = 160,
      frame_count = 25,
      line_length = 5,
      shift = {0.0, 0.0},
      animation_speed = 0.25
    }
auto_compressor.working_visualisations = nil

data:extend({recipe,item,auto_compressor})

--Add the autocompressor to the first technology
