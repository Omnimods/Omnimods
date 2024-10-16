if mods["bobgreenhouse"] then
    omni.lib.remove_recipe_all_techs("bob-seedling")
    omni.lib.add_prerequisite("bob-greenhouse","omnitech-omnimutator")
    omni.lib.remove_recipe_all_techs("basic-wood-mutation")
    omni.lib.remove_recipe_all_techs("improved-wood-mutation")
    --omni.lib.add_unlock_recipe("omnitech-omnimutator","omniseedling")
    --omni.lib.replace_recipe_all_techs("bob-basic-greenhouse-cycle","basic-omniwood-growth")
    --omni.lib.replace_recipe_all_techs("bob-advanced-greenhouse-cycle","fertilized-omniwood-growth")
    omni.lib.remove_recipe_all_techs("bob-basic-greenhouse-cycle")
    omni.lib.remove_recipe_all_techs("bob-advanced-greenhouse-cycle")
end

if settings.startup["omniwood-pure-wood-only"].value then
    if mods["bobelectronics"] then
        omni.lib.remove_recipe_all_techs("synthetic-wood")
        omni.lib.remove_recipe_all_techs("bob-resin-wood")
    end
end

if settings.startup["omniwood-all-mutated"].value then
    for _, tree in pairs(data.raw.tree) do
        if tree.minable then
            if tree.minable.result and tree.minable.result == "wood" then
                tree.minable.result = "omniwood"
            elseif tree.minable.results then
                for _, res in pairs(tree.minable.results) do
                    if res.name == "wood" then
                        res.name = "omniwood"
                    end
                end
            end
        end
    end
end

--[[if mods["pycoalprocessing"] then --needs a re-work, the add module restrictions scrip in py is failing with this running
    local pylog = {"log1", "log2", "log3", "log4", "log5", "log6", "log-organics", "log-wood"}
    for _, p in pairs(pylog) do
        omni.lib.remove_recipe_all_techs(p)
        data.raw.recipe[p] = nil
    end
    omni.lib.remove_recipe_all_techs("botanical-nursery")
    data.raw.recipe["botanical-nursery"] = nil
end]]