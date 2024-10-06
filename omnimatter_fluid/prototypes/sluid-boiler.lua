local boiler_images = require("prototypes.boiler-images")

------------------------------------------
-----Sluid Boiler (recipe) generation-----
------------------------------------------
local function sluid_boiler_generation(fluid_cats)
    local new_boiler = {}
    local ing_replace={}
    local boiler_tech = {}

    for _, boiler in pairs(data.raw.boiler) do
        --if exists, find recipe, item and entity
        if not omni.fluid.forbidden_boilers[boiler.name] then
            ------------------------------------------
            --Create a solid & fluid boiling recipes--
            ------------------------------------------
            local water = boiler.fluid_box.filter or "water"
            local steam = boiler.output_fluid_box.filter or "steam"
            local th_energy = (boiler.target_temperature - data.raw.fluid[water].default_temperature) * (omni.lib.get_fuel_number(data.raw.fluid[water].heat_capacity) or 1000) --1000 = default heat_capacity
            local boiler_consumption = 60 * omni.lib.get_fuel_number(boiler.energy_consumption) / ((boiler.energy_source.effectivity or 1) * th_energy)
            local temp_ing = string.gsub(data.raw.fluid[water].default_temperature, "%.", "_")

            --clobber fluid_box_filter if it exists
            --if generator_fluid[boiler.output_fluid_box.filter] then
            --    generator_fluid[boiler.output_fluid_box.filter] = nil
            --end

            new_boiler[#new_boiler+1] = {
                type = "recipe-category",
                name = "boiler-omnifluid-"..boiler.name,
            }

            --Create a boiling recipe with the boilers target temp (only when input~= output. Some boilers are used to heat up fluids)
            if water ~= steam then
                omni.fluid.add_boiler_fluid(steam)
                new_boiler[#new_boiler+1] = {
                    type = "recipe",
                    name = boiler.name.."-boiling-steam-"..boiler.target_temperature,
                    icons = omni.lib.icon.of(data.raw.fluid[steam]),
                    subgroup = "boiler-sluid-steam",
                    category = "boiler-omnifluid-"..boiler.name,
                    order = "a["..steam..boiler.target_temperature.."]",
                    energy_required = math.max(omni.fluid.sluid_contain_fluid/boiler_consumption, 0.0011),
                    enabled = true,
                    hide_from_player_crafting = true,
                    main_product = steam,
                    ingredients = {{type = "item", name = "solid-"..water.."-T-"..temp_ing, amount = 1}},
                    results = {{type = "fluid", name = steam, amount = omni.fluid.sluid_contain_fluid, temperature = math.min(boiler.target_temperature, data.raw.fluid[steam].max_temperature)}}
                }
            end

            --Create a solid water boiling recipe version if steam with the boiler target temp is required (registered as consumer).
            local category = "mush"
            if fluid_cats["sluid"][steam] then category = "sluid" end
            local found = false
            for _, temp in pairs(fluid_cats[category][steam]["consumer"].temperatures) do
                if boiler.target_temperature == temp then
                    found = true
                    break
                end
            end
            if found == true then
                local tempstring = string.gsub(boiler.target_temperature, "%.", "_")
                new_boiler[#new_boiler+1] = {
                    type = "recipe",
                    name = boiler.name.."-boiling-solid-steam-"..tempstring,
                    icons = omni.lib.icon.of(data.raw.fluid[steam]),
                    subgroup = "boiler-sluid-steam",
                    category = "boiler-omnifluid-"..boiler.name,
                    order = "a["..steam..boiler.target_temperature.."]",
                    energy_required = math.max(omni.fluid.sluid_contain_fluid/boiler_consumption, 0.0011),
                    enabled = true,
                    hide_from_player_crafting = true,
                    main_product = "solid-"..steam.."-T-"..tempstring,
                    ingredients = {{type = "item", name = "solid-"..water.."-T-"..temp_ing, amount = 1}},
                    results = {{type = "item", name = "solid-"..steam.."-T-"..tempstring, amount = 1}}
                }
            end

            ----------------------------
            --Create new boiler entity--
            ----------------------------
            --Modify the existing items place result. (An item might not exist)
            local new_item = data.raw.item[omni.lib.find_placed_by(boiler.name)]
            if new_item then
                new_item.place_result = boiler.name.."-converter"
                new_item.localised_name = {"item-name.boiler-converter", omni.lib.locale.of(boiler).name}
            end

            --stop it from being analysed further (stop recursive updates)
            omni.fluid.forbidden_boilers[boiler.name.."-converter"] = true

            --Create a new entity to not break stuff (convert boiler type to an assembler).
            local new_ent = table.deepcopy(data.raw.boiler[boiler.name])
            new_ent.type = "assembling-machine"
            new_ent.name = boiler.name.."-converter"
            new_ent.localised_name = {"item-name.boiler-converter", omni.lib.locale.of(boiler).name}
            new_ent.icon = boiler.icon
            new_ent.icons = boiler.icons
            new_ent.crafting_speed = 1

            --change source location to deal with the new size
            --new_ent.energy_source = table.deepcopy(boiler.energy_source)
            if new_ent.energy_source and new_ent.energy_source.connections then
                new_ent.energy_source.connections = omni.fluid.heat_pipe_images.connections
                new_ent.energy_source.pipe_covers = omni.fluid.heat_pipe_images.pipe_covers
                new_ent.energy_source.heat_pipe_covers = omni.fluid.heat_pipe_images.heat_pipe_covers
                new_ent.energy_source.heat_picture = omni.fluid.heat_pipe_images.heat_picture
                new_ent.energy_source.heat_glow = omni.fluid.heat_pipe_images.heat_glow
                new_ent.animation = omni.fluid.exchanger_images.animation
                new_ent.working_visualisations = omni.fluid.exchanger_images.working_visualisations
            else
                local tier = string.gsub(boiler.name, "boiler%-", "")
                if tier and omni.lib.is_number(tier) then
                    new_ent.animation = boiler_images(tonumber(tier)).animation
                    new_ent.working_visualisations = boiler_images(tonumber(tier)).working_visualisations
                else
                    new_ent.animation = boiler_images().animation
                    new_ent.working_visualisations = boiler_images().working_visualisations
                end
            end

            --Check if its a fluid burning boiler, needs another fluid box
            if new_ent.energy_source.burns_fluid then
                new_ent.energy_source.fluid_box.production_type = "input"
                pipe_covers = pipecoverspictures()
                new_ent.energy_source.fluid_box.volume = 1000
                new_ent.energy_source.fluid_box.pipe_connections = {{flow_direction = "input-output", position = {2,0}},{flow_direction = "input-output", position = {-2,0}}}
            end

            new_ent.energy_usage = boiler.energy_consumption
            new_ent.ingredient_count = 4
            new_ent.crafting_categories = {"boiler-omnifluid-"..boiler.name, "general-omni-boiler"}
            new_ent.fluid_boxes = {
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    volume = 1000,
                    pipe_connections = {{flow_direction = "output", position = {0, -2}}}
                }
            }
            new_ent.fluid_box = nil --removes input box
            new_ent.output_fluid_box = nil
            new_ent.mode = nil --invalid for assemblers
            --new_ent.minable.result = boiler.name.."-converter"

            if new_ent.next_upgrade then
                new_ent.next_upgrade = new_ent.next_upgrade.."-converter"
            end

            new_ent.collision_box = {{-1.29, -1.29}, {1.29, 1.29}}
            new_ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
            new_boiler[#new_boiler+1] = new_ent
            ing_replace[#ing_replace+1] = boiler.name

            --find tech unlock
            for _, tech in pairs(data.raw.technology) do
                if tech.effects then
                    for _, k in pairs(tech.effects) do
                        if k.recipe_name and k.recipe_name == boiler.name then
                            boiler_tech[#boiler_tech+1] = {tech_name = tech.name, old_name = boiler.name}
                        end
                    end
                end
            end

            --hide and disable old boiler entity
            local old = data.raw.boiler[boiler.name]
            old.enabled = false
            if old.flags then
                local I = 1
                local shouldhide = true
                -- Iterate and remove "player-creation" from the now-hidden boiler, add "hidden" flag if it doesn't have it already
                repeat
                    if old.flags[I] == "player-creation" then
                        table.remove(old.flags, I)
                        I = I - 1
                    elseif old.flags[I] == "hidden" then
                        shouldhide = false
                    end
                    I = I + 1
                until I > #old.flags
                if shouldhide then
                    old.flags[#old.flags+1] = "hidden"
                end
            else
                old.flags = {"hidden"}
            end
            if old.next_upgrade then old.next_upgrade = nil end

            ----------------------------
            -----Compression compat-----
            ----------------------------
            if mods["omnimatter_compression"] then
                --Create compressed boiling recipes
                local compression_levels = {["compact"] = 1, ["nanite"] = 2, ["quantum"] = 3, ["singularity"] = 4}
                local configured_levels = settings.startup["omnicompression_multiplier"].value
                local comp_water = "concentrated-"..string.gsub(water, "%-concentrated%-grade%-%d", "")
                local comp_steam = "concentrated-"..string.gsub(steam, "%-concentrated%-grade%-%d", "")
                local compression_string = string.gsub(boiler.name, "(.*)-", "")

                local level = 0
                if compression_levels[compression_string] then
                    level = compression_levels[compression_string]
                end

                if water ~= steam then
                    omni.fluid.add_boiler_fluid(comp_steam)

                    new_boiler[#new_boiler+1] = {
                        type = "recipe",
                        name = boiler.name.."-boiling-concentrated-steam-"..boiler.target_temperature,
                        icons = omni.lib.icon.of(data.raw.fluid[comp_steam]),
                        subgroup = "boiler-sluid-steam",
                        category = "boiler-omnifluid-"..boiler.name,
                        order = "b["..comp_steam..boiler.target_temperature.."]",
                        energy_required = math.max((60*omni.fluid.sluid_contain_fluid/boiler_consumption) / configured_levels^level, 0.0011),
                        enabled = true,
                        hide_from_player_crafting = true,
                        main_product = comp_steam,
                        ingredients = {{type = "item", name = "solid-"..comp_water.."-T-"..temp_ing, amount = 1}},
                        results = {{type = "fluid", name = comp_steam, amount = omni.fluid.sluid_contain_fluid, temperature = math.min(boiler.target_temperature, data.raw.fluid[comp_steam].max_temperature)}}
                    }
                end

                --Create a solid water boiling recipe version if steam with the boiler target temp is required (registered as consumer).
                category = "mush"
                if fluid_cats["sluid"][comp_steam] then category = "sluid" end
                found = false
                for _, temp in pairs(fluid_cats[category][comp_steam]["consumer"].temperatures) do
                    if boiler.target_temperature == temp then
                        found = true
                        break
                    end
                end
                if found == true then
                    local tempstring = string.gsub(boiler.target_temperature, "%.", "_")
                    new_boiler[#new_boiler+1] = {
                        type = "recipe",
                        name = boiler.name.."-boiling-concentrated-solid-steam-"..tempstring,
                        icons = omni.lib.icon.of(data.raw.fluid[comp_steam]),
                        subgroup = "boiler-sluid-steam",
                        category = "boiler-omnifluid-"..boiler.name,
                        order = "b["..comp_steam..boiler.target_temperature.."]",
                        energy_required = math.max((60*omni.fluid.sluid_contain_fluid/boiler_consumption) / configured_levels^level, 0.0011),
                        enabled = true,
                        hide_from_player_crafting = true,
                        main_product = "solid-"..comp_steam.."-T-"..tempstring,
                        ingredients = {{type = "item", name = "solid-"..comp_water.."-T-"..temp_ing, amount = 1}},
                        results = {{type = "item", name = "solid-"..comp_steam.."-T-"..tempstring, amount = 1}}
                    }
                end
            end
        end
    end

    ----------------------------------
    -----Create converter recipes-----
    ----------------------------------
    --Need to check sluids as well for some boiler fluids
    for _, cats in pairs({"mush", "sluid"}) do
        for _, fugacity in pairs(fluid_cats[cats]) do
            --deal with non-water mush fluids, allow temperature and specific boiler systems
            --Only need to worry about consumers
            --for _, state in pairs({"producer", "consumer"}) do
            for temp, _ in pairs(fugacity["consumer"].conversions) do
                --Check the old temperatures table if the required temperature requires a conversion recipe
                local tempstring = string.gsub(temp, "%.", "_")
                if data.raw.item["solid-"..fugacity.name.."-T-"..tempstring] then
                    new_boiler[#new_boiler+1] = {
                        type = "recipe",
                        name = fugacity.name.."-fluidisation-"..tempstring,
                        icons = omni.lib.icon.of(fugacity.name,"fluid"),
                        subgroup = "boiler-sluid-converter",
                        category = "crafting-with-fluid",
                        order = "a["..fugacity.name.."]",
                        energy_required = 0.25,
                        enabled = true,
                        hide_from_player_crafting = true,
                        main_product = fugacity.name,
                        ingredients = {{type = "item", name = "solid-"..fugacity.name.."-T-"..tempstring, amount = 1}},
                        results = {{type = "fluid", name = fugacity.name, amount = omni.fluid.sluid_contain_fluid, temperature = temp}},
                    }
                else
                    log("item does not exist:".. fugacity.name.."-fluidisation-"..tempstring)
                end
            end
            --end
        end
    end

    new_boiler[#new_boiler+1] = {
        type = "recipe-category",
        name = "general-omni-boiler",
    }
    data:extend(new_boiler)
end

return sluid_boiler_generation