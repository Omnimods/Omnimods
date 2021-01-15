if not omni then omni = {} end
if not omni.lib then omni.lib = {} end
omni.tint_level = {{r=0,g=0,b=0},{r=1,g=1,b=0},{r=1,g=0,b=0},{r=0,g=0,b=1},{r=1,g=0,b=1},{r=0,g=1,b=0},{r=1,g=0.5,b=0},{r=1,g=0.5,b=0.5},{r=1,g=1,b=1}}

--check setting has actually been forced off
if mods["bobtech"] then
  settings.startup["bobmods-tech-colorupdate"].value = false
end

require("prototypes.functions.locale")
require("prototypes.functions.icon")
require("prototypes.functions.functions-misc")
require("prototypes.functions.functions-recipe")
require("prototypes.functions.functions-technology")
require("prototypes.functions.omnimarathon")
require("prototypes.functions.recipe-standard")
require("prototypes.recipe-generation")
require("prototypes.ingredients-generation")

if mods["GN Factorio Tweaks"] then error("denied") end
--if mods["fluid_permutations"] then error("Incompatible, get omnipermute as the only fluid permutation mod.") end

sluid_contain_fluid = 60
sluid_stack_size = 360

if mods["angelsindustries"] and settings.startup["angels-enable-tech"].value then
  --add exceptions for tech
  angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore3-2")
  angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore3-1")
  angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore1-2")
  angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore1-1")
end
