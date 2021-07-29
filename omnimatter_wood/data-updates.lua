if mods["omnimatter_marathon"] then
    omni.marathon.equalize("burner-omniphlog","omni-mutator")
end
if mods["angelsbioprocessing"] and mods["bobgreenhouse"] then --checks both bio and greenhouse
    omni.lib.replace_all_ingredient("seedling","omniseedling")
    omni.lib.replace_recipe_result("wood-sawing-manual","wood","omniwood")
    omni.lib.remove_recipe_all_techs("bob-greenhouse")

    data.raw.recipe["wood-sawing-manual"].icons[1].icon = data.raw.item["omniwood"].icons[1].icon
    data.raw.recipe["wood-sawing-manual"].icons[1].icon_size = 32
    data.raw.recipe["wood-sawing-manual"].icons[1].scale = 1
    data.raw.recipe["wood-sawing-manual"].localised_name = {"item-name.omniwood"}
end
--update ingredients
if mods["bobplates"] then	omni.lib.replace_recipe_ingredient("omnimutator","copper-plate","glass") end

if data.raw.recipe["burner-lab"] then
    omni.lib.replace_recipe_ingredient("burner-lab","wood","omniwood")
end