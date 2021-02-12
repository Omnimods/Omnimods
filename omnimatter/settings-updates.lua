if mods["angelsindustries"] then
    --Force tech overhaul to be disabled and hide it until we provide a playable compat
    data.raw["bool-setting"]["angels-enable-tech"].forced_value = false
    data.raw["bool-setting"]["angels-enable-tech"].hidden = true
end