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

local function compression_planner(event, log_only)
	if event.item == "compression-planner" then
		local player = game.players[event.player_index]
		local surface = player.surface
		local entities = game.entity_prototypes
		local items = game.item_prototypes
		local remainder = 0
		for _, entity in pairs(event.entities) do
			if entity.valid and
			entity.type == "resource" and
			#entity.prototype.mineable_properties.products > 0 and
			not (
				entity.name:find("^compressed")
				or entity.name:find("^concentrated")
			)
			then
				local results = entity.prototype.mineable_properties.products
				local result = results[1]
				local size
				-- For later
				local ent = {
					position = entity.position,
					force = entity.force
				}

				local min, max, amount = entity.initial_amount, results.amount_max or 1, entity.amount
				-- if initial amount, =(min*max)/min/100, else entity.amount
				local output_amount = (min and (min * max) or entity.amount) / (min and 100 or 1)
				if result.type == "item" and entities["compressed-resource-"..entity.name] then
					size = items[result.name].stack_size
					ent.name = "compressed-resource-" .. entity.name
					if not min then
						output_amount = output_amount + remainder -- Add our previous remainder
						remainder = 1 - output_amount % 1 -- New remainder
					end
				elseif result.type == "fluid" and entities["concentrated-resource-"..entity.name] then
					size = 50
					ent.name = "concentrated-resource-" .. entity.name
				end

				if size then
					-- Do our final division
					output_amount = output_amount / size
					-- Ceil our actual output
					output_amount = math.ceil(output_amount)
					-- Apply to infinite or non-infinite respectively
					ent.initial_amount = min and output_amount
					ent.amount = amount and output_amount
					if not log_only then-- Actually do the thing
						entity.destroy()
						surface.create_entity(ent)
					else
						player.print(string.format(
							"[img=entity.%s](%d)->[img=entity.%s](%d).",
							result.name,
							amount,
							ent.name,
							ent.amount or ent.initial_amount
						))
					end
				end
			end
		end
	end
end

script.on_event(defines.events.on_player_selected_area, compression_planner)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
	compression_planner(event, true)
end)

