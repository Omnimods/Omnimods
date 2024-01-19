if settings.startup["omnicompression_entity_compression"].value then
    -------------------------------------------------------------------------------
    --[[Inits, Local lists and variables]]--
    -------------------------------------------------------------------------------
    local multiplier = settings.startup["omnicompression_multiplier"].value
    local cost_multiplier = settings.startup["omnicompression_cost_mult"].value
    local energy_multiplier = settings.startup["omnicompression_energy_mult"].value
    local exp_costs = settings.startup["omnicompression_compounding_building_mults"].value
    local black_list = {--By name
        "creative",
        {"burner", "turbine"},
        {"crystal","reactor"},
        {"factory","port","marker"},
        {"biotech","biosolarpanel","solarpanel"},
        "bucketw"
    }
    local building_list = {--Types
        ["boiler"] = true,
        ["lab"] = true,
        ["assembling-machine"] = true,
        ["generator"] = true,
        ["furnace"] = true,
        ["mining-drill"] = true,
        ["solar-panel"] = true,
        ["reactor"] = true,
        ["heat-pipe"] = true,
        ["accumulator"] = true,
        ["transport-belt"] = true,
        ["loader"] = true,
        ["splitter"] = true,
        ["underground-belt"] = true,
        ["beacon"] = true,
        ["electric-pole"] = true,
        ["offshore-pump"] = true,
        ["inserter"] = true,
        ["loader-1x1"] = true,
        ["burner-generator"] = true,
        ["rocket-silo"] = true,
        ["roboport"] = true
    }
    local not_energy_use = {--Types
        "solar-panel",
        "reactor",
        "boiler",
        "generator",
        "accumulator",
        "transport-belt",
        "loader",
        "splitter",
        "underground-belt",
        "electric-pole",
        "offshore-pump",
        "loader-1x1",
        "inserter",
        "burner-generator"
    }
    -- no longer needed?
    --if mods["omnimatter_fluid"] then building_list["boiler"] = nil end

    local recipe_category = {} --category additions
    local compress_level = {"Compact","Nanite","Quantum","Singularity"}
    local compressed_buildings = {}
    -- LightedPolesPlus support
    local hasLEP = mods["LightedPolesPlus"] ~= nil
    local LEP_scale = hasLEP and settings.startup["lepp_light_size_factor"].value
    local LEP_max_size = hasLEP and settings.startup["lepp_light_max_size"].value
    -------------------------------------------------------------------------------
    --[[Compression Specific Support Functions]]--
    -------------------------------------------------------------------------------
    local function zero_pad(num, places)
        return string.format("%0" .. places .. "d", num)
    end
    --set naming convention
    local function find_top_tier(build, kind)
        local name = build.name
        if not settings.startup["omnicompression_final_building"].value then
            return build
        end
        -- Take any digits off the end
        local digits = name:match("%d+$") or ""
        -- Remove trailing -1 etc
        name = name:gsub("[%-%d]+$","")
        -- Start at 1 since padding only starts at %02d
        local padded_zeroes = 1
        for I=1, #digits do
            local digit = digits:sub(I,I)
            if digit ~= "0" then
                break
            else
                padded_zeroes = padded_zeroes + 1
            end
        end
        -- If we don't have a tier 2 why bother
        local zero_two = zero_pad(2, padded_zeroes) 
        local rawkind = data.raw[kind]
        local namedash = name .. "-"
        if not rawkind[namedash..zero_two] and not rawkind[name..zero_two] then
            return build
        end
        local last_padded_nr = zero_pad(0, padded_zeroes)
        for nr=1, 99 do
            local padded_nr = zero_pad(nr, padded_zeroes)
            namedash = name .. "-"
            if not rawkind[namedash..padded_nr] and rawkind[namedash..last_padded_nr] then
                return rawkind[namedash..last_padded_nr]
            elseif not rawkind[name..padded_nr] and rawkind[name..last_padded_nr] then
                return rawkind[name..last_padded_nr]
            end
            last_padded_nr = padded_nr
        end
        return build
    end
    --set category if it does not exist
    local function category_exists(build)
        if build.crafting_categories then --no crafting_categories, don't loop
            for i, cat in pairs(build.crafting_categories) do --check crafting_categories and add compressed version if does not already exist
                if not data.raw["recipe-category"][cat.."-compressed"] then
                    if not omni.lib.is_in_table(cat.."-compressed", recipe_category) then --check not already in table (in case of data:extend being done right at the end)
                        recipe_category[#recipe_category+1] = {type = "recipe-category",name = cat.."-compressed"}
                    end
                end
            end
        end
    end

    local function new_effect(effect, level, linear, constant)
        local mult = (
            (linear and level + 1)
            or constant or
            math.pow(multiplier, level)
        )
        return omni.lib.mult_fuel_value(effect, mult)
    end

    --new fluids for boilers and generators
    local function create_concentrated_fluid(fluid, tier)
        local new_fluid = table.deepcopy(data.raw.fluid[fluid])

        new_fluid.localised_name = omni.lib.locale.custom_name(new_fluid, "compressed-fluid", tier)
        new_fluid.name = new_fluid.name.."-concentrated-grade-"..tier
        if new_fluid.heat_capacity then
            new_fluid.heat_capacity = new_effect(new_fluid.heat_capacity, tier, nil, multiplier^tier)
        end

        if new_fluid.fuel_value then
            new_fluid.fuel_value = new_effect(new_fluid.fuel_value, tier)
        end
        -- Tier + compression icon
        new_fluid.icons = omni.lib.add_overlay(new_fluid, "compress-fluid", tier)
        new_fluid.icon = nil
        data:extend{new_fluid}
    end

    local function create_concentrated_recipe(fluid, tier, temp)
        local new_fluid = table.deepcopy(data.raw.fluid[fluid])
        if temp then
            -- Clamp to fluid min/max
            temp = new_fluid.max_temperature and math.min(temp, new_fluid.max_temperature) or temp
            temp = new_fluid.default_temperature and math.max(temp, new_fluid.default_temperature) or temp
        end
        -- Zero pad to keep sorting proper
        local temp_str = temp and "-" .. string.format("%04d", temp) .. "c" or ""
        if not data.raw.fluid[fluid .. "-concentrated-grade-" .. tier] then
            create_concentrated_fluid(fluid, tier)
        end

        local base_fluid = fluid
        if not data.raw.recipe[fluid .. "-concentrated-grade-" .. tier  .. temp_str] then
            -- if tier > 1 then baseFluid = baseFluid.."-concentrated-grade-"..(tier-1) end
            local base_fluid_data = {{name = base_fluid, type = "fluid", amount = omni.compression.sluid_contain_fluid*multiplier^(tier+1), temperature=temp}}
            local compress_fluid_data = {{name = "concentrated-"..base_fluid, type = "fluid", amount = multiplier^(tier+1), temperature=temp}}
            local grade_fluid_data = {{name = fluid.."-concentrated-grade-"..tier, type = "fluid", amount = omni.compression.sluid_contain_fluid*multiplier, temperature=temp}}
            local grade_recipe_data = {
                energy_required = math.max(0.0011, multiplier^(tier+1)/60),
                enabled = true,
                hide_from_player_crafting = true
            }
            local ungrade_recipe_data = table.deepcopy(grade_recipe_data) --deepcopy to safeguard against pointer nonsense
            local grade_compressed_recipe_data = table.deepcopy(grade_recipe_data)
            local ungrade_compressed_recipe_data = table.deepcopy(grade_compressed_recipe_data)

            grade_recipe_data.ingredients = base_fluid_data
            grade_recipe_data.results = grade_fluid_data
            grade_compressed_recipe_data.ingredients = compress_fluid_data
            grade_compressed_recipe_data.results = table.deepcopy(grade_fluid_data)

            ungrade_recipe_data.ingredients = table.deepcopy(grade_fluid_data)
            ungrade_recipe_data.results = table.deepcopy(base_fluid_data)
            ungrade_compressed_recipe_data.ingredients = table.deepcopy(grade_fluid_data)
            ungrade_compressed_recipe_data.results = table.deepcopy(compress_fluid_data)

            local grade = {
                type = "recipe",
                name = fluid.."-concentrated-grade-"..tier..temp_str,
                --localised_name = omni.lib.locale.custom_name(data.raw.fluid[fluid], 'fluid-name.compressed-fluid', tier),
                category = "fluid-condensation",
                enabled = true,
                icons = omni.lib.add_overlay(new_fluid, "compress-fluid", tier),
                order = new_fluid.order or ("z".."[condensed-"..fluid .."]")
            }
            local ungrade = {
                type = "recipe",
                name = "uncompress-"..fluid.."-concentrated-grade-"..tier..temp_str,
                --localised_name = omni.lib.locale.custom_name(data.raw.fluid[fluid], 'fluid-name.compressed-fluid', tier),
                icons = omni.lib.add_overlay(omni.lib.add_overlay(new_fluid, "compress-fluid", tier),"uncompress"),
                category = "fluid-condensation",
                subgroup = "concentrator-fluids",
                enabled = true,
                order = new_fluid.order or ("z".."[condensed-"..fluid .."]")
            }
            local grade_compressed = table.deepcopy(grade)
            grade_compressed.name = "concentrated-"..grade.name
            local ungrade_compressed = table.deepcopy(ungrade)
            ungrade_compressed.name = "uncompress-concentrated-"..fluid.."-concentrated-grade-"..tier..temp_str

            grade.normal = grade_recipe_data
            grade.expensive = table.deepcopy(grade_recipe_data)
            ungrade.normal = ungrade_recipe_data
            ungrade.expensive = table.deepcopy(ungrade_recipe_data)

            grade_compressed.normal = grade_compressed_recipe_data
            grade_compressed.expensive = table.deepcopy(grade_compressed_recipe_data)
            ungrade_compressed.normal = ungrade_compressed_recipe_data
            ungrade_compressed.expensive = table.deepcopy(ungrade_compressed_recipe_data)

            data:extend{grade,ungrade,grade_compressed,ungrade_compressed}
        end
    end

    local recipe_results = {}
    log("calculating building tiers")
    for _, recipe in pairs(data.raw.recipe) do
        --log(recipe.name)
        local product = omni.lib.locale.get_main_product(recipe)
        product = product and data.raw[product.type][product.name]
        if product then
            local place_result = (data.raw[product.type][product.name] or {}).place_result
            place_result = place_result and omni.lib.locale.find(place_result, 'entity', true)
            if place_result and -- Valid
            building_list[place_result.type] and
            not omni.lib.string_contained_list(place_result.name, black_list) and --not on exclusion list
            not omni.compression.is_hidden(place_result) and (--Not hidden
            not omni.compression.compress_entity[place_result] or (
                omni.compression.compress_entity[place_result] and (
                not omni.compression.compress_entity[place_result].exclude or omni.compression.compress_entity[place_result].include
                ) -- Not excluded or included
            )) 
            then
                local top_result =  find_top_tier(place_result, place_result.type)
                if top_result and top_result.name == place_result.name and building_list[top_result.type] then
                    --log("Highest tier of " .. place_result.name .. " is " .. top_result.name)
                    recipe_results[top_result.name] = recipe_results[top_result.name] or {}
                    local res = recipe_results[top_result.name]
                        res[#res+1] = {
                        recipe = recipe,
                        item = product,
                        building = top_result,
                        base = place_result
                    }
                end
            end
        end
        -- Check for fluid temps here too, generate a recipe for each temp and tier
        if recipe.normal and recipe.normal.results and recipe.category ~= "fluid-condensation" then
            local parsed_results = omni.lib.locale.parse_product(recipe.normal.results)
            for _, result in pairs(parsed_results) do
                if result.type == "fluid" and result.temperature then
                    --log("Fluid: " .. result.name .. " (" .. result.temperature .. "C)")
                    for i = 1, omni.compression.bld_lvls do                    
                        create_concentrated_recipe(result.name, i, result.temperature)
                    end
                end
            end
        end
    end

    local process_fluid_box = function(fluid_box, i, is_graded, proto)
        if not fluid_box then return end
        local fl_name
        if fluid_box.filter then
            if is_graded then
                fl_name = fluid_box.filter.."-concentrated-grade-"..i
            else
                fl_name = "concentrated-" .. fluid_box.filter
            end
            create_concentrated_recipe(fluid_box.filter, i, fluid_box.minimum_temperature)
            create_concentrated_recipe(fluid_box.filter, i, fluid_box.maximum_temperature)
            if proto and (proto.target_temperature or proto.maximum_temperature) then
                create_concentrated_recipe(fluid_box.filter, i, proto.target_temperature or proto.maximum_temperature)
            end
            fluid_box.filter = fl_name
        end
        -- if fluid_box.base_area then
        --   fluid_box.base_area = fluid_box.base_area * math.pow(multiplier, i) / sluid_contain_fluid
        -- end
        for I=1, #fluid_box do
            if fluid_box[I] then
                if fluid_box.filter then
                    if is_graded then
                        fl_name = fluid_box.filter.."-concentrated-grade-"..i
                    else
                        fl_name = "concentrated-" .. fluid_box.filter
                    end
                    create_concentrated_recipe(fluid_box[I].filter, i, fluid_box[I].minimum_temperature)
                    create_concentrated_recipe(fluid_box[I].filter, i, fluid_box[I].maximum_temperature)
                    if proto and (proto.target_temperature or proto.maximum_temperature) then
                        create_concentrated_recipe(fluid_box[I].filter, i, proto.target_temperature or proto.maximum_temperature)
                    end
                    fluid_box[I].filter = fl_name
                end
                -- if fluid_box[I].base_area then
                --   fluid_box[I].base_area = fluid_box[I].base_area * math.pow(multiplier, i) / sluid_contain_fluid
                -- end
            end
        end
    end
    -- These names are ass
    local modspec = {
        slot_count = "module_slots",
        columns = "module_info_max_icons_per_row",
        rows = "module_info_max_icon_rows",
        shift = "module_info_icon_shift",
        scale = "module_info_icon_scale",
        gap_size = "module_info_separation_multiplier",
        y_offset = "module_info_multi_row_initial_height_modifier"
    }
    -- Help us keep the code clean
    setmetatable(modspec, {
        __call = function(self, proto, key, expression)
                if expression then
                    proto.module_specification[self[key]] = expression(proto.module_specification[self[key]])
                end
                return proto.module_specification[self[key]]
        end
    })


    -------------------------------------------------------------------------------
    --[[Entity Type Specific Properties]]--
    -------------------------------------------------------------------------------
    local run_entity_updates = function(new, kind, compr_lvl)
        --[[assembly type updates]]--
        --module slots
        if new.module_specification then
            -- Add slots
            modspec(
            new,
            "slot_count", 
            function(x) 
                return x and (x * (compr_lvl + 1))
            end
            )
            -- Make sure we don't occlude nearby entities
            local bounding_box = new.selection_box or {
            {
                x = 0,
                y = 0
            },
            {
                x = 0,
                y = 0
            }
            }
            for entry=1, #bounding_box do -- Remove numbered and convert to explicit
                for index=1, #bounding_box[entry] do
                    bounding_box[entry][string.char(119+index)] = bounding_box[entry][index]
                    bounding_box[entry][index] = nil
                end
            end
            -- Onwards!
            modspec(
            new,
            "scale", 
            function(x)
                x = modspec(new, "slot_count")
                -- Approach according to module count
                x = (x * 0.33) / (x + 2) + 0.25
                return x
            end
            )
            local scale_factor = modspec(new, "scale") / 0.5
            modspec(
            new,
            "shift", 
            function(x) 
                x = x or {0, 0.7}
                x[1] = x[1]
                x[2] = x[2]
                return x
            end
            )
            modspec(
            new,
            "gap_size", 
            function(x) 
                return x or 1.1
            end
            )
            modspec(
            new,
            "y_offset", 
            function(x) 
                return x or -0.1
            end
            )
            modspec(
            new,
            "columns", 
            function(x)
                x = util.distance(
                {bounding_box[1].x, 0},
                {bounding_box[2].x, 0}
                ) * 1.85
                -- Account for shift
                x = x - modspec(new, "shift")[1]
                -- And for gap size as well
                x = x - 0.05 * modspec(new, "gap_size") * scale_factor
                -- Apply scale
                x = x  / scale_factor
                return math.max(1, x)
            end
            )
            modspec(
            new,
            "rows", 
            function(x)
                -- Get our stock height
                x = util.distance(
                {0, bounding_box[1].y},
                {0, bounding_box[2].y}
                ) * 0.9
                -- Take out shift
                x = x - modspec(new, "shift")[2]
                -- y offset
                x = x - modspec(new, "y_offset")
                -- And for gap size as well
                x = x - 0.05 * modspec(new, "gap_size") * scale_factor
                -- Scale
                x = x / scale_factor
                return math.max(1, x)
            end
            )
        end

        --------------------------
        --[[Power type updates]]--
        --------------------------
        --energy source
        if new.energy_source then
            if new.energy_source.emissions_per_minute then
                new.energy_source.emissions_per_minute = new.energy_source.emissions_per_minute * math.pow(multiplier, compr_lvl)
            end
            if new.energy_source.buffer_capacity then
                new.energy_source.buffer_capacity = new_effect(new.energy_source.buffer_capacity, compr_lvl)
            end
            if new.energy_source.drain then
                new.energy_source.drain = new_effect(new.energy_source.drain, compr_lvl)
            end
            if new.energy_source.input_flow_limit then
                new.energy_source.input_flow_limit = new_effect(new.energy_source.input_flow_limit, compr_lvl)
            end
        end

        --energy usage
        if not omni.lib.is_in_table(kind,not_energy_use) and new.energy_usage then
            new.energy_usage = new_effect(new.energy_usage, compr_lvl)
            -- usage*mult*tier unless exp_costs in which case it's usage*mult^tier
            new.energy_usage = new_effect(new.energy_usage, nil, nil, exp_costs and math.pow(energy_multiplier, compr_lvl) or energy_multiplier)
        end

        ---------------------------
        --[[Entity type updates]]--
        ---------------------------
        --recipe category settings for assembly/furnace types
        if kind == "assembling-machine" or kind == "furnace" or kind == "rocket-silo" then
            local new_cat = table.deepcopy(new.crafting_categories) --revert each time
            for j, cat in pairs(new.crafting_categories) do
                if not data.raw["recipe-category"][cat.."-compressed"] then --check if category exists
                    if not omni.lib.is_in_table(cat.."-compressed", recipe_category) then --check not already in the to-expand table
                    recipe_category[#recipe_category+1] = {type = "recipe-category",name = cat.."-compressed"}
                    end
                end
                new_cat[#new_cat+1] = cat.."-compressed" --add cat
            end
            if kind == "assembling-machine" and string.find(new.name,"assembling") then
                new_cat[#new_cat+1] = "general-compressed"
            end
            new.crafting_categories = new_cat
            new.crafting_speed = new.crafting_speed * math.pow(multiplier,compr_lvl)
            -- if new.fluid_boxes then
            --     process_fluid_box(new.fluid_boxes, i, false)
            -- end
            -- Hide "made in"
            new.flags = new.flags or {}
            if not omni.lib.is_in_table("not-in-made-in", new.flags) then
                new.flags[#new.flags+1] = "not-in-made-in"
            end
        end
        --lab vial slot update (may want to move this to recipe update since tools/items are done later...)
        if kind == "lab" then
            for i, input in pairs(new.inputs) do
                if data.raw.tool["compressed-"..input] then
                    new.inputs[#new.inputs+1] = "compressed-"..input
                end
            end
            if new.researching_speed then 
                new.researching_speed = new.researching_speed * math.pow(multiplier, compr_lvl)
            end
        end

        --Solar Panels / Reactors
        if kind == "solar-panel" then
            new.production = new_effect(new.production,compr_lvl)
        elseif kind == "reactor" then
            new.consumption = new_effect(new.consumption,compr_lvl)
            if new.heat_buffer then
                new.heat_buffer.specific_heat = new_effect(new.heat_buffer.specific_heat,compr_lvl)
                new.heat_buffer.max_transfer = new_effect(new.heat_buffer.max_transfer,compr_lvl)
            end
        end
        
        --Heat Pipe
        if kind == "heat-pipe" then
            if new.heat_buffer then
                new.heat_buffer.specific_heat = new_effect(new.heat_buffer.specific_heat,compr_lvl)
                new.heat_buffer.max_transfer = new_effect(new.heat_buffer.max_transfer,compr_lvl)
            end
        end

        --Boiler
        if kind == "boiler" then
            if new.energy_consumption then new.energy_consumption = new_effect(new.energy_consumption, compr_lvl, nil, multiplier^compr_lvl) end
            if new.energy_source.fuel_inventory_size then new.energy_source.fuel_inventory_size = new.energy_source.fuel_inventory_size*(compr_lvl+1) end
            if new.energy_source.effectivity then new.energy_source.effectivity = math.pow(new.energy_source.effectivity,1/(compr_lvl+1)) end
            if new.energy_source.specific_heat then new.energy_source.specific_heat = new_effect(new.energy_source.specific_heat, compr_lvl, nil, multiplier^compr_lvl) end
            if new.energy_source.max_transfer then new.energy_source.max_transfer = new_effect(new.energy_source.max_transfer, compr_lvl, nil, multiplier^compr_lvl) end
            process_fluid_box(new.output_fluid_box, compr_lvl, true, new) -- Make sure output temp gets a recipe
            process_fluid_box(new.fluid_box, compr_lvl, true)
        end

        --Generator
        if kind == "generator" and new.fluid_box then
            process_fluid_box(new.output_fluid_box, compr_lvl, nil)
            process_fluid_box(new.fluid_box, compr_lvl, true, new) -- Make sure input temp gets a recipe
            new.scale_fluid_usage = true
            if new.max_power_output then
                new.max_power_output = new_effect(new.max_power_output, compr_lvl)
            end
            -- new.fluid_usage_per_tick = new.fluid_usage_per_tick * math.pow(multiplier, i) / sluid_contain_fluid
            --new.fluid_usage_per_tick*math.pow((multiplier+1)/multiplier,i)
            --new.effectivity = new.effectivity*math.pow(multiplier,i)
        end

        --Accumulator
        if kind == "accumulator" then
            --Make sure Buffer capacity is displayed in Joules again
            new.energy_source.buffer_capacity = string.sub(new.energy_source.buffer_capacity,1,string.len(new.energy_source.buffer_capacity)-1).."J"
            if new.energy_source.usage_priority == "tertiary" then
                new.energy_source.output_flow_limit = new_effect(new.energy_source.output_flow_limit, compr_lvl)
            end
        end

        --mining speed and radius update
        if kind == "mining-drill" then
            local speed_divisor = 2
            if new.energy_source and new.energy_source.type ~= "electric" then
                speed_divisor = 1
            end
            new.mining_speed = new.mining_speed * math.pow(multiplier,compr_lvl/speed_divisor)
            --new.mining_power = new.mining_power * math.pow(multiplier,i/2)
            new.resource_searching_radius = math.floor(new.resource_searching_radius *(compr_lvl+1)) + new.resource_searching_radius%1
        end

        --belts
        if kind == "transport-belt" or kind == "loader" or kind == "splitter" or kind == "underground-belt" or kind == "loader-1x1" then
            new.speed = new.speed*(compr_lvl+2)
        end

        --beacons
        if kind == "beacon" then
            if new.supply_area_distance*(compr_lvl+1) <= 64 then
                new.supply_area_distance = new.supply_area_distance*(compr_lvl+1)
            else
                new.supply_area_distance = 64
            end
            new.module_specification.module_slots = new.module_specification.module_slots*(compr_lvl+1)
        end

        --power poles
        if kind == "electric-pole" then
            new.maximum_wire_distance = math.min(new.maximum_wire_distance*multiplier*compr_lvl,64)
            -- "Old" formula
            local new_supply_area = new.supply_area_distance * (compr_lvl+1)
            -- Add a little bit based on our multiplier
            new_supply_area = math.ceil(new_supply_area ^ (1 + (multiplier / 50)))
            -- Cap per engine limit
            new.supply_area_distance = math.min(new_supply_area, 64)
            -- LightedPoles+ support
            if hasLEP then
                -- Do we have a lamp for our base pole?
                local orig_name = new.name:gsub("%-compressed%-%a+$", "-lamp")
                if data.raw.lamp[orig_name] then
                    local new_lamp = table.deepcopy(data.raw.lamp[orig_name])
                    -- Scale light by wire distance
                    if LEP_scale > 0 then
                        -- Math from LightedPolesPlus data_updates
                        local light_size = math.min(math.floor(math.sqrt(new.maximum_wire_distance)*(40/math.sqrt(7.5))*LEP_scale+0.5), LEP_max_size)
                        new_lamp.light.size = light_size
                        new_lamp.light_when_colored.size = light_size
                        new_lamp.energy_usage_per_tick = light_size * 0.125 .."kW"
                    end
                    -- Name and icons, just copy from the pole. Again, same as LEP data_updates
                    new_lamp.name = new.name .. "-lamp"
                    for _, v in pairs{"localised_name", "icon", "icons", "icon_size", "icon_mipmaps"} do
                        new_lamp[v] = new[v]
                    end
                    -- Aaand done
                    data:extend({new_lamp})           
                end
            end
        end

        --offshore pumps
        if kind == "offshore-pump" then
            -- new.fluid = "concentrated-"..new.fluid
            local fl_name = new.fluid.."-concentrated-grade-"..compr_lvl
            if not data.raw.fluid[fl_name] then 
                create_concentrated_recipe(new.fluid,compr_lvl)
            end
            new.fluid = fl_name
        end

        --Inserters!
        if kind == "inserter" then
            new.extension_speed = new.extension_speed * (compr_lvl + 1)
            new.rotation_speed = new.rotation_speed * (compr_lvl + 1)
            -- Add a little bit based on our multiplier
            new.extension_speed = new.extension_speed * (1 + (multiplier / 15))
            new.rotation_speed = new.rotation_speed * (1 + (multiplier / 15))
        end

        --Generators!
        if kind == "burner-generator" then
            new.max_power_output = new_effect(new.max_power_output, compr_lvl)
            new.burner.emissions_per_minute = (new.burner.emissions_per_minute or 0) * math.pow(multiplier,compr_lvl+1)
        end

        --Rockets!
        if kind == "rocket-silo" and new.fixed_recipe then
            new.door_opening_speed = new.door_opening_speed * math.pow(multiplier, compr_lvl)
            new.rocket_result_inventory_size = 8
            new.light_blinking_speed = new.light_blinking_speed * math.pow(multiplier, compr_lvl)
            new.rocket_rising_delay = math.ceil((new.rocket_rising_delay or 30) / math.pow(multiplier, compr_lvl)) -- Defaults are NOT present on the prototype!
            new.launch_wait_time = math.ceil((new.launch_wait_time or 120) / math.pow(multiplier, compr_lvl))
            local rocket = table.deepcopy(data.raw["rocket-silo-rocket"][new.rocket_entity])
            rocket.name = "compressed-" .. rocket.name .. "-" .. compr_lvl
            new.rocket_entity = rocket.name
            rocket.rising_speed = rocket.rising_speed * math.pow(multiplier, compr_lvl)
            rocket.engine_starting_speed = rocket.engine_starting_speed * math.pow(multiplier, compr_lvl)
            rocket.flying_speed = rocket.flying_speed * math.pow(multiplier, compr_lvl)
            rocket.flying_acceleration = rocket.flying_acceleration * math.pow(multiplier, compr_lvl)
            data:extend({rocket})
        end

        --Roboports
        if kind == "roboport" then
            -- Otherwise we get a backup of bots waiting
            if not new.charging_distance then
                new.charging_distance = 1
            end
            new.robot_slots_count = new.robot_slots_count * (compr_lvl + 1)
            new.material_slots_count = new.material_slots_count * (compr_lvl + 1)
            new.logistics_radius = new.logistics_radius * (compr_lvl + 1)
            new.construction_radius = new.construction_radius * (compr_lvl + 1)
            new.charging_distance = new.charging_distance * (compr_lvl + 1)
            -- Must be >= logistics_radius
            new.logistics_connection_distance = new.logistics_radius * (compr_lvl + 1)
            -- Add some based on compression ratio
            new.logistics_radius = math.ceil(new.logistics_radius ^ (1 + (multiplier / 50)))
            new.construction_radius = math.ceil(new.construction_radius ^ (1 + (multiplier / 50)))
            new.charging_distance = math.ceil(new.charging_distance ^ (1 + (multiplier / 50)))
            new.logistics_connection_distance = math.ceil(new.logistics_connection_distance ^ (1 + (multiplier / 50)))
            -- Energy output    
            new.charging_energy = new_effect(new.charging_energy, compr_lvl)      
            -- If we don't change this we get a queue of robots waiting to exit/enter
            if not new.robot_vertical_acceleration then
                new.robot_vertical_acceleration = 0.01
            end
            new.robot_vertical_acceleration = new.robot_vertical_acceleration * math.pow(multiplier, compr_lvl)
            -- Wiki says 0 default but it appears to actually be 4
            if not new.charging_station_count then
                new.charging_station_count = 4
            end
            new.charging_station_count = new.charging_station_count * math.pow(multiplier, compr_lvl)
            --recharge_minimum has to be >= energy_usage --> Make sure to use the same multiplier
            new.recharge_minimum = new_effect(new.recharge_minimum, compr_lvl)
            new.recharge_minimum = new_effect(new.recharge_minimum, nil, nil, exp_costs and math.pow(energy_multiplier, compr_lvl) or energy_multiplier)
        end
        return new
    end

    log("Start building compression")

    -------------------------------------------------------------------------------
    --[[Build Compression Tier Recipes]]--
    -------------------------------------------------------------------------------
    for _, values in pairs(recipe_results) do
        for _, details in pairs(values) do --only building types
            --category check and create if not
            local build = details.building
            if build and details.item and details.recipe and not details.recipe.name:find("^uncompress%-") and details.base and build.minable then -- and build.minable.result and data.raw.item[build.minable.result]
                --check that it is a minable entity
                category_exists(build)
                for compr_level = 1, omni.compression.bld_lvls do
                    local new = table.deepcopy(build)
                    local item = table.deepcopy(details.item)
                    local rc = table.deepcopy(details.recipe)
                    -------------------------------------------------------------------------------
                    --[[Set Specific Properties]]--
                    -------------------------------------------------------------------------------
                    --recipe/item subgrouping
                    if omni.compression.one_list then --if not the same as the base item
                        if not data.raw["item-subgroup"]["compressor-"..item.subgroup.."-"..build.type] then
                            local item_cat = {
                                type = "item-subgroup",
                                name = "compressor-"..item.subgroup.."-"..build.type,
                                group = "compressor-buildings",
                                order = "a[compressor-"..item.subgroup.."-".. build.type .."]" --maintain some semblance of order
                            }
                            data:extend({item_cat}) --create it if it didn't already exist
                        end
                        item.subgroup = "compressor-"..item.subgroup.."-"..build.type
                        rc.subgroup = item.subgroup
                    else --clean up item ordering
                        item.order = item.order or ("z"..compr_level.."-compressed") --should force it to match, but be after it under all circumstances
                    end

                    -------------------------------------------------------------------------------
                    --[[Since running deepcopy, only need to override new props]]--
                    -------------------------------------------------------------------------------
                    --[[ENTITY CREATION]]--
                    new.name = new.name.."-compressed-"..string.lower(compress_level[compr_level])
                    new.localised_name = omni.lib.locale.custom_name(details.base, "compressed-building", compress_level[compr_level])
                    new.localised_description = omni.lib.locale.custom_name(
                        details.base,
                        "entity-description.compressed-building",
                        multiplier^compr_level,
                        {"description-modifier." .. compr_level}
                    )
                    if new.max_health then
                        new.max_health = new.max_health * math.pow(multiplier, compr_level)
                        new.max_health = math.min(new.max_health, 2^31-1)
                    end
                    new.minable.result = new.name
                    new.minable.mining_time = (new.minable.mining_time or 10) * compr_level
                    -- Fast replace in kind
                    if not build.fast_replaceable_group then
                        build.fast_replaceable_group = build.name
                    end
                    if not omni.lib.is_in_table("not-upgradable", build.flags or {}) and not omni.lib.is_in_table("hidden", item.flags or {}) then
                        if compr_level < omni.compression.bld_lvls then
                            if new.next_upgrade then
                                new.next_upgrade = new.next_upgrade.."-compressed-"..string.lower(compress_level[compr_level])
                            else
                                new.next_upgrade = build.name.."-compressed-"..string.lower(compress_level[compr_level+1])
                            end
                        end
                    end
                    new.fast_replaceable_group = build.fast_replaceable_group
                    new.placeable_by = {item = new.name, count = 1}
                    new.icons = omni.lib.add_overlay(build,"building",compr_level)
                    new.icon = nil
                    run_entity_updates(new, new.type, compr_level)
                    compressed_buildings[#compressed_buildings+1] = new --add entity to the list

                    --[[ITEM CREATION]]--
                    item.localised_name = new.localised_name
                    item.name = new.name
                    item.place_result = new.name
                    item.stack_size = math.max(5, math.ceil(item.stack_size / multiplier))
                    item.icons = omni.lib.add_overlay(item,"building",compr_level)
                    item.icon = nil

                    compressed_buildings[#compressed_buildings+1] = item
                    --[[COMPRESSION/DE-COMPRESSION RECIPE CREATION]]--
                    local ing = {}
                    -- ing = {item, count}
                    if compr_level == 1 then
                        ing  = {{
                            details.item.name,
                            math.ceil(multiplier * cost_multiplier)
                        }}
                    else
                        ing = {{
                            build.name.."-compressed-"..string.lower(compress_level[compr_level-1]),
                            exp_costs and math.ceil(multiplier * cost_multiplier) or multiplier
                        }}
                    end


                    local recipe = {
                        type = "recipe",
                        name = rc.name.."-compressed-"..string.lower(compress_level[compr_level]),
                        localised_name = new.localised_name,
                        ingredients = ing,
                        icons = omni.lib.add_overlay(rc,"building",compr_level),
                        result = new.name,
                        energy_required = 5*math.floor(math.pow(multiplier,compr_level/2)),
                        enabled = false,
                        hidden = omni.lib.recipe_is_hidden(rc.name),
                        category = "crafting-compressed",
                        order = (rc.order or details.item.order or "") .. "-compressed",
                        subgroup = rc.subgroup,
                        hide_from_player_crafting = rc.hide_from_player_crafting or omni.compression.hide_handcraft
                    }

                    compressed_buildings[#compressed_buildings+1] = recipe
                    local uncompress = {
                        type = "recipe",
                        name = "uncompress-"..string.lower(compress_level[compr_level]).."-"..rc.name,
                        localised_name = omni.lib.locale.custom_name(build, 'recipe-name.uncompress-item'),
                        localised_description = omni.lib.locale.custom_description(build, 'recipe-description.uncompress-item'),
                        icons = omni.lib.add_overlay(rc,"uncompress"),
                        subgroup = rc.subgroup,
                        order = (rc.order or details.item.order or "") .. "-compressed",
                        category = "compression",
                        enabled = true,
                        hidden = true,
                        ingredients = {
                        {new.name, 1}
                        },
                        results = ing,
                        --inter_item_count = item_count,
                        energy_required = 5*math.floor(math.pow(multiplier,compr_level/2)),
                        hide_from_player_crafting = rc.hide_from_player_crafting or omni.compression.hide_handcraft
                    }
                    compressed_buildings[#compressed_buildings+1] = uncompress
                end
            end
        end
    end

    -- create tiered fluid fuel
    for fluidname, fluid in pairs(data.raw.fluid) do
        if fluid.fuel_value and not fluidname:find("concentrated%-") then
            for i = 1, omni.compression.bld_lvls do
                create_concentrated_recipe(fluidname, i)
            end
        end
    end

    --extend new categories
    if #recipe_category > 0 then
        data:extend(recipe_category)
    end
    --extend new buildings
    if #compressed_buildings > 0 then
        data:extend(compressed_buildings)
    end

    log("Building compression finished: "..(#compressed_buildings or 0).. " buildings")
end