if mods["angelsrefining"] then
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
end

if mods["angelssmelting"] then
    omni.lib.add_prerequisite("angels-metallurgy-1", "omnitech-basic-omnium-power")
end	