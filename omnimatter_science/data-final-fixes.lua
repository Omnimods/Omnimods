
if mods["angelsbioprocessing"] then
	omni.lib.add_unlock_recipe("bio-farm","temperate-garden-cultivating-b")
	omni.lib.add_unlock_recipe("bio-farm","desert-garden-cultivating-b")
	omni.lib.add_unlock_recipe("bio-farm","swamp-garden-cultivating-b")
end
if mods["omnimatter_crystal"] then
	log("adding ingredients")
	omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "fast-transport-belt", amount = 1})
	omni.lib.add_recipe_ingredient("omni-pack",{type = "fluid", name = "omniston", amount = 50})
	omni.lib.change_recipe_category("omni-pack","crafting-with-fluid")
	omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "iron-ore-crystal", amount = 2})
	if not mods["omnimatter_research"] then
		if mods["boblogistics"] and settings.startup["bobmods-logistics-inserteroverhaul"].value == true then
			omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "long-handed-inserter", amount = 1})
		else
			omni.lib.add_recipe_ingredient("omni-pack",{type = "item", name = "fast-inserter", amount = 1})
		end
	end
	
	omni.lib.remove_science_pack("crystallonics-4","utility-science-pack")
	omni.lib.add_recipe_ingredient("chemical-science-pack","basic-crystallonic")
	omni.lib.add_recipe_ingredient("production-science-pack","basic-oscillo-crystallonic")
	omni.lib.add_recipe_ingredient("utility-science-pack","basic-oscillo-crystallonic")
	--omni.lib.add_recipe_ingredient("logistic-science-pack","basic-oscillo-crystallonic")
	--[[
	if mods["bobores"] then
		omni.lib.replace_recipe_ingredient("chemical-science-pack","advanced-circuit",omni.crystal.find_hybrid({"copper","lead","tin"},1,"advanced-circuit"))
		omni.lib.add_recipe_ingredient("production-science-pack",{type = "item", name = "silver-ore-crystal", amount = 1})
	end
	
	if mods["bobores"] and mods["angelsrefining"] then
		omni.lib.replace_recipe_ingredient("utility-science-pack","processing-unit",omni.crystal.find_hybrid({"manganese","rutile","cobalt","chrome"},2,"processing-unit"))
	end
	
	if mods["bobtech"] then
		omni.lib.add_recipe_ingredient("logistic-science-pack",{type = "item", name = omni.crystal.find_hybrid({"bauxite","lead","zinc","copper"},2,"processing-unit"), amount = 1})
	end]]
	
	omni.lib.replace_science_pack("advanced-ore-refining-3","chemical-science-pack")
	omni.lib.replace_science_pack("ore-leaching","chemical-science-pack")
	omni.lib.replace_science_pack("crystallonics-1","chemical-science-pack")
	if mods["omnimatter_wood"] then omni.lib.replace_science_pack("omnimutator-2","chemical-science-pack") end
	omni.lib.add_science_pack("electric-engine")
	omni.lib.add_science_pack("plastics")
	if mods["angelslogistics"] then
		omni.lib.add_science_pack("cargo-robots-2")	
	end
	if mods["Factorissimo2"] then
		omni.lib.replace_science_pack("factory-architecture-t1","chemical-science-pack")
		
	end
	if mods["angelspetrochem"] then
		omni.lib.add_science_pack("angels-advanced-chemistry-2")
		omni.lib.add_science_pack("gas-steam-cracking-1")
		omni.lib.add_science_pack("oil-steam-cracking-1")
		omni.lib.replace_science_pack("angels-nitrogen-processing-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-nitrogen-processing-4","production-science-pack")
		omni.lib.replace_science_pack("chlorine-processing-2","chemical-science-pack")		
		
	end
	if mods["omnimatter_compression"] then
		omni.lib.replace_science_pack("compression-initial","chemical-science-pack")
	end
	if mods["Bio_Industries"] then
		omni.lib.replace_science_pack("bi-advanced-biotechnology","chemical-science-pack")
		omni.lib.replace_science_pack("bi-organic-plastic","production-science-pack")		
	end
	if mods["angelssmelting"] then
		omni.lib.replace_science_pack("angels-aluminium-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-copper-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-iron-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-steel-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-tin-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-solder-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-lead-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-silver-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-zinc-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-chrome-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-cobalt-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-manganese-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-nickel-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-silicon-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-gold-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-titanium-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-tungsten-smelting-2","chemical-science-pack")
		omni.lib.replace_science_pack("angels-glass-smelting-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-cement-processing-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-metallurgy-3","chemical-science-pack")
		omni.lib.replace_science_pack("angels-metallurgy-4","utility-science-pack")
		omni.lib.replace_science_pack("thermal-water-extraction","chemical-science-pack")
		omni.lib.replace_science_pack("ore-advanced-floatation","chemical-science-pack")
		omni.lib.add_science_pack("advanced-metallurgy-1")	
		
		omni.lib.add_science_pack("angels-coolant-1")
		omni.lib.replace_science_pack("water-treatment-2","logistic-science-pack")
	end
	if mods["angelsrefining"] then
		omni.lib.replace_science_pack("ore-processing-2","chemical-science-pack")
	end
	if mods["omnimatter_wood"] then
		omni.lib.replace_science_pack("omnimutator-2","chemical-science-pack")
	end
	if mods["bobpower"] then
		omni.lib.add_science_pack("bob-solar-energy-2")
	end
	if mods["bobplates"] then
		omni.lib.add_science_pack("gem-processing-1")
	end
	omni.lib.replace_science_pack("rocket-damage-3","chemical-science-pack")
	omni.lib.replace_science_pack("crystallology-2","chemical-science-pack")
	omni.lib.replace_science_pack("military-3","chemical-science-pack")
	omni.lib.replace_science_pack("mining-productivity-4","chemical-science-pack")
	omni.lib.replace_science_pack("mining-productivity-8","production-science-pack")
	omni.lib.replace_science_pack("mining-productivity-12","utility-science-pack")
	--omni.lib.add_science_pack("mining-productivity-16")
	--omni.lib.remove_science_pack("mining-productivity-16","space-science-pack")
	--data.raw.technology["mining-productivity-16"].max_level=20
	
	
	
	--[[data:extend({
	{
    type = "technology",
    name = "mining-productivity-21",
    icon = "__base__/graphics/technology/mining-productivity.png",
	icon_size = 128,
    effects =
    {
      {
        type = "mining-drill-productivity-bonus",
        modifier = 0.02
      }
    },
    prerequisites = {"mining-productivity-16"},
    unit =
    {
      count_formula = "100(L-1)",
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"omni-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1}
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
    order = "c-k-f-e"
  },
	})]]
	
	local post_find = true
	while post_find do
		post_find = false
		for _,tech in pairs(data.raw.technology) do
			if tech.prerequisites and #tech.prerequisites > 0 and (not string.find(tech.name,"module") or tech.name=="modules") then
				local techunits = {}
				for _,ing in pairs(tech.unit.ingredients) do
					techunits[#techunits+1]=ing[1]
				end
				if not omni.lib.is_in_table("omni-pack",techunits)then
					for _,req in pairs(tech.prerequisites) do
						local requnits = {}
						if not data.raw.technology[req] then 
							--log("the prerequisite "..req.." of "..tech.name.." does not exist")
							error("the prerequisite "..req.." of "..tech.name.." does not exist")
						end
						for _,ing in pairs(data.raw.technology[req].unit.ingredients) do
							requnits[#requnits+1]=ing[1]
						end
						if omni.lib.is_in_table("omni-pack",requnits)  then
							post_find = true
							omni.lib.add_science_pack(tech.name)
							break
						end
					end
				end
			end
		end
	end
end
--category = "crafting-with-fluid",
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
		--log(left)
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