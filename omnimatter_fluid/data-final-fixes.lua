omni.fluid.excempt_boiler("crystal-reactor")
omni.fluid.excempt_boiler("burner-turbine")
omni.fluid.excempt_boiler("burner-generator")
--Find mining operations if mining-drones is active
if mods["Mining_Drones"] then  --well this does nothing as far as i can tell... :(
    omni.fluid.excempt_assembler("mining-depot")
    omni.fluid.excempt_assembler("mining-drone")
    for _,rec in pairs(data.raw.recipe) do
        if string.find(rec.name,"mine-") and string.find(rec.name,"-with-") then
            log(rec.name)
            omni.fluid.excempt_recipe(rec.name)
        end
    end
end

require("prototypes.sluids-generation")