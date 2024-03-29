if mods["omnimatter_crystal"] then
    local omnipack = RecGen:create("omnimatter_science","omni-pack"):
        tool():
        setStacksize(200):
        setDurability(1):
        setIcons("__base__/graphics/icons/production-science-pack.png"):
        setDurabilityDesc("description.science-pack-remaining-amount"):
        setEnergy(5):
        addProductivity():
        setIngredients({
            {type = "item", name = "fast-transport-belt", amount = 1},
            {type = "item", name = "iron-ore-crystal", amount = 2},
            {type = "fluid", name = "omniston", amount = 50}
        }):
        setSubgroup("science-pack"):
        setCategory("crafting-with-fluid"):
        setOrder("ca[omni-science-pack]"):
        setTechName("omnipack-technology"):
        setTechCost(150):
        setTechIcons("omnipack-tech","omnimatter_science"):
        setTechPacks(2):
        setTechPrereq("omnitech-omnitractor-electric-2"):
        setTechTime(20)

    if mods["Krastorio2"] then
        omnipack:setIcons({{icon = "__omnimatter_science__/graphics/technology/omni-tech-card.png",icon_size = 128}}):
            setTechIcons({{icon = "__omnimatter_science__/graphics/technology/omni-tech-card.png",icon_size = 128}}):
            setLocName("item-name.omni-tech-card"):
            setTechLocName("omni-tech-card")
    else
        if data.raw.tool["production-science-pack"].icon == "__base__/graphics/icons/production-science-pack.png" then --only replace if vanilla icon?
            data.raw.tool["production-science-pack"].icon = "__omnilib__/graphics/icons/science-pack/production-science-pack.png"
            data.raw.recipe["production-science-pack"].icon = "__omnilib__/graphics/icons/science-pack/production-science-pack.png"
            data.raw.technology["production-science-pack"].icon = "__omnilib__/graphics/technology/production-science-pack.png"
            data.raw.technology["production-science-pack"].icon_size = 128
            data.raw.tool["production-science-pack"].icon_size=64
            data.raw.recipe["production-science-pack"].icon_size=64
        end
    end
    omnipack:extend()
end