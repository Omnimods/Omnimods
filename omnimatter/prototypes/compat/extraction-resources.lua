----------------------------------------------------------------------------
-- omnitraction resource additions --
-- common alternative mods --
----------------------------------------------------------------------------

--set to false if a compat mod is present that has its own tiers, otherwise these get added at the end
local all_time_ores = true --stone & coal 
local metal_ores = true       -- iron & copper & uranium
local vanilla_fluids = true    --crude oil

-- Angels / Bobs
if angelsmods and angelsmods.refining then
    metal_ores = false

    --Initial omnitractions for saph/ stir
    omni.matter.add_initial("angels-ore1", 1, 6)
    omni.matter.add_initial("angels-ore3", 1, 6)

    omni.matter.add_resource("angels-ore1", 1)
    omni.matter.add_resource("angels-ore3", 1) 
    omni.matter.add_resource("angels-ore4", 3)
    omni.matter.add_fluid("thermal-water", 3, 3)
    if bobmods and bobmods.ores or (angelsmods.industries and angelsmods.industries.overhaul) then
        omni.matter.add_resource("angels-ore2", 3)
        omni.matter.add_resource("angels-ore5", 2)
        omni.matter.add_resource("angels-ore6", 2)
    else
        omni.matter.add_resource("angels-ore2", 2)
    end
else
    --Non-Angel initial omnitractions
    omni.matter.add_initial("iron-ore", 1, 7)
    omni.matter.add_initial("copper-ore", 1, 7)
    if bobmods and bobmods.ores then
        local has_gems = settings.startup["bobmods-ores-unsortedgemore"].value
        local levels={        
            --["iron-ore"]=1,
            --["copper-ore"]=1,
            ["lead-ore"]=1,
            ["tin-ore"]=1,
            ["quartz"]=2,
            ["zinc-ore"]=2,
            ["nickel-ore"]=2,
            ["bauxite-ore"]=2,
            ["rutile-ore"]=3,
            ["gold-ore"]=3,
            ["cobalt-ore"]=3,
            ["silver-ore"]=3,
            ["tungsten-ore"]=3,
            --["uranium-ore"]=3,
            ["thorium-ore"]=3,
            ["gem-ore"]=has_gems and 3 or nil,
            ["sulfur"]=2
        }
        for i, ore in pairs(bobmods.ores) do --check ore triggers (works with plates)
            if ore.enabled and not (ore.category and ore.category == "water") then
                if levels[ore.name] then
                    omni.matter.add_resource(ore.name,levels[ore.name])
                else
                    log("WARNING: Omni Tier not set for bob`s ore: "..ore.name)
                end
            end
        end
        --Force Gem ore, certain bob settings disable it in the table checked above
        if has_gems then
            omni.matter.add_resource("gem-ore", 3)
        end
        omni.matter.add_fluid("lithia-water", 2, 1)
    end
end

if mods["SigmaOne_Nuclear"] then
    omni.matter.add_resource("fluorine-ore", 3)
end
if mods["dark-matter-replicators"] then
    omni.matter.add_resource("tenemut", 3)
end
if mods["Yuoki"] then
    omni.matter.add_resource("y-res1", 2)
    omni.matter.add_resource("y-res2", 3)
end
if mods["baketorio"] then
    omni.matter.add_initial("salt", 1, 6)
    omni.matter.add_resource("salt", 1)
    omni.matter.add_resource("trona", 2)
end
if mods["pycoalprocessing"] then
    -- Red
    omni.matter.add_resource("borax", 1)
    -- Green
    omni.matter.add_resource("niobium", 2)
end
if mods["pyfusionenergy"] then
    -- Blue
    omni.matter.add_resource("molybdenum-ore", mods["pyrawores"] and 2 or 4)
    omni.matter.add_resource("volcanic-pipe", 3)--kimberlite-rock
    -- Beyond
    omni.matter.add_resource("regolites", 4)
end
if mods["pyhightech"] then
    if     mods["pyalternativeenergy"] then
        omni.matter.add_resource("ree", 2)--rare-earth-ore
    else
        -- Blue
        omni.matter.add_resource("rare-earth-bolide", 2)--rare-earth-ore
    end
    -- Beyond
    omni.matter.add_resource("phosphate-rock", 2)
