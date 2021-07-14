require("prototypes.recipes.fuel-fixes")


--for _,loco in pairs(data.raw.locomotive) do
--	if loco.burner and loco.burner.fuel_category == "chemical" then
--		loco.burner.effectivity = loco.burner.effectivity*0.5
--	end
--end

--TODO bob compat?
omni.lib.add_recipe_ingredient("wooden-board", {normal = {"omni-tablet",1}, expensive = {"omni-tablet",2}})
omni.lib.add_unlock_recipe("omnitech-anbaricity", "wooden-board")


--Move all behind energy- pack? TODO

-- -- Techs to not move behind anbaricity - usually startup techs by other mods that have custom compat
-- local noloops = {
-- 	"sb-startup1",
-- 	"sb-startup2", 
-- 	"sb-startup3",
-- 	"sct-automation-science-pack"
-- }

-- --Find all remaining Techs without any prereqs that unlock entities that require electricity and move them behind anbaricity
-- for _,tech in pairs(data.raw.technology) do 
-- 	local ent
-- 	if tech.effects and (tech.prerequisites == nil or next(tech.prerequisites) == nil) and not omni.lib.is_in_table(tech.name, noloops) then
-- 		for _,eff in pairs(tech.effects) do
-- 			if eff.type == "unlock-recipe" then
-- 				ent = omni.lib.find_entity_prototype(eff.recipe)
-- 				if ent and ent.energy_source and ent.energy_source.type == "electric" then
-- 					omni.lib.add_prerequisite(tech.name, "omnitech-anbaricity")
-- 				end
-- 			end
-- 		end
-- 	end
-- end

--Add all normal lab inputs to bobs burner lab since its a steam lab now (Needs to be in final fixes)
if mods["bobtech"] and settings.startup["bobmods-burnerphase"].value then
	for _,input in pairs(data.raw["lab"]["lab"].inputs) do
		local new_inputs = data.raw["lab"]["burner-lab"].inputs 
		if not omni.lib.is_in_table(input,new_inputs) then
			new_inputs[#new_inputs+1] = input
		end
	end
end

-- --Make sure there are no leftover techs that prereq logistics (hidden without bobs belts)
-- --Want to make sure we reuse that in the future to avoid these fixes
-- if data.raw.technology["omnitech-belt-logistics"] then
-- 	for _,tech in pairs(data.raw.technology) do
-- 		if tech.prerequisites and omni.lib.is_in_table("logistics", tech.prerequisites) then
-- 			omni.lib.replace_prerequisite(tech.name, "logistics", "omnitech-belt-logistics")
-- 		end
-- 	end
-- end