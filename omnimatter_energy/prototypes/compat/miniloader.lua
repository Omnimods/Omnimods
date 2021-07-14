--Miniloader compatibility
--(The Chute recipe is based on basic belt ingredients (mostly just iron), so we need to add omnitors to that recipe aswell)
if data.raw.recipe["chute-miniloader"] then
	omni.lib.add_recipe_ingredient("chute-miniloader",{type = "item", name ="omnitor", amount = 2})
	omni.lib.add_science_pack("miniloader","logistic-science-pack")
end