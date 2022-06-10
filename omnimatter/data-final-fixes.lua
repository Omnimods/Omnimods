-----------------------
-----LATE COMPATS-----
-----------------------
require("prototypes.compat.bob-burnerphase")
require("prototypes.compat.angels-final-updates")
require("prototypes.compat.general-compat")

-----------------------
-----Late requires-----
-----------------------
require("prototypes.recipes.omnic-water")
require("prototypes.generation.autoplace-removal")


--Add last extraction techs as rocket silo prereq
if omni.rocket_locked then
    --Get highest ore and fluid tier
    local max_tier = 0
    local max_fluid_tier = 0
    
    for k,v in pairs(omni.matter.omnisource) do
        max_tier = math.max(max_tier, tonumber(k))
    end
    for k,v in pairs(omni.matter.omnifluid) do
        max_fluid_tier = math.max(max_fluid_tier, tonumber(k))
    end
    --Case low max tractor tier: set both max_tiers to the lowest tier that still has techs after the last tractor tech and add the last techs of that tier and all above as silo prereq
    max_tier = math.min(max_tier, omni.max_tier - 2)
    max_fluid_tier = math.min(max_fluid_tier, omni.max_tier - omni.fluid_levels/omni.fluid_levels_per_tier + 1)

    --Check if there is a higher ore than fluid tier
    if max_tier >= max_fluid_tier then
        local pure_extractions = 3 * omni.pure_levels_per_tier
        for tier, ores in pairs(omni.matter.omnisource) do
            if tonumber(tier) >= max_tier then
                for _,ore in pairs(ores) do
                    omni.lib.add_prerequisite("rocket-silo","omnitech-extraction-"..ore.name.."-"..pure_extractions)
                end
            end
        end
    end
    --Check if there is a higher fluid than ore tier
    if max_fluid_tier >= max_tier then
        for tier, fluids in pairs(omni.matter.omnifluid) do
            if tonumber(tier) >= max_fluid_tier then
                for _,fluid in pairs(fluids) do
                    omni.lib.add_prerequisite("rocket-silo","omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels)
                end
            end
        end
    end
end