if mods["pycoalprocessing"] and data.raw["fuel-category"]["biomass"] then
    for _, machine_name in pairs({"burner-omni-furnace", "burner-omniphlog", "burner-omnitractor"}) do
        local machine = data.raw["assembling-machine"][machine_name]
        if machine and machine.energy_source then
            local energy_source = machine.energy_source
            if not energy_source.fuel_categories then
                if energy_source.fuel_category then
                    energy_source.fuel_categories = {energy_source.fuel_category}
                    energy_source.fuel_category = nil
                else
                    energy_source.fuel_categories = {"chemical", "biomass"}
                    goto CONTINUE
                end
            end
            -- Local here since we may have set above
            local fuel_categories = energy_source.fuel_categories
            if fuel_categories then
                local has_biomass = false
                for _, v in pairs(fuel_categories) do
                    has_biomass = has_biomass or v == "biomass"
                end
                if not has_biomass then
                    log("Adding fuel category \"biomass\" to " .. machine_name)
                    fuel_categories[#fuel_categories+1] = "biomass"
                end
            end
        end
        ::CONTINUE::
    end
end