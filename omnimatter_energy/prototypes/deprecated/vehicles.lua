
local locomotive = table.deepcopy(data.raw.locomotive.locomotive)
locomotive.name = "omni-electro-locomotive"
locomotive.reversing_power_modifier = 1.0 -- Electric engines don't care
locomotive.burner.fuel_category = "omni-electro"
locomotive.burner.fuel_inventory_size = 2
locomotive.burner.burnt_inventory_size = 2
locomotive.burner.smoke = nil
locomotive.color = { r = 0.333, g = 0.733, b = 1.00, a = 0.5 }
locomotive.minable.result = locomotive.name
locomotive.working_sound = {
    sound = {
        filename = "__omnimatter_electricity__/sounds/electric-locomotive.ogg",
        volume = 0.4,
    },
    match_speed_to_activity = true,
}
data:extend({
    locomotive,

    {
        type = "item-with-entity-data",
        name = locomotive.name,
        icon = "__omnimatter_electricity__/graphics/icons/electro-loco-1.png",
        icon_size = 32,
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[train-system]-f[electric-locomotive]",
        place_result = locomotive.name,
        stack_size = 5,
    },

    {
        type = "recipe",
        icon = "__omnimatter_electricity__/graphics/icons/electro-loco-1.png",
        icon_size = 32,
        name = locomotive.name,
        energy = 10,
        ingredients = {
            { "electric-engine-unit", 20 },
            { "electronic-circuit", 10 },
            { "steel-plate", 30 },
            { "accumulator", 1 },
        },
        result = locomotive.name,
        enabled = false,
    },
    {
    type = "item",
    name = "omnicium-",
    icons = {
        {icon = "__omnimatter_electricity__/graphics/icons/oxyomnide-salt.png"}
    },
    icon_size = 32,
    flags = {"goes-to-main-inventory"},
    subgroup = "electro-components",
    order="a",
    stack_size = 100}
})
