--Find mining operations if mining-drones is active
if mods["Mining_Drones"] then
    for _,rec in pairs(data.raw.recipe) do
        if rec.category == "mining-depot" and string.find(rec.name,"mine%-") then
            --log("Excluded recipe "..rec.name)
            omni.fluid.excempt_recipe(rec.name)
        end
    end
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

if mods["omnimatter_compression"] then
    omni.fluid.add_boiler_fluid("concentrated-steam")
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