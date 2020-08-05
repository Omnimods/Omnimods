if not omni then omni={} end
if not omni.compression then omni.compression={} end

require("prototypes/item-groups")
require("prototypes/recipe-categories")
require("prototypes/technologies")
require("prototypes/auto-compressor")
require("prototypes/planner")
require("prototypes/functions")
data:extend({
  {
    type = "custom-input",
    name = "decompress-stack",
    key_sequence = "CONTROL + SHIFT + D",
    consuming = "none"
  },
})

local compress_level = {"compact","nanite","quantum","singularity"}
if settings.startup["omnicompression_building_levels"].value < 4 then
	for i=4,settings.startup["omnicompression_building_levels"].value+1,-1 do
		data.raw.technology["compression-"..compress_level[i].."-buildings"].enabled=false
	end
end