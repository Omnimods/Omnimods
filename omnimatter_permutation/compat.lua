if mods["space-exploration"] then

    --exclude condenser turbine recipes
    local steam_temperature_ranges = {
        100, -- Min
        165, -- Vanilla boiler
        200,
        300,
        400,
        415, -- K2 HE
        500, -- HE
        600,
        700,
        800,
        900,
        1000  -- last one is accepted but previous temperature is used internally
    }
    for i = 1, #steam_temperature_ranges - 1 do
        local low = steam_temperature_ranges[i]
        local high = steam_temperature_ranges[i+1]
        omni.permutation.exclude_recipe("se-condenser-turbine-reclaim-water-"..low.."-"..high)
    end

end