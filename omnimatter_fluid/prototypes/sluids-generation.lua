--Sort all fluid into categories. Fluids are ignored, Sluids get converted to items, mush stays fluid but also gets an item version.
--[[==examples of fluid only:
        steam and other fluidbox filtered generator fluids
        heat(omnienergy)]]
--[[examples of mush:
        mining fluids (sulfuric acid etc...)]]
local fluid_cats = {fluid = {}, sluid = {}, mush = {}}
local generator_fluid = {} --is used in a generator
--build a list of recipes to modify after the sluids list is generated
local recipe_mods = {}
local void_recipes = {}
local add_multi_temp_recipes = {}

local function sort_fluid(fluidname, category, temperature)
    local fluid = data.raw.fluid[fluidname]
    if temperature and not next(temperature) then temperature = nil end
    --Fluid doesnt exist in this category or as mush yet
    if fluid and not fluid_cats[category][fluid.name] and not fluid_cats["mush"][fluid.name] then
        --Check for a combination of fluid / sluid. If both is required, add it as mush and remove it from sluids/fluids
        local temperatures = {}
        --Pick up the already known temperature table
        if category == "fluid" and fluid_cats["sluid"][fluid.name] then
            category = "mush"
            temperatures = omni.lib.union(fluid_cats["sluid"][fluid.name].temperatures, {temperature or {temp = "none"}})
            fluid_cats["sluid"][fluid.name] = nil
        elseif category == "sluid" and fluid_cats["fluid"][fluid.name] then
            category = "mush"
            temperatures = omni.lib.union(fluid_cats["fluid"][fluid.name].temperatures, {temperature or {temp = "none"}})
            fluid_cats["fluid"][fluid.name] = nil
        else
            temperatures = {temperature or {temp = "none"}}
        end
        fluid_cats[category][fluid.name] = table.deepcopy(fluid)
        fluid_cats[category][fluid.name].temperatures = temperatures
    --Fluid already exists: Update temperatures table if a temperature is specified. Check if "none" is already in the table if no temp is specified
    elseif fluid then
        --Check if it already exists as mush and repoint category to that
        if category ~= "mush" and fluid_cats["mush"][fluid.name] then category = "mush" end
        table.insert(fluid_cats[category][fluid.name].temperatures, temperature or {temp = "none"})
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
                sort_fluid(gen.fluid_box.filter, "fluid", {temp = gen.maximum_temperature, conversion = true})
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
            sort_fluid(boiler.fluid_box.filter, "fluid", {temp = boiler.target_temperature, conversion = true})
        end
        --log("Added "..gen.fluid_box.filter.." as fluid. Boiler: "..boiler.name)
    end
end

--fluid throwing type turrets
for _, turr in pairs(data.raw["fluid-turret"]) do
    if turr.attack_parameters.fluids then
        for _, flu in pairs(turr.attack_parameters.fluids) do
            sort_fluid(flu.type, "fluid", {temp = "none", conversion = true})
            --log("Added "..flu.type.." as fluid. Generator: "..turr.name)
        end
    end
end

--mining fluid detection
for _, res in pairs(data.raw.resource) do
    --Required fluids for resources
    if res.minable then
        if res.minable.required_fluid then
            sort_fluid(res.minable.required_fluid, "fluid", {temp = "none", conversion = true})
            --log("Added "..res.minable.required_fluid.." as mining fluid. Resource: "..res.name)
        end
        --Fluid resources just incase they are not added from other analysis (fluids cant be in minable.result)
        if res.minable.results then
            for _,flu in pairs(res.minable.results) do
                if flu.type and flu.type =="fluid" then
                    sort_fluid(flu.name, "sluid")
                    --log("Added "..res.minable.required_fluid.." as sluid mining product. Resource: "..res.name)
                end
            end
        end
    end
end

--Mining fluids registered by compat
for flu, _ in pairs(omni.fluid.mining_fluids) do
    sort_fluid(flu, "fluid", {temp = "none", conversion = true})
end

