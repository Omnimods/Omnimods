data:extend(
{
    {
        type = "bool-setting",
        name = "omnicompression_item_compression",
        setting_type = "startup",
        default_value = true,
        order = "a"
    },
    {
        type = "bool-setting",
        name = "omnicompression_recipe_compression",
        setting_type = "startup",
        default_value = true,
        order = "b"
    },
    {
        type = "bool-setting",
        name = "omnicompression_entity_compression",
        setting_type = "startup",
        default_value = true,
        order = "c"
    },
    {
        type = "bool-setting",
        name = "omnicompression_resource_compression",
        setting_type = "startup",
        default_value = true,
        order = "d"
    },
    {
        type = "int-setting",
        name = "omnicompression_building_levels",
        setting_type = "startup",
        default_value = 2,
        minimum_value = 1,
        maximum_value = 4,
        allowed_values = {1,2,3,4},
        order = "e"
    },
    {
        type = "int-setting",
        name = "omnicompression_multiplier",
        setting_type = "startup",
        default_value = 4,
        minimum_value = 2,
        maximum_value = 10,
        allowed_values = {2,3,4,5,6,7,8,9,10},
        order = "f"
    },
    {
        type = "bool-setting",
        name = "omnicompression_final_building",
        setting_type = "startup",
        default_value = false,
        order = "g"
    },
    {
        type = "int-setting",
        name = "omnicompression_too_long_time",
        setting_type = "startup",
        default_value = 11000,
        minimum_value = 1200,
        maximum_value = 72000,
        order = "h"
    },
    {
        type = "bool-setting",
        name = "omnicompression_one_list",
        setting_type = "startup",
        default_value = false,
        order = "i"
    },
    {
        type = "bool-setting",
        name = "omnicompression_compensate_stacksizes",
        setting_type = "startup",
        default_value = false,
        order = "j"
    },
    {
        type = "bool-setting",
        name = "omnicompression_normalize_stacked_buildings",
        setting_type = "startup",
        default_value = false,
        order = "k"
    },
    {
        type = "int-setting",
        name = "omnicompression_compressed_tech_min",
        setting_type = "startup",
        default_value = 2000, --space science pack size
        minimum_value = 0,
        maximum_value = 250000000,
        order = "l"
    },
    {
        type = "string-setting",
        name = "omnicompression_always_compress_sp",
        setting_type = "startup",
        default_value = "chemical-science-pack,high-tech-science-pack,production-science-pack,military-science-pack,space-science-pack,datacore-war-1,angels-science-pack-orange,angels-science-pack-blue,angels-science-pack-yellow,angels-science-pack-white,datacore-exploration-1",
        order = "m"
    },
    {
        type = "bool-setting",
        name = "omnicompression_1x1_buildings",
        setting_type = "startup",
        default_value = false,
        order = "n"
    },
    {
        type = "double-setting",
        name = "omnicompression_energy_mult",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 5,
        order = "o"
    },
    {
        type = "double-setting",
        name = "omnicompression_cost_mult",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 5,
        order = "p"
    },
    {
        type = "bool-setting",
        name = "omnicompression_compounding_building_mults",
        setting_type = "startup",
        default_value = false,
        order = "q"
    },
    {
        type = "bool-setting",
        name = "omnicompression_hide_handcraft",
        setting_type = "startup",
        default_value = false,
        order = "r"
    },
})