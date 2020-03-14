for _, t in pairs({"recipe","item"}) do
	for _,d in pairs(data.raw[t]) do
		if d.icon_size == nil then
			d.icon_size=32
		end
	end
end

for _,pack in pairs({"automation-science-pack","logistic-science-pack","chemical-science-pack","production-science-pack","military-science-pack","utility-science-pack"}) do
	data.raw.tool[pack].icon = nil
	data.raw.tool[pack].icons = {{icon="__omnilib__/graphics/"..pack..".png"}}
	if data.raw.technology[pack] then
		data.raw.technology[pack].icon = "__omnilib__/graphics/technology/"..pack..".png"
	end
end