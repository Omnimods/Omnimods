
function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l.name] = l end
    return set
end