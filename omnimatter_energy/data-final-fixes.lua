require("prototypes.recipes.fuel-fixes")

--Add all normal lab inputs to bobs burner lab since its a steam lab now (Needs to be in final fixes)
if mods["bobtech"] and settings.startup["bobmods-burnerphase"].value then
    for _,input in pairs(data.raw["lab"]["lab"].inputs) do
        local new_inputs = data.raw["lab"]["burner-lab"].inputs 
        if not omni.lib.is_in_table(input,new_inputs) then
            new_inputs[#new_inputs+1] = input
        end
    end
end