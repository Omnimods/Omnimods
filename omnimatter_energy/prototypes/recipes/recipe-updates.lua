RecGen:import("repair-pack"):
    setNormalIngredients({type="item", name="omnicium-plate", amount=6},{type="item", name="omni-tablet", amount=2}):
    setExpensiveIngredients({type="item", name="omnicium-plate", amount=15},{type="item", name="omni-tablet", amount=7}):
    extend()


if not (mods["angelsindustries"] and angelsmods.industries.components) then
    omni.lib.add_recipe_ingredient("electric-furnace", {"steel-furnace", 1})

    --Add omnitors to various recipes
    --omnitors are generally added to all burner/non-electric buildings that have "moving" parts
    omni.lib.add_recipe_ingredient("gun-turret",{"omnitor",4})
    omni.lib.add_recipe_ingredient("engine-unit",{"omnitor",1})
    omni.lib.replace_recipe_ingredient("offshore-pump", component["circuit"][1], {"omnitor",4})
    omni.lib.replace_recipe_ingredient("burner-omnitractor", "omnicium-gear-wheel", {"omnitor",2})
    omni.lib.replace_recipe_ingredient("burner-omniphlog", "omnicium-gear-wheel", {"omnitor",5})

    --anbaric omnitor
    --anbaric omnitors are generally added to all first tier electric buildings that have "moving" parts
    omni.lib.replace_recipe_ingredient("assembling-machine-1", "iron-gear-wheel", {"anbaric-omnitor",4})
    omni.lib.add_recipe_ingredient("radar",{"anbaric-omnitor",2})
    omni.lib.add_recipe_ingredient("lab",{"anbaric-omnitor",4})
    omni.lib.add_recipe_ingredient("centrifuge",{"anbaric-omnitor",25})
    omni.lib.add_recipe_ingredient("artillery-turret",{"anbaric-omnitor",15})
    omni.lib.add_recipe_ingredient("artillery-wagon",{"anbaric-omnitor",15})
    omni.lib.add_recipe_ingredient("laser-turret",{"anbaric-omnitor",8})
    omni.lib.add_recipe_ingredient("electric-engine-unit",{"anbaric-omnitor",2})
    omni.lib.replace_recipe_ingredient("omnitractor-1", component["circuit"][1], {"anbaric-omnitor",2})
    omni.lib.replace_recipe_ingredient("omniphlog-1", "iron-plate", {"anbaric-omnitor",5})

    if mods["omnimatter_crystal"] then
        omni.lib.replace_recipe_ingredient("burner-omniplant", "iron-gear-wheel", {"omnitor",2})

        omni.lib.replace_recipe_ingredient("omniplant-1", "iron-gear-wheel", {"anbaric-omnitor",2})
        omni.lib.replace_recipe_ingredient("crystallomnizer-1", "iron-gear-wheel", {"anbaric-omnitor",2})
    end
end

--Stuff to manually remove from the Omnitor Lab
local packs = {
    "token-bio"
}

for i,inputs in pairs(data.raw["lab"]["omnitor-lab"].inputs) do
    for _,pack in pairs(packs) do
        if inputs == pack then
            table.remove(data.raw["lab"]["omnitor-lab"].inputs,i, pack)
        end
    end
end