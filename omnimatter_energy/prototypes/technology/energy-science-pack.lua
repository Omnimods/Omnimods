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

--Add it to the vanilla lab inputs
table.insert(data.raw["lab"]["lab"].inputs, 1, "energy-science-pack")
-- --Add all normal lab inputs to bobs burner lab since its a steam lab now (Needs to be in final fixes)
-- if mods["bobtech"] and settings.startup["bobmods-burnerphase"].value then
-- 	for _,input in pairs(data.raw["lab"]["lab"].inputs) do
-- 		local new_inputs = data.raw["lab"]["burner-lab"].inputs 
-- 		if not omni.lib.is_in_table(input,new_inputs) then
-- 			new_inputs[#new_inputs+1] = input
-- 		end
-- 	end
-- end