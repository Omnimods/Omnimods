--omni.lib.add_prerequisite("omnimutator", "omnitech-omnic-hydrolyzation-1")
if bobmods and bobmods.electronics then omni.lib.add_recipe_ingredient("omnimutator",{"basic-circuit-board",2}) end



if mods["bobgreenhouse"] then
	omni.lib.remove_recipe_all_techs("bob-seedling")
	omni.lib.add_prerequisite("bob-greenhouse","omnimutator")
	omni.lib.remove_recipe_all_techs("basic-wood-mutation")
	omni.lib.remove_recipe_all_techs("improved-wood-mutation")
	--omni.lib.add_unlock_recipe("omnimutator","omniseedling")
	--omni.lib.replace_recipe_all_techs("bob-basic-greenhouse-cycle","basic-omniwood-growth")
	--omni.lib.replace_recipe_all_techs("bob-advanced-greenhouse-cycle","fertilized-omniwood-growth")
	omni.lib.remove_recipe_all_techs("bob-basic-greenhouse-cycle")
	omni.lib.remove_recipe_all_techs("bob-advanced-greenhouse-cycle")
end

if mods["bobplates"] then
	omni.lib.replace_recipe_ingredient("omnimutator","copper-plate","glass")
end

if settings.startup["omniwood-pure-wood-only"].value then
	if mods["bobelectronics"] then
		omni.lib.remove_recipe_all_techs("synthetic-wood")
		omni.lib.remove_recipe_all_techs("bob-resin-wood")
	end
end	

if settings.startup["omniwood-all-mutated"].value then
	for _,tree in pairs(data.raw.tree) do
		if not string.find(tree.icon,"angelsbioprocessing") then
			if tree.minable then 
				if tree.minable.result then
					tree.minable.result="omniwood"
				else
					tree.minable.results[1].name="omniwood"
				end
			end
		end
	end
end

log("Arse")

if mods["angelsbioprocessing"] then
	omni.lib.add_prerequisite("bio-processing-green","omnialgae")
	omni.lib.add_prerequisite("bio-processing-brown","omnialgae")
	
	omni.lib.remove_unlock_recipe("bio-processing-green","algae-farm")
	
	omni.lib.add_recipe_ingredient("algae-green",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-brown",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-red",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-blue",{type="item",name="omnialgae",amount=40})
	
	for i=1,3 do
		local rec = data.raw.recipe["tree-arboretum-"..i]
		omni.marathon.standardise(rec)
		for _,dif in pairs({"normal","expensive"}) do
			rec[dif].results[1].name="omniwood"
			rec[dif].results[1].amount=rec[dif].results[1].amount*4
		end
		omni.lib.replace_recipe_ingredient("tree-arboretum-"..i,"water","omnic-water")
		rec.icons[1].icon = data.raw.item["omniwood"].icons[1].icon
		rec.localised_name = {"item-name.omniwood"}
	end
end

if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("omnic-waste")
	omni.marathon.exclude_recipe("waste-mutation")
end

if mods["pycoalprocessing"] then
	local pylog = {"log1", "log2", "log3", "log4", "log5", "log6", "log-organics", "log-wood"}
	for _, p in pairs(pylog) do
		omni.lib.remove_recipe_all_techs(p)
		data.raw.recipe[p] = nil	
	end
	omni.lib.remove_recipe_all_techs("botanical-nursery")
	data.raw.recipe["botanical-nursery"] = nil
end