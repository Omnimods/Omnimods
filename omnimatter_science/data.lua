if not omni.science then omni.science = {} end
if not omni.science.triggers then omni.science.triggers={} end

--set settings to triggers
omni.science.triggers.ModAllCost = settings.startup["omniscience-modify-costs"].value --bool
omni.science.triggers.ModOmCost = settings.startup["omniscience-modify-omnimatter-costs"].value --bool
omni.science.triggers.ModSilo = settings.startup["omniscience-rocket-modified-by-omni"].value --bool
omni.science.triggers.Cumul = settings.startup["omniscience-cumulative-count"].value --bool
omni.science.triggers.CumulConst = settings.startup["omniscience-cumulative-constant"].value --double
omni.science.triggers.CumulOmConst = settings.startup["omniscience-cumulative-constant-omni"].value --double
omni.science.triggers.ChainConst = settings.startup["omniscience-chain-constant"].value --double
omni.science.triggers.ChainOmConst = settings.startup["omniscience-chain-omnitech-constant"].value --double
omni.science.triggers.Expon = settings.startup["omniscience-exponential"].value --bool
omni.science.triggers.ExponInit = settings.startup["omniscience-exponential-initial"].value --double
omni.science.triggers.ExponBase = settings.startup["omniscience-exponential-base"].value --double
omni.science.triggers.OmMaxConst = settings.startup["omniscience-omnitech-max-constant"].value --double
omni.science.triggers.StdTime = settings.startup["omniscience-standard-time"].value --bool
omni.science.triggers.StdTimeConst = settings.startup["omniscience-standard-time-constant"].value --double

--set-up triggers for the science-pack
lab_ignore_pack = omni.science.triggers.lab_ignore_pack or {}
--default the bobs special labs to not take
lab_ignore_pack["lab-alien"] = true
lab_ignore_pack["lab-module"] = true
lab_ignore_pack["omnitor-lab"] = true

require("prototypes.functions")
require("prototypes.omni-pack")
