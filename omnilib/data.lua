if not omni then omni = {} end
if not omni.lib then omni.lib = {} end

omni.tint_level = {{r=0,g=0,b=0},{r=1,g=1,b=0},{r=1,g=0,b=0},{r=0,g=0,b=1},{r=1,g=0,b=1},{r=0,g=1,b=0},{r=1,g=0.5,b=0},{r=1,g=0.5,b=0.5},{r=1,g=1,b=1}}

require("prototypes.functions.functions-recipe")
require("prototypes.functions.locale") --requires functions-recipe
require("prototypes.functions.icon") --requires locale and functions-recipe
require("prototypes.functions.functions-misc")
require("prototypes.functions.functions-technology")
require("prototypes.functions.functions-compatibility")
require("prototypes.recipe-generation")
require("prototypes.ingredients-generation")