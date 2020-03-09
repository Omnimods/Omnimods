require("controlFunctions")

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

function omni_update(game)
for _, force in pairs(game.forces) do
		if force.technologies["compression-recipes"] and force.technologies["compression-recipes"].researched then
			for _, rec in pairs(force.recipes) do
				if not end_with(rec.name,"-compression") and rec.enabled and force.recipes[rec.name.."-compression"] then
					force.recipes[rec.name.."-compression"].enabled = true
				end
			end
		else
			for _, rec in pairs(force.recipes) do
				if end_with(rec.name,"-compression") and rec.enabled and force.recipes[rec.name] then
					force.recipes[rec.name].enabled = false
				end
			end
		end
		local techrec = {}
		for _, tech in pairs(force.technologies) do
			if start_with(tech.name,"omnitech") and tech.researched then
				local work_name = tech.name
				if end_with(tech.name,"omnipressed") then
					work_name=string.sub(tech.name,1,string.len(tech.name)-12)
				end
				local level = 1
				local name = ""
				if string.sub(work_name,string.len(work_name)-1,string.len(work_name)-1)=="-" then
					level = tonumber(string.sub(work_name,string.len(work_name),string.len(work_name)))
					name = string.sub(work_name,1,string.len(work_name)-1)
				else
					level = tonumber(string.sub(tech.name,string.len(tech.name)-1,string.len(tech.name)))
					name = string.sub(work_name,1,string.len(work_name)-2)
				end
				for _, eff in pairs(tech.effects) do
					if eff.type=="unlock-recipe" and start_with(eff.recipe,"omnirec") then
						if techrec[name] == nil then
							techrec[name]={level=level, recipes={}}
						end
						if techrec[name].recipes[tostring(level)] == nil then
							techrec[name].recipes[tostring(level)] = {eff.recipe}
						else
							table.insert(techrec[name].recipes[tostring(level)],eff.recipe)
						end
					end
				end
				if level and level > techrec[name].level then techrec[name].level=level end
			end
		end
		for j,t in pairs(techrec) do
			for i=1,t.level-1 do
				if t.recipes[tostring(i)] then
				for _,r in pairs(t.recipes[tostring(i)]) do
					force.recipes[r].enabled=false
					if force.recipes[r.."-compression"] then force.recipes[r.."-compression"].enabled=false end
					for _, b in pairs(global.omni.cat[game.recipe_prototypes[r].category].buildings) do
						for _,surface in pairs(game.surfaces) do
							for _,entity in pairs(surface.find_entities_filtered{force=force, name=b}) do
								local rec = entity.get_recipe()
								if rec and rec.name == r then
									local name = string.sub(r,1,string.len(r)-1)
									entity.set_recipe(name..ord[t.level])
								elseif rec and rec.name == r.."-compression" then
									local name = string.sub(r,1,string.len(r)-1)
									entity.set_recipe(name..ord[t.level].."-compression")
								end
							end
						end
					end
				end
				end
			end
		end
	end
	for _,kind in pairs({"compact","nanite","quantum","singularity"}) do
		for each, force in pairs(game.forces) do
			if force.technologies["compression-"..kind.."-buildings"] and force.technologies["compression-"..kind.."-buildings"].researched then
				for _,t in pairs(force.technologies) do
					if t.researched then
						for _,eff in pairs(t.effects) do
							if eff.type == "unlock-recipe" and force.recipes[eff.recipe.."-compressed-"..kind] then
								force.recipes[eff.recipe.."-compressed-"..kind].enabled = true
							end
						end
					end
				end
			end
		end
	end
	for _,force in pairs(game.forces) do
		for _,tech in pairs(force.technologies) do
			if not end_with(tech.name,"omnipressed") and tech.force.technologies[tech.name.."-omnipressed"] then
				tech.force.technologies[tech.name.."-omnipressed"].researched = tech.researched
			end
		end
	end
end

script.on_event(defines.events.on_console_chat, function(event)
	local player = game.players[event.player_index]
	if event.message=="omnidate" then
		omni_update(game)
	end

end)

local omni_cat={}

function acquireData(game)
	local perm = {}
	for _, rec in pairs(game.recipe_prototypes) do
		if not omni_cat[rec.category] then
			omni_cat[rec.category]={name=rec.category,buildings={}}
		end
		if string.find(rec.name,"omniperm") then
			local s,e = string.find(rec.name,"omniperm")
			local v = split(string.sub(rec.name,e+2,string.len(rec.name)),"-")
			local name = string.sub(rec.name,1,s-2)
			if not perm[name] then perm[name]={ingredient=1,result=1} end
			if tonumber(v[1])>perm[name].ingredient then perm[name].ingredient = tonumber(v[1]) end
			if tonumber(v[2])>perm[name].result then perm[name].result = tonumber(v[2]) end
		end
	end
	for _,entity in pairs(game.entity_prototypes) do
		if entity.crafting_categories then
			for i, c in pairs(entity.crafting_categories) do
				if omni_cat[i] then
					table.insert(omni_cat[i].buildings,entity.name)
				end
			end
		end
	end
	global.omni.cat=omni_cat
	global.omni.perm=perm
