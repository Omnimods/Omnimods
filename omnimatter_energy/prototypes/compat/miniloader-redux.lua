--Miniloader Redux compatibility
--(The Chute recipe is based on basic belt ingredients (mostly just iron), so we need to add omnitors to that recipe aswell)
if data.raw.recipe["chute-mdrn-loader"] then
    --omni.lib.add_recipe_ingredient("hps__ml-chute-miniloader",{type = "item", name ="omnitor", amount = 2})
    omni.lib.replace_recipe_ingredient("hps__ml-chute-miniloader", "transport-belt", "basic-transport-belt")
    --omni.lib.replace_recipe_ingredient("burner-inserter","omnitor","kr-inserter-parts")
    omni.lib.add_science_pack("hps__ml-miniloader","logistic-science-pack")
end