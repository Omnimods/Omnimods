RecGen:import("repair-pack"):
    setNormalIngredients({type="item", name="omnicium-plate", amount=6},{type="item", name="omni-tablet", amount=2}):
    setExpensiveIngredients({type="item", name="omnicium-plate", amount=15},{type="item", name="omni-tablet", amount=7}):
    extend()


omni.lib.add_recipe_ingredient("electric-furnace", {"steel-furnace", 1})

--Add omnitors to various recipes
--omnitor
omni.lib.add_recipe_ingredient("gun-turret",{"omnitor",4})
omni.lib.add_recipe_ingredient("engine-unit",{"omnitor",1})
omni.lib.replace_recipe_ingredient("offshore-pump", "electronic-circuit", {"omnitor",4})

--anbaric omnitor
omni.lib.replace_recipe_ingredient("assembling-machine-1", "iron-gear-wheel", {"anbaric-omnitor",4})
omni.lib.add_recipe_ingredient("radar",{"anbaric-omnitor",2})
omni.lib.add_recipe_ingredient("lab",{"anbaric-omnitor",4})
omni.lib.add_recipe_ingredient("centrifuge",{"anbaric-omnitor",25})
omni.lib.add_recipe_ingredient("artillery-turret",{"anbaric-omnitor",15})
omni.lib.add_recipe_ingredient("artillery-wagon",{"anbaric-omnitor",15})
omni.lib.add_recipe_ingredient("laser-turret",{"anbaric-omnitor",8})
omni.lib.add_recipe_ingredient("electric-engine-unit",{"anbaric-omnitor",2})

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