--recipes
for _, rec in pairs(data.raw.recipe) do
    --need to check hidden recipes aswell (voiding stuff for example), maybe exclude hidden AND NOT enabled in the future?
    if not omni.fluid.check_string_excluded(rec.name) --[[and not omni.lib.recipe_is_hidden(rec.name)]] and not omni.fluid.forbidden_recipe[rec.name] then
        local fluids = {}
        local is_void = omni.fluid.is_fluid_void(rec)
        for _, ingres in pairs({"ingredients","results"}) do --ignore result/ingredient as they don't handle fluids
            if rec[ingres] then
                for _, it in pairs(rec[ingres]) do
                    if it and it.type and it.type == "fluid" then
                        fluids[#fluids+1] = it
                        recipe_mods[rec.name] = recipe_mods[rec.name] or {ingredients = {}, results = {}}
                    end
                end
            elseif (rec.normal and rec.normal[ingres]) or (rec.expensive and rec.expensive[ingres]) then
                for _, diff in pairs({"normal","expensive"}) do
                    if rec[diff] and rec[diff][ingres] then
                        for _, it in pairs(rec[diff][ingres]) do
                            if it and it.type and it.type == "fluid" then
                                fluids[#fluids+1] = it
                                recipe_mods[rec.name] = recipe_mods[rec.name] or {ingredients = {}, results = {}}
                            end
                        end
                    end
                end
            end
        end
        for _, fluid in pairs(fluids) do
            if is_void then
                sort_fluid(fluid.name, "sluid")
                void_recipes[rec.name] = true
                --log("Added recipe "..rec.name.." as voiding recipe.")
            else
                local conv = nil
                local flu_temp = fluid.temperature
                if (fluid.temperature or -65535) > (data.raw.fluid[fluid.name].default_temperature or math.huge) then conv = true end
                --if only fluid.temperature is specified and if that matches the fluid´s default temperature, we dont need to register that to get a temperature less replacement
                if fluid.temperature and fluid.temperature == data.raw.fluid[fluid.name].default_temperature  and not fluid.maximum_temperature then flu_temp = nil end
                sort_fluid(fluid.name, "sluid", {temp = flu_temp, temp_min = fluid.minimum_temperature, temp_max = fluid.maximum_temperature, conversion = conv})
            end
        end
    else
        --log("Ignoring blacklisted recipe "..rec.name)
    end
end

--Check all fluids for a fuel value
for _,fluid in pairs(data.raw.fluid) do
    if fluid.fuel_value then
        sort_fluid(fluid.name, "fluid", {temp = "none", conversion = true})
    end
end

--Find the lowest and highest boilers target temperature
local min_boiler_temp = math.huge
local max_boiler_temp = 0
--Save all boiler temps with the according fluid output
local boiler_temps = {}

for _, boiler in pairs(data.raw.boiler) do
    min_boiler_temp = math.min(min_boiler_temp, boiler.target_temperature)
    max_boiler_temp = math.max(max_boiler_temp, boiler.target_temperature)

    local fluid = boiler.output_fluid_box.filter or "steam"
    if not boiler_temps[fluid] then
        boiler_temps[fluid]  = {boiler.target_temperature}
    else
        table.insert(boiler_temps[fluid], boiler.target_temperature)
    end
end

--Always create sluid steam for the lowest boiler temp
if min_boiler_temp < math.huge then
    sort_fluid("steam", "sluid", {temp = min_boiler_temp})
end


---------------------------------
-----Sort temperatures-----
---------------------------------
--Should check if we can properly build this table so we dont need to clean it up
for _,cat in pairs(fluid_cats) do
    for _,fluid in pairs(cat) do
        local new_temps = {}
        local conversions = {}
        --First loop: Get all entries that have .temperature or nothing (just one) set
        for i=#(fluid.temperatures),1,-1 do
            --Steam sucks
            if fluid.temperatures[i].temp then
                if fluid.temperatures[i].conversion then
                    conversions[fluid.temperatures[i].temp] = true
                end
                if not omni.lib.is_in_table(fluid.temperatures[i].temp, new_temps) then
                    new_temps[#new_temps+1] = fluid.temperatures[i].temp
                end
                fluid.temperatures[i] = nil
            end
        end

        if next(fluid.temperatures) then fluid.temperatures = omni.fluid.compact_array(fluid.temperatures) end

        --Second Loop: Go through the leftovers which have min/max set
        for i = #(fluid.temperatures),1,-1 do
            local found = false
            local temp = 0
            local flu = fluid.temperatures[i]
            if flu.temp_min or flu.temp_max then
                --Best case: min/max (for the required recipe) equals fluid min/max -->we can use a temperature-less solid (min/max dont have to both exist!!! if only one exists and matches its fine)
                if ((flu.temp_min or data.raw.fluid[fluid.name].default_temperature) == data.raw.fluid[fluid.name].default_temperature) and ((flu.temp_max or data.raw.fluid[fluid.name].max_temperature) == data.raw.fluid[fluid.name].max_temperature) then
                    found = true
                    temp = "none"
                else
                    --check if theres an entry already in its range
                    for _, new in pairs(new_temps)do
                        if type(new) == "number" and new >= (flu.temp_min or 0) and new <= (flu.temp_max or math.huge) then
                            found = true
                            temp = new
                            break
                        end
                    end
                    --Max is > than fluid.default_temperature.
                    --Fluid might only have default temp. versions in recipes. If this is the case, nothing had been found here yet and we need to point to "none"
                    if flu.temp_max and flu.temp_max >= fluid.default_temperature and omni.lib.is_in_table("none", new_temps) then
                        found = true
                        temp = "none"
                    end
                end
                if found == true then
                    if flu.conversion then
                        conversions[temp] = true
                    end
                    fluid.temperatures[i] = nil
                end
            end
        end

        --Check if the table is empty --> Everything should be sorted out properly
        if next(fluid.temperatures) then
            log("This should be empty")
            log(fluid.name)
            log(serpent.block(fluid.temperatures))
            log(serpent.block(new_temps))
            log(serpent.block("Min: "..fluid.default_temperature.." Max: "..fluid.max_temperature))
        end
        fluid.temperatures = new_temps
        fluid.conversions = conversions
    end
end


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
                        icons = omni.lib.icon.of_generic(fluid),
                        subgroup = "omni-solid-fluids",
                        order = fluid.order or "a",
                        stack_size = omni.fluid.sluid_stack_size,
                    }
                else
                    ent[#ent+1] = {
                        type = "item",
                        name = "solid-"..fluid.name.."-T-"..temp,
                        localised_name = {"item-name.solid-fluid-tmp", fluid.localised_name or {"fluid-name."..fluid.name},"T="..temp},
                        localised_description = {"item-description.solid-fluid", fluid.localised_description or {"fluid-description."..fluid.name}},
                        icons = omni.lib.icon.of_generic(fluid),
                        subgroup = "omni-solid-fluids",
                        order = fluid.order or "a",
                        stack_size = omni.fluid.sluid_stack_size,
                    }
                end
            end
        end
        --Sluid only: hide unused fluid
        if catname == "sluid" then
            fluid.hidden = true
            fluid.auto_barrel = false
        end
    end
end
data:extend(ent)


----------------------------------------
-----Sluid Boiler recipe generation-----
----------------------------------------
local new_boiler = {}
local ing_replace={}
local boiler_tech = {}
local boiling_steam = {}

for _, boiler in pairs(data.raw.boiler) do
    --PREPARE DATA FOR MANIPULATION
    local water = boiler.fluid_box.filter or "water"
    local steam = boiler.output_fluid_box.filter or "steam"
    local th_energy = (boiler.target_temperature - data.raw.fluid[water].default_temperature) * omni.lib.get_fuel_number(data.raw.fluid[water].heat_capacity)
    local boiler_consumption = 60 * omni.lib.get_fuel_number(boiler.energy_consumption) / ((boiler.energy_source.effectivity or 1) * th_energy)

    --clobber fluid_box_filter if it exists
    if generator_fluid[boiler.output_fluid_box.filter] then
        generator_fluid[boiler.output_fluid_box.filter] = nil
    end

    --if exists, find recipe, item and entity
    if not omni.fluid.forbidden_boilers[boiler.name] then --and boiler.minable then
        local rec = omni.lib.find_recipe(boiler.minable and boiler.minable.result) or omni.lib.find_recipe(boiler.name)

        new_boiler[#new_boiler+1] = {
            type = "recipe-category",
            name = "boiler-omnifluid-"..boiler.name,
        }

        --set-up result and main product values to be the new converter
        omni.lib.replace_recipe_result(rec.name, boiler.name, boiler.name.."-converter")

        --Create  boiling recipe with the boilers target temp (only when input~= output. Some boilers are used to heat up fluids)
        if water ~= steam then
            new_boiler[#new_boiler+1] = {
                type = "recipe",
                name = boiler.name.."-boiling-steam-"..boiler.target_temperature,
                icons = omni.lib.icon.of(data.raw.fluid[steam]),
                subgroup = "boiler-sluid-steam",
                category = "boiler-omnifluid-"..boiler.name,
                order = "g[hydromnic-acid]",
                energy_required = omni.fluid.sluid_contain_fluid/boiler_consumption,
                enabled = true,
                hide_from_player_crafting = true,
                main_product = steam,
                ingredients = {{type = "item", name = "solid-"..water, amount = 1},},
                results = {{type = "fluid", name = steam, amount = omni.fluid.sluid_contain_fluid, temperature = math.min(boiler.target_temperature, data.raw.fluid[steam].max_temperature)},},
            }
        end

        --Create a solid water boiling recipe version if steam with the boiler target temp is required. A recipe with the lowest boilers targed temp needs to be created aswell when "none" temp steam is required
        local category = "mush"
        if fluid_cats["sluid"][steam] then category = "sluid" end
        local found = false
        for _, temp in pairs(fluid_cats[category][steam].temperatures) do
            if (type(temp) == "string" and temp == "none" and boiler.target_temperature == min_boiler_temp) or (type(temp) == "number" and boiler.target_temperature == temp) then
                found = true
                break
            end
        end
        if found == true then
            local boiled_amount = omni.fluid.sluid_contain_fluid
            if water == steam then boiled_amount = 1 end
            boiling_steam[boiler.target_temperature] = true
            new_boiler[#new_boiler+1] = {
                type = "recipe",
                name = boiler.name.."-boiling-solid-steam-"..boiler.target_temperature,
                icons = omni.lib.icon.of(data.raw.fluid[steam]),
                subgroup = "boiler-sluid-steam",
                category = "boiler-omnifluid-"..boiler.name,
                order = "g[hydromnic-acid]",
                energy_required = omni.fluid.sluid_contain_fluid/boiler_consumption,
                enabled = true,
                hide_from_player_crafting = true,
                main_product = "solid-"..steam.."-T-"..boiler.target_temperature,
                ingredients = {{type = "item", name = "solid-"..water, amount = 1},},
                results = {{type = "item", name = "solid-"..steam.."-T-"..boiler.target_temperature, amount = boiled_amount}},
            }
        end

        --If the boiler output fluid requires a conversion with a temp < this boilers target temperature but higher than the next lower boiler, then we need to add a conversion recipe
        if fluid_cats["sluid"][steam] then
            --find next lower boiler for the same fluid
            local lower_tier = 0
            for _, t in pairs(boiler_temps[steam]) do
                if t > lower_tier and t < boiler.target_temperature then lower_tier = t end
            end
            for temp, _ in pairs(fluid_cats["sluid"][steam].conversions) do
                if temp < boiler.target_temperature and temp > lower_tier then
                    if data.raw.item["solid-"..steam.."-T-"..temp] then
                        new_boiler[#new_boiler+1] = {
                            type = "recipe",
                            name = boiler.name.."-"..steam.."-fluidisation-"..temp,
                            icons = omni.lib.icon.of(steam,"fluid"),
                            subgroup = "boiler-sluid-converter",
                            category = "boiler-omnifluid-"..boiler.name,
                            order = "g[hydromnic-acid]",
                            energy_required = omni.fluid.sluid_contain_fluid/boiler_consumption,
                            enabled = true,
                            hide_from_player_crafting = true,
                            main_product = steam,
                            ingredients = {{type = "item", name = "solid-"..steam.."-T-"..temp, amount = 1}},
                            results = {{type = "fluid", name = steam, amount = omni.fluid.sluid_contain_fluid, temperature = temp}},
                        }
                    end
                end
            end
        end

        --Create mush converter recipes
        for _, fugacity in pairs(fluid_cats.mush) do
            --deal with non-water mush fluids, allow temperature and specific boiler systems
            for temp,_ in pairs(fugacity.conversions) do
                --Check the old temperatures table if the required temperature requires a conversion recipe
                --Create conversion recipes for all mushes up to the boilers target temperature. Generator assembler fluids higher than any boiler temp are added to the highest tier boiler
                if temp ~= "none"  and (boiler.target_temperature >= temp or (omni.fluid.assembler_generator_fluids[fugacity.name] and boiler.target_temperature == max_boiler_temp)) then
                    if data.raw.item["solid-"..fugacity.name.."-T-"..temp] then
                        new_boiler[#new_boiler+1] = {
                            type = "recipe",
                            name = boiler.name.."-"..fugacity.name.."-fluidisation-"..temp,
                            icons = omni.lib.icon.of(fugacity.name,"fluid"),
                            subgroup = "boiler-sluid-converter",
                            category = "boiler-omnifluid-"..boiler.name,
                            order = "g[hydromnic-acid]",
                            energy_required = omni.fluid.sluid_contain_fluid/boiler_consumption,
                            enabled = true,
                            hide_from_player_crafting = true,
                            main_product = fugacity.name,
                            ingredients = {{type = "item", name = "solid-"..fugacity.name.."-T-"..temp, amount = 1}},
                            results = {{type = "fluid", name = fugacity.name, amount = omni.fluid.sluid_contain_fluid, temperature = temp}},
                        }
                    else
                        log("item does not exist:".. fugacity.name.."-fluidisation-"..temp)
                    end
                --no temperature specific fluid. Make sure to check for "none" since fluids outside of this boiler tier can go past the first if
                elseif temp == "none" then
                    new_boiler[#new_boiler+1] = {
                        type = "recipe",
                        name = fugacity.name.."-fluidisation",
                        icons = omni.lib.icon.of(fugacity.name,"fluid"),
                        subgroup = "boiler-sluid-converter",
                        category = "general-omni-boiler",
                        order = "g[hydromnic-acid]",
                        energy_required = omni.fluid.sluid_contain_fluid/boiler_consumption,
                        enabled = true,--may change this to be linked to the boiler unlock if applicable
                        hide_from_player_crafting = true,
                        main_product = fugacity.name,
                        ingredients = {{type = "item", name = "solid-"..fugacity.name, amount = 1}},
                        results = {{type = "fluid", name = fugacity.name, amount = omni.fluid.sluid_contain_fluid, temperature = data.raw.fluid[fugacity.name].default_temperature}},
                    }
                end
            end
        end

        --The sluids boiler is an assembly type so we cannot just override the old ones..., so we make the assemly type replacement and hide the original, Be careful with things like angels electric boilers as they are assembly type too.
        local new_item = table.deepcopy(data.raw.item[boiler.name])
        new_item.name = boiler.name.."-converter"
        new_item.place_result = boiler.name.."-converter"
        new_item.localised_name = {"item-name.boiler-converter", {"entity-name."..boiler.name}}
        new_boiler[#new_boiler+1] = new_item

        boiler.minable.result = boiler.name.."-converter"
        --stop it from being analysed further (stop recursive updates)
        omni.fluid.forbidden_assembler[boiler.name.."-converter"] = true
        
        --create entity
        local new_ent = table.deepcopy(data.raw.boiler[boiler.name])
        new_ent.type = "assembling-machine"
        new_ent.name = boiler.name.."-converter"
        new_ent.localised_name = {"item-name.boiler-converter", {"entity-name."..boiler.name}}
        new_ent.icon = boiler.icon
        new_ent.icons = boiler.icons
        new_ent.crafting_speed = 1
        --change source location to deal with the new size
        new_ent.energy_source = boiler.energy_source
        if new_ent.energy_source and new_ent.energy_source.connections then
            local HS = boiler.energy_source
            HS.connections = omni.fluid.heat_pipe_images.connections
            HS.pipe_covers = omni.fluid.heat_pipe_images.pipe_covers
            HS.heat_pipe_covers = omni.fluid.heat_pipe_images.heat_pipe_covers
            HS.heat_picture = omni.fluid.heat_pipe_images.heat_picture
            HS.heat_glow = omni.fluid.heat_pipe_images.heat_glow
        end
        new_ent.energy_usage = boiler.energy_consumption
        new_ent.ingredient_count = 4
        new_ent.crafting_categories = {"boiler-omnifluid-"..boiler.name,"general-omni-boiler"}
        new_ent.fluid_boxes = {
            {
                production_type = "output",
                pipe_covers = pipecoverspictures(),
                base_level = 1,
                pipe_connections = {{type = "output", position = {0, -2}}}
            }
        }--get_fluid_boxes(new.fluid_boxes or new.output_fluid_box)
        new_ent.fluid_box = nil --removes input box
        new_ent.mode = nil --invalid for assemblers
        new_ent.minable.result = boiler.name.."-converter"
        if new_ent.next_upgrade then
            new_ent.next_upgrade = new_ent.next_upgrade.."-converter"
        end
        if new_ent.energy_source and new_ent.energy_source.connections then --use HX graphics instead
            new_ent.animation = omni.fluid.exchanger_images.animation
            new_ent.working_visualisations = omni.fluid.exchanger_images.working_visualisations
        else
            local tier = string.gsub(boiler.name, "boiler%-", "")
            if tier and omni.lib.is_number(tier) then
                new_ent.animation = omni.fluid.boiler_images(tonumber(tier)).animation
                new_ent.working_visualisations = omni.fluid.boiler_images(tonumber(tier)).working_visualisations
            else
                new_ent.animation = omni.fluid.boiler_images().animation
                new_ent.working_visualisations = omni.fluid.boiler_images().working_visualisations
            end
            
        end
        new_ent.collision_box = {{-1.29, -1.29}, {1.29, 1.29}}
        new_ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
        new_boiler[#new_boiler+1] = new_ent
        ing_replace[#ing_replace+1] = boiler.name

        --find tech unlock
        found = false --if not found, force off (means enabled at start)
        for _, tech in pairs(data.raw.technology) do
            if tech.effects then
                for j, k in pairs(tech.effects) do
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

local function replace_barrels(recipe)
    for _, dif in pairs({"normal","expensive"}) do
        for _, ingres in pairs({"ingredients","results"}) do
            for	j, ing in pairs(recipe[dif][ingres]) do
                --Remove empty barrels
                if ing.name and ing.name == "empty-barrel" then
                    recipe[dif][ingres][j] = nil
                --Replace filled barrels with sluids
                elseif ing.name and string.find(ing.name, "%-barrel") then
                    local flu = string.gsub(ing.name, "%-barrel", "")
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

--Special Py case 2146321487: replace filled barrel ingredients with solids
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
                for	_, ing in pairs(rec[dif][ingres]) do
                    if string.find(ing.name, "%-barrel") then
                        replace_barrels(rec)
                        goto continue
                    end
                end
            end
        end
        ::continue::
    end
end


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
                for	_, ing in pairs(rec[dif][ingres]) do
                    local amount = 0
                    if ing.type == "fluid" and ing.amount and ing.amount ~= 0 then
                        --Round the fluid amount to get rid of weird base numbers, divide afterwards to not lose precision
                        amount = omni.lib.round(omni.fluid.get_true_amount(ing)) / omni.fluid.sluid_contain_fluid
                    else
                        --Ignore probability on items, we dont want to mess with/change that. Very low probabilities would make it hard to find a decent gcd
                        amount = (ing.amount or (ing.amount_min+ing.amount_max) / 2)
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
                        amount = amount * lcm_mult
                    end
                    lcm[dif] = omni.lib.lcm(lcm[dif], amount or 1)
                end
            end
            --divide by the lcm mult again to get the "true" lcm
            lcm[dif] = lcm[dif] / lcm_mult
            --Get the recipe multiplier which is lcm/lowest amount found in this recipe to not lose precision
            mult[dif] = lcm[dif]/min_amount

            --Second loop: Find GCD of all ingres multiplied with the LCM multiplier we just calculated (with sluid_contain_fluid applied for fluids)
            for _, ingres in pairs({"ingredients","results"}) do
                for	_, ing in pairs(rec[dif][ingres]) do
                    local amount = 0
                    if ing.type == "fluid" and ing.amount and ing.amount ~= 0 then
                        amount = omni.lib.round(omni.fluid.get_true_amount(ing) * mult[dif]) / omni.fluid.sluid_contain_fluid
                    else
                        --Ignore probability on items, we dont want to mess with/change that. Very low probabilities would make it hard to find a decent gcd
                        --amount = omni.lib.round((ing.amount or (ing.amount_min+ing.amount_max)/2)*mult[dif])
                        amount = (ing.amount or (ing.amount_min+ing.amount_max)/2) * mult[dif]
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
            if mult[dif]*max_amount > 20000  or (mult[dif] > 100 and mult[dif]*max_amount > 10000) then
                --reset all values
                mult[dif] = 1
                lcm[dif] = 1
                gcd[dif] = nil
                min_amount = math.huge
                max_amount = 0
                lcm_mult = 1
                for _, ingres in pairs({"ingredients","results"}) do
                    for	_, ing in pairs(rec[dif][ingres]) do
                        local amount = 0
                        if ing.type == "fluid" then
                            --Round the fluid amount to get rid of weird base numbers, divide afterwards to not lose precision
                            amount = omni.fluid.round_fluid(omni.fluid.get_true_amount(ing) / omni.fluid.sluid_contain_fluid)
                        else
                            --Ignore probability on items, we dont want to mess with/change that. Very low probabilities would make it hard to find a decent gcd
                            amount = omni.fluid.round_fluid(ing.amount or (ing.amount_min+ing.amount_max)/2)
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
                            amount = amount * lcm_mult
                        end
                        lcm[dif] = omni.lib.lcm(lcm[dif], amount or 1)
                    end
                end
                --divide by the lcm mult again to get the "true" lcm
                lcm[dif] = lcm[dif] / lcm_mult
                --Get the recipe multiplier which is lcm/lowest amount found in this recipe to not lose precision
                mult[dif] = lcm[dif]/min_amount

                --Recalculate GCD
                for _, ingres in pairs({"ingredients","results"}) do
                    for	_, ing in pairs(rec[dif][ingres]) do
                        local amount = 0
                        if ing.type == "fluid" then
                            --Use fluids round function after the ratio division to avoid decimals
                            amount = omni.fluid.round_fluid(omni.fluid.get_true_amount(ing) / omni.fluid.sluid_contain_fluid) * mult[dif]
                        else
                            amount = omni.fluid.round_fluid(ing.amount or ((ing.amount_min+ing.amount_max)/2)) * mult[dif]
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
        end

        --Now Replace fluids with sluids and apply the mult too all ingres and crafting time
        for _, dif in pairs({"normal","expensive"}) do
            local fix_stacksize = false
            for _, ingres in pairs({"ingredients","results"}) do
                for	n, ing in pairs(rec[dif][ingres]) do
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
                        --Has temperature set in recipe and that temperature is the default temp of the liquid --> use non temperatur solid
                        if ing.temperature and ing.temperature == data.raw.fluid[ing.name].default_temperature then
                            new_ing.name = "solid-"..ing.name
                        --Has temperature set in recipe and that temperature is in our list
                        elseif ing.temperature and omni.lib.is_in_table(ing.temperature, fluid_cats[cat][ing.name].temperatures) then
                            new_ing.name = "solid-"..ing.name.."-T-"..ing.temperature
                        --Ingredient has to be in a specific temperature range, check if a solid between min and max exists
                        --May need to add a recipe for ALL temperatures that are in this range
                        elseif ing.minimum_temperature or ing.maximum_temperature or ing.name == "steam" then
                            local found_temp = nil
                            local min_temp = ing.minimum_temperature or data.raw.fluid[ing.name].default_temperature
                            local max_temp = ing.maximum_temperature or data.raw.fluid[ing.name].max_temperature
                            --Temp min/max == fluid temp min/max -->use a non temp solid (min/max can exist solo)
                            --Steam sucks, dont replace fluid steam with a temperature less solid
                            if ing.name ~= "steam" and (min_temp == data.raw.fluid[ing.name].default_temperature) then-- and max_temp == data.raw.fluid[ing.name].max_temperature) then
                                new_ing.name = "solid-"..ing.name
                            else
                                for _,temp in pairs(fluid_cats[cat][ing.name].temperatures) do
                                    if type(temp) == "number" and temp >= (ing.minimum_temperature or 0) and temp <= (ing.maximum_temperature or math.huge) then
                                        --If multiple temps are found, use the lowest.
                                        found_temp = math.min(found_temp or math.huge, temp)
                                    end
                                end
                                --Steam sucks
                                if ing.name == "steam" then
                                    --Get the lowest boiler temp producing steam
                                    local min_temp = math.huge
                                    for t, _ in pairs (boiling_steam) do
                                        min_temp = math.min(min_temp, t)
                                    end
                                    --If the min boiler temp is in the temperature range and the found temp is lower than that, use that
                                    if found_temp and found_temp < min_temp and min_temp >= (ing.minimum_temperature or 0) and min_temp <= (ing.maximum_temperature or math.huge) then
                                        found_temp = min_temp
                                    end
                                    --If nothing has been found yet, we need to replace it with the lowest boiler temp
                                    if not found_temp then--or (found_temp and found_temp < min_boiler_temp) then
                                        found_temp = min_temp
                                    end

                                    new_ing.name = "solid-"..ing.name.."-T-"..found_temp
                                elseif found_temp then
                                    new_ing.name = "solid-"..ing.name.."-T-"..found_temp
                                --No temperature matches, use the no temperature sluid as fallback (or if the recipe is a void recipe. Surpress the warning for this case)
                                elseif omni.lib.is_in_table("none", fluid_cats[cat][ing.name].temperatures) then
                                    new_ing.name = "solid-"..ing.name
                                    if not void_recipes[rec.name] then log("No sluid found that matches the correct temperature for "..ing.name.." in the recipe "..rec.name) end
                                else
                                    log("Sluid Replacement error for "..ing.name)
                                    break
                                end
                            end
                            --Check if we want recipe copies for all temperatures in the min/max range and create them later by copying
                            if omni.fluid.multi_temp_recipes[rec.name] then
                                add_multi_temp_recipes[rec.name] = {fluid_name = ing.name, temperatures = {min = ing.minimum_temperature, max = ing.maximum_temperature, original = found_temp or "none"}}
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
                        local new_amount = (ing.amount or (ing.amount_min+ing.amount_max)/2) * mult[dif]
                        ing.amount = math.min(new_amount, 65535)
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
            rec[dif].energy_required = rec[dif].energy_required*mult[dif]
            --Apply stack size fixes
            if fix_stacksize then
                local add = {}
                for	_, ing in pairs(rec[dif]["results"]) do
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
            if type(temp) == "number" and data.raw.item["solid-"..flu.name.."-T-"..temp] then
                local new_rec = table.deepcopy(rec)
                new_rec.name = rec.name.."-T-"..temp
                new_rec.localised_name = omni.lib.locale.of(rec).name
                new_rec.normal.ingredients[1] = "solid-"..flu.name.."-T-"..temp
                new_rec.expensive.ingredients[1] = "solid-"..flu.name.."-T-"..temp
                voids[#voids+1] = new_rec
            end
        end
    end
end
if next(voids) then data:extend(voids) end

--Create the multi temperature recipe copies
for rec_name, fluid_data in pairs(add_multi_temp_recipes) do
    local temperatures = {}
    local replacement = "solid-"..fluid_data.fluid_name.."-T-"..fluid_data.temperatures.original
    if type(fluid_data.temperatures.original) ~= "number" then replacement = "solid-"..fluid_data.fluid_name end
    local cat = "sluid"
    if fluid_cats["mush"][fluid_data.fluid_name] then cat = "mush" end
    --Get all required temperatures
    for _, temp in pairs(fluid_cats[cat][fluid_data.fluid_name].temperatures) do
        if (type(temp) == "number" and temp >= (fluid_data.temperatures.min or -65535) and temp <= (fluid_data.temperatures.max or math.huge) and type(fluid_data.temperatures.original) == "number" and temp ~= fluid_data.temperatures.original) or
        (type(temp) ~= "number" and type(fluid_data.temperatures.original) ~= "number") then
            temperatures[#temperatures+1] = temp
        end
    end
    --Call create_temperature_copies with the replacement and a table of required temperatures
    omni.fluid.create_temperature_copies(data.raw.recipe[rec_name], fluid_data.fluid_name, replacement, temperatures)
end

--Replace minable fluids result with a sluid
for _,resource in pairs(data.raw.resource) do
    if resource.minable and resource.minable.results and resource.minable.results[1] and resource.minable.results[1].type == "fluid" then
        resource.minable.results[1].type = "item"
        resource.minable.results[1].name = "solid-"..resource.minable.results[1].name
        resource.minable.mining_time = resource.minable.mining_time * omni.fluid.sluid_contain_fluid
    end
end

--Replace furnace fluid ingredient/result slots with solid slots
for _, fu in pairs(data.raw["furnace"]) do
    if fu.fluid_boxes then
        for _, box in pairs(fu.fluid_boxes) do
            if type(box) == "table" and box.production_type and box.production_type == "input" and fu.source_inventory_size == 0 then
                fu.source_inventory_size = 1
            elseif type(box) == "table" and box.production_type and box.production_type == "ouput" and fu.result_inventory_size == 0 then
                fu.result_inventory_size = 1
            end
        end
        fu.fluid_boxes = nil
    end
end


---------------------------
-----Fluid box removal-----
---------------------------
for _, jack in pairs(data.raw["mining-drill"]) do
    if string.find(jack.name, "jack") then
        if jack.output_fluid_box then jack.output_fluid_box = nil end
        jack.vector_to_place_result = {0, -1.85}
    elseif string.find(jack.name, "thermal") then
        if jack.output_fluid_box then jack.output_fluid_box = nil end
        jack.vector_to_place_result = {-3, 5}
    end
end