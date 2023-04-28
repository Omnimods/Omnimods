local analysation = require("prototypes.fluid-analysation")
local sluid_boiler = require("prototypes.sluid-boiler")

local fluid_cats = analysation.fluid_cats_
local generator_fluid = analysation.generator_fluid_
local recipe_mods = analysation.recipe_mods_
local void_recipes = analysation.void_recipes_
local min_steam_boiler_temp = analysation.min_boiler_temp_

log(serpent.block(fluid_cats))
----------------------------
-----Create solid items-----
----------------------------
local ent = {}
--create subgroup
ent[#ent+1] = {
    type = "item-subgroup",
    name = "omni-solid-fluids",
    group = "intermediate-products",
    order = "aa",
}

for catname, cat in pairs(fluid_cats) do
    for _, fluid in pairs(cat) do
        --sluid or mush: create items and replace recipe ings/res
        if catname ~= "fluid" then
            for _,temp in pairs(fluid.temperatures ) do
                if temp == "none" then
                    ent[#ent+1] = {
                        type = "item",
                        name = "solid-"..fluid.name,
                        localised_name = {"item-name.solid-fluid", fluid.localised_name or {"fluid-name."..fluid.name}},
                        localised_description = {"item-description.solid-fluid", fluid.localised_description or {"fluid-description."..fluid.name}},
                        icons = omni.lib.icon.of_generic(data.raw.fluid[fluid.name]),
                        subgroup = "omni-solid-fluids",
                        order = fluid.order or "a",
                        stack_size = omni.fluid.sluid_stack_size,
                    }
                else
                    ent[#ent+1] = {
                        type = "item",
                        name = "solid-"..fluid.name.."-T-"..string.gsub(temp, "%.", "_"),
                        localised_name = {"item-name.solid-fluid-tmp", fluid.localised_name or {"fluid-name."..fluid.name},"T="..temp},
                        localised_description = {"item-description.solid-fluid", fluid.localised_description or {"fluid-description."..fluid.name}},
                        icons = omni.lib.icon.of_generic(data.raw.fluid[fluid.name]),
                        subgroup = "omni-solid-fluids",
                        order = fluid.order or "a",
                        stack_size = omni.fluid.sluid_stack_size,
                    }
                end
            end
        end
        --Sluid only: hide unused fluids.
        if catname == "sluid" then
            fluid.hidden = true
            fluid.auto_barrel = false
        end
    end
end
data:extend(ent)


--Convert boilers to sluid boilers and create converter recipes
sluid_boiler(fluid_cats, generator_fluid)


----------------------------------
-----Replacement preparations-----
----------------------------------
--Replace barrels with sluids before doing all other replacement so it can properly divide down the recipe ingredients/results
local function replace_barrels(recipe)
    for _, dif in pairs({"normal","expensive"}) do
        for _, ingres in pairs({"ingredients","results"}) do
            for    j, ing in pairs(recipe[dif][ingres]) do
                --Remove empty barrels
                if ing.name and (ing.name == "empty-barrel" or ing.name == "empty-canister"  or ing.name == "empty-gas-canister")then
                    recipe[dif][ingres][j] = nil
                --Replace filled barrels with sluids
                elseif ing.name and (string.find(ing.name, "%-barrel") or string.find(ing.name, "barrel%-") or string.find(ing.name, "%-canister")) then
                    local flu = string.gsub(ing.name, "%-barrel", "")
                    flu = string.gsub(flu, "barrel%-", "")
                    flu = string.gsub(flu, "%-gas%-canister", "")
                    flu = string.gsub(flu, "%-canister", "")

                    if fluid_cats["sluid"][flu] or fluid_cats["mush"][flu] then
                        if recipe[dif].main_product and recipe[dif].main_product == ing.name then
                            recipe[dif].main_product = "solid-"..flu
                        end
                        ing.name = "solid-"..flu
                        ing.amount = omni.lib.round(ing.amount*50/omni.fluid.sluid_contain_fluid)
                    end
                end
            end
        end
    end
end

