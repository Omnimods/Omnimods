--Regular Variables
if not mods["omnimatter_marathon"] then
    for _, rec in pairs(data.raw.recipe) do
        if standardized_recipes[rec.name] == nil then
            omni.lib.standardise(rec) --standardise what has not already been done
        end
    end
end

if mods["omnimatter_marathon"] or mods["omnimatter_science"] then
    omni.lib.remove_science_pack("compression-initial", "chemical-science-pack")
    omni.lib.remove_science_pack("compression-initial", "omni-pack")
    omni.lib.remove_science_pack("compression-mining", "production-science-pack")
    omni.lib.remove_science_pack("compression-mining", "chemical-science-pack")
    omni.lib.remove_science_pack("compression-recipes", "chemical-science-pack")
    omni.lib.remove_science_pack("compression-compact-buildings", "chemical-science-pack")
    omni.lib.remove_science_pack("compression-compact-buildings", "production-science-pack")
    omni.lib.remove_science_pack("compression-nanite-buildings", "production-science-pack")
    omni.lib.remove_science_pack("compression-quantum-buildings", "utility-science-pack")
    omni.lib.remove_prerequisite("compression-mining", "processing-unit")
    omni.lib.add_prerequisite("compression-nanite-buildings", "processing-unit")
end

omni.compression.tierless_buildings = omni.compression.tierless_buildings or {}

if mods["bobpower"] and mods["bobrevamp"] and mods["bobplates"] then
    if not settings.startup["bobmods-power-nuclear"].value then return end
    local tierless_buildings = omni.compression.tierless_buildings
    tierless_buildings["nuclear-reactor-3"] = true
    tierless_buildings["nuclear-reactor-2"] = true
    if settings.startup["bobmods-plates-nuclearupdate"].value == true or mods["bobores"] then
        tierless_buildings["nuclear-reactor"] = true
    end
end

require("prototypes/compress-items")
require("prototypes/compress-buildings")
require("prototypes/compress-ores")
require("prototypes/compress-recipes")
require("prototypes/compress-random")
require("prototypes/compress-technology")
require("prototypes/compat")