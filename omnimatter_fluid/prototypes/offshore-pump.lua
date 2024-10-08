--Create recipe category
data:extend({{type = "recipe-category", name = "solshore-pump"}})

--Go through each tile and check tile.fluid for possible pump outputs
for _, t in pairs(data.raw.tile) do
    if t.fluid then
        local pump_result = "solid-"..t.fluid.."-T-"..string.gsub(data.raw.fluid[t.fluid].default_temperature, "%.", "_")
        if not data.raw.recipe["solshore-"..t.fluid] then
            log("Creating recipe for "..t.fluid)
            local solid_rec = {
                type = "recipe",
                name = "solshore-"..t.fluid,
                localised_name = omni.lib.locale.of(data.raw.fluid[t.fluid]).name,
                ingredients = {},
                results = {{name = pump_result, amount = omni.fluid.sluid_contain_fluid, type = "item"}},
                enabled = true,
                category = "solshore-pump",
                energy_required = 1,
                hide_from_player_crafting = true
            }
            data:extend({solid_rec})
        end
    end
end

for _, pump in pairs(data.raw["offshore-pump"]) do
    pump.selectable_in_game = false
    pump.fluid_box.pipe_connections = {}

    local solid_ent = {
        type = "assembling-machine",
        name = "solshore-"..pump.name,
        localised_name = omni.lib.locale.of(pump).name,
        localised_description = pump.localised_description,
        selection_box = pump.collision_box,
        collision_box = pump.selection_box,
        collision_mask = {layers={item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true, is_lower_object = true}, not_colliding_with_itself = true},
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
        crafting_speed = pump.pumping_speed*60/omni.fluid.sluid_contain_fluid/omni.fluid.sluid_contain_fluid,
        crafting_categories = {"solshore-pump"},
        minable = pump.minable
    }
    data:extend({solid_ent})
end