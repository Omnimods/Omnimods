local analysation = require("prototypes.fluid-analysation")
local sluid_boiler = require("prototypes.sluid-boiler")
local fluid_cats = analysation.fluid_cats_
local recipe_mods = analysation.recipe_mods_
local void_recipes = analysation.void_recipes_

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

--Create items for sluids and mushes
for catname, cat in pairs(fluid_cats) do
    for _, fluid in pairs(cat) do
        local flu = data.raw.fluid[fluid.name]
        if catname ~= "fluid" then
            for _, state in pairs({"producer", "consumer"}) do
                for _,temp in pairs(fluid[state].temperatures) do
                    ent[#ent+1] = {
                        type = "item",
                        name = "solid-"..flu.name.."-T-"..string.gsub(temp, "%.", "_"),
                        localised_name = {"item-name.solid-fluid-tmp", flu.localised_name or {"fluid-name."..flu.name},"T="..temp},
                        localised_description = {"item-description.solid-fluid", flu.localised_description or {"fluid-description."..flu.name}},
                        icons = omni.lib.icon.of_generic(flu),
                        subgroup = "omni-solid-fluids",
                        order = (flu.order or "a").."-T-"..string.gsub(temp, "%.", "_"),
                        stack_size = omni.fluid.sluid_stack_size,
                    }
                end
            end
        end
        --Sluid only: hide unused fluids.
        if catname == "sluid" then
            flu.hidden = true
            flu.auto_barrel = false
        end
    end
end
data:extend(ent)

--Convert boilers to sluid boilers and create converter recipes
sluid_boiler(fluid_cats)

----------------------------------
-----Replacement preparations-----
----------------------------------
--Replace barrels with sluids before doing all other replacement so it can properly divide down the recipe ingredients/results
local function replace_barrels(recipe)
        for _, ingres in pairs({"ingredients","results"}) do
            for    j, ing in pairs(recipe[ingres]) do
                --Remove empty barrels
                if ing.name and (ing.name == "barrel" or ing.name == "empty-canister"  or ing.name == "empty-gas-canister")then
                    recipe[ingres][j] = nil
                --Replace filled barrels with sluids
                elseif ing.name and (string.find(ing.name, "%-barrel") or string.find(ing.name, "barrel%-") or string.find(ing.name, "%-canister")) then
                    local flu = string.gsub(ing.name, "%-barrel", "")
                    flu = string.gsub(flu, "barrel%-", "")
                    flu = string.gsub(flu, "%-gas%-canister", "")
                    flu = string.gsub(flu, "%-canister", "")

                    if fluid_cats["sluid"][flu] or fluid_cats["mush"][flu] then
                        local cat = "sluid"
                        if not fluid_cats[cat][flu] then cat = "mush" end

                        local tempstring = string.gsub(data.raw.fluid[flu].default_temperature, "%.", "_")
                        --Check if a solid with default temp exists, otherwise take the lowest consumer temp
                        if not data.raw.item["solid-"..flu.."-T-"..tempstring] then
                            local lowtemp = math.huge
                            for _, temp in pairs(fluid_cats[cat][flu].consumer.temperatures) do
                                if temp < lowtemp then
                                    lowtemp = temp
                                end
                            end
                            tempstring = string.gsub(lowtemp, "%.", "_")
                        end
                        if recipe.main_product and recipe.main_product == ing.name then
                            recipe.main_product = "solid-"..flu.."-T-"..tempstring
                        end
                        ing.name = "solid-"..flu.."-T-"..tempstring
                        ing.amount = omni.lib.round(ing.amount*50/omni.fluid.sluid_contain_fluid)
                    end
                end
            end
        end
end

--Special Py case 2146321487: replace filled barrel ingredients with solids (py uses "barel-" as name instead of "-barel")
for _, rec in pairs(data.raw.recipe) do
    if not omni.fluid.check_string_excluded(rec.name) and not omni.lib.recipe_is_hidden(rec.name)  then
        for _, ingres in pairs({"ingredients","results"}) do
            for _, ing in pairs(rec[ingres]) do
                if string.find(ing.name, "%-barrel") or string.find(ing.name, "barrel%-") or string.find(ing.name, "%-canister")  or string.find(ing.name, "%-gas%-canister") then
                    replace_barrels(rec)
                    goto continue
                end
            end
        end
        ::continue::
    end
end


-------------------------------------------
-----Replace recipe ingres with sluids-----
-------------------------------------------
local add_multi_temp_recipes = {}
local max_mult = 0

