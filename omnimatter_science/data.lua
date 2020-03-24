require("prototypes.omni-pack")

if mods["omnimatter_crystal"] then
    data.raw.tool["production-science-pack"].icon = "__omnimatter_science__/graphics/icons/production-science-pack.png"
    table.insert(data.raw["lab"]["lab"].inputs, "omni-pack")
    data.raw.tool["omni-pack"].icon_size=64
    data.raw.recipe["omni-pack"].icon_size=64
    if mods["bobtech"] then
        table.insert(data.raw["lab"]["lab-2"].inputs, "omni-pack")
    end
    if data.raw["lab"]["lab-alien"] then
        table.insert(data.raw["lab"]["lab-alien"].inputs,"omni-pack")
    end
    if data.raw["lab"]["lab-module"] then
        table.insert(data.raw["lab"]["lab-module"].inputs,"omni-pack")
    end
end
