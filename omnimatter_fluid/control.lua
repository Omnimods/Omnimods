global.offshore_pumps = {}

-----------------------
---Support functions---
-----------------------
local function in_table(element, tab)
    for _, t in pairs(tab) do
        if element == t then return true end
    end
    return false
end

local function remove_entities(surface, names, position, area)
    for _, name in pairs(names) do
        for _, entity in pairs(surface.find_entities_filtered{
        area= {{position.x -area, position.y -area},{position.x +area, position.y +area}},
        name=name,
        }) do
            entity.destroy()
        end
    end
end

local function offshore_pump_placed(entity)
    if game.entity_prototypes["solshore-"..entity.name] then
        local pos = entity.position
        pos.y = pos.y + 1/32
        entity.surface.create_entity{
            name = "solshore-"..entity.name,
            position = pos,
            direction = entity.direction,
            force = entity.force
        }
    end
end

----------------------
---Event functions---
----------------------
local function on_init()
    --Save the name of all found offshore pumps in globals
    local pumps = game.get_filtered_entity_prototypes({{filter = "type", type = "offshore-pump"}})
    for name, pump in pairs(pumps) do
        table.insert(global.offshore_pumps, name)
    end

    --Call Picker Dollies remnote interface to disable the fake offshore assemblers movement. Due to it being an assembler, it could be moved to land by dollies otherwise
    if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["add_blacklist_name"] then
        for _, name in pairs(global.offshore_pumps) do
            local sol = "solshore-"..name
            if game.entity_prototypes[sol] then
                remote.call("PickerDollies", "add_blacklist_name", name)
                remote.call("PickerDollies", "add_blacklist_name", sol)
            end
        end
    end
end

local function on_entity_created(event)
    local entity = event.created_entity or event.entity
    if entity and entity.valid then
        if entity.type == "offshore-pump" and in_table(entity.name, global.offshore_pumps) then
            offshore_pump_placed(entity)
        end
    end
end

local function on_entity_removed(event)
    local entity = event.created_entity or event.entity
    if entity and entity.valid then
        if entity.type == "assembling-machine" or entity.type == "offshore-pump" then
            local ori = entity.name:gsub("solshore%-", "")
            --Casse offshore pmp destroyed
            if in_table(entity.name, global.offshore_pumps) then
                remove_entities(entity.surface, {"solshore-"..entity.name}, entity.position, 0.5)
            --Case assembler destroyed
            elseif in_table(ori, global.offshore_pumps) then
                remove_entities(entity.surface, {ori}, entity.position, 0.5)
            end
        end
    end
end

-------------
---Events---
------------
--init
script.on_init(function() on_init() end)
script.on_configuration_changed(function() on_init() end)

--Entity creation
script.on_event(defines.events.on_built_entity, on_entity_created)
script.on_event(defines.events.on_robot_built_entity, on_entity_created)
script.on_event(defines.events.script_raised_built, on_entity_created)
script.on_event(defines.events.script_raised_revive, on_entity_created)

--Entity removal
script.on_event(defines.events.on_entity_died, on_entity_removed)
script.on_event(defines.events.on_pre_player_mined_item, on_entity_removed)
script.on_event(defines.events.on_robot_pre_mined, on_entity_removed)
script.on_event(defines.events.script_raised_destroy, on_entity_removed)