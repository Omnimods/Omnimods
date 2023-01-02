if mods["omnimatter_compression"] then
    omni.fluid.add_boiler_fluid("concentrated-steam")
end

if mods["pyalternativeenergy"] then
    omni.fluid.excempt_boiler("solar-tower-building")
    omni.fluid.add_multi_temp_recipe("nano-cellulose")
    omni.fluid.add_assembler_generator_fluid("pressured-steam")
end

if mods["pycoalprocessing"] then
    --Add pys combustion mixture as special fluid, need conversion recipes for all added temperatures since its created in assemblers
    omni.fluid.add_assembler_generator_fluid("combustion-mixture1")
    --Kind of a voiding recipe for steam, need copies for each solid steam temperature
    omni.fluid.add_multi_temp_recipe("cooling-water")
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

if mods["pyrawores"] then
    local multitemprecs = {
        "arqad",
        "oil-breakdown-2",
        "tar-breakdown-2",
        "quensch-ovengas",
        "reheat-coke-gas",
        "outlet-gas-01",
        "coke-oven-gas-pyvoid-gas"
    }
    for _, rec in pairs(multitemprecs) do
        omni.fluid.add_multi_temp_recipe(rec)
    end
end

if mods["angelspetrochem"] then
    -- Add the fluid conversions to angels electric boilers
    local boilers = {"angels-electric-boiler", "angels-electric-boiler-2", "angels-electric-boiler-3"}
    for _, b in pairs(boilers) do
        local boiler = data.raw["assembling-machine"][b]
        local cats = {}
        if boiler and boiler.crafting_category then
            cats = {boiler.crafting_category}
            boiler.crafting_category = nil
        elseif boiler and boiler.crafting_categories then
            cats = boiler.crafting_categories
        end
        cats[#cats+1] = "general-omni-boiler"
        boiler.crafting_categories = cats
    end
end

if mods["angelssmelting"] then
    omni.fluid.add_multi_temp_recipe("coolant-cool-steam")
end

if mods["space-exploration"] then
    --Exclude the hidden SE generators since their steam "fuel" is a hidden fluid
    omni.fluid.excluded_strings[#omni.fluid.excluded_strings+1] = {"se", "condenser", "turbine", "generator"}
    omni.fluid.excluded_strings[#omni.fluid.excluded_strings+1] = {"se", "big", "turbine", "generator"}
end