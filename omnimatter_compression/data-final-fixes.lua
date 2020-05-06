--Regular Variables
if not mods["omnimatter_marathon"] then
	for _, rec in pairs(data.raw.recipe) do
		if standardized_recipes[rec.name] == nil then
			omni.marathon.standardise(rec)
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
	omni.lib.remove_prerequisite("compression-mining", "advanced-electronics-2")
	omni.lib.add_prerequisite("compression-nanite-buildings", "advanced-electronics-2")

end

--require("prototypes/compress-recipes")
require("prototypes/compress-random")
require("prototypes/compress-ores")
--require("prototypes/compress-buildings")
require("prototypes/compress-technology")
--Extend our items/recipes for use in the game.
for _,kind in pairs({"assembling-machine","furnace"}) do
	for _,build in pairs(data.raw[kind]) do
		for i,cat in pairs(build.crafting_categories) do
			if not omni.lib.end_with(cat,"compressed") and data.raw["recipe-category"][cat.."-compressed"] then
				table.insert(build.crafting_categories,cat.."-compressed")
			end
		end
	end
end
