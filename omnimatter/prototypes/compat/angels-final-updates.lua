if mods["angelsrefining"] then
    for _,f in pairs(data.raw.fluid) do
        data.raw.recipe["angelss-fluid-splitter-"..f.name].name=nil
    end

    RecGen:import("coal-liquefaction"):
        replaceIngredients("heavy-oil","omniston"):
        replaceIngredients("liquid-naphtha","omniston"):
        extend()
end

--Tech Overhaul setting is currently hidden and forced to false until compat is playable
if mods["angelsindustries"] and settings.startup["angels-enable-tech"].value then
    -------------------------------------------------------------------------------
    -- GREY SCIENCE PACKS ---------------------------------------------------------
    -------------------------------------------------------------------------------
    for _,tech_name in pairs({
        --omnimatter
        --"omnitech-omnic-acid-hydrolyzation-1",
        "omnitech-omnisolvent-omnisludge-1",
        "omnitech-focused-extraction-angels-ore3-2",
        "omnitech-focused-extraction-angels-ore3-1",
        "omnitech-focused-extraction-angels-ore1-2",
        "omnitech-focused-extraction-angels-ore1-1",--consider making this mod dynamic based on levels settings
        "omnitech-water-omnitraction-1",
        "omnitech-water-omnitraction-2"
    }) do
        if data.raw.technology[tech_name] then
            angelsmods.functions.AI.pack_replace(tech_name, "red", "grey")
            angelsmods.functions.AI.core_replace(tech_name, "processing","basic")
        end
    end
    angelsmods.functions.OV.execute()
    -------------------------------------------------------------------------------
    -- OTHER SCIENCE PACKS (TIER CHANGES) -----------------------------------------
    -------------------------------------------------------------------------------
    --Tier fixes for other technologies
    --[[local tech_tweaks = {
            --example to swap packs (colour name only, not full pack name, as exampled)
            --grey (excluded above hopefully), red, green, orange, blue, yellow, white
        ["omnitech-focussed-extraction-angels-ore5-4"]={old="green",new="red"},
        }
    for tweaks, tech_name in pairs(tech_tweaks) do
        if data.raw.technology[tech_name] then
            angelsmods.functions.AI.pack_replace(tech_name, tweaks.old, tweaks.new)
        end
    end
    angelsmods.functions.OV.execute() --this MUST BE DONE before core updates
    -------------------------------------------------------------------------------
    -- OTHER SCIENCE PACKS (CORE TYPE CHANGES) ------------------------------------
    -- THIS IDEALLY SHOULD BE EXECUTED AFTER THE PACK TIER UPDATE -----------------
    -------------------------------------------------------------------------------
    --Type fixes for other technologies
    local tech_tweaks = {
            --example to swap types (type name only, not full pack name, as exampled. TIER 1 for (red,green,orange), TIER 2 for (blue,yellow,white))
        ["omnitech-focussed-extraction-angels-ore5-6"]={old="basic",new="processing",tier=2},
        }
    for tweaks, tech_name in pairs(tech_tweaks) do
        if data.raw.technology[tech_name] then
            tier = tweaks.tier or 1
            angelsmods.functions.AI.core_replace(tech_name, tweaks.old, tweaks.new, tier)
        end
    end
    angelsmods.functions.OV.execute()]]
    --fix dependancy changes (because sometimes the tech clean-up script does not pick it up)
    omni.lib.set_prerequisite("omnitech-base-impure-extraction","tech-specialised-labs")
    omni.lib.replace_prerequisite("omnitech-water-omnitraction","tech-specialised-labs-processing-1","tech-specialised-labs")
end