end
script.on_configuration_changed( function(conf)
	if not global.omni then global.omni={} end
	acquireData(game)
	global.omni.need_update=true
end)

script.on_init( function(conf)
	global.omni = {}
	acquireData(game)
	global.omni.need_update=false
end)
script.on_event(defines.events.on_tick, function(event)
	if global.omni.need_update then
		omni_update(game)
		acquireData(game)
		global.omni.need_update=false
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	local tech = event.research
	if tech.force.technologies["compression-recipes"] and tech.force.technologies["compression-recipes"].researched then
		for _, eff in pairs(tech.effects) do
			if eff.type=="unlock-recipe" and tech.force.recipes[eff.recipe.."-compression"] then
				tech.force.recipes[eff.recipe.."-compression"].enabled=true
			end
		end
	end
	if tech.name == "compression-recipes" then
		for _,r in pairs(tech.force.recipes) do
			if r.enabled and tech.force.recipes[r.name.."-compression"] then
				tech.force.recipes[r.name.."-compression"].enabled = true
			end
		end
	elseif start_with(tech.name,"omnitech") then
		local cat = {}
		local tech_recs = {}
		local omniperm={}
		local tDif = 0
		for _, eff in pairs(tech.effects) do
			if eff.type=="unlock-recipe" and start_with(eff.recipe,"omnirec") then
				cat[game.recipe_prototypes[eff.recipe].category] = true
				if not string.find(eff.recipe,"omniperm") then
					tech_recs[#tech_recs+1]=string.sub(eff.recipe,1,string.len(eff.recipe)-1)
					tDif = invOrd(string.sub(eff.recipe,string.len(eff.recipe),string.len(eff.recipe)))
					omniperm[tech_recs[#tech_recs]]={""}
				else
					local s,e = string.find(eff.recipe,"omniperm")
					local name = string.sub(eff.recipe,1,s-2)
					tech_recs[#tech_recs+1]=string.sub(name,1,string.len(name)-1)
					tDif = invOrd(string.sub(name,string.len(name),string.len(name)))
					if not omniperm[tech_recs[#tech_recs]] then omniperm[tech_recs[#tech_recs]] = {} end
					omniperm[tech_recs[#tech_recs]][#omniperm[tech_recs[#tech_recs]]+1]="-omniperm-"..string.sub(eff.recipe,e+2,string.len(eff.recipe))
				end
			end
		end
		
		local work_name = tech.name
		if end_with(tech.name,"omnipression") then
			work_name=string.sub(tech.name,1,string.len(tech.name)-12)
		end
		local length = string.len(tech.name)
		local lvl = 0
		if string.sub(work_name,length-1,length-1) == "-" then
			lvl = tonumber(string.sub(work_name,length,length))
		else
			lvl = tonumber(string.sub(work_name,length-1,length))
		end
		if lvl and tDif then tDif=tDif-lvl end
		
		local suffix = {"","-compressed"}
		--log(serpent.block(tech.effects))
		--log(serpent.block(omniperm))
		
		--Fix so it adjusts to the final one where fluids may no longer exist for omnipermutate
		
		if lvl and ((tDif and lvl+tDif > 1) or lvl > 1) then
			for _,r in pairs(tech_recs) do
				for _,s in pairs(suffix) do
					for _,perm in pairs(omniperm[r]) do
						if global and global.omni and global.omni.cat and game.recipe_prototypes[r..ord[lvl+tDif]..perm] and global.omni.cat[game.recipe_prototypes[r..ord[lvl+tDif]..perm].category..s] then
							for _,b in pairs(global.omni.cat[game.recipe_prototypes[r..ord[lvl+tDif]..perm].category..s].buildings) do
								for _,surface in pairs(game.surfaces) do
									for _,entity in pairs(surface.find_entities_filtered{force=event.research.force, name=b}) do
										local rec = entity.get_recipe()
										if rec and rec.name == r..ord[lvl+tDif-1]..perm then
											entity.set_recipe(r..ord[lvl+tDif]..perm)
										elseif rec and rec.name == r..ord[lvl+tDif-1]..perm.."-compression" then
											entity.set_recipe(r..ord[lvl+tDif]..perm.."-compression")
										end
									end
								end
							end
						end
					end
				end
			end
			for i=1,lvl+tDif-1 do
				for _,r in pairs(tech_recs) do
					for _,perm in pairs(omniperm[r]) do
						tech.force.recipes[r..ord[i]..perm].enabled = false
						if tech.force.recipes[r..ord[i]..perm.."-compression"] then
							tech.force.recipes[r..ord[i]..perm.."-compression"].enabled = false
						end
					end
				end				
			end
		end
	end
end)

script.on_event(defines.events.on_player_created, function(event)
game.players[event.player_index].print{"message.omni-difficulty"}
end)