for _,pack in pairs({"automation-science-pack","logistic-science-pack","chemical-science-pack","production-science-pack","military-science-pack","utility-science-pack"}) do
	data.raw.tool[pack].icon = nil
	data.raw.tool[pack].icons = {{icon="__omnilib__/graphics/"..pack..".png",icon_size=64}}
	if data.raw.technology[pack] then
		data.raw.technology[pack].icon = "__omnilib__/graphics/technology/"..pack..".png"
	end
end

require("prototypes.override-angels-tech")

