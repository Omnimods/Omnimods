if not omni then omni={} end
if not omni.compression then omni.compression={} end

-------------------------------------------------------------------------------
--[[Initialisation and Config Variables]]--
-------------------------------------------------------------------------------
omni.compression.stack_compensate = settings.startup["omnicompression_compensate_stacksizes"].value --kind of local
omni.compression.hide_handcraft = settings.startup["omnicompression_hide_handcraft"].value
omni.compression.bld_lvls = settings.startup["omnicompression_building_levels"].value --kind of local
omni.compression.one_list = settings.startup["omnicompression_one_list"].value
if settings.startup["omnicompression_hide_handcraft"].value == false then
    omni.compression.hide_handcraft = nil--Don't override to false
end

omni.compression.sluid_contain_fluid = 60


require("prototypes/item-groups")
require("prototypes/recipe-categories")
require("prototypes/technologies")
require("prototypes/auto-compressor")
require("prototypes/planner")
require("prototypes/functions")
require("prototypes/early_compat")
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