RecGen:create("omnimatter_energy","energy-science-pack"):
    tool():
    setStacksize(200):
    setDurability(1):
    setIcons({{icon = "energy-science-pack", icon_size = 64}}, "omnimatter_energy"):
    setDurabilityDesc("description.science-pack-remaining-amount"):
    setEnergy(5):
    addProductivity():
    setIngredients({
        {type = "item", name = "omnicium-plate", amount = 2},
        {type = "item", name = "burner-inserter", amount = 1}
    }):
    setSubgroup("science-pack"):
    setCategory("crafting"):
    setOrder("a[aa-energy-science-pack]"):
    setEnabled(true):
    extend()

--Add the energy SP to all labs that accept the automation Sp aswell (dont mess up late game labs!)
for _,lab in pairs(data.raw["lab"]) do
    if omni.lib.is_in_table("automation-science-pack", lab.inputs) then
        table.insert(lab.inputs, 1, "energy-science-pack")
    end
end