end
if mods["pypetroleumhandling"] then
    -- Green
    omni.matter.add_resource("oil-sand", 2)
    omni.matter.add_resource("sulfur-patch", 2)
    --Red
    omni.matter.add_resource("kerogen", 1)
    omni.matter.add_fluid("tar", 1, 1)
    omni.matter.add_fluid("natural-gas", 1, 1)
    --Tier 4
    omni.matter.add_fluid("water-saline", 4, 1)
end
if mods["pyalienlife"] then
    -- Green
    if data.raw.item["native-flora"] then -- indev version
        omni.matter.add_initial("ore-bioreserve", 1, 12)
        omni.matter.add_resource("ore-bioreserve", 1)--native-flora
    else
        omni.matter.add_resource("bio-sample", 2)
    end
end
if mods["pyrawores"] then
    --disable vanilla coal & stone, raw coal will produce our coal.
    all_time_ores = false
    --Initial omnitractions
    if not mods["pyalienlife"] then
        -- not needed as of current portal, leaving for ratio reference
        -- omni.matter.add_initial("ore-aluminium", 1, 14)
        omni.matter.add_initial("ore-tin", 1, 12)
        omni.matter.add_initial("ore-quartz", 1, 12)
    end
    omni.matter.add_initial("raw-coal", 1, 10)
    -- Pre-sci/red
    omni.matter.add_resource("stone", 1)
    omni.matter.add_resource("ore-aluminium", 1)
    omni.matter.add_resource("ore-tin", 1)
    omni.matter.add_resource("ore-quartz", 1)
    omni.matter.add_resource("raw-coal", 1)
    omni.matter.add_resource("ore-lead",
        1,
        {
            name = mods["pyfusionenergy"] and "acetylene" or data.raw.resource["ore-lead"].minable.required_fluid,
            amount = data.raw.resource["ore-lead"].minable.fluid_amount
        }
    )
    omni.matter.add_resource("ore-titanium",
        1,
        {
            name = mods["pyfusionenergy"] and "acetylene" or data.raw.resource["ore-titanium"].minable.required_fluid,
            amount = data.raw.resource["ore-titanium"].minable.fluid_amount
        }
    )
    omni.matter.add_resource("salt-rock", 1)
    omni.matter.add_resource("ore-chromium", 1)
    -- Green
    omni.matter.add_resource("ore-nickel", mods["pyalternativeenergy"] and 1 or 2)
    omni.matter.add_resource("ore-zinc", mods["pyalternativeenergy"] and 1 or 2)
end

if mods["pyalternativeenergy"] then
    omni.matter.add_resource("antimonium", 1)
    omni.matter.add_fluid("geothermal-water", 1, 1, 3000)
end

if mods["Krastorio2"] then
    --disable vanilla coal & stone, need a lower tier
    all_time_ores = false
    -- T1
    omni.matter.add_resource("coal", 1)
    -- T2
    omni.matter.add_resource("raw-rare-metals", 2)
    omni.matter.add_fluid("mineral-water", 2, 1)
    -- T5
    omni.matter.add_resource("raw-imersite", 5)
    -- Only add stone and uranium when angels is not present
    if not (angelsmods and angelsmods.refining) then
        -- T1
        omni.matter.add_resource("stone", 1)
        -- T3
        omni.matter.add_resource("uranium-ore", 3)
    end
end

----------------------------------------------------------------------------
-- Oils ain't oils section --
----------------------------------------------------------------------------
if angelsmods and angelsmods.petrochem then
    vanilla_fluids = false
    omni.matter.add_fluid("gas-natural-1", 1, 3+4/7)
    omni.matter.add_fluid("liquid-multi-phase-oil", 2, 1+3/8)
    if not mods["omnimatter_water"] and not mods["pypetroleumhandling"] then omni.matter.add_resource("sulfur", 2) end
end

----------------------------------------------------------------------------
-- Add vanilla resources --
----------------------------------------------------------------------------
if all_time_ores then
    omni.matter.add_resource("coal", 2)
    omni.matter.add_resource("stone", 3)
end
if metal_ores then
    omni.matter.add_resource("iron-ore", 1)
    omni.matter.add_resource("copper-ore", 1)
    omni.matter.add_resource("uranium-ore", 3)
end
if vanilla_fluids then
    omni.matter.add_fluid("crude-oil", 1, 1)
end