--Sort all fluid into categories. Fluids are ignored, Sluids get converted to items, mush stays fluid but also gets an item version.
--examples of fluid only: steam and other fluidbox filtered generator fluids
--examples of mush: mining fluids (sulfuric acid etc...)
local fluid_cats = {fluid = {}, sluid = {}, mush = {}}
local recipe_mods = {}  --build a list of recipes to modify after the sluids list is generated
local crafting_category_fluids = {} --Save the highest amount of unique fluid ingredients per crafting category
local generator_fluid = {} --is used in a generator
local void_recipes = {} --Recipe has no result(s)


--Keep track of which temperatures are required for each fluid
--Sort by producers and consumer to be able to remove unnecessary temperature copies later on
local function sort_fluid(fluidname, category, state, temperature)
    local fluid = data.raw.fluid[fluidname]
    if temperature and not next(temperature) then temperature = nil end
    --Fluid doesnt exist in this category or as mush yet --We need to move stuff
    if fluid and not fluid_cats[category][fluid.name] and not fluid_cats["mush"][fluid.name] then
        --Check for a combination of fluid / sluid. If both is required, add it as mush and remove it from sluids/fluids
        --Pick up the already known temperature table
        if category == "fluid" and fluid_cats["sluid"][fluid.name] then
            category = "mush"
            --Move over all old data and nil old table
            fluid_cats[category][fluid.name] = table.deepcopy(fluid_cats["sluid"][fluid.name])
            fluid_cats["sluid"][fluid.name] = nil
        elseif category == "sluid" and fluid_cats["fluid"][fluid.name] then
            category = "mush"
            --Move over all old data and nil old table
            fluid_cats[category][fluid.name] = table.deepcopy(fluid_cats["fluid"][fluid.name])
            fluid_cats["fluid"][fluid.name] = nil
        end

        --Only copy required attributes from the base fluid to not create huge tables
        if not fluid_cats[category][fluid.name] then
            fluid_cats[category][fluid.name] = {
                name=fluid.name, localised_name=fluid.localised_name, default_temperature = fluid.default_temperature, max_temperature=fluid.max_temperature or fluid.default_temperature, fuel_value=fluid.fuel_value, heat_capacity=fluid.heat_capacity
            }
        end

        --Create producer/consumer tables
        if not fluid_cats[category][fluid.name]["consumer"] then fluid_cats[category][fluid.name]["consumer"] = {} end
        if not fluid_cats[category][fluid.name]["producer"] then fluid_cats[category][fluid.name]["producer"] = {} end
        --Add the temperatures
        fluid_cats[category][fluid.name][state].temperatures = omni.lib.union(fluid_cats[category][fluid.name][state].temperatures or {}, {temperature or {temp = "none"}})

    --Fluid already exists in a category (has to be a mush at this point):
    --Update temperatures table if a temperature is specified. Check if "none" is already in the table if no temp is specified
    elseif fluid then
        --Check if it already exists as mush and repoint category to that
        if category ~= "mush" and fluid_cats["mush"][fluid.name] then category = "mush" end

        if not fluid_cats[category][fluid.name][state].temperatures then fluid_cats[category][fluid.name][state].temperatures = {} end
        table.insert(fluid_cats[category][fluid.name][state].temperatures, temperature or {temp = "none"})
    else
        log(serpent.block(temperature))
        log("Fail")
    end
end


------------------------------
-----Analyse all entities-----
------------------------------

--generators
for _, gen in pairs(data.raw.generator) do
    --Check exclusion table
    if not omni.fluid.check_string_excluded(gen.name) then
        --Ignore fluid burning gens, looking for things that must stay fluid like steam and save their required temperature in case of getting mush
        if not gen.burns_fluid and gen.fluid_box and gen.fluid_box.filter then
            --Ignore steam since we create a seperate boiling recipe for that
            if gen.fluid_box.filter ~= "steam" then
                sort_fluid(gen.fluid_box.filter, "fluid", "consumer", {temp = gen.maximum_temperature, conversion = true})
            end
            generator_fluid[gen.fluid_box.filter] = true --set the fluid up as a known filter
            --log("Added "..gen.fluid_box.filter.." as fluid. Generator: "..gen.name)
        end
    end
end

for _, boiler in pairs(data.raw.boiler) do
    --Check exclusion table
    if not omni.fluid.check_string_excluded(boiler.name) and not omni.fluid.forbidden_boilers[boiler.name]then
        --Input fluid == output fluid - Boiler is only used for heating up the fluid
        if boiler.fluid_box.filter == boiler.output_fluid_box.filter then
            sort_fluid(boiler.fluid_box.filter, "fluid", "producer", {temp = boiler.target_temperature, conversion = true})
        end
        --log("Added "..gen.fluid_box.filter.." as fluid. Boiler: "..boiler.name)
    end
end

--fluid throwing type turrets
for _, turr in pairs(data.raw["fluid-turret"]) do
    if turr.attack_parameters.fluids then
        for _, flu in pairs(turr.attack_parameters.fluids) do
            sort_fluid(flu.type, "fluid", "consumer", {temp = "none", conversion = true})
            --log("Added "..flu.type.." as fluid. Generator: "..turr.name)
        end
    end
