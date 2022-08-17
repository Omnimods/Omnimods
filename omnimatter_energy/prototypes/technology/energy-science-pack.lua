RecGen:create("omnimatter_energy","energy-science-pack"):
    tool():
    setStacksize(200):
    setDurability(1):
    setIcons({{icon = "energy-science-pack", icon_size = 64}}, "omnimatter_energy"):
    setDurabilityDesc("description.science-pack-remaining-amount"):
    setEnergy(5):
    addProductivity():
    setIngredients({{"omnicium-plate", 2}, {"omnite-brick", 1}}):
    setSubgroup("science-pack"):
    setCategory("crafting"):
    setOrder("a[aa-energy-science-pack]"):
    setEnabled(true):
    extend()

--Modify the automation science pack
--Since the gear wheel replacement makes it cheaper, we can fix that by replacing the copper plate with omnium
omni.lib.replace_recipe_ingredient("automation-science-pack", "iron-gear-wheel", {"omnitor",1})
omni.lib.replace_recipe_ingredient("automation-science-pack", "copper-plate", "omnium-plate")

--Add the energy SP to all labs that accept the automation Sp aswell (dont mess up late game labs!)
for _,lab in pairs(data.raw["lab"]) do
    if omni.lib.is_in_table("automation-science-pack", lab.inputs) then
        table.insert(lab.inputs, 1, "energy-science-pack")
    end
end