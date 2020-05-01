if not omni then omni={} end
if not omni.crystal then omni.logistics={} end

require("prototypes.categories")
require("prototypes.equipment.armour") --just adds a primative armour
--require("prototypes.equipment.generator") --currently empty, but i think the steam battery from armour is meant for here
require("prototypes.equipment.shoes") --new exo's for earlier
require("prototypes.equipment.roboports") --personal roboport for earlier

require("prototypes.entities.chests")
require("prototypes.entities.infrastructure")
require("prototypes.entities.robots-logistic")
require("prototypes.entities.robots-construction")

require("prototypes.recipes.armour")
require("prototypes.recipes.generator")
require("prototypes.recipes.shoes")
require("prototypes.recipes.infrastructure")

require("prototypes.equipment-grid")

require("prototypes.technology.omniquipment")
