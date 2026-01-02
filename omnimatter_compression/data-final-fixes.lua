omni.compression.tierless_buildings = omni.compression.tierless_buildings or {}

if mods["bobpower"] and mods["bobrevamp"] and mods["bobplates"] then
    if not settings.startup["bobmods-power-nuclear"].value then return end
    local tierless_buildings = omni.compression.tierless_buildings
    tierless_buildings["nuclear-reactor-3"] = true
    tierless_buildings["nuclear-reactor-2"] = true
    tierless_buildings["nuclear-reactor"] = true
end

require("prototypes/compress-items")
require("prototypes/compress-buildings")
require("prototypes/compress-ores")
require("prototypes/compress-recipes")
require("prototypes/compress-random")
require("prototypes/compress-technology")
require("prototypes/compat")