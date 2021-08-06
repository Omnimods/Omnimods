data:extend(
{
    {
        type = "int-setting",
        name = "water-levels",
        setting_type = "startup",
        default_value = 8,
        maximum_value = 20,
        minimum_value = 4,
        order="a"
    },
    {
        type = "bool-setting",
        name = "enable-waste-water",
        setting_type = "startup",
        default_value = true,
        order="b"
    },
})