require("prototypes.recipes.fuel-fixes")


--for _,loco in pairs(data.raw.locomotive) do
--	if loco.burner and loco.burner.fuel_category == "chemical" then
--		loco.burner.effectivity = loco.burner.effectivity*0.5
--	end
--end


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