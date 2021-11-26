--------------------------------------------------------------------------------------------------
--[[ SETTING UP BASICS AND NOTES
PLAN: FLAT OUT REPLACE ALL FLUIDS WITH SOLIDS in non-furnace type recipes
--for all power production (steam etc) fluids, add in a solid-fluid conversion recipe to the sluid boiler
STEP 1 Find all properties assocated with fluids which are not associated with solids
--Fluid only props
Temperature (temperature, max_temperature, default_temperature)
Heat_capacity
visuals(base_color, flow_color)
pressure_to_speed_ratio
flow_to_energy_ratio
auto_barrel
type="fluid"

--Solid only props
type="item"
stack_size
]]
--[[ FLUIDS which need to remain fluids:
Generator fluids
Mining fluids
Fuel fluids
Boiler/HX fluids
possibly pumpjacks
flamer turrets (and other fluid turrets)]]
--==These fluids should still get replaced in all other recipes, and have a solid-fluid conversion boiler recipe

--ADD an OVERLAY for remaining fluids

--[[Build a database of fluids to keep, fluids to become solids and fluids which need both (i.e. conversion)]]
-- Ensure that buildings which are "removing" fluid boxes are checked for ingredient counts and that property is removed or augmented
--------------------------------------------------------------------------------------------------
--set local lists and category parameters
local fuel_fluid = {} --is a fuel type fluid

local generator_fluid = {} --is used in a generator
local generator_recipe = {}
local generator_cat = {}
local cat_add = {}


--------------------------------------------------------------------------------------------------
--NEW CODE BASE
--------------------------------------------------------------------------------------------------
local fluid_cats = {fluid = {}, sluid = {}, mush = {}}
--where fluids remain, sluids fully convert, mush gets a coversion recipe and partial conversion
--[[==examples of fluid only:
        steam and other fluidbox filtered generator fluids
        heat(omnienergy)]]
--[[examples of mush:
        mining fluids (sulfuric acid etc...)
        fluids with fuel value
        fluids with temperature requirements]]
local recipe_mods = {}
--build a list of recipes to modify after the sluids list is generated
--==I FIGURED BUILDING THE DATABASE LIKE THIS WOULD SPEED UP THE WHOLE PROCESS, and skip "disabled/hidden" stuff
-- should build a table with recipe name as index, then ing#/res# and fluid name (for reference checks)
--[[example: ["sulfuric-acid"]={ings={"sulfur-dioxide","water"}, res = {"sulfuric-acid"}}]]
--==DAMN this does not account for the temperature thingies...

--------------------------------------------------------------------------------------------------
--Functions for migration to the functions file
--------------------------------------------------------------------------------------------------
function omni.fluid.get_fluid_amount(subtable) --individual ingredient/result table
    -- amount min system
    -- "min-max" parses mininum, sets mm_prob as max/min
    -- "min-chance" parses minimum, sets mp_prob as min*prob
    -- "zero-max" parses maximum only
    -- "chance" parses average yield, sets prob as prob
    -- does this interferre with the GCD functionallity?
    if subtable.amount then
        if subtable.probability then --normal style, priority over previous step
            return omni.fluid.round_fluid((subtable.amount * subtable.probability) / sluid_contain_fluid)
        else
            return omni.fluid.round_fluid(subtable.amount / sluid_contain_fluid) --standard
        end
    elseif subtable.amount_min and subtable.amount_min > 0 then
        if subtable.amount_max then
            return omni.fluid.round_fluid((subtable.amount_max + subtable.amount_min) / (2 * sluid_contain_fluid))
        elseif subtable.probability then
            return omni.fluid.round_fluid(subtable.amount_min * subtable.probability)
        end
    elseif subtable.amount_min and subtable.amount_min == 0 then
        if subtable.amount_max then
            return omni.fluid.round_fluid(subtable.amount_max / sluid_contain_fluid)
        end
    elseif subtable.amount_max and subtable.amount_max > 0 then
        if subtable.probability then
            return omni.fluid.round_fluid(subtable.amount_max * subtable.probability)
        end
    end
    log("an error has occured with this ingredient, please find logs to find out why")
    log(serpent.block(subtable))
end

local function search_range(temp_cond,value,temp_set)
    for _,val in pairs(temp_set) do
        if temp_cond == "max" and val.ave then
            if val.ave <= value then
                return false --a lower value exists, remove condition
            end
        elseif temp_cond == "min" and val.ave then
            if val.ave >= value then
                return false --a higher value exists, remove condition
            end
        end
    end
    return true --keep limit as actual value
end

