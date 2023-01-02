omni.fluid.forbidden_boilers = {}
omni.fluid.forbidden_assembler = {}
omni.fluid.forbidden_recipe = {}
--Generator fluids that are normally created in an assembling machine. If the results temp is higher than any boiler, we need to ignore the boiler temperature(s) to create conversion recipes
omni.fluid.assembler_generator_fluids = {}
omni.fluid.multi_temp_recipes = {}
omni.fluid.mining_fluids = {}
omni.fluid.boiler_fluids = {}
omni.fluid.excluded_strings = {{"empty","barrel"},{"fill","barrel"},{"empty","canister"},{"fill","canister"},{"fluid","unknown"},"barreling-pump","creative"}

local compression_levels = {"compact","nanite","quantum","singularity"}
if not mods["omnimatter_compression"] then compression_levels = nil end

function omni.fluid.excempt_boiler(boiler_name)
    omni.fluid.forbidden_boilers[boiler_name] = true
    if compression_levels then
        for _, level in pairs(compression_levels) do
            omni.fluid.forbidden_boilers[boiler_name.."-compressed-"..level] = true
        end
    end
end

function omni.fluid.excempt_assembler(assembler_name)
    omni.fluid.forbidden_assembler[assembler_name] = true
    if compression_levels then
        for _, level in pairs(compression_levels) do
            omni.fluid.forbidden_boilers[assembler_name.."-compressed-"..level] = true
        end
    end
end

function omni.fluid.excempt_recipe(recipe_name)
    omni.fluid.forbidden_recipe[recipe_name] = true
    if mods["omnimatter_compression"] then
        omni.fluid.forbidden_recipe[recipe_name.."-compression"] = true
    end
end

function omni.fluid.add_assembler_generator_fluid(fluid_name)
    omni.fluid.assembler_generator_fluids[fluid_name] = true
    local base_name = string.gsub(fluid_name, "solid%-", "")
    if mods["omnimatter_compression"] then
        omni.fluid.forbidden_recipe["solid-concentrated-"..base_name] = true
    end
end

--Adds recipe copies for each available temperature of the sluid ingredients
function omni.fluid.add_multi_temp_recipe(recipe_name)
    omni.fluid.multi_temp_recipes[recipe_name] = true
    if mods["omnimatter_compression"] then
        omni.fluid.multi_temp_recipes[recipe_name.."-compression"] = true
    end
end

--Adds that fluid as mining fluid, converter recipes will be generated
function omni.fluid.add_mining_fluid(fluid_name)
    omni.fluid.mining_fluids[fluid_name] = true
    local base_name = string.gsub(fluid_name, "solid%-", "")
    if mods["omnimatter_compression"] then
        omni.fluid.mining_fluids["solid-concentrated-"..base_name] = true
    end
end

--Adds that fluid as boiler fluid. Required if fluids that are not a boiler output should still be handled like boiler output fluids
function omni.fluid.add_boiler_fluid(fluid_name)
    omni.fluid.boiler_fluids[fluid_name] = true
    local base_name = string.gsub(fluid_name, "solid%-", "")
    if mods["omnimatter_compression"] then
        omni.fluid.boiler_fluids["solid-concentrated-"..base_name] = true
    end
end

function omni.fluid.check_string_excluded(comparison) --checks fluid/recipe name against exclusion list
    for _, str in pairs(omni.fluid.excluded_strings) do
        --deal with multiple values (multi search)
        if type(str) == "table" then
            local check = table_size(str)
            for _,stringy in pairs(str) do
                if string.find(comparison,stringy) then
                    check=check-1
                end
            end
            if check == 0 or nil then
                return true
            end
        elseif string.find(comparison,str) then
            return true
        end
    end
    return false
end

function omni.fluid.has_fluid(recipe)
    for _,ingres in pairs({"ingredients","results"}) do
        for _,component in pairs(recipe.normal[ingres]) do
            if component.type == "fluid" then return true end
        end
    end
    return false
end

