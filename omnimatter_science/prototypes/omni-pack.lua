if mods["omnimatter_crystal"] then
	RecGen:create("omnimatter_science","omni-pack"):
		tool():
		setStacksize(200):
		setDurability(1):
		setIcons("__base__/graphics/icons/production-science-pack.png"):
		setDurabilityDesc("description.science-pack-remaining-amount"):
		setEnergy(5):
		addProductivity():
		setIngredients({
			{type = "item", name = "fast-transport-belt", amount = 1},
			{type = "item", name = "iron-ore-crystal", amount = 2},
			{type = "fluid", name = "omniston", amount = 50}
		}):
		setSubgroup("science-pack"):
		setCategory("crafting-with-fluid"):
		setOrder("ca[omni-science-pack]"):
		setTechName("omnipack-technology"):
		setTechCost(150):
		setTechIcon("omnipack-tech"):
		setTechPacks(2):
		setTechPrereq("omnitractor-electric-2"):
		setTechTime(20):
		extend()
		
	TechGen:import("chemical-science-pack"):addPrereq("omnipack-technology"):extend()

	if data.raw.tool["production-science-pack"].icon == "__base__/graphics/icons/production-science-pack.png" then --only replace if vanilla icon?
	  data.raw.tool["production-science-pack"].icon = "__omnilib__/graphics/icons/science-pack/production-science-pack.png"
	  data.raw.technology["production-science-pack"].icon = "__omnilib__/graphics/technology/production-science-pack.png"
	  data.raw.tool["production-science-pack"].icon_size=64
	  data.raw.recipe["production-science-pack"].icon_size=64
	  data.raw.tool["omni-pack"].icon_size=64
	end
end