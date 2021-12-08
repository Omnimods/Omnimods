--Find mining operations if mining-drones is active
-- if mods["Mining_Drones"] then  --well this does nothing as far as i can tell... :(
--     omni.fluid.excempt_assembler("mining-depot")
--     omni.fluid.excempt_assembler("mining-drone")
--     for _,rec in pairs(data.raw.recipe) do
--         if string.find(rec.name,"mine-") and string.find(rec.name,"-with-") then
--             log(rec.name)
--             omni.fluid.excempt_recipe(rec.name)
--         end
--     end
-- end

--Add pys combustion mixture as special fluid, need conversion recipes for all added temperatures since its created in assemblers
omni.fluid.add_assembler_generator_fluid("combustion-mixture1")


require("prototypes.sluids-generation")
require("prototypes.offshore-pump")