RecGen:create("omnimatter_energy","energy-science-pack"):
    tool():
    setStacksize(200):
    setDurability(1):
    setIcons({{icon = "energy-science-pack", icon_size = 64}}, "omnimatter_energy"):
    setDurabilityDesc("description.science-pack-remaining-amount"):
    setEnergy(5):
    addProductivity():
    setIngredients({
        {type = "item", name = "omnicium-plate", amount = 1},
        {type = "item", name = "omnitor", amount = 1}
    }):
    setSubgroup("science-pack"):
    setCategory("crafting"):
    setOrder("a[aa-energy-science-pack]"):
    setEnabled(true):
    extend()

omni.lib.set_recipe_ingredients("automation-science-pack" ,{"burner-inserter",1}, {"copper-plate", 1})

--Add the energy SP to all labs that accept the automation Sp aswell (dont mess up late game labs!)
for _,lab in pairs(data.raw["lab"]) do
    if omni.lib.is_in_table("automation-science-pack", lab.inputs) then
        table.insert(lab.inputs, 1, "energy-science-pack")
    end
end