local function item_temperature_tab_cleanup(temp_sets)
    --sort and filter out temperatures in the table
    --will run iteratively for items, or just once for recipes
    local temps = {} --set metatable of used temperatures to override later
    for i,temperature in pairs(temp_sets) do
        --temp.ave (common settings)
        if temperature.ave and not omni.lib.is_in_table({ave = temperature.ave},temps) then
            temps[#temps+1] = {ave=temperature.ave} --basically copy it...
        elseif (temperature.max and temperature.min) then --set average based on max and min
            local aver = (temperature.max+temperature.min)/2
            if not omni.lib.is_in_table({ave = aver},temps) then
                temps[#temps+1] = {ave = aver}
            --	log("replacing range with average: "..temperature.max.."+"..temperature.min.."="..aver)
            --else --already in table
            --	log("average of range in table already: "..temperature.max.."+"..temperature.min.."="..aver)
            end
        elseif temperature.max --[[and not temperature.min]] then
        --log("max only")
        --log(search_range("max",temperature.max,temp_sets))
            --search subtable for a value lower than max...
            if search_range("max",temperature.max,temp_sets) then
                temps[#temps+1] = {max = temperature.max}
            --else
            --	log("removing max:"..temperature.max)
            end
        elseif temperature.min --[[and not temperature.max]] then
            --log("min only")
            --log(search_range("min",temperature.min,temp_sets))
            --search subtable for a value higher than min...
            if search_range("min",temperature.min,temp_sets) then
                temps[#temps+1] = {min = temperature.min}
            --else
            --	log("removing min:"..temperature.min)
            end
        end
    end
    temp_sets = temps
    return temps --override old table with new
end

local function adjust_amounts(recipe_name ,mult, dif, need_adjustment)
    local modMult = mult[dif]*500/need_adjustment
    local multPrimes = omni.lib.factorize(mult[dif])
    local addPrimes = {}
    local checkPrimes = mult[dif]
    for i = 0, (multPrimes["2"] or 0) do
        for j = 0, (multPrimes["3"] or 0) do
            for k = 0, (multPrimes["5"] or 0) do
                local c = math.pow(2,i)*math.pow(3,j)*math.pow(5,k)
                if c > modMult and c < checkPrimes then
                    checkPrimes = c
                end
            end
        end
    end
    local prime60 = {}
    addPrimes = omni.lib.factorize(checkPrimes)
    local totalPrimeVal = omni.lib.prime.value(omni.lib.prime.mult(addPrimes,gcd_primes))
    for _,ingres in pairs({"ingredients","results"}) do
        for j,component in pairs(data.raw.recipe[recipe_name][dif][ingres]) do
            if component.type == "fluid" then
                local fluid_amount = 0
                for i=1,#roundFluidValues do
                    if roundFluidValues[i]%totalPrimeVal == 0 then
                        if ingres == "ingredients" then
                            if roundFluidValues[i] > fluids[dif][ingres][j].amount then
                                fluid_amount = roundFluidValues[i]
                                break
                            end
                        else
                            if roundFluidValues[i] < fluids[dif][ingres][j].amount then
                                fluid_amount = roundFluidValues[i]
                            else
                                break
                            end
                        end
                    elseif ingres == "results" and roundFluidValues[i] > fluids[dif][ingres][j].amount then
                        break
                    end
                end
                fluids[dif][ingres][j].amount = fluid_amount
            end
        end
    end
    mult[dif] = mult[dif]/checkPrimes
end


--Sluid generation code
function generate_sluid()
    --does not deal with fuel value conversion
    local fluid_solid = {} --sluids create list
    --add category
    fluid_solid[#fluid_solid+1] = {
        type = "item-subgroup",
        name = "omni-solid-fluids",
        group = "intermediate-products",
        order = "aa",
    }
    for _, diff in pairs({"sluid","mush"}) do
        for _, fluid in pairs(fluid_cats[diff]) do
            local icn = omni.lib.icon.of_generic(data.raw.fluid[fluid.name])--get_icons(fluid)
            fluid.temperature = item_temperature_tab_cleanup(fluid.temperature)
            if fluid.temperature and table_size(fluid.temperature) > 0 then --if table is not empty...
                --clean-up the table
                for _,temps in pairs(fluid.temperature) do
                    if temps.ave then
                        if not data.raw.item["solid-"..fluid.name.."-T-"..temps.ave] then
                            fluid_solid[#fluid_solid+1] = {
                                type = "item",
                                name = "solid-"..fluid.name.."-T-"..temps.ave,
                                localised_name = {"item-name.solid-fluid-tmp", data.raw.fluid[fluid.name].localised_name or {"fluid-name."..fluid.name},"T="..temps.ave},
                                localised_description = {"item-description.solid-fluid", data.raw.fluid[fluid.name].localised_description or {"fluid-description."..fluid.name}},
                                icons = icn,
                                --icon_size = 32,
                                subgroup = "omni-solid-fluids",
                                order = "a",
                                stack_size = sluid_stack_size,
                                flags = {}
                                --inter_item_count = item_count,
                            }
                        end
                    elseif temps.max then
                        if not data.raw.item["solid-"..fluid.name.."-Th-"..temps.max] and not data.raw.item["solid-"..fluid.name.."-T-"..temps.max] then --don't duplicate
                            fluid_solid[#fluid_solid+1] = {
                                type = "item",
                                name = "solid-"..fluid.name.."-Th-"..temps.max,
                                localised_name = {"item-name.solid-fluid-tmp", data.raw.fluid[fluid.name].localised_name or {"fluid-name."..fluid.name},"Tmax="..temps.max},
                                localised_description = {"item-description.solid-fluid", data.raw.fluid[fluid.name].localised_description or {"fluid-description."..fluid.name}},
                                icons = icn,
                                --icon_size = 32,
                                subgroup = "omni-solid-fluids",
                                order = "a",
                                stack_size = sluid_stack_size,
                                flags = {}
                                --inter_item_count = item_count,
                            }
                        end
                    elseif temps.min then
                        if not data.raw.item["solid-"..fluid.name.."-Th-"..temps.min] and not data.raw.item["solid-"..fluid.name.."-T-"..temps.min] then --don't duplicate
                            fluid_solid[#fluid_solid+1] = {
                                type = "item",
                                name = "solid-"..fluid.name.."-Tc-"..temps.min,
                                localised_name = {"item-name.solid-fluid-tmp", data.raw.fluid[fluid.name].localised_name or {"fluid-name."..fluid.name},"Tmin="..temps.min},
                                localised_description = {"item-description.solid-fluid", data.raw.fluid[fluid.name].localised_description or {"fluid-description."..fluid.name}},
                                icons = icn,
                                --icon_size = 32,
                                subgroup = "omni-solid-fluids",
                                order = "a",
                                stack_size = sluid_stack_size,
                                flags = {}
                                --inter_item_count = item_count,
                            }
                        end
                    end
                end
            end
            if not data.raw.item["solid-"..fluid.name] then --don't make it if it already exists
                --get properties parsed if needed and append to key properties (name specifically)
                fluid_solid[#fluid_solid+1] = {
                    type = "item",
                    name = "solid-"..fluid.name,
                    localised_name = {"item-name.solid-fluid", data.raw.fluid[fluid.name].localised_name or {"fluid-name."..fluid.name}},
                    localised_description = {"item-description.solid-fluid", data.raw.fluid[fluid.name].localised_description or {"fluid-description."..fluid.name}},
                    icons = icn,
                    --icon_size = 32,
                    subgroup = "omni-solid-fluids",
                    order = "a",
                    stack_size = sluid_stack_size,
                    flags = {}
                    --inter_item_count = item_count,
                }
            end
        end
    end
    data:extend(fluid_solid)
end
--------------------------------------------------------------------------------------------------
--Temperature clean-up functions
--------------------------------------------------------------------------------------------------
local function recipe_temperature_cleanup(recipe_temp,ingredient_name)
    if recipe_temp == nil then
        return nil
    end
    --checks the recipe temperature against the mush/sluid temperatures
    if recipe_temp.ave then
        if recipe_temp.ave <= 25 then
            return nil
        else
            return recipe_temp --will always exist
        end
    elseif recipe_temp.max and recipe_temp.min then
        return {ave=(recipe_temp.max+recipe_temp.min)/2}
    elseif recipe_temp.max --[[and not min]] then
        for _, diff in pairs({"sluid","mush"}) do
            for _, fluid in pairs(fluid_cats[diff]) do --iterate through item generation table
                if fluid==ingredient_name then --found you
                    for _,temps in pairs(fluid.temp) do
                    --iterate through "known" temperatures
                        if recipe_temp.max >= 25 then --works, skip all below 25, by removing the temperature setting --may fail if using sub-zero temperatures...
                            if temps.ave <= recipe_temp.max then
                                return temps
                            end
                        end
                        return recipe_temp
                    end
                    return nil
                end
                log("item not found")
            end
        end
    elseif recipe_temp.min --[[and not max]] then
        for _, diff in pairs({"sluid","mush"}) do
            for _, fluid in pairs(fluid_cats[diff]) do --iterate through item generation table
                if fluid==ingredient_name then --found you
                    for _,temps in pairs(fluid.temp) do
                    --iterate through "known" temperatures
                        if temps.ave >= recipe_temp.min then
                            return temps
                        end
                    end
                    return recipe_temp
                end
                log("item not found")
            end
        end
    end
end
--------------------------------------------------------------------------------------------------
--Recipe update code
--------------------------------------------------------------------------------------------------
local function mp_update(co_ord, new_names)
    for _, res in pairs(new_names) do
        if res.name == co_ord then
            co_ord = "solid-"..co_ord
            if res.temp then --deal with temperature
                local temps = recipe_temperature_cleanup(res.temp,res.name) --override name to carry correct tags
                if temps then
                    if temps.ave then 
                        co_ord = co_ord.."-T-"..temps.ave
                    elseif temps.max then
                        co_ord = co_ord.."-Th-"..temps
                    elseif temps.min then
                        co_ord = co_ord.."-Tc-"..temps
                    end
                end
            end
            return co_ord
        end
    end
    return co_ord --if it is not changing
end

local function main_product_update(rec_name, results_updates)
    local rec = data.raw.recipe[rec_name]
    --collect all main_product locations
    if rec.main_product then
        rec.main_product = mp_update(rec.main_product,results_updates)
    end
    if rec.normal and rec.normal.main_product then
        rec.normal.main_product = mp_update(rec.normal.main_product,results_updates)
    end
    if rec.expensive and rec.expensive.main_product then
        rec.expensive.main_product = mp_update(rec.expensive.main_product,results_updates)
    end
end

function sluid_recipe_updates() --currently works with non-standardised recipes
    for name, changes in pairs(recipe_mods) do
        local rec = data.raw.recipe[name]
        --check if needs standardisation
        local std = false
        for i,dif in pairs({"normal","expensive"}) do
            if not (rec[dif] and rec[dif].ingredients and rec[dif].expensive) then
                std = true
            end
        end
        if std == true then
            --standardise
            omni.lib.standardise(rec)
        end
        if not rec then	return log("recipe not found:".. name) end
        --declare sub-tabs
        local fluids = {normal = {ingredients = {}, results = {}}, expensive = {ingredients = {}, results = {}}}
        local primes = {normal = {ingredients = {}, results = {}}, expensive = {ingredients = {}, results = {}}}
        local lcm = 1
        local mult = {normal = 1,expensive = 1}
        --start first layer of analysis
        for _,dif in pairs({"normal","expensive"}) do
            for _,ingres in pairs({"ingredients","results"}) do
                for j,ing in pairs(rec[dif][ingres]) do
                    if ing.type == "fluid" then
                        if ing.amount then
                            fluids[dif][ingres][j] = {name= ing.name, amount = omni.fluid.get_fluid_amount(ing)}
                            mult[dif] = omni.lib.lcm(omni.lib.lcm(sluid_contain_fluid, fluids[dif][ingres][j].amount)/fluids[dif][ingres][j].amount, mult[dif])
                            primes[dif][ingres][j] = omni.lib.factorize(fluids[dif][ingres][j].amount)
                        else --throw error
                            log("invalid fluid amount found in: "..rec.name.. " part: ".. dif.."."..ingres)
                            log(serpent.block(rec[dif][ingres]))
                        end
                    end
                end
            end
            --result value adjustments checker
            local div = 1
            local need_adjustment = nil
            local gcd_primes = {}
            for j,ing in pairs(rec[dif]["results"]) do
                if ing.type == "fluid" then
                    local c = fluids[dif]["results"][j].amount*mult[dif]
                    if c > 500 and (not need_adjustment or c > need_adjustment) then
                        need_adjustment = c
                    end
                    if gcd_primes == {} then
                        gcd_primes = primes[dif]["results"][j]
                    else
                        gcd_primes = omni.lib.prime.gcd(primes[dif]["results"][j],gcd_primes)
                    end
                end
            end
            if need_adjustment then
                adjust_amounts(rec.name,mult,dif,need_adjustment)
            end
        end
        --fix to pick up temperatures etc
        for _, dif in pairs({"normal","expensive"}) do
            for _, ingres in pairs({"ingredients","results"}) do
                for i = 1, table_size(changes[ingres]) do
                    for	n, ing in pairs(rec[dif][ingres]) do
                        if ing.name == changes[ingres][i].name then --don't assume fully standarised
                            --replace with solids equivalent
                            local new_ing={}--start empty to remove all old props to add only what is needed
                            new_ing.type = "item"
                            --detect temperature
                            local temps = recipe_temperature_cleanup(changes[ingres][i].temp,changes[ingres][i].name)
                            if temps then
                                if temps.ave then 
                                    new_ing.name = "solid-"..changes[ingres][i].name.."-T-"..temps.ave
                                elseif temps.max then
                                    new_ing.name = "solid-"..changes[ingres][i].name.."-Th-"..temps.max
                                elseif temps.min then
                                    new_ing.name = "solid-"..changes[ingres][i].name.."-Tc-"..temps.min
                                end
                            else --default
                                new_ing.name = "solid-"..changes[ingres][i].name
                            end
                            new_ing.amount = omni.fluid.get_fluid_amount(ing)
                            --ing = new_ing
                            rec[dif][ingres][n]=new_ing
                        end
                    end
                end
            end
            --crafting time adjustment
            rec[dif].energy_required=rec[dif].energy_required*mult[dif]
        end
        --main product tweaks
            main_product_update(name,changes.results)
    end
end

--DON'T forget to clobber the fluids not in mush/fluids once completed
for _,disfluid in pairs(data.raw.fluid) do
    if not fluid_cats.fluid[disfluid] then --not found in fluids exclusion list
        if not fluid_cats.mush[disfluid] then --not found in mush either
            disfluid.enabled = false
            disfluid.hidden = true
            disfluid.auto_barrel = false
        end
    end
end

--------------------------------------------------------------------------------------------------
--List Generation Support functions
--------------------------------------------------------------------------------------------------
function check_temperature_table(table,ing)--min,max,ave) --im sure this can be done better... its comparing subtables... in a messy way
    local vals={min=ing.minimum_temperature, max=ing.maximum_temperature, ave=ing.temperature}
    if vals.min==nil and vals.max==nil and vals.ave==nil then
        return true
    end
    --fix average temp here...
    if vals.min and vals.max then
        vals.ave=(vals.min+vals.max)/2
        vals.min=nil
        vals.max=nil
    end
    if omni.lib.is_in_table(vals,table) then
        return true
    end
    return false
end

local function ing_tab_check(table, ing)
    for row, valu in pairs(table) do
        if valu.name == ing.name then
            --ingredient name matches
            if check_temperature_table({valu.temp}, ing) then
                return true
            end
        end
    end
    return false
end

local function table_addition(sub, type) --ingredient/result subtable

    if not fluid_cats[type][sub.name] and fluid_cats.fluid[sub.name] then
        fluid_cats[type][sub.name] = table.deepcopy(fluid_cats.fluid[sub.name]) --copy from fluids table (considering the fluids table is for generator fluids, would it be better to just do it from scratch?)
    elseif not fluid_cats[type][sub.name] then
        fluid_cats[type][sub.name] = {name = sub.name, temperature = {}}
    end

    if not check_temperature_table(fluid_cats[type][sub.name].temperature,sub) then
        --add new temperature entry
        table.insert(fluid_cats[type][sub.name].temperature, {min = sub.minimum_temperature, max = sub.maximum_temperature, ave = sub.temperature})
    end
end




--------------------------------------------------------------------------------------------------
--Analyse entities
--------------------------------------------------------------------------------------------------
--generators
for _, gen in pairs(data.raw.generator) do
    --Check exclusion table
    if not omni.fluid.check_string_excluded(gen.name) then
        --Check for fluid box filters to avoid fluid burning gens that take all fuel fluids
        if not gen.burns_fluid and gen.fluid_box and gen.fluid_box.filter then
            --fluid not known
            if not fluid_cats.fluid[gen.fluid_box.filter] then
                fluid_cats.fluid[gen.fluid_box.filter] = {name = gen.fluid_box.filter, temperature = {}}
                fluid_cats.fluid[gen.fluid_box.filter].temperature[1] = {--[[min = gen.fluid_box.minimum_temperature,]] max = gen.maximum_temperature}
                generator_fluid[gen.fluid_box.filter] = generator_fluid[gen.fluid_box.filter] or true --set the fluid up as a known filter
            else
                --check if entry already exists and update temperatures
                if not check_temperature_table(fluid_cats.fluid[gen.fluid_box.filter].temperature, {--[[gen.fluid_box.minimum_temperature,]] max = gen.maximum_temperature}) then
                    table.insert(fluid_cats.fluid[gen.fluid_box.filter].temperature, {--[[min = gen.fluid_box.minimum_temperature,]] max = gen.maximum_temperature})
                end
            end
        end
    end
end

--fluid throwing type turrets
for _, turr in pairs(data.raw["fluid-turret"]) do
    if turr.attack_parameters.fluids then
        for _, diesel in pairs(turr.attack_parameters.fluids) do
            if not fluid_cats.fluid[diesel.type] then
                fluid_cats.fluid[diesel.type] = {name = diesel.type, temperature = {}}
            end
        end
    end
end

--mining fluid detection
for _,resource in pairs(data.raw.resource) do
    if resource.minable and resource.minable.required_fluid then
        fluid_cats.fluid[resource.minable.required_fluid] = {name = resource.minable.required_fluid, temperature = {}}
        --are there any cases of "mining fluids" having a temperature filter?
    end
end

--recipes
for _, rec in pairs(data.raw.recipe) do
    if not omni.fluid.check_string_excluded(rec.name) and not omni.lib.recipe_is_hidden(rec.name) then --exclude creative mode shenanigans and barrels
        for _, ingres in pairs({"ingredients","results"}) do --ignore result/ingredient as they don't handle fluids
            if rec[ingres] then
                --handle non-standardised stuff just in case
                for _, it in pairs(rec[ingres]) do
                    if it.type and it.type == "fluid" then
                        recipe_mods[rec.name] = recipe_mods[rec.name] or {ingredients = {}, results = {}} --add recipe to tweak list
                        if fluid_cats.fluid[it.name] then
                            table_addition(it,"mush")
                        else
                            table_addition(it,"sluid")
                        end
                        if not ing_tab_check(recipe_mods[rec.name][ingres], it) then 
                            table.insert(recipe_mods[rec.name][ingres], {name = it.name, temp = {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature}})
                            --check item is also being generated
                            if fluid_cats.sluid[it.name] then
                                if not check_temperature_table(fluid_cats.sluid[it.name].temperature, {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature}) then
                                    table.insert(fluid_cats.sluid[it.name].temperature, {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature})
                                end
                            end
                            if fluid_cats.mush[it.name] then
                                if not check_temperature_table(fluid_cats.mush[it.name].temperature, {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature}) then
                                    table.insert(fluid_cats.mush[it.name].temperature, {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature})
                                end
                            end
                        else --ignore since ing is already in the table 
                            --log("ing in table")
                        end
                    end
                end
            --handle standardised stuff
            elseif (rec.normal and rec.normal[ingres]) or (rec.expensive and rec.expensive[ingres]) then
                for _, diff in pairs({"normal","expensive"}) do
                    for _, it in pairs(rec[diff][ingres]) do
                        if it and it.type and it.type == "fluid" then
                            recipe_mods[rec.name] = recipe_mods[rec.name] or {ingredients = {}, results = {}}  --add recipe to tweak list
                            if fluid_cats.fluid[it.name] then
                                table_addition(it,"mush")
                            else
                                table_addition(it,"sluid")
                            end
                            --append recipe modification
                            if not ing_tab_check(recipe_mods[rec.name][ingres],it) then 
                                table.insert(recipe_mods[rec.name][ingres], {name = it.name, temp = {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature}})
                                --check item is also being generated
                                if fluid_cats.sluid[it.name] then
                                    if not check_temperature_table(fluid_cats.sluid[it.name].temperature, {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature}) then
                                        table.insert(fluid_cats.sluid[it.name].temperature, {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature})
                                    end
                                end
                                if fluid_cats.mush[it.name] then
                                    if not check_temperature_table(fluid_cats.mush[it.name].temperature, {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature}) then
                                        table.insert(fluid_cats.mush[it.name].temperature, {min = it.minimum_temperature, max = it.maximum_temperature, ave = it.temperature})
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--------------------------------------------------------------------------------------------------
--Call sluid generation
--------------------------------------------------------------------------------------------------
generate_sluid()
sluid_recipe_updates()


--------------------------------------------------------------------------------------------------
--Sluid Boiler tweaks
--------------------------------------------------------------------------------------------------
local new_boiler = {}
local fix_boilers_recipe = {}
local fix_boilers_item = {}
local ing_replace={}
local boiler_tech = {}

for _, boiler in pairs(data.raw.boiler) do
    -----------------------------------------
    --PREPARE DATA FOR MANIPULATION
    -----------------------------------------
    local water = boiler.fluid_box.filter or "water"
    local water_cap = omni.fluid.convert_mj(data.raw.fluid[water].heat_capacity)
    local water_delta_tmp = data.raw.fluid[water].max_temperature - data.raw.fluid[water].default_temperature
    local steam = boiler.output_fluid_box.filter or "steam"
    local steam_cap = omni.fluid.convert_mj(data.raw.fluid[steam].heat_capacity)
    local steam_delta_tmp = boiler.target_temperature - data.raw.fluid[water].max_temperature
    local prod_steam = omni.fluid.round_fluid(omni.lib.round(omni.fluid.convert_mj(boiler.energy_consumption) / (water_delta_tmp * water_cap + steam_delta_tmp * steam_cap)),1)
    local lcm = omni.lib.lcm(prod_steam, sluid_contain_fluid)
    local prod = lcm / sluid_contain_fluid
    local tid = lcm / prod_steam
    --clobber fluid_box_filter if it exists
    if generator_fluid[boiler.output_fluid_box.filter] then
        generator_fluid[boiler.output_fluid_box.filter] = nil
    end
    --if exists, find recipe, item and entity
    if not omni.fluid.forbidden_boilers[boiler.name] and boiler.minable then
        local rec = omni.lib.find_recipe(boiler.minable.result)
        new_boiler[#new_boiler+1] = {
            type = "recipe-category",
            name = "boiler-omnifluid-"..boiler.name,
        }
        if standardized_recipes[rec.name] == nil then
            omni.lib.standardise(data.raw.recipe[rec.name])
        end
        --add boiler to recip list and fix minable-result list
        fix_boilers_recipe[#fix_boilers_recipe+1] = rec.name
        fix_boilers_item[boiler.minable.result] = true

        --set-up result and main product values to be the new converter
        data.raw.recipe[rec.name].normal.results[1].name = boiler.name.."-converter"
        data.raw.recipe[rec.name].normal.main_product = boiler.name.."-converter"
        data.raw.recipe[rec.name].expensive.results[1].name = boiler.name.."-converter"
        data.raw.recipe[rec.name].expensive.main_product = boiler.name.."-converter"
        data.raw.recipe[rec.name].main_product = boiler.name.."-converter"
        --omni.lib.replace_all_ingredient(boiler.name,boiler.name.."-converter")
        
        --add boiling recipe to new listing
        new_boiler[#new_boiler+1] = {
            type = "recipe",
            name = boiler.name.."-boiling-steam-"..boiler.target_temperature,
            icons = {{icon = "__base__/graphics/icons/fluid/steam.png", icon_size = 64, icon_mipmaps = 4}},
            subgroup = "fluid-recipes",
            category = "boiler-omnifluid-"..boiler.name,
            order = "g[hydromnic-acid]",
            energy_required = tid,
            enabled = true,
            hide_from_player_crafting = true,
            main_product = steam,
            ingredients = {{type = "item", name = "solid-"..water, amount = prod},},
            results = {{type = "fluid", name = steam, amount = sluid_contain_fluid*prod, temperature = math.min(boiler.target_temperature, data.raw.fluid[steam].max_temperature)},},
        }
        
        for _, fugacity in pairs(fluid_cats.mush) do
            --deal with non-water mush fluids, allow temperature and specific boiler systems
            if #fugacity.temperature >= 1 then --not sure if i want to add another level of analysis to split them into temperature specific ranges which may make modded hard, or leave it as is.
                for _, temps in pairs(fugacity.temperature) do
                    --deal with each instance
                    if temps.ave and boiler.target_temperature >= temps.ave then
                        if data.raw.item["solid-"..fugacity.name.."-T-"..temps.ave] then
                            new_boiler[#new_boiler+1] = {
                                type = "recipe",
                                name = boiler.name.."-"..fugacity.name.."-fluidisation-"..temps.ave,
                                icons = omni.lib.icon.of(fugacity.name,"fluid"),
                                subgroup = "fluid-recipes",
                                category = "boiler-omnifluid-"..boiler.name,
                                order = "g[hydromnic-acid]",
                                energy_required = tid,
                                enabled = true,--may change this to be linked to the boiler unlock if applicable
                                hide_from_player_crafting = true,
                                main_product = fugacity.name,
                                ingredients = {{type = "item", name = "solid-"..fugacity.name.."-T-"..temps.ave, amount = prod}},
                                results = {{type = "fluid", name = fugacity.name, amount = sluid_contain_fluid*prod, temperature = temps.ave}},
                            }
                        else
                            log("item does not exist:".. fugacity.name.."-fluidisation-"..temps.ave)
                        end
                    elseif temps.min and boiler.target_temperature >= temps.min then
                        if data.raw.item[fugacity.name.."-fluidisation-"..temps.min] then
                            new_boiler[#new_boiler+1] = {
                                type = "recipe",
                                name = boiler.name.."-"..fugacity.name.."-fluidisation-"..temps.min,
                                icons = omni.lib.icon.of(fugacity.name,"fluid"),
                                subgroup = "fluid-recipes",
                                category = "general-omni-boiler",
                                order = "g[hydromnic-acid]",
                                energy_required = tid,
                                enabled = true,--may change this to be linked to the boiler unlock if applicable
                                hide_from_player_crafting = true,
                                main_product = fugacity.name,
                                ingredients = {{type = "item", name = "solid-"..fugacity.name.."-Tmin-"..temps.min, amount = prod}},
                                results = {{type = "fluid", name = fugacity.name, amount = sluid_contain_fluid*prod, temperature = boiler.target_temperature}},
                            }
                        else
                            log("item does not exist:".. fugacity.name.."-fluidisation-"..temps.min)
                        end
                    elseif temps.max and boiler.target_temperature <= temps.max then
                        if data.raw.item[fugacity.name.."-fluidisation-"..temps.max] then
                            new_boiler[#new_boiler+1] = {
                                type = "recipe",
                                name = boiler.name.."-"..fugacity.name.."-fluidisation-"..temps.max,
                                icons = omni.lib.icon.of(fugacity.name,"fluid"),
                                subgroup = "fluid-recipes",
                                category = "general-omni-boiler",
                                order = "g[hydromnic-acid]",
                                energy_required = tid,
                                enabled = true,--may change this to be linked to the boiler unlock if applicable
                                hide_from_player_crafting = true,
                                main_product = fugacity.name,
                                ingredients = {{type = "item", name = "solid-"..fugacity.name.."-Tmax-"..temps.max, amount = prod}},
                                results = {{type = "fluid", name = fugacity.name, amount = sluid_contain_fluid*prod, temperature = boiler.target_temperature}},
                            }
                        else
                            log("item does not exist:".. fugacity.name.."-fluidisation-"..temps.max)
                        end
                    end
                end
            else --no temperature specific fluid
                new_boiler[#new_boiler+1] = {
                    type = "recipe",
                    name = fugacity.name.."-fluidisation",
                    icons = omni.lib.icon.of(fugacity.name,"fluid"),
                    subgroup = "fluid-recipes",
                    category = "general-omni-boiler",
                    order = "g[hydromnic-acid]",
                    energy_required = tid,
                    enabled = true,--may change this to be linked to the boiler unlock if applicable
                    hide_from_player_crafting = true,
                    main_product = fugacity.name,
                    ingredients = {{type = "item", name = "solid-"..fugacity.name, amount = prod}},
                    results = {{type = "fluid", name = fugacity.name, amount = sluid_contain_fluid*prod, temperature = data.raw.fluid[fugacity.name].default_temperature}},
                }
            end
        end

        --duplicate boiler for each corresponding one?
        local new_item = table.deepcopy(data.raw.item[boiler.name])
        new_item.name = boiler.name.."-converter"
        new_item.place_result = boiler.name.."-converter"
        new_item.localised_name = {"item-name.boiler-converter", {"entity-name."..boiler.name}}
        new_boiler[#new_boiler+1] = new_item

        boiler.minable.result = boiler.name.."-converter"
        --stop it from being analysed further (stop recursive updates)
        omni.fluid.forbidden_assembler[boiler.name.."-converter"] = true
        --create entity
        
        local new = table.deepcopy(data.raw.boiler[boiler.name])
            new.type = "assembling-machine"
            new.name = boiler.name.."-converter"
            new.localised_name = {"item-name.boiler-converter", {"entity-name."..boiler.name}}
            new.icon = boiler.icon
            new.icons = boiler.icons
            new.crafting_speed = 1
            --change source location to deal with the new size
            new.energy_source = boiler.energy_source
            if new.energy_source and new.energy_source.connections then
                local HS=boiler.energy_source
                HS.connections = omni.fluid.heat_pipe_images.connections
                HS.pipe_covers = omni.fluid.heat_pipe_images.pipe_covers
                HS.heat_pipe_covers = omni.fluid.heat_pipe_images.heat_pipe_covers
                HS.heat_picture = omni.fluid.heat_pipe_images.heat_picture
                HS.heat_glow = omni.fluid.heat_pipe_images.heat_glow
            end
            new.energy_usage = boiler.energy_consumption
            new.ingredient_count = 4
            new.crafting_categories = {"boiler-omnifluid-"..boiler.name,"general-omni-boiler"}
            new.fluid_boxes =	{
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    base_level = 1,
                    pipe_connections = {{type = "output", position = {0, -2}}}
                }}--get_fluid_boxes(new.fluid_boxes or new.output_fluid_box)
            new.fluid_box = nil --removes input box
            new.mode = nil --invalid for assemblers
            new.minable.result = boiler.name.."-converter"
            if new.next_upgrade then
                new.next_upgrade = new.next_upgrade.."-converter"
            end
            if new.energy_source and new.energy_source.connections then --use HX graphics instead
                new.animation = omni.fluid.exchanger_images.animation
                new.working_visualisations = omni.fluid.exchanger_images.working_visualisations
            else
                new.animation = omni.fluid.boiler_images.animation
                new.working_visualisations = omni.fluid.boiler_images.working_visualisations
            end
            new.collision_box = {{-1.29, -1.29}, {1.29, 1.29}}
            new.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
        new_boiler[#new_boiler+1] = new
        ing_replace[#ing_replace+1] = boiler.name
        --find tech unlock
        local found = false --if not found, force off (means enabled at start)
        for i,tech in pairs(data.raw.technology) do
            if tech.effects then
                for j,k in pairs(tech.effects) do
                    if k.recipe_name and k.recipe_name == boiler.name then
                        boiler_tech[#boiler_tech+1] = {tech_name = tech.name, old_name = boiler.name}
                    end
                end
            end
        end
        if found == false then
            --hide and disable starting items
            local old = data.raw.boiler[boiler.name]
            old.enabled = false
            if old.flags then
                if not old.flags["hidden"] then
                    table.insert(old.flags,"hidden")
                end
            else
                old.flags = {"hidden"}
            end
            data.raw.item[boiler.name].hidden = true
            data.raw.item[boiler.name].enabled = false
        end
    end
end

new_boiler[#new_boiler+1] = {
    type = "recipe-category",
    name = "general-omni-boiler",
}

data:extend(new_boiler)

--replace the item as an ingredient
for _,boiler in pairs(ing_replace) do
    omni.lib.replace_all_ingredient(boiler, boiler.."-converter")
end
--replace in tech unlock
for _,boil in pairs(boiler_tech) do
    omni.lib.replace_unlock_recipe(boil.tech_name, boil.old_name, boil.old_name.."-converter")
end

--------------------------------------------------------------------------------------------------
--Update Fluid mining (offshore pumps/pumpjacks etc) to output solids
--------------------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------------
--Entity Fluidbox Reduction(don't clobber all in case some recipes still have them)
--------------------------------------------------------------------------------------------------
-- do i trawl through recipe categories and work out "maximum" fluid count for in/out (for the mixed or fluids) and remove other fluid boxes?
--------------------------------------------------------------------------------------------------