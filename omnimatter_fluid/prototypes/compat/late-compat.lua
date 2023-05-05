if mods["space-exploration"] then
    --Those SE turbines have a hidden fluid generator behind them
    --The decompressed steam needs to be converted back into a fluid
    --Fluid boxes need to be fixed so it lands in the correct output fluid box which is connected to the hidden generator
    --Fluidbox filters stop working once there are more fluidboxes than fluid recipe results...
    --Condenser turbine
    for _, rec in pairs(data.raw.recipe) do
        if rec.category and rec.category == "condenser-turbine" and string.find(rec.name, "turbine%-reclaim%-water") then
            local temp = string.sub(rec.name, -7, -5)
            for _, dif in pairs({"normal","expensive"}) do
                for _, res in pairs(rec[dif].results) do
                    if res.name == "solid-se-decompressing-steam-T-"..temp then
                        res.type = "fluid"
                        res.name = "se-decompressing-steam"
                        res.amount = res.amount * omni.fluid.sluid_contain_fluid
                        res.temperature = temp
                    end
                end
            end
        end
    end
    for i, box in pairs(data.raw.furnace["se-condenser-turbine"].fluid_boxes) do
        if box.filter and box.filter ~= "se-decompressing-steam" then
            data.raw.furnace["se-condenser-turbine"].fluid_boxes[i] = nil
        end
    end
    --Big turbine
    for _, dif in pairs({"normal","expensive"}) do
        for _, res in pairs(data.raw.recipe["se-big-turbine-internal"][dif].results) do
            if res.name == "solid-se-decompressing-steam-T-5000" then
                res.type = "fluid"
                res.name = "se-decompressing-steam"
                res.amount = res.amount * omni.fluid.sluid_contain_fluid
                res.temperature = 5000
            end
        end
    end
    for i, box in pairs(data.raw.furnace["se-big-turbine"].fluid_boxes) do
        if box.filter and box.filter ~= "se-decompressing-steam" then
            data.raw.furnace["se-big-turbine"].fluid_boxes[i] = nil
        else
            --Increase the damn base_area to allow it to hold 2 crafts
            box.base_area = 100
        end
    end
end