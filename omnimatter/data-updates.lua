--Extraction & solvation recipes (allow other mods to interact between our data and data-updates)
require("prototypes.recipes.extraction-dynamic")
require("prototypes.recipes.solvation-dynamic")

-- Add water extraction recipes (needs to be done after extraction-dynamic)
omni.matter.add_omniwater_extraction("omnimatter", "water", omni.fluid_levels, 1, 360, true)

-----------------------
-----EARLY COMPATS-----
-----------------------
require("prototypes.compat.bob-compensation")

omni.matter.add_omnium_alloy("steel","steel-plate","ingot-steel")
omni.matter.add_omnium_alloy("iron","iron-plate","ingot-iron")

--Add crushing recipes to base impure extraction
omni.lib.add_unlock_recipe("omnitech-base-impure-extraction","crushed-omnite")
omni.lib.add_unlock_recipe("omnitech-base-impure-extraction","pulverized-omnite")
omni.lib.add_unlock_recipe("omnitech-base-impure-extraction","pulverized-stone")
omni.lib.add_unlock_recipe("omnitech-base-impure-extraction","pulver-omnic-waste")

--SET EXTERNAL PARAMETERS
require("prototypes.compat.angels-updates")
require("prototypes.compat.pycp-updates")