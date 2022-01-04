local function writeDebug(message)
    if false then
        for _, player in pairs(game.players) do
            player.print(tostring(message))
        end
    end
end

local function gather(pos,entity)
    return surface.find_entities_filtered{
        area= {{pos.x -0.5, pos.y -0.5},{pos.x +0.5, pos.y +0.5}},
        name=entity,
    }
end

local function On_Remove(event)
    local entity = event.entity	
    if entity.valid and entity.name == "omni-solar-road" then
        local entity_group = gather(entity.position,nil)
        if entity_group then
            for ix, vx in ipairs(entity_group) do
                if vx == entity then
                    --vx.destroy()
                else
                    vx.destroy()
                end
            end
        end
    end
end

local function Player_Tile_Built(event)
    local player = game.players[event.player_index]
    local surface = player and player.surface

    for i, vv in ipairs(event.tiles) do
        local position = vv.position
        local currentTilename = surface.get_tile(position.x,position.y).name

        if currentTilename == "omni-solar-road" then			
            local force = event.force
            local solar_mat = surface.get_tile(position.x,position.y)
            local sm_pole_name = "omni-solar-road-pole"  
            local sm_panel_name = "omni-solar-road-panel"  

            local create_sm_pole = surface.create_entity({name = sm_pole_name, position = {position.x + 0.5, position.y + 0.5}, force = force})
            local create_sm_panel = surface.create_entity({name = sm_panel_name, position = {position.x + 0.5, position.y + 0.5}, force = force})

            create_sm_pole.minable = false
            create_sm_pole.destructible = false
            create_sm_panel.minable = false
            create_sm_panel.destructible = false 
        else
            local radius = 0.5
            local area = {{position.x - radius, position.y - radius}, {position.x + radius, position.y + radius}}
            writeDebug("NOT Solar Mat")
            local entities = surface.find_entities(area)
            local entity1 = entities[1]
            entity1 = surface.find_entities_filtered{area=area, name="omni-solar-road-panel" , limit=1}

            if entity1 then
                for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni-solar-road-panel" })) do o.destroy() end
            end

            --- Remove the Hidden Solar Panel
            local entity2 = entities[1]
            entity2 = surface.find_entities_filtered{area=area, name="omni-solar-road-pole"  , limit=1}	

            if entity2 then
                for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni-solar-road-pole"  })) do o.destroy() end
                writeDebug("bi_solar-panel_for_Solar-Mat Removed")
            else
                writeDebug("bi_solar-panel_for_Solar-Mat not found")				
            end
        end
    end
end

local function Robot_Tile_Built(event)
    local robot = event.robot
    local surface = robot.surface

    -- fix #2 Error while running event Bio_Industries::on_robot_built_tile
    if surface == nil then
        return
    end

    for i, vv in ipairs(event.tiles) do
        local position = vv.position
        local currentTilename = surface.get_tile(position.x,position.y).name

        if currentTilename == "omni-solar-road" then		
            writeDebug("Solar Mat has been built")
            local force = event.force
            local solar_mat = surface.get_tile(position.x,position.y)
            local sm_pole_name = "omni-solar-road-pole"  
            local sm_panel_name = "omni-solar-road-panel"  

            local create_sm_pole = surface.create_entity({name = sm_pole_name, position = {position.x + 0.5, position.y + 0.5}, force = force})
            local create_sm_panel = surface.create_entity({name = sm_panel_name, position = {position.x + 0.5, position.y + 0.5}, force = force})

            create_sm_pole.minable = false
            create_sm_pole.destructible = false
            create_sm_panel.minable = false
            create_sm_panel.destructible = false
        else
            local radius = 0.5
            local area = {{position.x - radius, position.y - radius}, {position.x + radius, position.y + radius}}
            local entities = surface.find_entities(area)
            local entity1 = entities[1]
            entity1 = surface.find_entities_filtered{area=area, name="omni-solar-road-pole" , limit=1}

            if entity1 then
                for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni-solar-road-pole" })) do o.destroy() end
                writeDebug("bi_solar_pole Removed")
            else
                writeDebug("bi_solar_pole not found")				
            end

            --- Remove the Hidden Solar Panel		
            local entity2 = entities[1]
            entity2 = surface.find_entities_filtered{area=area, name="omni-solar-road-panel" , limit=1}	
            if entity2 then
                for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni-solar-road-panel" })) do o.destroy() end
                writeDebug("bi_solar-panel_for_Solar-Mat Removed")
            else
                writeDebug("bi_solar-panel_for_Solar-Mat not found")
            end
        end
    end
end
--------------------------------------------------------------------
local function solar_mat_removed_at(surface, position)
    local radius = 0.5
    local area = {{position.x - radius, position.y - radius}, {position.x + radius, position.y + radius}}
    local n = 0
    for _,o in next,surface.find_entities_filtered{name='omni-solar-road-pole',area=area} or {}
        do o.destroy() n = n+1 end
    --writedebug(string.format('%g bi_solar_poles removed',n))
    for _,o in next,surface.find_entities_filtered{name='omni-solar-road-panel',area=area} or {}
        do o.destroy() n = n+1 end
    --writedebug(string.format('bi_solar-panel_for_Solar-Mat',n))
end

local function Player_Tile_Remove(event)
    local player = game.players[event.player_index]
    if event.item_stack.name == 'bi-solar-mat' and player.mining_state.mining then
        -- writedebug(string.format('%g solar mats removed',event.item_stack.count))
        return solar_mat_removed_at(player.surface, player.mining_state.position)
    end
end


local function Robot_Tile_Remove(event)
    local robot = event.robot 
    if event.item_stack.name == 'omni-solar-road' then
        -- writedebug(string.format('%g solar mats removed',event.item_stack.count))
        return solar_mat_removed_at(robot.surface,robot.position)
    end
end

local function call_remote_functions()
    --K2 crash site
    if game.active_mods["Krastorio2"] and remote.interfaces["kr-crash-site"] then
        remote.call("kr-crash-site","remove_crash_site_entity","kr-crash-site-generator")
    end
    --DiscoScience
    if remote.interfaces["DiscoScience"] and remote.interfaces["DiscoScience"]["setIngredientColor"] then
        remote.call("DiscoScience", "setIngredientColor", "energy-science-pack", {r = 0, g = 0, b = 0.6})
        remote.call("DiscoScience", "setLabScale", "omnitor-lab", 1)
    end
end

--------------------------------------------------------------------

script.on_init(call_remote_functions)
script.on_configuration_changed(call_remote_functions)

local pre_remove_events = {defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}
script.on_event(pre_remove_events, On_Remove)

local player_build_event = {defines.events.on_player_built_tile}
script.on_event(player_build_event, Player_Tile_Built)

local robot_build_event = {defines.events.on_robot_built_tile}
script.on_event(robot_build_event, Robot_Tile_Built)

local player_remove_events = {defines.events.on_player_mined_item}
script.on_event(player_remove_events, Player_Tile_Remove)

local robot_remove_events = {defines.events.on_robot_mined}
script.on_event(robot_remove_events, Robot_Tile_Remove)