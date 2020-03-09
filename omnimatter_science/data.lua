require("prototypes.omni-pack")

if mods["omnimatter_crystal"] then
	data.raw.tool["production-science-pack"].icon = "__omnimatter_science__/graphics/icons/production-science-pack.png"
	table.insert(data.raw["lab"]["lab"].inputs, "omni-pack")
	if mods["bobtech"] then
        table.insert(data.raw["lab"]["lab-2"].inputs, "omni-pack")
    end
end