--Find mining operations if mining-drones is active
if mods["Mining_Drones"] then
    for _,rec in pairs(data.raw.recipe) do
        if rec.category == "mining-depot" and string.find(rec.name,"mine%-") then
            --log("Excluded recipe "..rec.name)
            omni.fluid.excempt_recipe(rec.name)
        end
    end
end

--Add pys combustion mixture as special fluid, need conversion recipes for all added temperatures since its created in assemblers
if mods["pycoalprocessing"] and data.raw.fluid["combustion-mixture1"] then
    omni.fluid.add_assembler_generator_fluid("combustion-mixture1")
    omni.fluid.add_multi_temp_recipe("cooling-water")
end


--Late requires
require("prototypes.sluids-generation")
require("prototypes.offshore-pump")