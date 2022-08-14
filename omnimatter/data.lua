--INITIALIZE
if not omni then omni = {} end
if not omni.matter then omni.matter = {} end

--LOAD CONSTANT, CATEGORY AND FUNCTION PROTOTYPES
require("prototypes.constants")
require("prototypes.categories")
require("prototypes.functions")

--LOAD BUILDINGS
require("prototypes.compat.angels-omniblocks")
require("prototypes.buildings.omnitractor")
require("prototypes.buildings.omniphlog")
require("prototypes.buildings.omnifurnace")

--LOAD RESOURCE PROTOTYPES
require("prototypes.omniore")
require("prototypes.generation.omnite")
require("prototypes.generation.omnite-inf")
require("prototypes.compat.extraction-resources")

--LOAD ALL OTHER PROTOTYPES
require("prototypes.recipes.omnium")
require("prototypes.recipes.omnibrick")
require("prototypes.recipes.omnic-acid")