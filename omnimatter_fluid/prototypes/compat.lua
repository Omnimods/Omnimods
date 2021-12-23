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
if mods["pycoalprocessing"] then
    omni.fluid.add_assembler_generator_fluid("combustion-mixture1")
    omni.fluid.add_multi_temp_recipe("cooling-water")
end

--Excempt pys drilling-fluids recipe. hidden Assembler with that fixed recipe to allow multi fluid mining
--The drilling fluids need to be manually registered as mining fluids since the assembler/script consumes them
if mods["pypetroleumhandling"] then
    omni.fluid.excempt_recipe("drilling-fluids")
    omni.fluid.add_mining_fluid("drilling-fluid-0")
    omni.fluid.add_mining_fluid("drilling-fluid-1")
    omni.fluid.add_mining_fluid("drilling-fluid-2")
    omni.fluid.add_mining_fluid("drilling-fluid-3")
end