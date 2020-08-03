require("prototypes.category")
require("prototypes.standard")
require("prototypes.angels-bioprocessing")
require("prototypes.bioindustries")

--update electronics if bobs-electronics
if bobmods and bobmods.electronics then omni.lib.add_recipe_ingredient("omnimutator",{"basic-circuit-board",2}) end
