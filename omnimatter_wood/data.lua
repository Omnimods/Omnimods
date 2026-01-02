require("prototypes.category")
require("prototypes.standard")

--update electronics if bobs-electronics
if bobmods and bobmods.electronics then
    omni.lib.add_recipe_ingredient("omnimutator",{"bob-basic-circuit-board",2})
end