function omni.fluid.SetRoundFluidValues()
    local top_value = 500000
    local step = omni.fluid.sluid_contain_fluid
    local roundFluidValues = {}
    local current = 0
    while current < top_value do
        if current <= 100 then
            current = current + (step/10)
        elseif current <= 1000 then
            current = current + (step/5)
        else
            current = current + step
        end
        roundFluidValues[#roundFluidValues+1] = current
    end
    table.sort(roundFluidValues)
    return(roundFluidValues)
end

local roundFluidValues = omni.fluid.SetRoundFluidValues()
function omni.fluid.round_fluid(nr,round)
    local t = omni.lib.round(nr)
    local newval = t
    for i=1, #roundFluidValues-1 do
        if roundFluidValues[i]< t and roundFluidValues[i+1]>t then
            if t-roundFluidValues[i] < roundFluidValues[i+1]-t then
                local c = 0
                if roundFluidValues[i] ~= t and round == 1 then c=1 end
                newval = roundFluidValues[i+c]
            else
                local c = 0
                if roundFluidValues[i+1] ~= t and round == -1 then c=-1 end
                newval = roundFluidValues[i+1+c]
            end
        end
    end
    return math.max(newval,1)
end

function omni.fluid.get_true_amount(subtable) --individual ingredient/result table
    local probability = subtable.probability or 1
    local amount = subtable.amount or (subtable.amount_min + subtable.amount_max)/2 or 0
    return amount * probability
end

function omni.fluid.compact_array(array) --individual ingredient/result table
    local new = {}
    for i=1,#array do
        if array[i]~=nil then
            new[#new+1] = array[i]
        end
    end
    return new
end

function omni.fluid.is_fluid_void(recipe)
    local results = {}
    local ingredients = {}
    if recipe.normal then
        results = recipe.normal.results
        ingredients = recipe.normal.ingredients
    elseif recipe.results then
        results = recipe.results
        ingredients = recipe.ingredients
    end
    --need to check results since it can be nil when .result exists
    if results and next(results) and #results == 1 and results[1].amount and results[1].amount == 0  and next(ingredients) and ingredients[1].type and ingredients[1].type == "fluid" then
        return true
    end
    return false
end

function omni.fluid.create_temperature_copies(recipe, fluidname, replacement, temperatures)
    if recipe then
        --Additional recipe checks: If this is a fixed recipe somewhere, we need to remove that, enable the recipe and unhide if required
        for _, ent in pairs(data.raw["assembling-machine"]) do
            if ent.fixed_recipe and ent.fixed_recipe == recipe.name then
                ent.fixed_recipe = nil
                omni.lib.enable_recipe(recipe.name)
                if recipe.normal then
                    recipe.normal.hidden = false
                    recipe.expensive.hidden = false
                end
                if recipe.hidden then recipe.hidden = false end
            end
        end
        --Create copies for each temp in temperatures and replace the sluid with the required temp sluid
        local copies = {}
        for _, temp in pairs(temperatures) do
            local sluid = "solid-"..fluidname.."-T-"..temp
            local tech = omni.lib.get_tech_name(recipe.name)
            if type(temp) ~= "number" then sluid = "solid-"..fluidname end
            if data.raw.item[sluid] and sluid ~= replacement then
                local newrec = table.deepcopy(recipe)
                newrec.name = newrec.name .."-T-"..temp
                newrec.localised_name = omni.lib.locale.of(recipe).name
                for _, dif in pairs({"normal","expensive"}) do
                    for _, ingres in pairs({"ingredients","results"}) do
                        for _, flu in pairs(newrec[dif][ingres]) do
                            if flu.name and flu.name == replacement then
                                flu.name = sluid
                                break
                            end
                        end
                    end
                end
                copies[#copies+1] = newrec
                if tech and not omni.lib.recipe_is_enabled(recipe.name) then
                    omni.lib.add_unlock_recipe(tech, newrec.name, true)
                end
            end
        end
        if next(copies) then data:extend(copies) end
    end
end