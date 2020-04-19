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
				if not string.find(rec.name,"compression") and rec.enabled then
					local compressCheck = rec.name.."-compression"
					if string.find(rec.name,"omniperm") then
						local b=string.find(rec.name,"omniperm")
						compressCheck=string.sub(rec.name,1,b-1).."compression-"..string.sub(rec.name,b,-1)
					end
					if force.recipes[compressCheck] then
						force.recipes[compressCheck].enabled = true
						local z=1
						while force.recipes[rec.name.."-compression-grade-"..z] do
							force.recipes[rec.name.."-compression-grade-"..z].enabled=true
							z=z+1
						end
					end
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
		log("sorting all omnitech recipes")
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
							name = string.sub(rec.name,1,s-2)
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
		local compressedSuffixes = {"","-compression"}
		log("updating buildings to the latest recipe they can carry")
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
												for _,comp in pairs(compressedSuffixes) do
													if rec.name == name..ord[i]..comp..suf and force.recipes[name..recipe.level..comp..sufTarget] and (suf==sufTarget or not force.recipes[name..recipe.level..comp..suf]) then
														entity.set_recipe(name..recipe.level..comp..suf)
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
			end
			for name,recipe in pairs(c) do
				for i=1,recipe.level-1 do
					for _,suf in pairs(recipe.suffixes) do
						if force.recipes[name..ord[i]..suf] and force.recipes[name..ord[i]..suf].enabled then
							force.recipes[name..ord[i]..suf].enabled = false
							if force.recipes[name..ord[i].."-compression"..suf] then
								force.recipes[name..ord[i].."-compression"..suf].enabled = false
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
	if event.player_index then
		local player = game.players[event.player_index]
		if event.message=="omnidate" then
		omni_update(game)
		end
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
	for name,entity in pairs(game.entity_prototypes) do
		if entity.crafting_categories and not string.find(name,"character") then
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

local recipeDeficiet = {}
script.on_event(defines.events.on_tick, function(event)
	if global.omni.need_update then
		omni_update(game)
		acquireData(game)
		global.omni.need_update=false
	end
end)

