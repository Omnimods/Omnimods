--require("gui")

function start_with(a,b)
	return string.sub(a,1,string.len(b)) == b
end
function end_with(a,b)
	return string.sub(a,string.len(a)-string.len(b)+1) == b
end

local get_stacksize = function(game,item)
	for _, p in pairs({"item","mining-tool","gun","ammo","armor","repair-tool","capsule","module","tool","rail-planner","selection-tool","item-with-entity-data"}) do
		if game[p][item] and game[p][item].stack_size then return game[p][item].stack_size end
	end
end

local get_ore_stack = function(game, item)
	return
end
local not_already_compressed=function(recipe)
	local str={"compact","nanite","quantum","singularity"}
	for _,com in pairs(str) do
		if string.find(recipe,com) then return false end
	end
	return true
end


script.on_event("decompress-stack", function(event)
	local player = game.players[event.player_index]
	if player.force.technologies["compression-hand"].researched == true then
		if player.cursor_stack and player.cursor_stack.valid_for_read then
			local item = player.cursor_stack 
			if start_with(item.name,"compressed-") then
				local n = string.sub(item.name,string.len("compressed-")+1,string.len(item.name))
				local decompressed = n
				if player.can_insert(decompressed) then
					if item.count > 1 then
						item.count=item.count-1
					else
						item.clear()
					end
					player.insert(decompressed)
				end
			end
		end
	end
end)


script.on_event(defines.events.on_research_finished, function(event)
	local tech = event.research
	--[[if end_with(tech.name,"omnipressed") then
		tech.force.technologies[string.sub(tech.name,1,string.len(tech.name)-12)].researched = true
	elseif tech.force.technologies[tech.name.."-omnipressed"] then
		tech.force.technologies[tech.name.."-omnipressed"].researched = true
	end
	if tech.name == "compression-recipes" then
		for _,r in pairs(tech.force.recipes) do
			if r.enabled and tech.force.recipes[r.name.."-compression"] then
				tech.force.recipes[r.name.."-compression"].enabled = true
			end
		end
	end]]
	for _,kind in pairs({"compact","nanite","quantum","singularity"}) do
		if tech.name == "compression-"..kind.."-buildings" then
			for _,r in pairs(tech.force.recipes) do
				if r.enabled and not_already_compressed(r.name) and tech.force.recipes[r.name.."-compressed-"..kind] then
					tech.force.recipes[r.name.."-compressed-"..kind].enabled = true
				end
			end
		elseif tech.force.technologies["compression-"..kind.."-buildings"].researched then
			for _,eff in pairs(tech.effects) do
				if eff.type == "unlock-recipe" and not_already_compressed(eff.recipe) and tech.force.recipes[eff.recipe.."-compressed-"..kind] then
					tech.force.recipes[eff.recipe.."-compressed-"..kind].enabled = true
				end
			end
		end
	end
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)

end)

local round = function(nr)
	local dec = nr-math.floor(nr)
	if dec >= 0.5 then
		return math.floor(nr)+1
	else
		return math.floor(nr)
	end
end

script.on_event(defines.events.on_player_selected_area, function(event)
	if event.item == "compression-planner" then
		local player = game.players[event.player_index]
		local surface = player.surface
		local miscount = 0
		local resource = ""
		for _,entity in pairs(event.entities) do
			if entity.type == "resource" and game.entity_prototypes[entity.name].resource_category == "basic-solid" and entity.name ~= "stone" and not start_with(entity.name,"compressed") then
				local results = entity.prototype.mineable_properties.products 
				
				local size = 0
				for _, res in pairs(results) do
					if game.item_prototypes["compressed-"..res.name] then
						size = size + game.item_prototypes[res.name].stack_size
						resource=res.name
					end
				end
				size=size/#results
				
				local quant = entity.amount
				if entity.initial_amount == nil then
					quant = round((entity.amount+miscount)/size)
					miscount = math.floor((entity.amount+miscount)-quant*size)
				else
					quant = quant/50
				end
				local extra = entity
				local surf = extra.surface
				local pos = extra.position
				local force = extra.force
				local name = extra.name
				extra.destroy()
							
				if quant > 0 then
					surf.create_entity({name = "compressed-"..name.."-ore" , position = pos, force = force, amount = quant})
				end
			else
			end
		end
		if miscount > 0 then
			player.insert({name = resource, count = miscount})
		end
	end
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
	if event.item == "compression-planner" then
		local player = game.players[event.player_index]
		local surface = player.surface
		local miscount = 0
		local resource = ""
		for _,entity in pairs(event.entities) do
			if entity.type == "resource" and game.entity_prototypes[entity.name].resource_category == "basic-solid"  then
				--entity.amount = entity.amount+50
			end
		end
	end
end)

