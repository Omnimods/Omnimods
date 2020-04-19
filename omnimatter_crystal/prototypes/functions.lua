
function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l.name] = l end
    return set
end

omni.crystal.get_ore_ic_size=function(metal_ore)
	local ic_sz=32
	if data.raw.item[metal_ore].icon_size then
		ic_sz=data.raw.item[metal_ore].icon_size
	elseif data.raw.item[metal_ore].icons and data.raw.item[metal_ore].icons[1].icon_size then
		ic_sz=data.raw.item[metal_ore].icons[1].icon_size
	end
	return ic_sz
end
