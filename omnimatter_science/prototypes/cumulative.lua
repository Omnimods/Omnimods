local tech_list = {}
local check_techs = {}
tech_list.name={}
tech_list.cost={}

for _,tech in pairs(data.raw.technology) do
    check_techs[#check_techs+1]=tech.name
    ----log(tech.name)
end
--log("total techs: "..#check_techs)
for i,tech in pairs(check_techs) do
    if not data.raw.technology[tech].prerequisites or #data.raw.technology[tech].prerequisites==0 then
        tech_list.name[#tech_list.name+1]=tech
        tech_list.cost[#tech_list.cost+1]=data.raw.technology[tech].unit.count
        --table.insert(tech_list.name,tech.name)
        --table.insert(tech_list.cost,data.raw.technology[tech].unit.count)
        --log("added: "..tech..";"..i)
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
local found = true
while #check_techs>0 and found do
    found=false
    for i,tech in pairs(check_techs) do
        if all_pre_in_table(tech) and data.raw.technology[tech].unit.count then
            --log("working on: "..tech)
            found = true
            table.insert(tech_list.name,tech)
            local cost = data.raw.technology[tech].unit.count 
            if omni.lib.string_contained_list(tech, omni_list) then
                cost=cost*settings.startup["omniscience-cumulative-constant-omni"].value
            else
                cost=cost*settings.startup["omniscience-cumulative-constant"].value
            end
            for _,pre in pairs(data.raw.technology[tech].prerequisites) do
                cost = cost+get_cost(pre)
            end
            table.insert(tech_list.cost,cost)
            table.remove(check_techs,i)
            break
        end
    end
end
if #check_techs>0 then
    --log("Something didn't go as I wanted and this many remains: "..#check_techs)
end