if not omni then omni={} end
if not omni.crystal then omni.crystal={} end
require("prototypes.functions")
require("prototypes.omniplant")
require("prototypes.crystallomnizer")
require("prototypes.crystallonics")
require("prototypes.crystal-making")
require("prototypes.categories")
require("prototypes.fuel-category")

--require("prototypes.circuit")
--require("prototypes.technology.crystallology")


if mods["angelsindustries"] and angelsmods.industries.components then
    for i=1,settings.startup["omnimatter-max-tier"].value do
        -- Remove previous tier buildings from the recipes
        if i == 1 then
            omni.lib.remove_recipe_ingredient("omniplant-1", "burner-omniplant")
        else
            omni.lib.remove_recipe_ingredient("omniplant-"..i, "omniplant-"..i-1)
            omni.lib.remove_recipe_ingredient("crystallomnizer-"..i, "crystallomnizer-"..i-1)
        end
    end
end
