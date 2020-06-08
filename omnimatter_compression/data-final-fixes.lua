--Regular Variables
if not mods["omnimatter_marathon"] then
	for _, rec in pairs(data.raw.recipe) do
		if standardized_recipes[rec.name] == nil then
			omni.marathon.standardise(rec) --standardise what has not already been done
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
require("prototypes/compress-items")
require("prototypes/compress-recipes")
require("prototypes/compress-random")
require("prototypes/compress-technology")

--Extend compression items/recipes into the regular machines.
for _,kind in pairs({"assembling-machine","furnace"}) do
	for _,build in pairs(data.raw[kind]) do
		for i,cat in pairs(build.crafting_categories) do
			if not omni.lib.end_with(cat,"compressed") and data.raw["recipe-category"][cat.."-compressed"] then
				table.insert(build.crafting_categories,cat.."-compressed")
      end
    end
    if kind == "assembling-machine" and string.find(build.name,"assembling") then
      if not omni.lib.is_in_table("general-compressed",build.crafting_categories) then
        table.insert(build.crafting_categories,"general-compressed")
      end
    end
	end
end
