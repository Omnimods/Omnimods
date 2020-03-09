	
local ord={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r"}
local chem_buildings={{"omni","plant"}}

function strsplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

local start_with = function(a,b)
	return string.sub(a,1,string.len(b)) == b
end
local start_within_table = function(a,b)
	return string.sub(a,1,string.len(b)) == b
end

local omni = {tech = {},rec={}}




script.on_event(defines.events.on_player_joined_game, function(event)

end)

local string_contained_list = function(str, list)
	for i=1, #list do
		if type(list[i])=="table" then
			local found_it = true
			for _,words in pairs(list[i]) do
				found_it = found_it and string.find(str,words)
			end
			if found_it then return true end
		else
			if string.find(str,list[i]) then return true end
		end
	end
	return false
end

local cate={}

script.on_configuration_changed( function(conf)
	
	local material_level = {}
	for each, force in pairs(game.forces) do
		for _, tech in pairs(force.technologies) do
			if tech.researched then
				
			end
		end
	end
end)

script.on_init( function(conf)
	for _, rec in pairs(game.recipe_prototypes) do
		if not cate[rec.category] then
			cate[rec.category]={name=rec.category}
		end
	end
	for _,entity in pairs(game.entity_prototypes) do
		
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	local tech = event.research
	if start_with(tech.name,"omni") and string.find(tech.name,"tech") then
		local cat = {}
		local tech_recs = {}
		for _, eff in pairs(tech.effects) do
			if eff.type=="unlock-recipe" then
				cat[game.recipe_prototypes[eff.recipe].category] = true
				tech_recs[#tech_recs+1]=string.sub(eff.recipe,1,string.len(eff.recipe)-1)
			end
		end
		local buildings={}
		for _,entity in pairs(game.entity_prototypes) do
			if entity.crafting_categories then
				for i, c in pairs(entity.crafting_categories) do
					if cat[i]==true then
						buildings[#buildings+1]=entity.name
						break
					end
				end
			end
		end
		local length = string.len(tech.name)
		local lvl = 0
		if string.sub(tech.name,length-1,length-1) == "-" then
			lvl = tonumber(string.sub(tech.name,length,length))
		else
			lvl = tonumber(string.sub(tech.name,length-1,length))
		end
		if lvl > 1 then
			for _,b in pairs(buildings) do
				for _,surface in pairs(game.surfaces) do
					for _,entity in pairs(surface.find_entities_filtered{force=event.research.force, name=b}) do
						local rec = entity.get_recipe()
						for _,r in pairs(tech_recs) do
							if rec and rec.name == r..ord[lvl-1] then
								entity.set_recipe(r..ord[lvl])
							end
						end
					end
				end
			end
			for i=1,lvl-1 do
				for _,r in pairs(tech_recs) do
					tech.force.recipes[r..ord[i]].enabled = false
				end				
			end
		end
	end
end)