for name, _ in pairs(recipe_mods) do
    local rec = data.raw.recipe[name]
    if rec then
        -----Multiplier calculation with LCM AND GCD-----
        -------------------------------------------------
        local mult = 1
        local lcm = 1
        local gcd = nil

        local min_amount = math.huge
        local max_amount = 0
        local lcm_mult = 1
        for _, ingres in pairs({"ingredients","results"}) do
            --First loop: Calculate the lcm respecting omni.fluid.sluid_contain_fluid
            for    _, ing in pairs(rec[ingres]) do
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
                        lcm = lcm * lcm_mult
                        amount = amount * lcm_mult
                        amount = omni.lib.round(amount)
                    else
                        amount = omni.lib.round(amount * lcm_mult)
                    end
                else
                    amount = omni.lib.round(amount * lcm_mult)
                end
                lcm = omni.lib.lcm(lcm, amount or 1)
            end
        end
        --divide by the lcm mult again to get the "true" lcm
        lcm = lcm / lcm_mult
        --Get the recipe multiplier which is lcm/lowest amount found in this recipe to not lose precision
        mult = lcm / min_amount

        --Second loop: Find GCD of all ingres multiplied with the LCM multiplier we just calculated (with sluid_contain_fluid applied for fluids)
        for _, ingres in pairs({"ingredients","results"}) do
            for    _, ing in pairs(rec[ingres]) do
                local amount = 0
                if ing.type == "fluid" and ing.amount and ing.amount ~= 0 then
                    amount = omni.lib.round(omni.fluid.get_true_amount(ing) * mult) / omni.fluid.sluid_contain_fluid
                else
                    --amount = omni.lib.round((ing.amount or (ing.amount_min+ing.amount_max)/2)*mult[dif])
                    amount = omni.fluid.get_true_amount(ing) * mult
                end
                if amount == 0 then break end
                if not amount then log("Could not get the amount of the following table:") log(serpent.block(ing)) end

                if not gcd then
                    gcd = amount
                else
                    gcd = omni.lib.gcd(gcd, amount)
                end
            end
        end
        --The final recipe multiplier is our old mult/the calculated gcd
        mult = mult / gcd

        --Multiplier for this recipe is too huge. Lets do the math lcm/gcd math again with slightly less precision (use rounding)
        if mult*max_amount > 10000  or (mult > 50 and mult*max_amount > 1000) then
            --reset all values
            mult = 1
            lcm = 1
            gcd = nil
            min_amount = math.huge
            max_amount = 0
            lcm_mult = 1
            for _, ingres in pairs({"ingredients","results"}) do
                for    _, ing in pairs(rec[ingres]) do
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

                    lcm = omni.lib.lcm(lcm, amount or 1)
                end
            end
            --divide by the lcm mult again to get the "true" lcm
            lcm = lcm / lcm_mult
            --Get the recipe multiplier which is lcm/lowest amount found in this recipe to not lose precision
            mult = lcm / min_amount

            --Recalculate GCD
            for _, ingres in pairs({"ingredients","results"}) do
                for    _, ing in pairs(rec[ingres]) do
                    local amount = 0
                    if ing.type == "fluid" then
                        --Use fluids round function after the ratio division to avoid decimals
                        amount = omni.fluid.round_fluid(omni.fluid.round_fluid(omni.fluid.get_true_amount(ing)) / omni.fluid.sluid_contain_fluid) * mult
                    else
                        amount = omni.fluid.round_fluid(omni.fluid.get_true_amount(ing)) * mult
                    end
                    if amount == 0 then break end
                    if not amount then log("Could not get the amount of the following table:") log(serpent.block(ing)) end

                    if not gcd then
                        gcd = amount
                    else
                        gcd = omni.lib.gcd(gcd, amount)
                    end
                end
            end
            --The final recipe multiplier is our old mult/the calculated gcd
            mult = mult / gcd
        end
        max_mult = math.max(mult, max_mult)

        --Now Replace fluids with sluids and apply the mult too all ingres and crafting time
        local fix_stacksize = false
        for _, ingres in pairs({"ingredients","results"}) do
            for n, ing in pairs(rec[ingres]) do
                --Fuid replacement
                if ing.type == "fluid" then
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
                    --Producers: has temp, simply replace (no temp = default temp)
                    --Consumers: if temp, replace- otherwise search all possible temperatures
                    -->dont care for type, temp available == replace
                    --temp not available -->search all possible
                    local state = "producer"
                    if ingres == "ingredients" then state = "consumer" end
                    --First check: fluid has a specified temp -->simply replace
                    if ing.temperature and omni.lib.is_in_table(ing.temperature, fluid_cats[cat][ing.name][state].temperatures) then
                        new_ing.name = "solid-"..ing.name.."-T-"..string.gsub(ing.temperature, "%.", "_")
                    --results that have no temperature values --> factorio handles those by using the default fluid temp
                    elseif state == "producer" and not (ing.temperature or ing.minimum_temperature or ing.maximum_temperature) then
                        new_ing.name = "solid-"..ing.name.."-T-"..string.gsub(fluid_cats[cat][ing.name].default_temperature, "%.", "_")
                    --No specific temperature - This has to be a consumer (ingredient)
                    --Now we need to add recipe copies for each registered producer temperature that is in the defined range
                    else
                        local flu = fluid_cats[cat][ing.name]
                        --Get the allowed temperature range. if nothing is specified in the recipe it takes the fluids min/max temp
                        local min_temp = ing.minimum_temperature or flu.default_temperature
                        local max_temp = ing.maximum_temperature or flu.max_temperature
                        local found_temps = {}
                        for _, t in pairs(fluid_cats[cat][ing.name]["producer"].temperatures) do
                            if (t >= min_temp) and (t<=max_temp) then
                                found_temps[#found_temps+1] = t
                            end
                        end
                        --some fluids might not have any producers, use the default temp as fallback
                        if not next(found_temps) then
                            if data.raw.item["solid-"..flu.name.."-T-"..flu.default_temperature] then
                                found_temps = {flu.default_temperature}
                                --log(ing.name.." does not have any producers, falling back to the default temperature.")
                            else
                                local newtemp = fluid_cats[cat][ing.name]["producer"].temperatures[1]
                                for _, t in pairs(fluid_cats[cat][ing.name]["producer"].temperatures) do
                                    if math.abs(min_temp - t) < math.abs(min_temp - newtemp) then
                                        newtemp = t
                                    end
                                end
                                found_temps = {newtemp}
                            end
                        end
                        --If possible, use the default temperature of the fluid for the original recipe.
                        --Otherwise use the lowest found temperature. This logic is required to be determenistic with what temperature is used for the original recipe with compression for example
                        local used_temp = flu.default_temperature
                        if not omni.lib.is_in_table(flu.default_temperature, found_temps) then
                            used_temp = omni.lib.get_min(found_temps)
                        end
                        new_ing.name = "solid-"..ing.name.."-T-"..string.gsub(tostring(used_temp), "%.", "_")
                        --We need to create recipe copies with all other temperatures
                        if #found_temps > 1 then
                            add_multi_temp_recipes[#add_multi_temp_recipes+1] = {rec_name = rec.name, fluid_name = ing.name, temperatures = found_temps, original = used_temp}
                        end
                    end

                    --Finally round again for the case of a precision error like .999
                    local new_amount = 0
                    -- If amount is 0 (void recipes), jump this. Otherwise make sure that the amount is atleast 1
                    if (ing.amount and ing.amount > 0 ) or ing.amount_min or ing.amount_max then
                        new_amount = math.max(omni.lib.round(omni.fluid.get_true_amount(ing)*mult/omni.fluid.sluid_contain_fluid), 1)
                    end
                    new_ing.amount = math.min(new_amount, 65535)
                    if new_amount > 65535 then
                        log("WARNING: Ingredient "..new_ing.name.." from the recipe "..rec.name.." ran into the upper limit. Amount = "..new_amount.." Mult = "..mult)
                    end

                    --Main product checks
                    if ingres == "results" and rec.main_product and rec.main_product == ing.name then
                        rec.main_product = new_ing.name
                    end
                    rec[ingres][n] = new_ing

                --Items:Apply multiplier
                else
                    --Multiply amount with mult, keep probability in mind
                    local new_amount = omni.fluid.get_true_amount(ing) * mult
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
                        ing.catalyst_amount = omni.lib.round(ing.catalyst_amount * mult)
                    end

                    --Nil probability related values since these are calculated into the amount now
                    ing.amount_max = nil
                    ing.amount_min = nil

                    if new_amount > 65535 then
                        log("WARNING: Ingredient "..ing.name.." from the recipe "..rec.name.." ran into the upper limit. Amount = "..new_amount.." Mult = "..mult)
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
        rec.energy_required = math.max(rec.energy_required*mult, 0.0011)
        --Apply stack size fixes
        if fix_stacksize then
            --set a localised name - Due to splitting a single result, the recipe might not have one at all
            rec.localised_name = omni.lib.locale.of(rec).name
            local add = {}
            for    _, ing in pairs(rec["results"]) do
                local proto = omni.lib.find_prototype(ing.name)
                if proto and (omni.lib.is_in_table("not-stackable", proto.flags or {}) or proto.stack_size == 1) then
                    local to_add = ing.amount - 1
                    ing.amount = 1
                    for _ = 1, to_add do
                        add[#add+1] = table.deepcopy(ing)
                    end
                end
            end
            rec["results"]= omni.lib.union(rec["results"], add)
        end
    else
        log("recipe not found:".. name)
    end
end
log("Highest sluid recipe multiplier: "..max_mult)


--Create copies of generator recipes that have a fluid output for the generator fluid
for gen_recs, fluid_info in pairs(omni.fluid.generator_recipes) do
    local rec = data.raw.recipe[gen_recs]
    local gen_fluid = fluid_info.fluid
    local temp = fluid_info.temp
    if rec then
        local new_rec = table.deepcopy(rec)
            for _, res in pairs(new_rec.results) do
                if res.name and string.find(res.name, string.gsub(gen_fluid, "%-", "%%-")) then
                    --Main product checks
                    if new_rec.main_product and new_rec.main_product == res.name then
                        new_rec.main_product = gen_fluid
                    end
                    res.name = gen_fluid
                    res.type = "fluid"
                    res.amount = res.amount * omni.fluid.sluid_contain_fluid
                    res.temperature = temp
                end
            end
        new_rec.name = new_rec.name.."-fluid-"..gen_fluid
        if string.find(rec.name, "%-compression") then
            new_rec.enabled = true
        end
        data:extend({new_rec})
        omni.lib.add_unlock_recipe(omni.lib.get_tech_name(rec.name), new_rec.name)
    end
end


--Create the multi temperature recipe copies
for _, fluid_data in pairs(add_multi_temp_recipes) do
    local replacement = "solid-"..fluid_data.fluid_name.."-T-"..string.gsub(fluid_data.original, "%.", "_")
    --Call create_temperature_copies with the replacement and a table of required temperatures
    omni.fluid.create_temperature_copies(data.raw.recipe[fluid_data.rec_name], fluid_data.fluid_name, replacement, fluid_data.temperatures)
end

--Copy the sluid void recipe for all temperature sluids that have been generated
local voids = {}
for name, _ in pairs(void_recipes) do
    local rec = data.raw.recipe[name]
    local ing = rec.ingredients[1].name
    local cat = "sluid"
    if fluid_cats["mush"][ing] then cat = "mush" end
    local flu = fluid_cats[cat][ing]

    if flu then
        --Void recipes have to be consumers
        for _,temp in pairs(fluid_cats[cat][ing]["consumer"].temperatures) do
            local tempstring = string.gsub(temp, "%.", "_")
            if type(temp) == "number" and data.raw.item["solid-"..flu.name.."-T-"..tempstring] then
                local new_rec = table.deepcopy(rec)
                new_rec.name = rec.name.."-T-"..tempstring
                new_rec.localised_name = omni.lib.locale.of(rec).name
                new_rec.ingredients[1] = "solid-"..flu.name.."-T-"..tempstring
                voids[#voids+1] = new_rec
            end
        end
    end
end
if next(voids) then data:extend(voids) end


------------
---Cleanup--
------------

--Replace minable fluids result with a sluid
for _,resource in pairs(data.raw.resource) do
    if resource.minable and resource.minable.results and resource.minable.results[1] and resource.minable.results[1].type == "fluid" then
        local tempstring = data.raw.fluid[resource.minable.results[1].name].default_temperature
        resource.minable.results[1].type = "item"
        resource.minable.results[1].name = "solid-"..resource.minable.results[1].name.."-T-"..tempstring
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

--Mining drill fluid box removal
for _, jack in pairs(data.raw["mining-drill"]) do
    --Set the output vector for the solid item to the old output_fluidbox(if multiple are defined, use the first in the table) and nil the output_fluidbox
    if jack.output_fluid_box then
        local sluidbox = {0, -1.85}
        if jack.output_fluid_box.pipe_connections and jack.output_fluid_box.pipe_connections[1] then
            local pipe_con = jack.output_fluid_box.pipe_connections and jack.output_fluid_box.pipe_connections[1]
            if pipe_con.position then
                sluidbox = table.deepcopy(pipe_con.position)
            elseif pipe_con.positions and pipe_con.positions[1] then
                sluidbox = table.deepcopy(pipe_con.positions[1])
            end
            --make sure to use the inner side of the belt
            sluidbox = {sluidbox[1], sluidbox[2]+0.15}
        end
        jack.output_fluid_box = nil
        jack.vector_to_place_result = sluidbox
    end
end