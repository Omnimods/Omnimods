local function call_remote_functions()
    --DiscoScience
    if game.active_mods["omnimatter_crystal"] and remote.interfaces["DiscoScience"] and remote.interfaces["DiscoScience"]["setIngredientColor"] then
        remote.call("DiscoScience", "setIngredientColor", "omni-pack", {r = 0.8, g = 0.1, b = 0.8})
        if not game.active_mods["Krastorio2"] then
            remote.call("DiscoScience", "setIngredientColor", "production-science-pack", {r = 0.8, g = 0.41, b = 0.0})
        end
    end
end

--------------------------------------------------------------------

script.on_init(call_remote_functions)
script.on_configuration_changed(call_remote_functions)