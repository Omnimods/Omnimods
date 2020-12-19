--INITIALIZE
if not omnimatter then omnimatter = {} end
if not omni then omni = {} end
if not omni.matter then omni.matter = {} end

require("prototypes.constants")
require("prototypes.categories")
require("prototypes.compat.extraction-functions")




--Infinite ore result probability check
--LOAD PROTOTYPES

require("prototypes.omniore")
require("prototypes.generation.omnite-inf")
require("prototypes.generation.omnite")
require("prototypes.buildings.omnifurnace")
require("prototypes.recipes.omnicium")
require("prototypes.recipes.omnibrick")
require("prototypes.recipes.omnic-acid")
require("prototypes.compat.extraction-resources")

--require("prototypes.generation.omniston")
--require("prototypes.omnitractor-dynamic")
--require("prototypes.recipes.extraction-dynamic")
--require("prototypes.recipes.solvation-dynamic")
