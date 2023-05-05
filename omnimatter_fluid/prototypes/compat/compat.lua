if mods["omnimatter_compression"] then
    omni.fluid.add_boiler_fluid("concentrated-steam")
end

if mods["pyalternativeenergy"] then
    omni.fluid.excempt_boiler("solar-tower-building")
end

if mods["pypetroleumhandling"] then
    --Excempt pys drilling-fluids recipe. hidden Assembler with that fixed recipe to allow multi fluid mining
    --The drilling fluids need to be manually registered as mining fluids since the assembler/script consumes them
    omni.fluid.excempt_recipe("drilling-fluids")
    omni.fluid.add_mining_fluid("drilling-fluid-0")
    omni.fluid.add_mining_fluid("drilling-fluid-1")
    omni.fluid.add_mining_fluid("drilling-fluid-2")
    omni.fluid.add_mining_fluid("drilling-fluid-3")
end

if mods["space-exploration"] then
    --Exclude the hidden SE generators since their steam "fuel" is a hidden fluid
    omni.fluid.excluded_strings[#omni.fluid.excluded_strings+1] = {"se", "condenser", "turbine", "generator"}
    omni.fluid.excluded_strings[#omni.fluid.excluded_strings+1] = {"se", "big", "turbine", "generator"}
end