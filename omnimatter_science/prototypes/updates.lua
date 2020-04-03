if mods["angelsbioprocessing"] then
	omni.lib.add_unlock_recipe("bio-farm","temperate-garden-cultivating-b")
	omni.lib.add_unlock_recipe("bio-farm","desert-garden-cultivating-b")
	omni.lib.add_unlock_recipe("bio-farm","swamp-garden-cultivating-b")
end
if mods["omnimatter_crystal"] then
	omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "fast-transport-belt", amount = 1})
	omni.lib.add_recipe_ingredient("omni-pack",{type = "fluid", name = "omniston", amount = 50})
	omni.lib.change_recipe_category("omni-pack","crafting-with-fluid")
	omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "iron-ore-crystal", amount = 2})
	if not mods["omnimatter_research"] then
		if mods["boblogistics"] and settings.startup["bobmods-logistics-inserteroverhaul"].value == true then
			omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "long-handed-inserter", amount = 1})
		else
			omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "fast-inserter", amount = 1})
		end
	end
	omni.lib.remove_science_pack("crystallonics-4","utility-science-pack")
	omni.lib.add_recipe_ingredient("chemical-science-pack","basic-crystallonic")
	omni.lib.add_recipe_ingredient("production-science-pack","basic-oscillo-crystallonic")
	omni.lib.add_recipe_ingredient("utility-science-pack","basic-oscillo-crystallonic")
	omni.lib.replace_science_pack("advanced-ore-refining-3","chemical-science-pack")
	omni.lib.replace_science_pack("ore-leaching","chemical-science-pack")
	omni.lib.replace_science_pack("crystallonics-1","chemical-science-pack")
	if mods["omnimatter_wood"] then omni.lib.replace_science_pack("omnimutator-2","chemical-science-pack") end
	omni.lib.add_science_pack("electric-engine")
	omni.lib.add_science_pack("plastics")
	if mods["angelslogistics"] then	omni.lib.add_science_pack("cargo-robots-2")	end
	if mods["Factorissimo2"] then	omni.lib.replace_science_pack("factory-architecture-t1","chemical-science-pack") end
	if mods["angelspetrochem"] then
		omni.lib.add_science_pack("angels-advanced-chemistry-2")
		omni.lib.add_science_pack("gas-steam-cracking-1")
		omni.lib.add_science_pack("oil-steam-cracking-1")
		omni.lib.replace_science_pack("angels-nitrogen-processing-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-nitrogen-processing-4","production-science-pack")
		omni.lib.replace_science_pack("chlorine-processing-2","chemical-science-pack")
	end
	if mods["omnimatter_compression"] then	omni.lib.replace_science_pack("compression-initial","chemical-science-pack") end
	if mods["Bio_Industries"] then
		omni.lib.replace_science_pack("bi-advanced-biotechnology","chemical-science-pack")
		omni.lib.replace_science_pack("bi-organic-plastic","production-science-pack")
	end
	if mods["angelssmelting"] then
		omni.lib.replace_science_pack("angels-aluminium-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-copper-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-iron-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-steel-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-tin-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-solder-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-lead-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-silver-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-zinc-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-chrome-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-cobalt-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-manganese-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-nickel-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-silicon-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-gold-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-titanium-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-tungsten-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-glass-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-cement-processing-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-metallurgy-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-metallurgy-4","utility-science-pack")
		omni.lib.replace_science_pack("thermal-water-extraction","chemical-science-pack")
		omni.lib.replace_science_pack("ore-advanced-floatation","chemical-science-pack")
		omni.lib.add_science_pack("advanced-metallurgy-1")
		omni.lib.add_science_pack("angels-coolant-1")
		omni.lib.replace_science_pack("water-treatment-2","logistic-science-pack")
	end
	if mods["angelsrefining"] then omni.lib.replace_science_pack("ore-processing-2","chemical-science-pack")	end
	if mods["omnimatter_wood"] then	omni.lib.replace_science_pack("omnimutator-2","chemical-science-pack")	end
	if mods["bobpower"] then	omni.lib.add_science_pack("bob-solar-energy-2")	end
	if mods["bobplates"] then	omni.lib.add_science_pack("gem-processing-1")	end
	omni.lib.replace_science_pack("rocket-damage-3","chemical-science-pack")
	omni.lib.replace_science_pack("crystallology-2","chemical-science-pack")
	omni.lib.replace_science_pack("military-3","chemical-science-pack")
	omni.lib.replace_science_pack("mining-productivity-4","chemical-science-pack")
	omni.lib.replace_science_pack("mining-productivity-8","production-science-pack")
	omni.lib.replace_science_pack("mining-productivity-12","utility-science-pack")
	omni.science.tech_post_find_update()
end
omni.science.tech_updates()
