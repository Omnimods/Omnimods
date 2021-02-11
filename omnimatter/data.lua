--INITIALIZE
if not omni then omni = {} end
if not omni.matter then omni.matter = {} end

--LOAD CONSTANT, CATEGORY AND FUNCTION PROTOTYPES
require("prototypes.constants")
require("prototypes.categories")
require("prototypes.functions")

--LOAD ALL OTHER PROTOTYPES
require("prototypes.omniore")
require("prototypes.generation.omnite")
require("prototypes.generation.omnite-inf")
require("prototypes.compat.extraction-resources")

require("prototypes.buildings.omnitractor")
require("prototypes.buildings.omniphlog")
require("prototypes.buildings.omnifurnace")

require("prototypes.recipes.omnicium")
require("prototypes.recipes.omnibrick")
require("prototypes.recipes.omnic-acid")


if mods["angelsindustries"] and settings.startup["angels-enable-tech"].value then
	--add exceptions for tech
	angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore3-2")
	angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore3-1")
	angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore1-2")
	angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore1-1")
end