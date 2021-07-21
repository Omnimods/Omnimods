data:extend(
{
    --Item Groups
    {
        type = "item-group",
        name = "omnicrystal",
        order = "z",
        icon = "__omnimatter_crystal__/graphics/technology/omnicrystal-category.png",
        icon_size = 128,
    },
    {
        type = "item-group",
        name = "crystallonics",
        order = "z",
        icon = "__omnimatter_crystal__/graphics/technology/crystallonics.png",
        icon_size = 128,
    },
    --Item Subgroups
    --crystallonics
    {
        type = "item-subgroup",
        name = "crystal-part",
        group = "crystallonics",
        order = "aa",
    },
    {
        type = "item-subgroup",
        name = "crystal",
        group = "crystallonics",
        order = "ab",
    },
    {
        type = "item-subgroup",
        name = "crystallonic",
        group = "crystallonics",
        order = "ac",
    },
    --omnicrystal
    {
        type = "item-subgroup",
        name = "crystallomnizer",
        group = "omnicrystal",
        order = "aa",
    },
    {
        type = "item-subgroup",
        name = "omniplant",
        group = "omnicrystal",
        order = "ab",
    },
    {
        type = "item-subgroup",
        name = "omnine",
        group = "omnicrystal",
        order = "ac",
    },
    {
        type = "item-subgroup",
        name = "crystal-fluids",
        group = "omnicrystal",
        order = "ad",
    },
    {
        type = "item-subgroup",
        name = "salting",
        group = "omnicrystal",
        order = "ae",
    },
    {
        type = "item-subgroup",
        name = "solvation",
        group = "omnicrystal",
        order = "af",
    },
    {
        type = "item-subgroup",
        name = "crystallization",
        group = "omnicrystal",
        order = "ag",
    },
    {
        type = "item-subgroup",
        name = "traction",
        group = "omnicrystal",
        order = "ah",
    },
    --Recipe categories
    {
        type = "recipe-category",
        name = "omniplant",
    },
    {
        type = "recipe-category",
        name = "crystallomnizer",
    },
})