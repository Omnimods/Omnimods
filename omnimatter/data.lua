--INITIALIZE
if not zemods then zemods = {} end
if not omnimatter then omnimatter = {} end
if not omni then omni = {} end
require("config")
require("prototypes.functions")
require("prototypes.constants")

if omni.pure_dependency > omni.pure_levels_per_tier then omni.pure_dependency = omni.pure_levels_per_tier end
if omni.impure_dependency > omni.impure_levels_per_tier then omni.impure_dependency = omni.impure_levels_per_tier end
if omni.fluid_dependency > omni.fluid_levels_per_tier then omni.fluid_dependency = omni.fluid_levels_per_tier end

--Infinite ore result probability check
--LOAD PROTOTYPES
require("prototypes.categories")
require("prototypes.omniore")
require("prototypes.generation.omnite-inf")
require("prototypes.generation.omnite")
require("prototypes.buildings.omnifurnace")
require("prototypes.recipes.omnicium")
require("prototypes.recipes.omnibrick")
require("prototypes.recipes.omnic-acid")

--require("prototypes.generation.omniston")
--require("prototypes.localization-override")
--require("prototypes.omnitractor-dynamic")
--require("prototypes.recipes.extraction-dynamic")
--require("prototypes.recipes.solvation-dynamic")
