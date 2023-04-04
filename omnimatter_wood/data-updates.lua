require("prototypes.angels-bioprocessing")
require("prototypes.bioindustries")

if mods["omnimatter_marathon"] then
    omni.marathon.equalize("burner-omniphlog","omni-mutator")
end

--update ingredients
if mods["bobplates"] then    omni.lib.replace_recipe_ingredient("omnimutator","copper-plate","glass") end

if data.raw.recipe["burner-lab"] then
    omni.lib.replace_recipe_ingredient("burner-lab","wood","omniwood")
end