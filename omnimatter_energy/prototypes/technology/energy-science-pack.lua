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
	setOrder("aa[energy-science-pack]"):
	setEnabled(true):
    extend()