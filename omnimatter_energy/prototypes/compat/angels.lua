--Dont mess with recipes when angels component mode is active
local nocomps = true
if mods["angelsindustries"] and angelsmods.industries.components then
    nocomps = false
end


if mods["angelsrefining"] and nocomps then
    --Non component recipe part
    if nocomps then
        RecGen:import("burner-ore-crusher"):
            setIngredients({type="item", name="omnite-brick", amount=4},
            {type="item", name="iron-plate", amount=4},
            {type="item", name="omnitor", amount=1}):
            extend()
        
        RecGen:import("ore-sorting-facility"):
            setIngredients({type="item", name="omnite-brick", amount=30},
            {type="item", name="iron-plate", amount=15},
            {type="item", name="anbaric-omnitor", amount=5}):
            setTechPrereq("omnitech-anbaricity"):
            extend()

        omni.lib.add_prerequisite("ore-crushing", "omnitech-anbaricity")

        omni.lib.add_recipe_ingredient("ore-crusher", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("ore-floatation-cell", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("ore-leaching-plant", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("ore-refinery", {"anbaric-omnitor", 8})
        omni.lib.add_recipe_ingredient("ore-powderizer", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("electro-whinning-cell", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("thermal-bore", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("filtration-unit", {"anbaric-omnitor", 3})
        omni.lib.add_recipe_ingredient("hydro-plant", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("clarifier", {"anbaric-omnitor", 1})
        omni.lib.add_recipe_ingredient("salination-plant", {"anbaric-omnitor", 5})
        omni.lib.add_recipe_ingredient("seafloor-pump", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("washing-plant", {"anbaric-omnitor", 4})
        omni.lib.add_recipe_ingredient("ground-water-pump", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("barreling-pump", {"anbaric-omnitor", 2})
    end
end


if mods["angelssmelting"] then
    omni.lib.add_prerequisite("angels-metallurgy-1", "omnitech-basic-omnium-power")
    --Non component recipe part
    if nocomps then
        omni.lib.add_recipe_ingredient("ore-processing-machine", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("pellet-press", {"anbaric-omnitor", 3})
        omni.lib.add_recipe_ingredient("powder-mixer", {"anbaric-omnitor", 2})
    end
end

if mods["angelsbioprocessing"] then
    omni.lib.set_prerequisite("bio-processing-brown", "automation-science-pack")
    --Non component recipe part
    if nocomps then
        omni.lib.add_recipe_ingredient("algae-farm", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("seed-extractor", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("bio-processor", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("bio-press", {"anbaric-omnitor", 2})
        omni.lib.add_recipe_ingredient("nutrient-extractor", {"anbaric-omnitor", 3})
    end
end