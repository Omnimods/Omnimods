for _, pump in pairs(data.raw["offshore-pump"]) do
    local pump_result = "solid-"..pump.fluid.."-T-"..string.gsub(data.raw.fluid[pump.fluid].default_temperature, "%.", "_")
    --Safety check if we created a solid for the pump-fluid
    if data.raw.item[pump_result] then
        pump.selectable_in_game = false
        pump.fluid_box.pipe_connections = {}

        local solid_cat = {
            type = "recipe-category",
            name = "solshore-"..pump.name
        }

        local solid_rec = {
            type = "recipe",
            name = "solshore-"..pump.name,
            ingredients = {},
            results = {{name = pump_result, amount = math.floor(pump.pumping_speed*60/omni.fluid.sluid_contain_fluid)}},
            enabled = true,
            category = "solshore-"..pump.name,
            energy_required = 1,
            hide_from_player_crafting = true
        }

        local solid_ent = {
            type = "assembling-machine",
            name = "solshore-"..pump.name,
            localised_name = omni.lib.locale.of(pump).name,
            localised_description = pump.localised_description,
            selection_box = pump.collision_box,
            collision_box = pump.selection_box,
            collision_mask = {"not-colliding-with-itself"},
            animation = pump.picture,
            order="z",
            icon = "__base__/graphics/icons/offshore-pump.png",
            icon_size = 64,
            --flags = {"placeable-neutral", "player-creation", "not-deconstructable", "not-blueprintable", "placeable-off-grid"},
            flags = {"placeable-neutral", "player-creation", "not-blueprintable", "placeable-off-grid"},
            max_health = 150,
            resistances =
            {
                {
                    type = "fire",
                    percent = 70
                },
                {
                    type = "impact",
                    percent = 30
                }
            },
            corpse = "small-remnants",
            energy_source = {type = "void"},
            energy_usage = "1W",
            vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
            crafting_speed = 1,
            crafting_categories = {"solshore-"..pump.name},
            fixed_recipe = "solshore-"..pump.name,
            minable = pump.minable
        }
        data:extend({solid_cat, solid_rec, solid_ent})
    end
end