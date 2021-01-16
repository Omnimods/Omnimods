ore_to_move = {}

function start_with(a,b)
	return string.sub(a,1,string.len(b)) == b
end
function end_with(a,b)
	return string.sub(a,string.len(a)-string.len(b)+1) == b
end

local round = function(nr)
	local dec = nr-math.floor(nr)
	if dec >= 0.5 then
		return math.floor(nr)+1
	else
		return math.floor(nr)
	end
end

script.on_event(defines.events.on_player_selected_area, function(event)
	if event.item == "ore-move-planner" then
		local player = game.players[event.player_index]
		local surface = player.surface
		--Always set the ore player table back to default to clean up old data when copying a new ore
		ore_to_move[event.player_index] = {ore={}, centre={}, samples = {}, catch = {found = false, samples = {}}}
		local centre = {x=0,y=0}
		local qnt = 0
		for _,entity in pairs(event.entities) do
			if entity.type == "resource" then
				qnt=qnt+1
				local pos = entity.position
				centre.x=centre.x+pos.x
				centre.y=centre.y+pos.y
				ore_to_move[event.player_index].ore[#ore_to_move[event.player_index].ore+1]={name=entity.name,pos=pos,surface = entity.surface}
			end
		end
		--check if something was actually selected
		if qnt > 0 then
			centre.x=round(centre.x/qnt)
			centre.y=round(centre.y/qnt)
			ore_to_move[event.player_index].centre.x=centre.x
			ore_to_move[event.player_index].centre.y=centre.y
			ore_to_move[event.player_index].catch.samples = {}
			local found=false
			for _, ore in pairs(ore_to_move[event.player_index].ore) do
				ore.pos.x=ore.pos.x-centre.x
				ore.pos.y=ore.pos.y-centre.y
				for i,s in pairs(ore_to_move[event.player_index].samples) do
					local p = {}
					p.x = s.pos.x
					p.y = s.pos.y
					if p.x==ore_to_move[event.player_index].centre.x+ore.pos.x and p.y==ore_to_move[event.player_index].centre.y+ore.pos.y then
						ore_to_move[event.player_index].catch.found = true
						table.insert(ore_to_move[event.player_index].catch.samples,i)
					end
				end
			end
		end
	end
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
	if event.item == "ore-move-planner" and ore_to_move[event.player_index] ~= nil then
		local player = game.players[event.player_index]
		local surface = player.surface
		local centre = {x=round((event.area.left_top.x+event.area.right_bottom.x)/2),y=round((event.area.left_top.y+event.area.right_bottom.y)/2)}
		local surface = player.surface
		local dist = math.sqrt(math.pow(centre.x-ore_to_move[event.player_index].centre.x,2)+math.pow(centre.y-ore_to_move[event.player_index].centre.y,2))
		-- if ore_to_move[event.player_index].catch.found == true then
		-- 	dist=dist+ore_to_move[event.player_index].samples[ore_to_move[event.player_index].catch.samples[1]].dist
		-- end

		--Surface Checks
		--Get the highest and lowest x/y coordinates to create the complete area the ore would be moved to
		local max_x = 0
		local max_y = 0
		local min_x = 0
		local min_y = 0
		  
		for _, ore in pairs(ore_to_move[event.player_index].ore) do
			local entities = surface.find_entities_filtered{
				area= {{ore_to_move[event.player_index].centre.x+ore.pos.x -0.5, ore_to_move[event.player_index].centre.y+ore.pos.y -0.5},
				{ore_to_move[event.player_index].centre.x+ore.pos.x +0.5, ore_to_move[event.player_index].centre.y+ore.pos.y +0.5}},
				name=ore.name}
			for _, ent in pairs(entities) do
				if ore.pos.x > max_x then max_x = ore.pos.x end
				if ore.pos.y > max_y then max_y = ore.pos.y end
				if ore.pos.x < min_x then min_x = ore.pos.x end
				if ore.pos.y < min_y then min_y = ore.pos.y end
			end
		end

		--Define blocker tiles / entities
		local area = {{centre.x + min_x, centre.y + min_y},{centre.x + max_x, centre.y + max_y}}
		local blocker_tile = surface.find_tiles_filtered{area = area, collision_mask = {"water-tile"}}
		local blocker_ent = surface.find_entities_filtered{area = area, type= {"cliff","resource"}}

		--Dont do anything if a blocking entity / tile was found (print info msg)
		if next(blocker_ent) or next(blocker_tile) then
			local ent = blocker_ent[next(blocker_ent)] or blocker_tile[next(blocker_tile)]
			game.print("[OmnimatterMove]: "..ent.name.." is in the way.")
		else
			--If the surface has no blocking entities / tiles , continue
			for _, ore in pairs(ore_to_move[event.player_index].ore) do
				local entities = surface.find_entities_filtered{
			  	area= {{ore_to_move[event.player_index].centre.x+ore.pos.x -0.5, ore_to_move[event.player_index].centre.y+ore.pos.y -0.5},
			  	{ore_to_move[event.player_index].centre.x+ore.pos.x +0.5, ore_to_move[event.player_index].centre.y+ore.pos.y +0.5}},
			  	name=ore.name}
			
				local cost = 1/(1+dist/5000)
				for _, ent in pairs(entities) do
					local pos = {}
					pos.x = centre.x+ore.pos.x
					pos.y = centre.y+ore.pos.y
					local amount = round(ent.amount*cost)-3
					if amount > 0 then
						ore.surface.create_entity({name = ore.name , position = pos, force = ent.force, amount = round(ent.amount*cost)})
					end
					ent.destroy()
				end
			end
			if ore_to_move[event.player_index].catch.found then
				for _, s in pairs(ore_to_move[event.player_index].catch.samples) do
					ore_to_move[event.player_index].samples[s].pos.x = ore_to_move[event.player_index].samples[s].pos.x -ore_to_move[event.player_index].centre.x+centre.x
					ore_to_move[event.player_index].samples[s].pos.y = ore_to_move[event.player_index].samples[s].pos.y -ore_to_move[event.player_index].centre.y+centre.y
					ore_to_move[event.player_index].samples[s].dist=dist
				end
				ore_to_move[event.player_index].catch.found=false
			else
				local sample_size = math.min(#ore_to_move[event.player_index].ore,5)
				math.randomseed(#ore_to_move[event.player_index].ore)
				local picked = {}
				for i=1,sample_size do
					local chosen = 0
					while picked[chosen] ~= nil or chosen==0 do
						chosen = math.random(1,#ore_to_move[event.player_index].ore)
					end
					picked[chosen]= true
					local pos = {}
					pos.x = centre.x+ore_to_move[event.player_index].ore[chosen].pos.x
					pos.y = centre.y+ore_to_move[event.player_index].ore[chosen].pos.y
					table.insert(ore_to_move[event.player_index].samples,{pos=pos,dist = dist})
				end
			end
			ore_to_move[event.player_index].ore={}
			ore_to_move[event.player_index].centre.x=centre.x
			ore_to_move[event.player_index].centre.y=centre.y
		end
	end
end)

-------------------------
---Planner spawn logic---
-------------------------

local function get_planner_status(player)
	--Set checks to true if setting "always unlocked" is true, otherwise unlock with rocket-silo
	local check = not not player.force.technologies["rocket-silo"].researched
	if settings.global["ore-move-planner-always-unlock"].value == true then
		check = true
	end
	return check
end

local function refresh_planner_status(force)
	for _, ply in pairs(game.players) do
		ply.set_shortcut_available("ore-move-planner-shortcut", get_planner_status(ply))
	end
end

local function spawn_planner(player_index)
	local player = game.players[player_index]
	local stack = player.cursor_stack
	--check if the cursor is valid and clear it before inserting (lets not void held items :) )
	if stack and stack.valid then
		player.clear_cursor()
		player.cursor_stack.set_stack({type="selection-tool",name = "ore-move-planner",count=1})
	end
end

--unlock ore-move planner after the tech is researtched
script.on_event(defines.events.on_research_finished, function(event)
	local research = event.research
	if research.name == "compression-mining" then
		refresh_planner_status()
	end
end)

--Refresh planner activation when a player is created (doesnt work for sp, thanks cutscene)
script.on_event(defines.events.on_player_created, function(event)
	refresh_planner_status()
end)

--Refresh planner activation when the cutscene is canceled
script.on_event(defines.events.on_cutscene_cancelled, function(event)
	refresh_planner_status()
end)

--Refresh planner activation when tech effects are reset
script.on_event(defines.events.on_technology_effects_reset, function(event)
	refresh_planner_status()
end)

--Refresh planner activation when omnidate is activated
script.on_event(defines.events.on_console_chat, function(event)
	if event.player_index and game.players[event.player_index] then
		if event.message=="omnidate" then
			refresh_planner_status()
		end
	end
end)

--Refresh planner activation when map config is changed (required to update after the setting is changed mid-save)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	refresh_planner_status()
end)

--spawn ore-move planner when a player clicks the shortcut
script.on_event(defines.events.on_lua_shortcut, function(event)
	if event.prototype_name and event.prototype_name == "ore-move-planner-shortcut" then 
		spawn_planner(event.player_index)
	end
end)

--spawn ore-move planner when the hotkey is pressed
script.on_event("give-ore-move-planner", function(event)
	if get_planner_status(game.players[event.player_index]) == true then
		spawn_planner(event.player_index)
	end
end)