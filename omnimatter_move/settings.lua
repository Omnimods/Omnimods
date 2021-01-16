data:extend({
    {
        type = "bool-setting",
        name = "ore-move-planner-always-unlock",
        setting_type = "runtime-global",
        default_value = false,
        order = "a"
    },
    {
        type = "bool-setting",
        name = "enable-ore-tile-loss",
        setting_type = "runtime-global",
        default_value = true,
        order = "b"
    },
    {
        type = "int-setting",
        name = "ore-tile-loss",
        setting_type = "runtime-global",
        default_value = 5000,
        minimum_value = 100,
        maximum_value = 65000,
        order = "c"
    }
})