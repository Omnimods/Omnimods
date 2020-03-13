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
local initilizing = false
function omni_update(game)
	initilizing = true
	log("running through omnidate")
	for _, force in pairs(game.forces) do
		log("researching compressed techs where the standard is done.")
		for _,tech in pairs(force.technologies) do
			if not end_with(tech.name,"omnipressed") and tech.force.technologies[tech.name.."-omnipressed"] then
				tech.force.technologies[tech.name.."-omnipressed"].researched = tech.researched
			end
		end
		if force.technologies["compression-recipes"] and force.technologies["compression-recipes"].researched then
			log("enabling compressed recipes of researched techs")
			for _, rec in pairs(force.recipes) do
				if not end_with(rec.name,"-compression") and rec.enabled and force.recipes[rec.name.."-compression"] then
					force.recipes[rec.name.."-compression"].enabled = true
				end
			end
		elseif force.technologies["compression-recipes"] then
			log("disabling compressed recipes cause it is not researched")
			for _, rec in pairs(force.recipes) do
				if end_with(rec.name,"-compression") and rec.enabled and force.recipes[rec.name] then
					force.recipes[rec.name].enabled = false
				end
			end
		end
		local catrec = {}
		for _, tech in pairs(force.technologies) do
			if start_with(tech.name,"omnitech") and tech.researched then
				local tech_level = tonumber(string.sub(tech.name,string.len(tech.name)-1,string.len(tech.name)-1)) or tonumber(string.sub(tech.name,string.len(tech.name)-string.len("-omnipressed")-1,string.len(tech.name)-string.len("-omnipressed")-1))
				for _, eff in pairs(tech.effects) do
					if eff.type=="unlock-recipe" and start_with(eff.recipe,"omnirec") then
						local rec = force.recipes[eff.recipe]
						if not catrec[rec.category] then
							catrec[rec.category] = {}
						end
						
						local grade = 0
						local name = eff.recipe
						local suffix = ""
						if string.find(eff.recipe,"omniperm") then
							local s,e = string.find(rec.name,"omniperm")
							name = string.sub(rec.name,1,s-1)
							suffix = string.sub(rec.name,e+2,string.len(rec.name))
						end
						local prefix = string.sub(name,1,string.len(name)-1)
						grade = invOrd(string.sub(name,string.len(name),string.len(name)))
						
						
						if not catrec[rec.category][prefix] then
							catrec[rec.category][prefix] = {level = grade,suffixes = {""}}
						elseif grade > catrec[rec.category][prefix].level then
							catrec[rec.category][prefix].level = grade
						end
						if suffix ~= "" and not inTable(suffix,catrec[rec.category][prefix].suffixes) then
							table.insert(catrec[rec.category][prefix].suffixes,"-omniperm-"..suffix)
						end
					end
				end
			end
		end
		for cat,c in pairs(catrec) do
			for _, kind in pairs(global.omni.cat[cat].buildings) do
				for _,surface in pairs(game.surfaces) do
					for _,entity in pairs(surface.find_entities_filtered{force=force, name=kind}) do
						for name,recipe in pairs(c) do
							for i=1,recipe.level-1 do
								for _, suf in pairs(recipe.suffixes) do
									if force.recipes[name..ord[i]..suf] then
										local rec = entity.get_recipe()
										if rec then
											for _, sufTarget in pairs(recipe.suffixes) do
												if rec.name == name..ord[i]..suf and force.recipes[name..recipe.level..sufTarget] then
													entity.set_recipe(name..ord[i]..suf)
													break
												elseif rec.name == name..ord[i]..suf.."-compression" and force.recipes[name..recipe.level..sufTarget.."-compression"] then
													entity.set_recipe(name..ord[i]..suf.."-compression")
													break
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			for name,recipe in pairs(c) do
				for i=1,recipe.level-1 do
					for _,suf in pairs(recipe.suffixes) do
						if force.recipes[name..ord[i]..suf] and force.recipes[name..ord[i]..suf].enabled then
							force.recipes[name..ord[i]..suf].enabled = false
							if force.recipes[name..ord[i]..suf.."-compression"] then
								force.recipes[name..ord[i]..suf.."-compression"].enabled = false
							end
						end
					end
				end
			end
		end
		log("adding compressed buildings")
		for _,kind in pairs({"compact","nanite","quantum","singularity"}) do
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
	log("omnidate completed")
	initilizing=false
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
	if not initilizing then
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
			if end_with(tech.name,"omnipressed") then
				work_name=string.sub(tech.name,1,string.len(tech.name)-12)
			end
			local length = string.len(work_name)
			local lvl = 0
			if string.sub(work_name,length-1,length-1) == "-" then
				lvl = tonumber(string.sub(work_name,length,length))
			else
				lvl = tonumber(string.sub(work_name,length-1,length))
			end
			if lvl and tDif then tDif=tDif-lvl end
			
			local subTechRecs = {}
			for i=1,tDif  do
				subTechRecs[i]={}
				for _,r in pairs(tech_recs) do
					local j=1
					local k=1
					while game.recipe_prototypes[r..ord[i].."-omniperm-"..j.."-"..k] do
						k=1
						permuted=true
						while game.recipe_prototypes[r..ord[i].."-omniperm-"..j.."-"..k] do
							subTechRecs[i][#subTechRecs[i]+1]=r..ord[i].."-omniperm-"..j.."-"..k
							k=k+1
						end
						j=j+1
					end
					if game.recipe_prototypes[r..ord[i]] then subTechRecs[i][#subTechRecs[i]+1]=r..ord[i] end
				end
			end
			
			work_name=string.sub(work_name,1,string.len(work_name)-string.len(tostring(lvl)))
			for i=1,lvl-1 do
				subTechRecs[i+tDif]={}
				for _,eff in pairs(game.technology_prototypes[work_name..i].effects) do
					if string.find(eff.recipe,"omnirec") then
						subTechRecs[i][#subTechRecs[i]+1]=eff.recipe
					end
				end
			end
			local targetRec={}
			if lvl > 1 then
				for _, r in pairs(subTechRecs[#subTechRecs]) do
					if string.find(r,"omniperm") then
						local s,e = string.find(r,"omniperm")
						local name = string.sub(r,1,s-2)
						local permutation = string.sub(r,e+2,string.len(r))
						local check = string.sub(name,1,string.len(name)-1)..ord[1+invOrd(string.sub(name,string.len(name),string.len(name)))].."-omniperm-"..permutation
						if game.recipe_prototypes[check] then
							targetRec[r]=check
						else
							check = string.sub(name,1,string.len(name)-1)..ord[1+invOrd(string.sub(name,string.len(name),string.len(name)))]
						end
					else
						targetRec[r]=string.sub(r,1,string.len(r)-1)..ord[1+invOrd(string.sub(r,string.len(r),string.len(r)))]
					end
				end
			end
			local suffix = {"","-compressed"}
			log(serpent.block(targetRec))
			for name,target in pairs(targetRec) do
				for _,s in pairs(suffix) do
					if global and global.omni and global.omni.cat and game.recipe_prototypes[name] and global.omni.cat[game.recipe_prototypes[name].category..s] then
						for _,b in pairs(global.omni.cat[game.recipe_prototypes[name].category..s].buildings) do
							for _,surface in pairs(game.surfaces) do
								for _,entity in pairs(surface.find_entities_filtered{force=event.research.force, name=b}) do
									if rec and rec.name == name then
										entity.set_recipe(target)
									elseif rec and rec.name == name.."-compression" then
										entity.set_recipe(target.."-compression")
									end
								end
							end
						end
					end
				end
			end
			for _,t in pairs(subTechRecs) do
				for _,r in pairs(t) do
					tech.force.recipes[r].enabled = false
					if tech.force.recipes[r.."-compression"] then
						tech.force.recipes[r.."-compression"].enabled = false
					end
				end
			end
		end
	end
end)

script.on_event(defines.events.on_player_created, function(event)
game.players[event.player_index].print{"message.omni-difficulty"}
end)