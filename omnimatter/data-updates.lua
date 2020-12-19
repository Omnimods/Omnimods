omni.add_omnicium_alloy("steel","steel-plate","ingot-steel")
omni.add_omnicium_alloy("iron","iron-plate","ingot-iron")
if mods["bobplates"] then
	omni.add_omnicium_alloy("aluminium","aluminium-plate","ingot-aluminium")
	omni.add_omnicium_alloy("tungsten","tungsten-plate","casting-powder-tungsten")
end
if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("pulverize-omnite")
	omni.marathon.exclude_recipe("omni-iron-general-1")
	omni.marathon.exclude_recipe("omni-copper-general-1")
	omni.marathon.exclude_recipe("omni-saphirite-general-1")
	omni.marathon.exclude_recipe("omni-stiratite-general-1")
end

----------------------------------------------------------------------------
-- Steam science compatability --
----------------------------------------------------------------------------
-- Fix for Steam SP Bob's Tech introduces sometimes
if data.raw.recipe["steam-science-pack"] then
	omni.lib.replace_recipe_ingredient("steam-science-pack","coal","omnite")
end

--marathon stuff
if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("omnicium-plate-pure")
	omni.marathon.exclude_recipe("crushing-omnite-by-hand")
end

----------------------------------------------------------------------------
-- Late requires --
----------------------------------------------------------------------------
require("prototypes.buildings.omnitractor-dynamic")
require("prototypes.recipes.extraction-dynamic")
require("prototypes.recipes.solvation-dynamic")
require("prototypes.buildings.omniphlog")
require("prototypes.buildings.steam-omni")