----------------------------------
-- set omni-pack exclusion list --
----------------------------------
omni.science.exclude_tech = {}
--add techs to omni-pack exclusion list (this is to simplify the below tech_post_find_update function)
local set_exclude = function()
  for _,tech in pairs(data.raw.technolgy) do
  -- if modules
    if string.find(tech.name,"module") or tech.name=="modules" then
      omni.science.exclude_tech[tech.name]=true
    end
    -- if alien science (gold pack)
    for _,ing in pairs(tech.unit.ingredients) do
      for _,sub_ing in pairs(ing) do
        if string.find(sub_ing, "science%-pack%-gold") then 
          omni.science.exclude_tech[tech.name]=true
        end
      end
    end
    -- if no pre-requisites
    if tech.prerequisites and #tech.prerequisites > 0 then
      omni.science.exclude_tech[tech.name]=true
    end
  end
end
---------------------------------------------------------------
-- Add omnipack to pre-requisites and tech if conditions met --
-- this is relatively slow as it will go through the whole tree
---------------------------------------------------------------
local contains_omnipack = {}
--===================================================================
-- SHOULD ADD A METATABLE FOR POSITIVES TO STOP DUPLICATE ANALYSING
-- use a method similar to to what was done with compressed tech
--===================================================================
-- add omnipack to all techs above chemical science pack, and set pre-req to pack tech if needed
function omni.science.tech_post_find_update()
  set_exclude()
	local post_find = true
	while post_find do
		post_find = false
    for _,tech in pairs(data.raw.technology) do
      --if has prerequisites and not excluded
      if not omni.lib.is_in_table(tech.name,omni.science.exclude_tech) then
        local techunits = {}
        for _,ing in pairs(tech.unit.ingredients) do
          techunits[#techunits+1]=ing[1]
        end
        if omni.lib.is_in_table("omni-pack",techunits) then
          contains_omnipack[req] = true
          post_find = true
        else --not omni.lib.is_in_table("omni-pack",techunits) --if no omnipack do prereq check
          for _,req in pairs(tech.prerequisites) do --check if prereq has pack
            if data.raw.technology[req] and contains_omnipack[req] == true then --shortcut for true, add pack
              post_find = true
              omni.lib.add_science_pack(tech.name)
            elseif data.raw.technology[req] and contains_omnipack[req] == false then --not in prebuilt table
              --nothing
            elseif data.raw.technology[req] then
              for _,ing in pairs(data.raw.technology[req].unit.ingredients) do
                requnits[#requnits+1]=ing[1]
              end
              if omni.lib.is_in_table("omni-pack",requnits)  then
                post_find = true
                omni.lib.add_science_pack(tech.name)
                contains_omnipack[req] = true
              else
                --set prereq as false
                contains_omnipack[req] = false
              end
            else
              log("the prerequisite "..req.." of "..tech.name.." does not exist")
            end
          end
          post_find = true --continue while loop
        end
        log(serpent.block(contains_omnipack))
      end
    end
  end
end

function omni.science.tech_updates()
	local tech_list = {}
	local check_techs = {}
	tech_list.name={}
	tech_list.cost={}
	tech_list.height={}
	--module
	--omni-impure
	local omni_excempt_list = {{"omniston","solvation"},{"omnic","hydrolyzation"},{"stone","omnisolvent"},"distillation",{"omni","sorting"},{"impure","omni"},{"water","omnitraction"},{"mud","omnitraction"}}
	omni_excempt_list[#omni_excempt_list+1]={"pseudoliquid","amorphous","crystal"}

	local labComponents = {}

	for _,lab in pairs(data.raw.lab) do
		if not string.find(lab.name,"creative") then
			for _, input in pairs(lab.inputs) do
				labComponents[input]=true
			end
		end
	end

	local hasLabIngredients = function(tech)
		for _,input in pairs(tech.unit.ingredients) do
			if not labComponents[input[1]] then return false end
		end
		return true
	end

	for _,tech in pairs(data.raw.technology) do
		if settings.startup["omniscience-standard-time"].value and omni.lib.end_with(tech.name,"-omnipressed") then
			tech.unit.time = settings.startup["omniscience-standard-time-constant"].value
		end
		if tech.unit.count then
			if settings.startup["omniscience-modify-omnimatter-costs"].value and omni.lib.start_with(tech.name,"omnitech") then
				check_techs[#check_techs+1]=tech.name
			elseif not omni.lib.start_with(tech.name,"omnitech") then
				check_techs[#check_techs+1]=tech.name
				----log(tech.name.." is being adapted")
			elseif not settings.startup["omniscience-modify-omnimatter-costs"].value and omni.lib.start_with(tech.name,"omnitech") then
				tech_list.name[#tech_list.name+1]=tech.name
				tech_list.cost[#tech_list.cost+1]=tech.unit.count
				tech_list.height[#tech_list.height+1]=0
			end
		end
	end

	for i,tech in pairs(check_techs) do
		if not data.raw.technology[tech].prerequisites or #data.raw.technology[tech].prerequisites==0 or not hasLabIngredients(data.raw.technology[tech]) then
			tech_list.name[#tech_list.name+1]=tech
			tech_list.cost[#tech_list.cost+1]=data.raw.technology[tech].unit.count
			tech_list.height[#tech_list.height+1]=1
			--table.insert(tech_list.name,tech.name)
			--table.insert(tech_list.cost,data.raw.technology[tech].unit.count)
		end
	end

	local tmp_list={}
	for i,tech in pairs(check_techs) do
		if not omni.lib.is_in_table(tech,tech_list.name) then
			tmp_list[#tmp_list+1]=tech
		end
	end
	check_techs=tmp_list

	local all_pre_in_table = function(tech)
		t=data.raw.technology[tech]
		for _,pre in pairs(t.prerequisites) do
			if not omni.lib.is_in_table(pre,tech_list.name) then return false end
		end
		return true
	end

	local omni_list = {"omni","distillation"}

	local get_cost = function(tech)
		for i,t in pairs(tech_list.name) do
			if tech == t then return tech_list.cost[i] end
		end
		return nil
	end

	local get_cost = function(tech)
		for i,t in pairs(tech_list.name) do
			if tech == t then return tech_list.cost[i] end
		end
		return nil
	end

	local get_height = function(tech)
		for i,t in pairs(tech_list.name) do
			if tech == t then return tech_list.height[i] end
		end
		return nil
	end

	local found = true
	while #check_techs>0 and found do
		found=false
		for i,tech in pairs(check_techs) do
			if all_pre_in_table(tech) and data.raw.technology[tech].unit.count then
				found = true
				table.insert(tech_list.name,tech)
				local cost = data.raw.technology[tech].unit.count
				if omni.lib.start_with(tech,"omnitech") then
					cost=cost*settings.startup["omniscience-cumulative-constant-omni"].value
				else
					cost=cost*settings.startup["omniscience-cumulative-constant"].value
				end
				local h = 0
				local add = 0
				for _,pre in pairs(data.raw.technology[tech].prerequisites) do
					if settings.startup["omniscience-rocket-modified-by-omni"].value or tech ~= "rocket-silo" then
						if not string.find(pre,"omnitech") then
							cost = cost+get_cost(pre)
						else
							add = math.max(add,get_cost(pre))
						end
						h = math.max(h,get_height(pre))
					elseif not string.find(pre,"omnitech") then
						cost = cost+get_cost(pre)
						h = math.max(h,get_height(pre))
					end
				end
				cost=cost+add*settings.startup["omniscience-omnitech-max-constant"].value
				if #data.raw.technology[tech].prerequisites == 1 then
					local c = settings.startup["omniscience-cumulative-constant-omni"].value
					local chain = settings.startup["omniscience-chain-constant"].value
					if omni.lib.start_with(tech,"omnitech") then
						cost=cost*(1+settings.startup["omniscience-chain-omnitech-constant"].value*c/(c+1))
					else
						local ln = 1
						local t = data.raw.technology[tech].prerequisites[1]
						while data.raw.technology[t].prerequisites and #data.raw.technology[t].prerequisites == 1 do
							ln=ln+1
							t=data.raw.technology[t].prerequisites[1]
						end
						cost = cost*(math.pow(1+chain*c/(c+1),1+ln/(ln+1)))
					end
				end
				table.insert(tech_list.cost,cost)
				table.insert(tech_list.height,h+1)
				table.remove(check_techs,i)
				break
			end
		end
	end

	if #check_techs>0 then
		--log("Something didn't go as I wanted and this many remains: "..#check_techs.." and they are")
		for _,left in pairs(check_techs) do
		end
	end

	local base = nil
	for _,x in pairs(settings.startup["omniscience-exponential-base"]) do
		base=x
	end

	if not base then base = settings.startup["omniscience-exponential-base"] end

	if settings.startup["omniscience-modify-costs"].value then
		for i,tech in pairs(tech_list.name) do
			if settings.startup["omniscience-cumulative-count"].value then
				data.raw.technology[tech].unit.count = tech_list.cost[i]
			elseif settings.startup["omniscience-exponential"].value then
				data.raw.technology[tech].unit.count=settings.startup["omniscience-exponential-initial"].value*math.pow(base,tech_list.height[i])
			end
		end
	end
end
