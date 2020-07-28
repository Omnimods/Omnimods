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
local tiers = {"compact","nanite","quantum","singularity"}
local items_per_tier = settings.startup["omnicompression-multiplier"] and settings.startup["omnicompression-multiplier"].value or 4
local not_already_compressed=function(recipe)
	for _, tier in pairs(tiers) do
		if string.find(recipe, tier) then
			return false
		end
	end
	return true
end

local function find_tier(class_name)
	for index, tier in pairs(tiers) do
		if class_name:find(tier .. "$") then -- Only look at end
			return index, tier
		end
	end
end

local function flying_text(entity, say_string)
	entity.surface.create_entity{
		name = "tutorial-flying-text",
		position = entity.position,
		text = say_string
	}
end

script.on_event("decompress-stack", function(event)
	local player = game.players[event.player_index]
	if player.force.technologies["compression-hand"].researched == true then
		if player.cursor_stack and player.cursor_stack.valid_for_read then
			local item = player.cursor_stack 
			if item.name:find("^compressed%-") then
				local decompressed = item.name:gsub("^compressed%-", "")
				if player.can_insert(decompressed) then
					flying_text(player, "+[img=item."..decompressed.."]")
					--flying_text(player, "-[img=item."..item.name.."]")
					if item.count > 1 then
						item.count=item.count-1
					else
						item.clear()
					end
					player.insert({
						name = decompressed
					})-- Defaults to a stack?
					return -- Don't bother continuing
				end
			end
			local tier_num, tier_name = find_tier(item.name)
			if tier_num and tiers[tier_num-1] then-- Remove tier, repl with previous tier
				local decompressed = item.name:gsub(tier_name .. "$", tiers[tier_num-1])
				if player.can_insert(decompressed) then
					flying_text(player, "+[img=item."..decompressed.."]")
					--flying_text(player, "-[img=item."..item.name.."]")
					if item.count > 1 then
						item.count=item.count-1
					else
						item.clear()
					end
					player.insert({
						name = decompressed,
						count = items_per_tier
					})-- Defaults to a stack?
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
		local result_table = {}
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
				-- Store the relevant entity properties, we'll add to this table as we calculate
				local ent = {
					position = entity.position,
					force = entity.force
				}
				local size
				local min, max, amount = entity.initial_amount, results.amount_max or 1, entity.amount
				-- if initial amount, =(min*max)/min/100, else entity.amount
				local output_amount
				if min then
					output_amount = (min * max) / 100 -- Infinites are divided by 100
				else
					output_amount = amount -- Otherwise we just give ore contents
				end
				if result.type == "item" and entities["compressed-resource-"..entity.name] then
					size = items[result.name].stack_size
					ent.name = "compressed-resource-" .. entity.name
				elseif result.type == "fluid" and entities["concentrated-resource-"..entity.name] then
					size = 50
					ent.name = "concentrated-resource-" .. entity.name
				end

				if size then -- We have valid output, continue
					-- Do our final division
					output_amount = output_amount / size
					if not min and result.type == "item" then -- If not infinite, we'll add to our remainder.
						remainder = remainder + (output_amount % 1) -- New remainder, add what floor removes
						if remainder > 1 then -- We'll add if we're greater than 1
							output_amount = output_amount + 1
							remainder = remainder - 1
						end
					end
					-- Floor our actual output
					output_amount = math.floor(output_amount)
					-- Apply to infinite or non-infinite respectively
					ent.initial_amount = min and output_amount
					ent.amount = amount and output_amount
					if amount >= 1 then
						if not log_only then-- Actually do the thing
							entity.destroy()
							surface.create_entity(ent)
						else -- Or don't do the thing
							result_table[result.name] = result_table[result.name] or {}
							-- Alias and store
							local res_table = result_table[result.name]
							res_table.source_amount = (res_table.source_amount or 0) + (entity.amount or entity.initial_amount)
							res_table.dest_name = (
								result.type == "item" and "compressed-" .. result.name or
								"concentrated-" .. result.name
							)
							res_table.dest_amount = (res_table.dest_amount or 0) + (ent.amount or ent.initial_amount)
							res_table.type = result.type
						end
					end
				end
			end
		end
		if log_only then
			for source_name, properties in pairs(result_table) do
				if properties.dest_amount >= 1 then
					player.print(string.format(
						"[img=entity.%s](%d)->[img=%s.%s](%d), ratio is %d:1.",
						source_name,
						properties.source_amount,
						properties.type,
						properties.dest_name,
						properties.dest_amount,
						math.floor(properties.source_amount/properties.dest_amount+0.5)--Equiv to rounding
					))
				end
			end
		end
	end
end

script.on_event(defines.events.on_player_selected_area, compression_planner)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
	compression_planner(event, true)
end)

