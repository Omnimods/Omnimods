data:extend(
{
    {
        type = "bool-setting",
        name = "omnicompression_one_list",
        setting_type = "startup",
        default_value = false,
        order = "a"
    },
    {
        type = "int-setting",
        name = "omnicompression_building_levels",
        setting_type = "startup",
        default_value = 2,
        minimum_value = 1,
        maximum_value = 4,
        allowed_values = {1,2,3,4},
        order = "b"
    },
    {
        type = "int-setting",
        name = "omnicompression_multiplier",
        setting_type = "startup",
        default_value = 4,
        minimum_value = 2,
        maximum_value = 10,
        allowed_values = {2,3,4,5,6,7,8,9,10},
        order = "c"
    },
    {
        type = "bool-setting",
        name = "omnicompression_final_building",
        setting_type = "startup",
        default_value = false,
        order = "d"
    },
    {
        type = "int-setting",
        name = "omnicompression_too_long_time",
        setting_type = "startup",
        default_value = 11000,
        minimum_value = 1200,
        maximum_value = 72000,
        order = "e"
    },
    {
        type = "bool-setting",
        name = "omnicompression_compensate_stacksizes",
        setting_type = "startup",
        default_value = false,
        order = "f"
    },
    {
        type = "bool-setting",
        name = "omnicompression_normalize_stacked_buildings",
        setting_type = "startup",
        default_value = false,
        order = "g"
    },
    {
        type = "int-setting",
        name = "omnicompression_compressed_tech_min",
        setting_type = "startup",
        default_value = 2000, --space science pack size
        minimum_value = 0,
        maximum_value = 250000000,
        order = "h"
    },
    {
        type = "string-setting",
        name = "omnicompression_always_compress_sp",
        setting_type = "startup",
        default_value = "chemical-science-pack,high-tech-science-pack,production-science-pack,military-science-pack,space-science-pack,datacore-war-1,angels-science-pack-orange,angels-science-pack-blue,angels-science-pack-yellow,angels-science-pack-white,datacore-exploration-1",
        order = "i"
    },
    {
        type = "bool-setting",
        name = "omnicompression_1x1_buildings",
        setting_type = "startup",
        default_value = false,
        order = "j"
    },
    {
        type = "int-setting",
        name = "omnicompression_energy_mult",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 5,
        allowed_values = {1,2,3,4,5},
        order = "k"
    },
    {
        type = "int-setting",
        name = "omnicompression_cost_mult",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 5,
        allowed_values = {1,2,3,4,5},
        order = "l"
    },
    {
        type = "bool-setting",
        name = "omnicompression_hide_handcraft",
        setting_type = "startup",
        default_value = false,
        order = "aa"
    },
})