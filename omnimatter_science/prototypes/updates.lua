if mods["angelsbioprocessing"] then
    omni.lib.add_unlock_recipe("bio-farm","temperate-garden-cultivating-b")
    omni.lib.add_unlock_recipe("bio-farm","desert-garden-cultivating-b")
    omni.lib.add_unlock_recipe("bio-farm","swamp-garden-cultivating-b")
end

--Add Omni science pack if crystal is present
if mods["omnimatter_crystal"] then
    --UPDATE LABS INPUT
    for i, labs in pairs(data.raw["lab"]) do
        local found = false
        for _,v in pairs(labs.inputs) do
            if v == "omni-pack" then
                found = true
            end
        end
        if not lab_ignore_pack[labs.name] and found == false then
            table.insert(labs.inputs, "omni-pack")
        end
    end

    --SP ingredient manipulation
    omni.lib.add_recipe_ingredient("chemical-science-pack","basic-crystallonic")
    omni.lib.add_recipe_ingredient("production-science-pack","basic-oscillo-crystallonic")
    omni.lib.add_recipe_ingredient("utility-science-pack","basic-oscillo-crystallonic")

    --SP tech manipulation
    omni.lib.remove_science_pack("omnitech-crystallonics-4","utility-science-pack")
    omni.lib.add_science_pack("electric-engine", "omni-pack")

    if not mods["pycoalprocessing"] then
        omni.lib.add_science_pack("plastics", "omni-pack")
        omni.lib.add_prerequisite("plastics", "omnipack-technology")
    end

    omni.lib.replace_science_pack("omnitech-crystallology-2", "chemical-science-pack", "omni-pack")
    omni.lib.replace_science_pack("military-3", "chemical-science-pack", "omni-pack")
    omni.lib.replace_science_pack("mining-productivity-4", "chemical-science-pack", "omni-pack")
    --omni.lib.replace_science_pack("rocket-damage-3", "chemical-science-pack", "omni-pack") --keeps throwing an error??
    --omni.lib.replace_science_pack("mining-productivity-8", "production-science-pack", "omni-pack") --keeps throwing an error??
    --omni.lib.replace_science_pack("mining-productivity-12", "utility-science-pack", "omni-pack") --keeps throwing an error??

    ---------------------------------------------------------------------------
    -- Mod based Manipulation
    ---------------------------------------------------------------------------
    --Omni
    if not mods["omnimatter_research"] then
        if mods["boblogistics"] and settings.startup["bobmods-logistics-inserteroverhaul"].value == true then
            omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "long-handed-inserter", amount = 1})
        else
            omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "fast-inserter", amount = 1})
        end
    end

    if mods["omnimatter_wood"] then 
        omni.lib.replace_science_pack("omnitech-omnimutator-2", "chemical-science-pack", "omni-pack")
    end

    if mods["omnimatter_compression"] then
        omni.lib.replace_science_pack("compression-initial", "chemical-science-pack", "omni-pack")
    end

    --Angels
    if mods["angelsrefining"] then
        omni.lib.replace_science_pack("angels-advanced-ore-refining-3", "chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-ore-leaching", "chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-ore-processing-2", "chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-ore-processing-3", "production-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-ore-processing-4","utility-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-ore-leaching", "chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-slag-processing-2", "chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-thermal-water-extraction-2", "chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-ore-powderizer", "chemical-science-pack", "omni-pack")
    end

    if mods["angelslogistics"] then
        omni.lib.add_science_pack("cangels-argo-robots-2", "omni-pack")
    end

    if mods["angelspetrochem"] then
        omni.lib.replace_science_pack("angels-advanced-gas-processing","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-advanced-oil-processing","chemical-science-pack", "omni-pack")
        omni.lib.add_science_pack("angels-advanced-chemistry-2", "omni-pack")
        omni.lib.add_science_pack("angels-gas-steam-cracking-1", "omni-pack")
        omni.lib.add_science_pack("angels-oil-steam-cracking-1", "omni-pack")
        omni.lib.add_science_pack("angels-nitrogen-processing-2", "omni-pack")
        omni.lib.add_science_pack("angels-chlorine-processing-2", "omni-pack")
    end

    if mods["angelssmelting"] then
        omni.lib.replace_science_pack("angels-aluminium-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-bronze-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-copper-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-iron-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-nitinol-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-steel-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-tin-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-solder-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-lead-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-silver-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-zinc-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-chrome-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-cobalt-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-manganese-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-nickel-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-silicon-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-titanium-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-tungsten-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-platinum-smelting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-glass-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-stone-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-metallurgy-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-metallurgy-4","utility-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-powder-metallurgy-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-strand-casting-2","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-thermal-water-extraction","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-ore-advanced-floatation","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("omnitech-angels-omnicium-smelting-3","chemical-science-pack", "omni-pack")
        omni.lib.add_science_pack("angels-coolant-1", "omni-pack")

        if mods ["Clowns-Extended-Minerals"] then
            omni.lib.replace_science_pack("clowns-ore-leaching","chemical-science-pack", "omni-pack")
        end
    end

    if mods["angelsbioprocessing"] then
        omni.lib.replace_science_pack("angels-bio-paper-3","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("angels-bio-processing-2","chemical-science-pack", "omni-pack")
        omni.lib.add_science_pack("angels-bio-refugium-fish-1", "omni-pack")
        omni.lib.add_science_pack("angels-bio-processing-paste", "omni-pack")
    end

    --Bobs
    if mods["bobpower"] then
        omni.lib.add_science_pack("bob-solar-energy-2", "omni-pack")
    end

    if mods["bobplates"] then
        omni.lib.add_science_pack("gem-processing-1", "omni-pack")
    end

    if mods["boblogistics"] then
        omni.lib.add_science_pack("bob-fluid-handling-2", "omni-pack")
    end

    --Misc
    if mods["Bio_Industries"] then
        omni.lib.replace_science_pack("bi-advanced-biotechnology","chemical-science-pack", "omni-pack")
        omni.lib.replace_science_pack("bi-organic-plastic","production-science-pack", "omni-pack")
    end

    if mods["Factorissimo2"] then
        omni.lib.replace_science_pack("factory-architecture-t1","chemical-science-pack", "omni-pack")
    end

    --Add Omni SP to all techs that have manually added techs as prereq
    omni.science.omnipack_tech_post_update()
end

omni.science.tech_updates()
