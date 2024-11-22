if settings.startup["omnicompression_resource_compression"].value then
    data:extend({
        {
            type = "selection-tool",
            name = "compression-planner",
            icon = "__omnimatter_compression__/graphics/planner.png",
            icon_size = 32,
            stack_size = 1,
            stackable = false,
            subgroup = "tool",
            order = "c[automated-construction]-d[dirty-planner]",
            flags = {"only-in-cursor", "spawnable"},
            always_include_tiles = true,
            select = {
                border_color = {r = 1.0, g = 0.2, b = 1.0, a = 0.3},
                cursor_box_type = "not-allowed",
                mode = "any-entity",
                entity_type_filters = {"resource"},
                entity_filter_mode = "whitelist",
                
            },
            alt_select = {
                border_color = {r = 0.2, g = 0.8, b = 0.3, a = 0.3},
                cursor_box_type = "not-allowed",
                mode = "any-entity",
                entity_type_filters = {"resource"},
                entity_filter_mode = "whitelist",
            },
        },
        {
            type = "custom-input",
            name = "give-compression-planner",
            key_sequence = "ALT + C",
            consuming = "game-only",
            action = "lua"
        },
        {
            type = "shortcut",
            name = "compression-planner-shortcut",
            localised_name = {"item-name.compression-planner"},
            action = "lua",
            associated_control_input = "give-compression-planner",
            icons = {{
                icon = "__omnimatter_compression__/graphics/planner-shortcut.png",
                icon_size = 128,
                scale = 1,
            }},
            small_icons = {{
                icon = "__omnimatter_compression__/graphics/planner-shortcut-white.png",
                icon_size = 128,
                scale = 1,
            }},
        }
    })
end