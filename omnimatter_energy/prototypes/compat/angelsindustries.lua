if mods["angelsindustries"] and angelsmods.industries.components then
    -- Add omnitors to omniblocks
    omni.lib.replace_recipe_ingredient("block-omni-0",component["omniplate"][1],"omnitor")
    omni.lib.replace_recipe_ingredient("block-omni-1",component["omniplate"][1],"anbaric-omnitor")

    omni.lib.set_recipe_ingredients("burner-mining-drill", {type="item", name="stone-furnace", amount=1}, {type="item", name="mechanical-parts", amount=3}, {type="item", name="construction-frame-1", amount=3})

    omni.lib.set_recipe_ingredients("omnitor-assembling-machine", {"block-omni-0", 2}, {"construction-frame-1"})
    omni.lib.set_recipe_ingredients("omnitor-lab", {"block-omni-0", 4}, {"cable-harness-1", 5}, {"omnite-brick", 5})
end