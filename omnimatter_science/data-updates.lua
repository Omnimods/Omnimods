--Add Omni science pack to labs if crystal is present
if mods["omnimatter_crystal"] then
    for i, labs in pairs(data.raw["lab"]) do
        local found = false
        for _,v in pairs(labs.inputs) do
            if v == "omni-pack" then
                found = true
            end
        end
        if not lab_ignore_pack[labs.name] and found == false then
            table.insert(labs.inputs, "omni-pack")
        end
    end
end