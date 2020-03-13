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

script.on_event(defines.events.on_player_alt_selected_area, function(event)

end)

script.on_event(defines.events.on_player_selected_area, function(event)
	if event.item == "ore-move-planner" then
		local player = game.players[event.player_index]
		local surface = player.surface
		if not ore_to_move[event.player_index] then
			ore_to_move[event.player_index] = {{ore={},centre={},cost=0},{ore={},centre={},cost=0}}
		else
			ore_to_move[event.player_index][2] = ore_to_move[event.player_index][1]
			ore_to_move[event.player_index][1] = {ore={},centre={},cost=0}
		end
		
		--log(ore_to_move[event.player_index][2].cost)
		local centre = {x=0,y=0}
		local qnt = 0
		for _,entity in pairs(event.entities) do
			if entity.type == "resource" then
				qnt=qnt+1
				local pos = entity.position
				centre.x=centre.x+pos.x
				centre.y=centre.y+pos.y
				ore_to_move[event.player_index][1].ore[#ore_to_move[event.player_index][1].ore+1]={name=entity.name,pos=pos,surface = entity.surface}

				local extra = entity
				--extra.destroy()
							
					--surf.create_entity({name = "compressed-"..name.."-ore" , position = pos, force = force, amount = quant})
			end
		end
		centre.x=round(centre.x/qnt)
		centre.y=round(centre.y/qnt)
		ore_to_move[event.player_index][1].centre.x=centre.x
		ore_to_move[event.player_index][1].centre.y=centre.y
		
		local found=false
		for _, ore in pairs(ore_to_move[event.player_index][1].ore) do
			ore.pos.x=ore.pos.x-centre.x
			ore.pos.y=ore.pos.y-centre.y
			if not found then
				for _,ore in pairs(ore_to_move[event.player_index][2].ore) do
					local p = {}
					p.x = ore_to_move[event.player_index][2].centre.x+ore.pos.x
					p.y = ore_to_move[event.player_index][2].centre.y+ore.pos.y
					if p.x==ore_to_move[event.player_index][1].centre.x+ore.pos.x and p.y==ore_to_move[event.player_index][1].centre.y+ore.pos.y then
						ore_to_move[event.player_index][1].cost=ore_to_move[event.player_index][2].cost
						found=true
						break
					end
				end
			end
		end
			--player.insert({name = resource, count = miscount})
	end
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
	if event.item == "ore-move-planner" and ore_to_move[event.player_index] ~= nil then
		local player = game.players[event.player_index]
		local surface = player.surface
		local centre = {x=round((event.area.left_top.x+event.area.right_bottom.x)/2),y=round((event.area.left_top.y+event.area.right_bottom.y)/2)}
		local surface = player.surface
		local dist = math.sqrt(math.pow(centre.x-ore_to_move[event.player_index][1].centre.x,2)+math.pow(centre.y-ore_to_move[event.player_index][1].centre.y,2))
		dist=dist+ore_to_move[event.player_index][1].cost
		for _, ore in pairs(ore_to_move[event.player_index][1].ore) do
			local entities = surface.find_entities_filtered{
			  area= {{ore_to_move[event.player_index][1].centre.x+ore.pos.x -0.5, ore_to_move[event.player_index][1].centre.y+ore.pos.y -0.5},
			  {ore_to_move[event.player_index][1].centre.x+ore.pos.x +0.5, ore_to_move[event.player_index][1].centre.y+ore.pos.y +0.5}},
			  name=ore.name,
			}
			local cost = 1/(1+dist/5000)
			for _, ent in pairs(entities) do
				local pos = {}
				pos.x = centre.x+ore.pos.x
				pos.y = centre.y+ore.pos.y
				local amount = round(ent.amount*cost)
				if amount > 0 then
					ore.surface.create_entity({name = ore.name , position = pos, force = ent.force, amount = round(ent.amount*cost)})
				end
				ent.destroy()
			end
		end
		ore_to_move[event.player_index][1].cost=dist
		ore_to_move[event.player_index][1].centre.x=centre.x
		ore_to_move[event.player_index][1].centre.y=centre.y
	end
end)

