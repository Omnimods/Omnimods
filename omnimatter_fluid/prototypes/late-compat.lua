if mods["pyalienlife"] then
    --Barrel names are messed up in PY 1.3.4. This can be removed once py updates
    local milk_rec = "korlex-milk-"
    omni.lib.multiply_recipe_result()
    for i = 1, 4, 1 do
        omni.lib.remove_recipe_ingredient(milk_rec..i, "empty-barrel-milk")
        omni.lib.multiply_recipe_result(milk_rec..i, "barrel-milk", omni.fluid.sluid_contain_fluid)
        omni.lib.replace_recipe_result(milk_rec..i, "barrel-milk", "solid-milk")
    end
end