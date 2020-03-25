
if mods["aai-industry-sp0"] then
	industry.add_tech("omniwaste")
end

if mods["angelsbioprocessing"] then
	omni.lib.replace_all_ingredient("seedling","omniseedling")
	
	local tree_recipes = {"tree-generator-1","tree-generator-2","tree-generator-3",
						  "desert-tree-generator-1","desert-tree-generator-2","desert-tree-generator-3",
						  "swamp-tree-generator-1","swamp-tree-generator-2","swamp-tree-generator-3",
						  "temperate-tree-generator-1","temperate-tree-generator-2","temperate-tree-generator-3"}
	
	--data.raw.recipe["wood-sawing-manual"]["normal"].results[1].name="omniwood"
	--data.raw.recipe["wood-sawing-manual"]["expensive"].results[1].name="omniwood"
	--data.raw.recipe["wood-sawing-manual"].icons[1].icon = data.raw.item["omniwood"].icons[1].icon
	--data.raw.recipe["wood-sawing-manual"].icon_size = 32
	--data.raw.recipe["wood-sawing-manual"].localised_name = {"item-name.omniwood"}
end

if mods["omnimatter_marathon"] then
	omni.marathon.equalize("burner-omniphlog","omni-mutator")
end
