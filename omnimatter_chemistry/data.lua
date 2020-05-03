omni.add_omniwaste()
if not omni.chem then omni.chem={} end

omni.chem.levels = settings.startup["omnichemistry-levels"].value
omni.chem.pack = settings.startup["omnichemistry-levels-per-pack"].value

--omnirec-impure-"..omnisource[i].ore.name.."-extraction-"..l
--"omnitech-impure-"..omnisource[i].ore.name.."-extraction-"..l

require("prototypes/buildings")
require("prototypes/carbomni")
require("prototypes/thiomni")
require("prototypes/oxomni")
require("prototypes/nitromni")
require("prototypes/categories")
require("prototypes/omni-materials")
require("prototypes/organomnimetals")
require("prototypes/omnimetal")
require("prototypes/biomni")