script.on_nth_tick(30,function(conf)
	if #recipeDeficiet>0 then
		local count = 0
		local blank = 1
		while count < 10 and blank < 50 and #recipeDeficiet > 0 do
			local entity = recipeDeficiet[count+blank].entity
			local entityInventory=entity.get_inventory(defines.inventory.assembling_machine_input)
			local ingredients = recipeDeficiet[count+blank].ingredients
			local success = false
			for k,ing in pairs(ingredients.inventory) do
				for i=ing.amount,1,-2 do
					local stack = {name=ing.name,count=i}
					if entityInventory.can_insert(stack) then
						entity.insert(stack)
						success = true
						ing.amount=ing.amount-i
						if ing.amount == 0 then
							table.remove(ingredients.inventory,k)
						end
						break
					end
				end
			end
			if #ingredients.inventory==0 then
				table.remove(recipeDeficiet,count+blank)
				blank=blank-1
			end
			if success then
				count= count+1
			else
				blank=blank+1
			end
			if not recipeDeficiet[count+blank] then
				blank = 1
			end
		end
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	if not initilizing then
		local tech = event.research
		if tech.force.technologies["compression-recipes"] and tech.force.technologies["compression-recipes"].researched then
			for _, eff in pairs(tech.effects) do
				local compressCheck
				if eff.type=="unlock-recipe" then
					compressCheck = eff.recipe.."-compression"
					if string.find(eff.recipe,"omniperm") then
						local b=string.find(eff.recipe,"omniperm")
						compressCheck=string.sub(eff.recipe,1,b-1).."compression-"..string.sub(eff.recipe,b,-1)
					end
					if tech.force.recipes[compressCheck] then
						tech.force.recipes[compressCheck].enabled=true
						local z=1
						while tech.force.recipes[eff.recipe.."-compression-grade-"..z] do
							tech.force.recipes[eff.recipe.."-compression-grade-"..z].enabled=true
							z=z+1
						end
					end
				end
			end
		end
		if tech.name == "compression-recipes" then
			for _,r in pairs(tech.force.recipes) do
				--omnirec-omnic-acid-a-omniperm-1-1
				--omnirec-omnic-acid-a-compression-omniperm-1-1
				local compressCheck = r.name.."-compression"
				if string.find(r.name,"omniperm") then
					local b=string.find(r.name,"omniperm")
					compressCheck=string.sub(r.name,1,b-1).."compression-"..string.sub(r.name,b,-1)
				end
				if r.enabled and tech.force.recipes[compressCheck] then
					tech.force.recipes[compressCheck].enabled = true
					local z=1
					while tech.force.recipes[r.name.."-compression-grade-"..z] do
						tech.force.recipes[r.name.."-compression-grade-"..z].enabled=true
						z=z+1
					end
				end
			end
		elseif start_with(tech.name,"omnitech") and not end_with(tech.name,"omnipressed") then
			local tech_recs = {}
			local omniperm={}
			local tDif = 0

			local catRec = {}

			local work_name = tech.name
			if end_with(tech.name,"omnipressed") then
				work_name=string.sub(tech.name,1,string.len(tech.name)-12)
			end

			local niva = 0
			if string.sub(tech.name,string.len(tech.name)-1,string.len(tech.name)-1)=="-" then
				niva=tonumber(string.sub(tech.name,string.len(tech.name),string.len(tech.name)))
			else
				niva=tonumber(string.sub(tech.name,string.len(tech.name)-1,string.len(tech.name)))
			end

			local tprefix = string.sub(work_name,1,string.len(tech.name)-string.len(tostring(niva)))
			for i=1,niva do
				for _, eff in pairs(tech.force.technologies[tprefix..i].effects) do
					if eff.type=="unlock-recipe" and start_with(eff.recipe,"omnirec") then
						local category = game.recipe_prototypes[eff.recipe].category
						if not catRec[category] then catRec[category] = {} end
						local prefix = string.sub(eff.recipe,1,string.len(eff.recipe)-1)
						local suffixes = {""}
						local suffix = nil
						if string.find(eff.recipe,"omniperm") then
							local s,e = string.find(eff.recipe,"omniperm")
							prefix = string.sub(eff.recipe,1,s-3)
							suffix = "-omniperm-"..string.sub(eff.recipe,e+2,string.len(eff.recipe))
						end
						local grade = invOrd(string.sub(eff.recipe,string.len(prefix)+1,string.len(prefix)+1))
						if not catRec[category][prefix] then catRec[category][prefix]={level=grade,suffixes = suffixes} end
						if grade and catRec[category][prefix].level and grade > catRec[category][prefix].level then catRec[category][prefix].level = grade end
						if not inTable(suffix,catRec[category][prefix].suffixes) then table.insert(catRec[category][prefix].suffixes,suffix) end
					end
				end
			end
			local compressionSuffix = {"","-compression"}
			for cname,c in pairs(catRec) do
				if global and global.omni and global.omni.cat and global.omni.cat[cname] then
					if settings.global["omnilib-autoupdate"].value == true then
						for _,kind in pairs(global.omni.cat[cname].buildings) do
							for _,surface in pairs(game.surfaces) do
								for _,entity in pairs(surface.find_entities_filtered{force=event.research.force, name=kind}) do
									log(kind)
									local rec = entity.get_recipe()
									if rec then
										local ingredients = {inventory={},fluidbox={}}
										if entity.is_crafting() then
											for _,ing in pairs(rec.ingredients) do
												if ing.type=="fluid" then
													table.insert(ingredients.fluidbox,ing)
												else
													table.insert(ingredients.inventory,ing)
												end
											end
											--[[table.insert(recipeDeficiet,{
												entity=entity,
												ingredients = ingredients
											})]]
										end
										for prefix,recipe in pairs(c) do
											if recipe.level > 1 then
												for _,suffix in pairs(recipe.suffixes) do
													for _,comp in pairs(compressionSuffix) do
														if rec.name == prefix..ord[recipe.level-1]..comp..suffix then
															for _, sufTarget in pairs(recipe.suffixes) do
																if tech.force.recipes[prefix..ord[recipe.level]..comp..sufTarget] and (suffix==sufTarget or not tech.force.recipes[prefix..ord[recipe.level]..comp..suffix]) then
																	entity.set_recipe(prefix..ord[recipe.level]..comp..sufTarget)
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
						end
					end
					for prefix,recipe in pairs(c) do
						if recipe.level then
							for i=1,recipe.level-1 do
								for _,suffix in pairs(recipe.suffixes) do
									for _,comp in pairs(compressionSuffix) do
										if tech.force.recipes[prefix..ord[i]..comp..suffix] then
											tech.force.recipes[prefix..ord[i]..comp..suffix].enabled = false
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
end)


script.on_event(defines.events.on_player_created, function(event)
game.players[event.player_index].print{"message.omni-difficulty"}
end)
