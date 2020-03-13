--[[data:extend({
  {
    type = "tool",
    name = "omni-pack",
    icon = "__base__/graphics/icons/production-science-pack.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "science-pack",
    order = "a[science-pack-1]",
	icon_size = 32,
    stack_size = 200,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount"
  },
  {
	type = "recipe",
	name = "omni-pack",
	enabled = false,
	ingredients = {
	},
	order = "a[angelsore1-crushed]",
	icon = "__base__/graphics/icons/production-science-pack.png",
	results = {{type = "item", name = "omni-pack", amount=1}},
	energy_required = 5,
	icon_size = 32,
	},
})]]
if mods["omnimatter_crystal"] then
	RecGen:create("omnimatter_science","omni-pack"):
		tool():
		setStacksize(200):
		setDurability(1):
		setIcons("__base__/graphics/icons/production-science-pack.png"):
		setDurabilityDesc("description.science-pack-remaining-amount"):
		setEnergy(5):
		addProductivity():
		setTechName("omnipack-technology"):
		setTechCost(150):
		setTechIcon("omnipack-tech"):
		setTechPacks(2):
		setTechPrereq("omnitractor-electric-2"):
		setTechTime(20):
		extend()
		
	TechGen:import("chemical-science-pack"):addPrereq("omnipack-technology"):extend()
end