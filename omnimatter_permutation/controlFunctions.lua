local omnictrl = {}

function omnictrl.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function omnictrl.start_with(a,b)
    return string.sub(a,1,string.len(b)) == b
end

function omnictrl.end_with(a,b)
    return string.sub(a,string.len(a)-string.len(b)+1) == b
end

function omnictrl.start_within_table(a,b)
    return string.sub(a,1,string.len(b)) == b
end

function omnictrl.clone(tab)
    local ret = {}
    if type(tab) ~= "table" then
        return tab
    end
    for i,row in pairs(tab) do
        if type(row) == "table" then
            if getmetatable(row) then
                ret[i] = setmetatable(omnictrl.clone(row),getmetatable(row))
            else
                ret[i] = omnictrl.clone(row)
            end
        elseif type(row) == "function" then
            ret[i] = omnictrl.clone(row)
        else
            ret[i] = row
        end
    end
    for i=1, #tab do
        if type(tab[i]) == "table" then
            if getmetatable(tab[i]) then
                ret[i] = setmetatable(omnictrl.clone(tab[i]),getmetatable(tab[i]))
            else
                ret[i] = omnictrl.clone(tab[i])
            end
        elseif type(tab[i]) == "function" then
            ret[i] = omnictrl.clone(tab[i])
        else
            ret[i] = tab[i]
        end
    end
    return ret
end

return omnictrl