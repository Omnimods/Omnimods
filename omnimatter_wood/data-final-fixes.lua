--omni.lib.add_prerequisite("omnimutator", "omnitech-omnic-hydrolyzation-1")

if mods["bobgreenhouse"] then
	omni.lib.remove_recipe_all_techs("bob-seedling")
	omni.lib.add_prerequisite("bob-greenhouse","omnitech-omnimutator")
	omni.lib.remove_recipe_all_techs("basic-wood-mutation")
	omni.lib.remove_recipe_all_techs("improved-wood-mutation")
	--omni.lib.add_unlock_recipe("omnitech-omnimutator","omniseedling")
	--omni.lib.replace_recipe_all_techs("bob-basic-greenhouse-cycle","basic-omniwood-growth")
	--omni.lib.replace_recipe_all_techs("bob-advanced-greenhouse-cycle","fertilized-omniwood-growth")
	omni.lib.remove_recipe_all_techs("bob-basic-greenhouse-cycle")
	omni.lib.remove_recipe_all_techs("bob-advanced-greenhouse-cycle")
end

if settings.startup["omniwood-pure-wood-only"].value then
	if mods["bobelectronics"] then
		omni.lib.remove_recipe_all_techs("synthetic-wood")
		omni.lib.remove_recipe_all_techs("bob-resin-wood")
	end
end

if settings.startup["omniwood-all-mutated"].value then
	for _,tree in pairs(data.raw.tree) do
		local i_path = tree.icon or (tree.icons and tree.icons[1] and (tree.icons[1].icon or tree.icons[1][1]))
		if not string.find(i_path,"angelsbioprocessing") then
			if tree.minable then
				if tree.minable.result then
					tree.minable.result="omniwood"
				elseif tree.minable.results then
					tree.minable.results[1].name="omniwood"
				end
			end
		end
	end
end

if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("omnic-waste")
	omni.marathon.exclude_recipe("waste-mutation")
end

--[[if mods["pycoalprocessing"] then --needs a re-work, the add module restrictions scrip in py is failing with this running
	local pylog = {"log1", "log2", "log3", "log4", "log5", "log6", "log-organics", "log-wood"}
	for _, p in pairs(pylog) do
		omni.lib.remove_recipe_all_techs(p)
		data.raw.recipe[p] = nil
	end
	omni.lib.remove_recipe_all_techs("botanical-nursery")
	data.raw.recipe["botanical-nursery"] = nil
end]]
