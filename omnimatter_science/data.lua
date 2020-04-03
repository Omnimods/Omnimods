if not omni.science then omni.science = {} end
if not omni.science.triggers then omni.science.triggers={} end
--set-up triggers for the science-pack
lab_ignore_pack = omni.science.triggers.lab_ignore_pack or {}
--default the bobs special labs to not take
lab_ignore_pack["lab-alien"] = true
lab_ignore_pack["lab-module"] = true

require("prototypes.functions")
require("prototypes.omni-pack")

if mods["omnimatter_crystal"] then
  data.raw.tool["production-science-pack"].icon = "__omnimatter_science__/graphics/icons/production-science-pack.png"
  data.raw.tool["production-science-pack"].icon_size=64
  data.raw.recipe["production-science-pack"].icon_size=64
  data.raw.tool["omni-pack"].icon_size=64
  data.raw.recipe["omni-pack"].icon_size=64
end
