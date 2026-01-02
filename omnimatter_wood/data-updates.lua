require("prototypes.angels-bioprocessing")
require("prototypes.bioindustries")

--update ingredients
if mods["bobplates"] then    omni.lib.replace_recipe_ingredient("omnimutator","copper-plate","bob-glass") end

if data.raw.recipe["bob-burner-lab"] then
    omni.lib.replace_recipe_ingredient("bob-burner-lab","wood","omniwood")
end