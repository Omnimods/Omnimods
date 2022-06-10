if mods["angelsindustries"] and angelsmods.industries.components then

    data:extend(
    {
    -----------------------------------------------------------------------------
    -- OMNI BLOCKS --------------------------------------------------------------
    -----------------------------------------------------------------------------
    {
        type = "item-subgroup",
        name = "omniblocks",
        group = "omnimatter",
        order = "aga",
    },
    {
        type = "item",
        name = "block-omni-0",
        localised_name = {"item-name.block-omni", 0},
        icons = {
                {icon = "__angelsindustries__/graphics/icons/block-bprocessing-4.png",
                tint = {255,0,255}},
                {icon = "__omnilib__/graphics/icons/small/lvl0.png",icon_size=64,scale=0.5}
                },
        icon_size = 32,
        subgroup = "omniblocks",
        order = "a",
        stack_size = 200,
    },
    {
        type = "recipe",
        name = "block-omni-0",
        localised_name = {"item-name.block-omni", 0},
        enabled = true,
        category = "crafting",
        energy_required = 5,
        ingredients =
        {
        {type="item", name = "construction-frame-1", amount = 1},
        {type="item", name = "omnicium-plate", amount = 2},
        },
        results=
        {
        {type="item", name="block-omni-0", amount=1},
        },
        icon_size = 32,
    }
    })

    for i=1,5 do
        plate_index = math.min(i,#component["omniplate"])
        gbox_index = math.min(i,#component["gear-box"])
        data:extend(
        {
            {
                type = "item",
                name = "block-omni-"..i,
                localised_name = {"item-name.block-omni", i},
                icons = {
                    {icon = "__angelsindustries__/graphics/icons/block-bprocessing-4.png",
                    tint = {255,0,255}},
                    {icon = "__omnilib__/graphics/icons/small/lvl"..i..".png",icon_size=64,scale=0.5}
                    },
                icon_size = 32,
                subgroup = "omniblocks",
                order = "a",
                stack_size = 200,
            },
            {
                type = "recipe",
                name = "block-omni-"..i,
                localised_name = {"item-name.block-omni", i},
                enabled = false,
                category = "crafting",
                energy_required = 5,
                ingredients =
                {
                {type="item", name = "block-omni-"..i-1, amount = 1},
                {type="item", name = component["omniplate"][plate_index], amount = 4},
                {type="item", name = component["gear-box"][gbox_index], amount = 2},
                },
                results=
                {
                {type="item", name="block-omni-"..i, amount=1},
                },
                icon_size = 32,
            }
        })
    end

    component["construction-block"] = {"block-construction-1", "block-construction-2", "block-construction-3", "block-construction-4","block-construction-5"}
    component["electric-block"] = {"block-electronics-0", "block-electronics-1", "block-electronics-2", "block-electronics-3", "block-electronics-4", "block-electronics-5"}
    component["fluid-block"] = {"construction-frame-1", "block-fluidbox-1", nil, "block-fluidbox-2", nil}
    component["mechanical-block"] = {"construction-frame-1", "block-mechanical-1", nil, "block-mechanical-2", nil}
    component["enhancement-block"] = {"block-enhancement-1", "block-enhancement-2", "block-enhancement-3", "block-enhancement-4", "block-enhancement-5"}
    component["energy-block"] = {"block-energy-1", "block-energy-2", "block-energy-3", "block-energy-4", "block-energy-5"}
    component["logistic-block"] = {"block-logistic-1", "block-logistic-2", "block-logistic-3", "block-logistic-4", "block-logistic-5"}
    component["production-block"] = {"block-production-1", "block-production-2", "block-production-3", "block-production-4", "block-production-5"}
    component["omni-block"] = {"block-omni-1","block-omni-2","block-omni-3","block-omni-4","block-omni-5"}
end
