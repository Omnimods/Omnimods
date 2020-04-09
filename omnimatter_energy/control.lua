local gather = function(pos,entity)
	return surface.find_entities_filtered{
      area= {{pos.x -0.5, pos.y -0.5},{pos.x +0.5, pos.y +0.5}},
      name=entity,
    }
end

local function On_Remove(event)
	local entity = event.entity	
   	if entity.valid and entity.name == "omni_solar_road" then
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
        ungroup_entities(pos_hash)
	end
end

local function Player_Tile_Built(event)

	local player = game.players[event.player_index]
	local surface = player and player.surface

	for i, vv in ipairs(event.tiles) do
		local position = vv.position
		local currentTilename = surface.get_tile(position.x,position.y).name
		
		if currentTilename == "omni_solar_road" then			
			local force = event.force
			local solar_mat = surface.get_tile(position.x,position.y)
			local sm_pole_name = "omni_solar_road_pole"  
			local sm_panel_name = "omni_solar_road_panel"  
			  
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
			entity1 = surface.find_entities_filtered{area=area, name="omni_solar_road_panel" , limit=1}
				
			if entity1 then 		
			
				for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni_solar_road_panel" })) do o.destroy() end	
			else			
			end
				
			--- Remove the Hidden Solar Panel		
			local entity2 = entities[1]
			entity2 = surface.find_entities_filtered{area=area, name="omni_solar_road_pole"  , limit=1}	
			
			if entity2 then 
					
				for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni_solar_road_pole"  })) do o.destroy() end	

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
		
		if currentTilename == "bi-solar-mat" then
			writeDebug("Solar Mat has been built")
			
			local force = event.force
			local solar_mat = surface.get_tile(position.x,position.y)
			local sm_pole_name = "omni_solar_road_pole" 
			local sm_panel_name = "omni_solar_road_panel" 
			  
			local create_sm_pole = surface.create_entity({name = sm_pole_name, position = position, force = force})
			local create_sm_panel = surface.create_entity({name = sm_panel_name, position = position, force = force})
			  
			create_sm_pole.minable = false
			create_sm_pole.destructible = false
			create_sm_panel.minable = false
			create_sm_panel.destructible = false
		else
			local radius = 0.5
			local area = {{position.x - radius, position.y - radius}, {position.x + radius, position.y + radius}}
			local entities = surface.find_entities(area)
			local entity1 = entities[1]
			entity1 = surface.find_entities_filtered{area=area, name="omni_solar_road_pole" , limit=1}
				
			if entity1 then 		
			
				for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni_solar_road_pole" })) do o.destroy() end	

				writeDebug("bi_solar_pole Removed")
			else
				writeDebug("bi_solar_pole not found")				
			end
				
			--- Remove the Hidden Solar Panel		
			local entity2 = entities[1]
			entity2 = surface.find_entities_filtered{area=area, name="omni_solar_road_panel" , limit=1}	
			
			if entity2 then 
					
				for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni_solar_road_panel" })) do o.destroy() end	

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
	local position = event.positions
	
	-- fix #2 Error while running event Bio_Industries::on_robot_built_tile
	if surface == nil then
		return
	end
	
	for i, position in ipairs(position) do
		local currentTilename = surface.get_tile(position.x,position.y).name
		
		if currentTilename == "omni_solar_road" then
			writeDebug("Solar Mat has been built")
			
			local force = event.force
			local solar_mat = surface.get_tile(position.x,position.y)
			local sm_pole_name = "omni_solar_road_pole"  
			local sm_panel_name = "omni_solar_road_panel"  
			  
			local create_sm_pole = surface.create_entity({name = sm_pole_name, position = position, force = force})
			local create_sm_panel = surface.create_entity({name = sm_panel_name, position = position, force = force})
			  
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
			entity1 = surface.find_entities_filtered{area=area, name="omni_solar_road_pole", limit=1}
				
			if entity1 then 		
			
				for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni_solar_road_pole"})) do o.destroy() end	

				writeDebug("omni_solar_road_pole Removed")
			else
				writeDebug("omni_solar_road_pole not found")				
			end
				
			--- Remove the Hidden Solar Panel		
			local entity2 = entities[1]
			entity2 = surface.find_entities_filtered{area=area, name="omni_solar_road_panel", limit=1}	
			
			if entity2 then 
					
				for _, o in pairs(surface.find_entities_filtered({area = area, name = "omni_solar_road_panel"})) do o.destroy() end	

				writeDebug("omni_solar_road_panel Removed")
			else
				writeDebug("omni_solar_road_panel not found")				
			end


		
		end
	end	
		
end


--------------------------------------------------------------------
local function solar_mat_removed_at(surface, position)
   local radius = 0.5
   local area = {{position.x - radius, position.y - radius}, {position.x + radius, position.y + radius}}
   local n = 0
   for _,o in next,surface.find_entities_filtered{name='omni_solar_road_pole',area=area} or {}
      do o.destroy() n = n+1 end
   --writedebug(string.format('%g bi_solar_poles removed',n))
   for _,o in next,surface.find_entities_filtered{name='omni_solar_road_panel',area=area} or {}
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
   if event.item_stack.name == 'omni_solar_road' then
     -- writedebug(string.format('%g solar mats removed',event.item_stack.count))
      return solar_mat_removed_at(robot.surface,robot.position)
      end
   end
--------------------------------------------------------------------



local build_events = {defines.events.on_built_entity, defines.events.on_robot_built_entity}
script.on_event(build_events, On_Built)

local pre_remove_events = {defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}
script.on_event(pre_remove_events, On_Remove)

local death_events = {defines.events.on_entity_died}
script.on_event(death_events, On_Death)

local player_build_event = {defines.events.on_player_built_tile}
script.on_event(player_build_event, Player_Tile_Built)

local robot_build_event = {defines.events.on_robot_built_tile}
script.on_event(robot_build_event, Robot_Tile_Built)

local remove_events = {defines.events.on_player_mined_item}
script.on_event(remove_events, Player_Tile_Remove)

local remove_events = {defines.events.on_robot_mined}
script.on_event(remove_events, Robot_Tile_Remove)



--------------------------------------------------------------------
--- DeBug Messages 
--------------------------------------------------------------------
function writeDebug(message)
	if QC_Mod == true then 
		for i, player in pairs(game.players) do
			player.print(tostring(message))
		end
	end
end

