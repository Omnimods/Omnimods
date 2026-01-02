--Dont mess with recipes when angels component mode is active
local nocomps = true
if mods["angelsindustries"] and angelsmods.industries.components then
    nocomps = false
end


if mods["angelsrefining"] and nocomps then
    --Non component recipe part
    if nocomps then
        RecGen:import("angels-burner-ore-crusher"):
            setIngredients({type="item", name="omnite-brick", amount=4},
            {type="item", name="iron-plate", amount=4},
            {type="item", name="omnitor", amount=1}):
            extend()
        
        RecGen:import("angels-ore-sorting-facility"):
            setIngredients({type="item", name="omnite-brick", amount=30},
            {type="item", name="iron-plate", amount=15},
            {type="item", name="anbaric-omnitor", amount=5}):
            setTechPrereq("omnitech-anbaricity"):
            extend()

        omni.lib.add_prerequisite("angels-ore-crushing", "omnitech-anbaricity")

        omni.lib.add_recipe_ingredient("angels-ore-crusher", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("angels-ore-floatation-cell", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("angels-ore-leaching-plant", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("angels-ore-refinery", {"anbaric-omnitor", 8})
        omni.lib.add_recipe_ingredient("angels-ore-powderizer", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-electro-whinning-cell", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-thermal-bore", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("angels-filtration-unit", {"anbaric-omnitor", 3})
        omni.lib.add_recipe_ingredient("angels-hydro-plant", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("angels-clarifier", {"anbaric-omnitor", 1})
        omni.lib.add_recipe_ingredient("angels-salination-plant", {"anbaric-omnitor", 5})
        omni.lib.add_recipe_ingredient("angels-seafloor-pump", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-washing-plant", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("angels-ground-water-pump", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-barreling-pump", {"anbaric-omnitor", 2})
    end
end


if mods["angelssmelting"] then
    omni.lib.add_prerequisite("angels-metallurgy-1", "omnitech-basic-omnium-power")
    --Non component recipe part
    if nocomps then
        omni.lib.add_recipe_ingredient("angels-ore-processing-machine", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-pellet-press", {"anbaric-omnitor", 3})
        omni.lib.add_recipe_ingredient("angels-powder-mixer", {"anbaric-omnitor", 2})
    end
end

if mods["angelsbioprocessing"] then
    omni.lib.set_prerequisite("angels-bio-processing-brown", "automation-science-pack")
    --Non component recipe part
    if nocomps then
        omni.lib.add_recipe_ingredient("angels-algae-farm", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-seed-extractor", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-bio-processor", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-bio-press", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("angels-nutrient-extractor", {"anbaric-omnitor", 3})
    end
end