end

--mining fluid detection
for _, res in pairs(data.raw.resource) do
    --Required fluids for resources
    if res.minable then
        if res.minable.required_fluid then
            sort_fluid(res.minable.required_fluid, "fluid", "consumer", {temp = "none", conversion = true})
            --log("Added "..res.minable.required_fluid.." as mining fluid. Resource: "..res.name)
        end
        --Fluid resources just incase they are not added from other analysis (fluids cant be in minable.result)
        if res.minable.results then
            for _,flu in pairs(res.minable.results) do
                if flu.type and flu.type =="fluid" then
                    sort_fluid(flu.name, "sluid", "producer")
                    --log("Added "..res.minable.required_fluid.." as sluid mining product. Resource: "..res.name)
                end
            end
        end
    end
end

--Mining fluids registered by compat
for flu, _ in pairs(omni.fluid.mining_fluids) do
    sort_fluid(flu, "fluid", "consumer", {temp = "none", conversion = true})
end

--recipes
for _, rec in pairs(data.raw.recipe) do
    --need to check hidden recipes aswell (voiding stuff for example), maybe exclude hidden AND NOT enabled in the future?
    if not omni.fluid.check_string_excluded(rec.name) --[[and not omni.lib.recipe_is_hidden(rec.name)]] and not omni.fluid.forbidden_recipe[rec.name] then
        local fluids = {}
        local ing_fluids = 0
        local is_void = omni.fluid.is_fluid_void(rec)
        for _, ingres in pairs({"ingredients","results"}) do --ignore result/ingredient as they don't handle fluids
            if rec[ingres] then
                for _, it in pairs(rec[ingres]) do
                    if it and it.type and it.type == "fluid" then
                        fluids[#fluids+1] = {flu = it, type = ingres}
                        recipe_mods[rec.name] = recipe_mods[rec.name] or {ingredients = {}, results = {}}
                        if ingres == "ingredients" then ing_fluids = ing_fluids + 1 end
                    end
                end
            elseif (rec.normal and rec.normal[ingres]) or (rec.expensive and rec.expensive[ingres]) then
                for _, diff in pairs({"normal","expensive"}) do
                    if rec[diff] and rec[diff][ingres] then
                        for _, it in pairs(rec[diff][ingres]) do
                            if it and it.type and it.type == "fluid" then
                                fluids[#fluids+1] = {flu = it, type = ingres}
                                recipe_mods[rec.name] = recipe_mods[rec.name] or {ingredients = {}, results = {}}
                                if ingres == "ingredients" then ing_fluids = ing_fluids + 1 end
                            end
                        end
                    end
                end
            end
        end

        --Update the fluid count for the crafting category of this recipe. "crafting" cant hold any fluids so we dont need to worry
        if rec.category and rec.category ~= "crafting" then
            if not crafting_category_fluids[rec.category] then
                crafting_category_fluids[rec.category] = ing_fluids
            else
                crafting_category_fluids[rec.category] = math.max(crafting_category_fluids[rec.category], ing_fluids)
            end
        end

        for _, fluid in pairs(fluids) do
            local state = "producer"
            if fluid.type =="ingredients" then state = "consumer" end
            if is_void then
                sort_fluid(fluid.flu.name, "sluid", state)
                void_recipes[rec.name] = true
                --log("Added recipe "..rec.name.." as voiding recipe.")
            else
                local conv = nil
                local flu_temp = fluid.flu.temperature
                if (fluid.flu.temperature or -65535) > (data.raw.fluid[fluid.flu.name].default_temperature or math.huge) then conv = true end
                --if only fluid.temperature is specified and if that matches the fluid´s default temperature, we dont need to register that to get a temperature less replacement
                if fluid.flu.temperature and fluid.flu.temperature == data.raw.fluid[fluid.flu.name].default_temperature  and not fluid.flu.maximum_temperature then flu_temp = nil end
                sort_fluid(fluid.flu.name, "sluid", state, {temp = flu_temp, temp_min = fluid.flu.minimum_temperature, temp_max = fluid.flu.maximum_temperature, conversion = conv})
            end
        end
    else
        --log("Ignoring blacklisted recipe "..rec.name)
    end
end

-- --Check all fluids for a fuel value -- Required? We should detect all fluid burning generators
-- for _,fluid in pairs(data.raw.fluid) do
--     if fluid.fuel_value then
--         sort_fluid(fluid.name, "fluid", {temp = "none", conversion = true})
--     end
-- end

--Always create sluid steam for the lowest boiler temp
local min_boiler_temp = math.huge
for _, boiler in pairs(data.raw.boiler) do
    min_boiler_temp = math.min(min_boiler_temp, boiler.target_temperature)
end
if min_boiler_temp < math.huge then
    sort_fluid("steam", "sluid", "producer", {temp = min_boiler_temp})
end

--Increase assembling machine ingredient slots if they cant hold the updated sluid recipe anymore
for _, ass in pairs(data.raw["assembling-machine"]) do
    if ass.ingredient_count then
        for _, cat in pairs(ass.crafting_categories) do
            local max_inc = 0
            if crafting_category_fluids[cat] then
                max_inc = math.max(max_inc, crafting_category_fluids[cat])
            end
            ass.ingredient_count = math.min(255, ass.ingredient_count + max_inc)
        end
    end
end


---------------------------------
-----Sort temperatures-----------
---------------------------------
--Should check if we can properly build this table so we dont need to clean it up
for _,cat in pairs(fluid_cats) do
    for _,fluid in pairs(cat) do
        local new_temps = {consumer = {}, producer = {}}
        local conversions = {consumer = {}, producer = {}}
        for _, state in pairs({"producer", "consumer"}) do
            --Some fluids might not have any consumer/producers
            if not fluid[state].temperatures then
                log(fluid.name.." has no "..state)
                goto continue
            end

            --First loop: Get all entries that have .temperature set
            for i=#(fluid[state].temperatures),1,-1 do
                --Clean up all cases of "none" - Producers: default fluid temp, consumer: min/max fluid temp
                if fluid[state].temperatures[i].temp == "none" and state == "producer" then
                    fluid[state].temperatures[i].temp = fluid.default_temperature
                elseif fluid[state].temperatures[i].temp == "none" and state == "consumer" then
                    fluid[state].temperatures[i].temp = nil
                    fluid[state].temperatures[i].temp_min = fluid.default_temperature
                    fluid[state].temperatures[i].temp_max = fluid.max_temperature
                    --new_temps[#new_temps+1] = {temp_min = fluid.default_temperature, temp_max = fluid.max_temperature}
                end

                --Get all entries that have .temperature set
                if fluid[state].temperatures[i].temp then
                    if fluid[state].temperatures[i].conversion then
                        conversions[state][fluid[state].temperatures[i].temp] = true
                    end
                    if not omni.lib.is_in_table(fluid[state].temperatures[i].temp, new_temps[state]) then
                        new_temps[state][#new_temps[state]+1] = fluid[state].temperatures[i].temp
                    end
                    fluid[state].temperatures[i] = nil
                end
            end

            if next(fluid[state].temperatures) then fluid[state].temperatures = omni.fluid.compact_array(fluid[state].temperatures) end

            --Check if the producer table is empty --> Everything should be sorted out properly
            if state == "producer" and next(fluid["producer"].temperatures) then
                log("This should be empty (producers)")
                log(fluid.name)
                log(serpent.block(fluid[state].temperatures))
                log(serpent.block(new_temps[state]))
                log(serpent.block("Min: "..fluid.default_temperature.." Max: "..fluid.max_temperature))
            end
            ::continue::
        end

        --Second Loop: Go through the consumer which have min/max set
        if fluid["consumer"].temperatures then
            --> Check for producer temps that are in the range of the min/max consumer temps. If there are multiple in the range, we need each
            for i = #(fluid["consumer"].temperatures),1,-1 do
                local flu = fluid["consumer"].temperatures[i]
                local min = flu.temp_min or fluid.default_temperature
                local max = flu.temp_max or fluid.max_temperature
                if next(new_temps["producer"]) then
                    for _, prod in pairs(new_temps["producer"]) do
                        if (prod >= min) and (prod <= max) then
                            if flu.conversion then
                                conversions["consumer"][prod] = true
                            end
                            if not omni.lib.is_in_table(prod, new_temps["consumer"]) then
                                new_temps["consumer"][#new_temps["consumer"]+1] = prod
                            end
                            fluid["consumer"].temperatures[i] = nil
                        end
                    end
                    fluid["consumer"].temperatures[i] = nil
                else --No producers, use the default temp
                    fluid["consumer"].temperatures[i] = nil
                    if flu.conversion then
                        conversions["consumer"][fluid.default_temperature] = true
                    end
                    if not omni.lib.is_in_table(fluid.default_temperature, new_temps["consumer"]) then
                        new_temps["consumer"][#new_temps["consumer"]+1] = fluid.default_temperature
                    end
                    fluid["consumer"].temperatures[i] = nil
                end
            end

            --Check if the consumer table is empty --> Everything should be sorted out properly
            if next(fluid["consumer"].temperatures) then
                log("This should be empty (consumer)")
                log(fluid.name)
                log(serpent.block(fluid["consumer"].temperatures))
                log(serpent.block(new_temps["consumer"]))
                log(serpent.block("Min: "..fluid.default_temperature.." Max: "..fluid.max_temperature))
            end

            --Add the found temperatures to the fluid cats table
            fluid["consumer"].temperatures = new_temps["consumer"]
            fluid["consumer"].conversions = conversions["consumer"]
            fluid["producer"].temperatures = new_temps["producer"]
            fluid["producer"].conversions = conversions["producer"]
        end
    end
end

return {fluid_cats_ = fluid_cats, generator_fluid_ = generator_fluid, recipe_mods_ = recipe_mods, void_recipes_ = void_recipes}