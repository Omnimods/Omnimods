--Loaders Modernized compatibility
--(The Chute recipe is based on basic belt ingredients (mostly just iron), so we need to add omnitors to that recipe aswell)
if data.raw.recipe["chute-mdrn-loader"] then
    omni.lib.add_recipe_ingredient("chute-mdrn-loader",{type = "item", name ="omnitor", amount = 2})
    omni.lib.add_science_pack("mdrn-loader","logistic-science-pack")
end