--Special Py case 2146321487: replace filled barrel ingredients with solids (py uses "barel-" as name instead of "-barel")
for _, rec in pairs(data.raw.recipe) do
    if not omni.fluid.check_string_excluded(rec.name) and not omni.lib.recipe_is_hidden(rec.name)  then
        local std = false
        for _,dif in pairs({"normal","expensive"}) do
            if not (rec[dif] and rec[dif].ingredients and rec[dif].expensive) then
                std = true
                break
            end
        end
        if std == true then omni.lib.standardise(rec) end
        for _, dif in pairs({"normal","expensive"}) do
            for _, ingres in pairs({"ingredients","results"}) do
                for _, ing in pairs(rec[dif][ingres]) do
                    if string.find(ing.name, "%-barrel") or string.find(ing.name, "barrel%-") or string.find(ing.name, "%-canister")  or string.find(ing.name, "%-gas%-canister") then
                        replace_barrels(rec)
                        goto continue
                    end
                end
            end
        end
        ::continue::
    end
end


local add_multi_temp_recipes = {}
local max_mult = 0

-------------------------------------------
-----Replace recipe ingres with sluids-----
-------------------------------------------
for name, _ in pairs(recipe_mods) do
    local rec = data.raw.recipe[name]
    if rec then
        --check if needs standardisation
        local std = false
        for _,dif in pairs({"normal","expensive"}) do
            if not (rec[dif] and rec[dif].ingredients and rec[dif].expensive) then
                std = true
                break
            end
        end
        if std == true then omni.lib.standardise(rec) end

        -----Multiplier calculation with LCM AND GCD-----
        -------------------------------------------------
        local mult = {normal = 1, expensive = 1}
        local lcm = {normal = 1, expensive = 1}
        local gcd = {}
        for _, dif in pairs({"normal","expensive"}) do
            local min_amount = math.huge
            local max_amount = 0
            local lcm_mult = 1
            for _, ingres in pairs({"ingredients","results"}) do
                --First loop: Calculate the lcm respecting omni.fluid.sluid_contain_fluid
                for    _, ing in pairs(rec[dif][ingres]) do
                    local amount = 0
                    if ing.type == "fluid" and ing.amount and ing.amount ~= 0 then
                        --Round the fluid amount to get rid of weird base numbers, divide afterwards to not lose precision
                        amount = omni.lib.round(omni.fluid.get_true_amount(ing)) / omni.fluid.sluid_contain_fluid
                    else
                        amount = omni.fluid.get_true_amount(ing)
                    end
                    if amount == 0 then break end
                    if not amount then log("Could not get the amount of the following table:") log(serpent.block(ing)) end
                    --Calculate lcm
                    --Since our lcm function is not working with floats, multiply by 1000 if we find floats to keep precision for low fluid amounts (we just divided by sluid fluid ratio)
                    min_amount = math.min(min_amount, amount)
                    max_amount = math.max(max_amount, amount)
                    if (amount*lcm_mult) % 1 > 0 and lcm_mult < 1000 then
                        if lcm_mult < 1000 then
                            lcm_mult = 1000
                            lcm[dif] = lcm[dif] * lcm_mult
                            amount = amount * lcm_mult
                            amount = omni.lib.round(amount)
                        else
                            amount = omni.lib.round(amount * lcm_mult)
                        end
                    else
                        amount = omni.lib.round(amount * lcm_mult)
                    end
                    lcm[dif] = omni.lib.lcm(lcm[dif], amount or 1)
                end
            end
            --divide by the lcm mult again to get the "true" lcm
            lcm[dif] = lcm[dif] / lcm_mult
            --Get the recipe multiplier which is lcm/lowest amount found in this recipe to not lose precision
            mult[dif] = lcm[dif] / min_amount

            --Second loop: Find GCD of all ingres multiplied with the LCM multiplier we just calculated (with sluid_contain_fluid applied for fluids)
            for _, ingres in pairs({"ingredients","results"}) do
                for    _, ing in pairs(rec[dif][ingres]) do
                    local amount = 0
                    if ing.type == "fluid" and ing.amount and ing.amount ~= 0 then
                        amount = omni.lib.round(omni.fluid.get_true_amount(ing) * mult[dif]) / omni.fluid.sluid_contain_fluid
                    else
                        --amount = omni.lib.round((ing.amount or (ing.amount_min+ing.amount_max)/2)*mult[dif])
                        amount = omni.fluid.get_true_amount(ing) * mult[dif]
                    end
                    if amount == 0 then break end
                    if not amount then log("Could not get the amount of the following table:") log(serpent.block(ing)) end

                    if not gcd[dif] then
                        gcd[dif] = amount
                    else
                        gcd[dif] = omni.lib.gcd(gcd[dif], amount)
                    end
                end
            end
            --The final recipe multiplier is our old mult/the calculated gcd
            mult[dif] = mult[dif] / gcd[dif]

            --Multiplier for this recipe is too huge. Lets do the math lcm/gcd math again with slightly less precision (use rounding)
            if mult[dif]*max_amount > 10000  or (mult[dif] > 50 and mult[dif]*max_amount > 1000) then
                --reset all values
                mult[dif] = 1
                lcm[dif] = 1
                gcd[dif] = nil
                min_amount = math.huge
                max_amount = 0
                lcm_mult = 1
                for _, ingres in pairs({"ingredients","results"}) do
                    for    _, ing in pairs(rec[dif][ingres]) do
                        local amount = 0
                        if ing.type == "fluid" then
                            --Round the fluid amount to get rid of weird base numbers, divide afterwards to not lose precision
                            amount = omni.fluid.round_fluid(omni.fluid.get_true_amount(ing) / omni.fluid.sluid_contain_fluid)
                        else
                            amount = omni.fluid.round_fluid(omni.fluid.get_true_amount(ing))
                        end
                        if amount == 0 then break end
                        if not amount then log("Could not get the amount of the following table:") log(serpent.block(ing)) end
                        --Calculate lcm
                        --Since our lcm function is not working with floats, multiply by 1000 if we find floats to keep precision for low fluid amounts (we just divided by sluid fluid ratio)
                        min_amount = math.min(min_amount, amount)
                        max_amount = math.max(max_amount, amount)

                        lcm[dif] = omni.lib.lcm(lcm[dif], amount or 1)
                    end
                end
                --divide by the lcm mult again to get the "true" lcm
                lcm[dif] = lcm[dif] / lcm_mult
                --Get the recipe multiplier which is lcm/lowest amount found in this recipe to not lose precision
                mult[dif] = lcm[dif] / min_amount


                --Recalculate GCD
                for _, ingres in pairs({"ingredients","results"}) do
                    for    _, ing in pairs(rec[dif][ingres]) do
                        local amount = 0
                        if ing.type == "fluid" then
                            --Use fluids round function after the ratio division to avoid decimals
                            amount = omni.fluid.round_fluid(omni.fluid.round_fluid(omni.fluid.get_true_amount(ing)) / omni.fluid.sluid_contain_fluid) * mult[dif]
                        else
                            amount = omni.fluid.round_fluid(omni.fluid.get_true_amount(ing)) * mult[dif]
                        end
                        if amount == 0 then break end
                        if not amount then log("Could not get the amount of the following table:") log(serpent.block(ing)) end

                        if not gcd[dif] then
                            gcd[dif] = amount
                        else
                            gcd[dif] = omni.lib.gcd(gcd[dif], amount)
                        end
                    end
                end
                --The final recipe multiplier is our old mult/the calculated gcd
                mult[dif] = mult[dif] / gcd[dif]
            end
            max_mult = math.max(mult[dif], max_mult)
        end

        --Now Replace fluids with sluids and apply the mult too all ingres and crafting time
        for _, dif in pairs({"normal","expensive"}) do
            local fix_stacksize = false
            for _, ingres in pairs({"ingredients","results"}) do
                for    n, ing in pairs(rec[dif][ingres]) do
                    if ing.type == "fluid" then
                        local found_temp = nil
                        local new_ing={}--start empty to remove all old props to add only what is needed
                        new_ing.type = "item"
                        local cat = ""
                        if fluid_cats["sluid"][ing.name] then
                            cat = "sluid"
                        elseif fluid_cats["mush"][ing.name] then
                            cat = "mush"
                        else
                            break
                        end
                        --Has temperature set in recipe and that temperature is the default temp of the liquid --> use non temperature solid
                        if ing.temperature and ing.temperature == data.raw.fluid[ing.name].default_temperature then
                            new_ing.name = "solid-"..ing.name
                        --Has temperature set in recipe and that temperature is in our list
                        elseif ing.temperature and omni.lib.is_in_table(ing.temperature, fluid_cats[cat][ing.name].temperatures) then
                            new_ing.name = "solid-"..ing.name.."-T-"..string.gsub(ing.temperature, "%.", "_")
                        --Ingredient has to be in a specific temperature range, check if a solid between min and max exists
                        --May need to add a recipe for ALL temperatures that are in this range
                        elseif ing.minimum_temperature or ing.maximum_temperature or omni.fluid.boiler_fluids[ing.name] then
                            local min_temp = ing.minimum_temperature or data.raw.fluid[ing.name].default_temperature
                            --Temp min/max == fluid temp min/max -->use a non temp solid (min/max can exist solo)
                            --Steam sucks, dont replace fluid steam with a temperature less solid
                            if not omni.fluid.boiler_fluids[ing.name] and (min_temp <= data.raw.fluid[ing.name].default_temperature) then-- and max_temp == data.raw.fluid[ing.name].max_temperature) then
                                new_ing.name = "solid-"..ing.name
                            else
                                for _,temp in pairs(fluid_cats[cat][ing.name].temperatures) do
                                    if type(temp) == "number" and temp >= (ing.minimum_temperature or 0) and temp <= (ing.maximum_temperature or math.huge) then
                                        --If multiple temps are found, use the lowest.
                                        found_temp = math.min(found_temp or math.huge, temp)
                                    end
                                end
                                --Steam sucks
                                if omni.fluid.boiler_fluids[ing.name] then
                                    --Get the lowest boiler temp producing steam
                                    min_temp = min_steam_boiler_temp
                                    --If the min boiler temp is in the temperature range and the found temp is lower than that, use that
                                    if found_temp and found_temp < min_temp and min_temp >= (ing.minimum_temperature or 0) and min_temp <= (ing.maximum_temperature or math.huge) then
                                        found_temp = min_temp
                                    end
                                    --If nothing has been found yet, we need to replace it with the lowest boiler temp
                                    if not found_temp then--or (found_temp and found_temp < min_boiler_temp) then
                                        found_temp = min_temp
                                    end

                                    new_ing.name = "solid-"..ing.name.."-T-"..string.gsub(found_temp, "%.", "_")
                                elseif found_temp then
                                    new_ing.name = "solid-"..ing.name.."-T-"..string.gsub(found_temp, "%.", "_")
                                --No temperature matches, use the no temperature sluid as fallback (or if the recipe is a void recipe. Surpress the warning for this case)
                                elseif omni.lib.is_in_table("none", fluid_cats[cat][ing.name].temperatures) then
                                    new_ing.name = "solid-"..ing.name
                                    if not void_recipes[rec.name] then
                                        log("No sluid found that matches the correct temperature for "..ing.name.." in the recipe "..rec.name)
                                        log("Defined max. temp: "..(ing.maximum_temperature or "-"))
                                        log("Defined min. temp: "..(ing.minimum_temperature or "-"))
                                        log("Registered sluid temperatures: "..serpent.block(fluid_cats[cat][ing.name].temperatures))
                                    end
                                else
                                    log("Sluid Replacement error for "..ing.name)
                                    break
                                end
                            end
                        -- No temperature set and "none" is in our list --> no temp sluid exists
                        elseif omni.lib.is_in_table("none", fluid_cats[cat][ing.name].temperatures) then
                            new_ing.name = "solid-"..ing.name
                        --Something is wrong...
                        else
                            log("Sluid Replacement error for "..ing.name)
                            log(serpent.block(rec))
                            break
                        end
                        --Check if we want recipe copies for all temperatures in the min/max range and create them later by copying (only add this once!)
                        if omni.fluid.multi_temp_recipes[rec.name] and not add_multi_temp_recipes[rec.name] then
                            add_multi_temp_recipes[rec.name] = {fluid_name = ing.name, temperatures = {min = ing.minimum_temperature, max = ing.maximum_temperature, original = found_temp or "none"}}
                        end
                        --Finally round again for the case of a precision error like .999
                        local new_amount = 0
                        -- If amount is 0 (void recipes), jump this. Otherwise make sure that the amount is atleast 1
                        if (ing.amount and ing.amount > 0 ) or ing.amount_min or ing.amount_max then
                            new_amount = math.max(omni.lib.round(omni.fluid.get_true_amount(ing)*mult[dif]/omni.fluid.sluid_contain_fluid), 1)
                        end
                        new_ing.amount = math.min(new_amount, 65535)
                        if new_amount > 65535 then
                            log("WARNING: Ingredient "..new_ing.name.." from the recipe "..rec.name.." ran into the upper limit. Amount = "..new_amount.." Mult = "..mult[dif])
                        end
                        --Main product checks
                        if ingres == "results" and rec[dif].main_product and rec[dif].main_product == ing.name then
                            rec[dif].main_product = new_ing.name
                        end
                        rec[dif][ingres][n] = new_ing
                    --ingres is an item, apply mult
                    else

                        --Multiply amount with mult, keep probability in mind
                        local new_amount = omni.fluid.get_true_amount(ing) * mult[dif]
                        if new_amount < 1 then
                            ing.probability = new_amount
                            new_amount = 1
                        else
                            omni.lib.round(new_amount)
                            ing.probability = nil
                        end

                        ing.amount = math.min(new_amount, 65535)

                        --Apply the mult on the catalyst amount aswell
                        if ing.catalyst_amount then
                            ing.catalyst_amount = omni.lib.round(ing.catalyst_amount * mult[dif])
                        end

                        --Nil probability related values since these are calculated into the amount now
                        ing.amount_max = nil
                        ing.amount_min = nil

                        if new_amount > 65535 then
                            log("WARNING: Ingredient "..ing.name.." from the recipe "..rec.name.." ran into the upper limit. Amount = "..new_amount.." Mult = "..mult[dif])
                        end
                        --Check stacksize. If the stacksize is smaller than the amount, we need to split up the result/ingredien
                        local item_proto = omni.lib.find_prototype(ing.name)
                        if item_proto and ing.amount > 1 and (omni.lib.is_in_table("not-stackable", item_proto.flags or {}) or item_proto.stack_size == 1) then
                            fix_stacksize = true
                        end
                    end
                end
            end
            --crafting time adjustment
            rec[dif].energy_required = math.max(rec[dif].energy_required*mult[dif], 0.0011)
            --Apply stack size fixes
            if fix_stacksize then
                local add = {}
                for    _, ing in pairs(rec[dif]["results"]) do
                    local proto = omni.lib.find_prototype(ing.name)
                    if proto and (omni.lib.is_in_table("not-stackable", proto.flags or {}) or proto.stack_size == 1) then
                        local to_add = ing.amount - 1
                        ing.amount = 1
                        for _ = 1, to_add do
                            add[#add+1] = table.deepcopy(ing)
                        end
                    end
                end
                rec[dif]["results"]= omni.lib.union(rec[dif]["results"], add)
            end
        end
    else
        log("recipe not found:".. name)
    end
end
log("Highest sluid recipe multiplier: "..max_mult)

--Copy the sluid void recipe for all temperature sluids that have been generated
local voids = {}
for name, _ in pairs(void_recipes) do
    local rec = data.raw.recipe[name]
    local ing = rec.normal.ingredients[1].name
    local cat = "sluid"
    if fluid_cats["mush"][ing] then cat = "mush" end
    local flu = fluid_cats[cat][ing]

    if flu then
        for _,temp in pairs(fluid_cats[cat][ing].temperatures) do
            local tempstring = string.gsub(temp, "%.", "_")
            if type(temp) == "number" and data.raw.item["solid-"..flu.name.."-T-"..tempstring] then
                local new_rec = table.deepcopy(rec)
                new_rec.name = rec.name.."-T-"..tempstring
                new_rec.localised_name = omni.lib.locale.of(rec).name
                new_rec.normal.ingredients[1] = "solid-"..flu.name.."-T-"..tempstring
                new_rec.expensive.ingredients[1] = "solid-"..flu.name.."-T-"..tempstring
                voids[#voids+1] = new_rec
            end
        end
    end
end
if next(voids) then data:extend(voids) end

--Create the multi temperature recipe copies
for rec_name, fluid_data in pairs(add_multi_temp_recipes) do
    local temperatures = {}
    local replacement = "solid-"..fluid_data.fluid_name.."-T-"..string.gsub(fluid_data.temperatures.original, "%.", "_")
    if type(fluid_data.temperatures.original) ~= "number" then replacement = "solid-"..fluid_data.fluid_name end
    local cat = "sluid"
    if fluid_cats["mush"][fluid_data.fluid_name] then cat = "mush" end
    --Get all required temperatures
    local min_temp = fluid_data.temperatures.min or data.raw.fluid[fluid_data.fluid_name].default_temperature or -65535
    local max_temp = fluid_data.temperatures.max or data.raw.fluid[fluid_data.fluid_name].max_temperature or math.huge

    for _, temp in pairs(fluid_cats[cat][fluid_data.fluid_name].temperatures) do
        if (type(temp) == "number" and temp >= min_temp and temp <= max_temp and tostring(temp) ~= tostring(fluid_data.temperatures.original)) or
        (type(temp) ~= "number" and type(fluid_data.temperatures.original) ~= "number") then
            temperatures[#temperatures+1] = temp
        end
    end

    --Call create_temperature_copies with the replacement and a table of required temperatures
    omni.fluid.create_temperature_copies(data.raw.recipe[rec_name], fluid_data.fluid_name, replacement, temperatures)
end


------------
---Cleanup--
------------

--Replace minable fluids result with a sluid
for _,resource in pairs(data.raw.resource) do
    if resource.minable and resource.minable.results and resource.minable.results[1] and resource.minable.results[1].type == "fluid" then
        resource.minable.results[1].type = "item"
        resource.minable.results[1].name = "solid-"..resource.minable.results[1].name
        resource.minable.mining_time = resource.minable.mining_time * omni.fluid.sluid_contain_fluid
    end
end

--Replace furnace fluid ingredient/result slots with solid slots. Do not nil fluid boxes since they might be requried for barreling/conversion
for _, fu in pairs(data.raw["furnace"]) do
    if fu.fluid_boxes then
        for _, box in pairs(fu.fluid_boxes) do
            --Furnaces can not have more than 1 item ingredient slot
            if type(box) == "table" and box.production_type and box.production_type == "input" then
                fu.source_inventory_size = 1
            elseif type(box) == "table" and box.production_type and box.production_type == "output" then
                fu.result_inventory_size = (fu.result_inventory_size or 0) + 1
            end
        end
    end
end

--Fluid box removal
for _, jack in pairs(data.raw["mining-drill"]) do
    --Set the output vector for the solid item to the old output_fluicbox(if multiple are defined, use the first in the table) and nil the output_fluidbox
    if jack.output_fluid_box then
        local sluidbox = {0, -2}
        if jack.output_fluid_box.pipe_connections and jack.output_fluid_box.pipe_connections[1] then
            local pipe_con = jack.output_fluid_box.pipe_connections and jack.output_fluid_box.pipe_connections[1]
            if pipe_con.position then
                sluidbox = table.deepcopy(pipe_con.position)
            elseif pipe_con.positions and pipe_con.positions[1] then
                sluidbox = table.deepcopy(pipe_con.positions[1])
            end
        end
        jack.output_fluid_box = nil
        jack.vector_to_place_result = sluidbox
    end
end