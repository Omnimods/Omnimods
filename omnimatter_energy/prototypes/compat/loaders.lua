--Loaders Modernized compatibility
--(The Chute recipe is based on basic belt ingredients (mostly just iron), so we need to add omnitors to that recipe aswell)
if data.raw.recipe["mdrn-chute-loader"] then
    omni.lib.add_recipe_ingredient("mdrn-chute-loader", {type = "item", name = "omnitor", amount = 2})
    omni.lib.add_science_pack("mdrn-loader", "logistic-science-pack")
end

--Miniloader Redux compatibility
--(The Chute recipe uses transport belts replace with basic transport belts)
if data.raw.recipe["hps__ml-chute-miniloader"] then
    omni.lib.replace_recipe_ingredient("hps__ml-chute-miniloader", "transport-belt", "basic-transport-belt")
    omni.lib.add_science_pack("hps__ml-miniloader", "logistic-science-pack")
end
