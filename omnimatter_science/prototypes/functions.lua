-----------------------
-- Variable Trimming --
-----------------------
local Set = omni.science.triggers
omni.science.exclude_tech_from_maths = {} --build this in the override file, this is to exclude stuff in "angels tech archive" etc
--not sure if i should also exclude the modules/alien stuff from bobs while im at it
----------------------------------
-- set omni-pack exclusion list --
----------------------------------

omni.science.exclude_tech = {}
omni.science.remaining_techs = {}

--add techs to omni-pack exclusion list (this is to simplify the below tech_post_find_update function)
local function build_tech_list()
    log("Building technology list")
    for _, tech in pairs(data.raw.technology) do
        --No science packs -> Trigger tech
        if not tech.unit or not next(tech.unit) then
            omni.science.exclude_tech[tech.name] = true
            goto continue
        end
        -- if modules
        if string.find(tech.name,"-module") or tech.name == "module-merging" then
            omni.science.exclude_tech[tech.name] = true
            goto continue
        end
        -- if alien science (gold pack)
        for _,ing in pairs(tech.unit.ingredients) do
            for _,sub_ing in pairs(ing) do
                if string.find(sub_ing, "science%-pack%-gold") then
                    omni.science.exclude_tech[tech.name] = true
                    goto continue
                end
            end
        end
        -- if no pre-requisites
        if tech.prerequisites and #tech.prerequisites == 0 then
            omni.science.exclude_tech[tech.name]=true
            goto continue
        elseif not tech.prerequisites then
                omni.science.exclude_tech[tech.name]=true
            goto continue
        end
        --Add Tech to the list of remaining techs to update
        omni.science.remaining_techs[#omni.science.remaining_techs+1] = tech.name
        ::continue::
    end
end

---------------------------------------------------------------
-- Add omnipack to pre-requisites and tech if conditions met --
-- this is relatively slow as it will go through the whole tree
---------------------------------------------------------------
local contains_omnipack = {}

-- add omnipack to all techs above chemical science pack, and set pre-req to pack tech if needed
function omni.science.omnipack_tech_post_update()
    build_tech_list()

    local index = 0
    --Repeat looping through omni.science.remaining_tech until its empty
    log("Adding Omni packs to technologies.")
    while next(omni.science.remaining_techs) do

        index = index +1
        --log("Looping through the internal tech list for the "..index.." time")
        --log("Number of techs to loop through: "..#omni.science.remaining_techs)
        if index > 50 then
            log("WARNING: Max amount of tech list loops exceeded!")
            break
        end

        for _,techname in pairs(omni.science.remaining_techs) do
            local tech = data.raw.technology[techname]
            --No tech packs
            if  tech.unit and next(tech.unit) then
                --Check if tech already contains omnipacks
                local contains = false
                for _,ing in pairs(tech.unit.ingredients) do
                    --techunits[#techunits+1]=ing[1]
                    if omni.lib.is_in_table("omni-pack", ing) then
                        contains_omnipack[techname] = true
                        omni.lib.remove_from_table(techname, omni.science.remaining_techs)
                        contains = true
                        break
                    end
                end
                if contains == true then goto continue end
            end

            --When this tech has no prereqs, remove it from the list
            if not tech.prerequisites or not next(tech.prerequisites) then
                omni.lib.remove_from_table(techname, omni.science.remaining_techs)
                goto continue
            end

            --Check if prereqs contains omnipacks
            local found = false
            for _,prereq in pairs(tech.prerequisites) do
                if contains_omnipack[prereq] then
                    found = true
                    break
                else
                    if not data.raw.technology[prereq] then
                        error("Prereq "..prereq.." of Technology "..techname.." does not exist")
                    end
                    if data.raw.technology[prereq].unit and next(data.raw.technology[prereq].unit) then
                        for _,ing in pairs(data.raw.technology[prereq].unit.ingredients) do
                            if omni.lib.is_in_table("omni-pack", ing) then
                                contains_omnipack[prereq] = true
                                omni.lib.remove_from_table(prereq, omni.science.remaining_techs)
                                found = true
                                break
                            end
                        end
                    end
                    if found == true then break end
                end
            end

            if found == true then
                omni.lib.add_science_pack(techname, "omni-pack")
                contains_omnipack[techname] = true
                omni.lib.remove_from_table(techname, omni.science.remaining_techs)
                goto continue
            end

            --Check if prereqs still need to be checked, if all prereqs are checked, this tech is done aswell
            local reqs_done = true
            for _,prereq in pairs(tech.prerequisites) do
                if omni.lib.is_in_table(prereq, omni.science.remaining_techs) then
                    reqs_done = false
                    break
                end
            end
            if reqs_done == true then
                omni.lib.remove_from_table(techname, omni.science.remaining_techs)
            end
            ::continue::
        end
    end
end


-----------------------
-- Support Functions --
-----------------------
local SP_used_in_lab = {}
local function run_lab_comp_check()
--build lab ingredients table
    for _,lab in pairs(data.raw.lab) do
        if not string.find(lab.name,"creative") then --always exclude creative labs
            for _, input in pairs(lab.inputs) do
                SP_used_in_lab[input] = true
            end
        end
    end
end

--check lab ingredients
local function all_SP_ings_are_lab_inputs(tech)
    if tech.unit and tech.unit.ingredients then
        for _,input in pairs(tech.unit.ingredients) do
            if not SP_used_in_lab[input.name or input[1]] then return false end
        end
    end
    return true
end

--prerequisite in finalised list check
local function all_pre_in_table(tech)
    for _, pre in pairs(data.raw.technology[tech].prerequisites) do
        if not omni.lib.is_in_table(pre, omni.science.tech_list.name) then return false end
    end
    return true
end

--fetch values from arrays (cost)
local function get_cost(tech)
    for i,t in pairs(omni.science.tech_list.name) do
        if tech == t then return omni.science.tech_list.cost[i] end
    end
    return nil
end

--fetch values from arrays (height)
local function get_height(tech)
    for i,t in pairs(omni.science.tech_list.name) do
        if tech == t then return omni.science.tech_list.height[i] end
    end
    return nil
end
------------------
-- Tech Updates --
------------------
omni.science.tech_list = { name = {}, cost = {}, height = {}} --list of tech and key properties

function omni.science.tech_updates()
    log("Updating technology costs.")
    local tech_list = omni.science.tech_list
    local check_techs = {} --list of checks
    --tech_list.name={}
    --tech_list.cost={}
    --tech_list.height={}
    --module
    --omni-impure
    local omni_excempt_list = {{"omniston","solvation"},{"omnic","hydrolyzation"},{"stone","omnisolvent"},"distillation",{"omni","sorting"},{"impure","omni"},{"water","omnitraction"},{"mud","omnitraction"},{"pseudoliquid","amorphous","crystal"}}

    run_lab_comp_check() --ensure this is done at the right time

    -- separate techs for processing and set tech time
    for _, tech in pairs(data.raw.technology) do
        local unit = tech.unit
        if unit then
            --roll through each tech
            if tech.unit and Set.StdTime and omni.lib.start_with(tech.name,"omnipressed-") then --compression tech time standardise?
                --standardised research time
                tech.unit.time = Set.StdTimeConst
            end
            --if contains packs as ingredients
            if not omni.lib.start_with(tech.name,"omnitech") or
            ((Set.ModOmCost and omni.lib.start_with(tech.name,"omnitech")) and (#omni.science.exclude_tech_from_maths >=1) and not omni.science.exclude_tech_from_maths(tech.name)) then --omnitech with start-up setting
                --check compliance before adding to table
                if not tech.prerequisites or #tech.prerequisites == 0 or not all_SP_ings_are_lab_inputs(tech) then
                    --non-compliant, set height to 1
                    tech_list.name[#tech_list.name+1] = tech.name
                    tech_list.cost[#tech_list.cost+1] = unit.count or 1 --just incase does not have count
                    tech_list.height[#tech_list.height+1] = 1
                else
                    check_techs[#check_techs+1] = tech.name
                end
            elseif omni.lib.start_with(tech.name,"omnitech") and not Set.ModOmCost then
                --set height to 0 (so multiplier is 1)
                tech_list.name[#tech_list.name+1] = tech.name
                tech_list.cost[#tech_list.cost+1] = tech.unit.count or tech.unit[2] or 1
                tech_list.height[#tech_list.height+1] = 0
            elseif omni.lib.start_with(tech.name,"omnitech") then
                check_techs[#check_techs+1] = tech.name
            else
                log("what? ".. tech.name .." does not compute?")--this should NEVER show up :D
            end
        end
    end

    -- select and update costings of techs in check_techs
    local found = true --used to allow multi-pass calculations
    while #check_techs > 0 and found do
        found = false
        for i,tech in pairs(check_techs) do
            local techno = data.raw.technology[tech] --set shortening of something used commonly
            if all_pre_in_table(tech) and (techno.unit.count or techno.unit[2]) then
                found = true --this re-initiates the loop, this prevents lockups if a loop fails to modify
                tech_list.name[#tech_list.name+1] = tech
                local cost = techno.unit.count or techno.unit[2]
                local h = 0
                local add = 0
                for _,pre in pairs(techno.prerequisites) do
                    h = math.max(h, get_height(pre)) -- set this for all conditions
                    if Set.Cumul then
                        if tech ~= "rocket-silo" or Set.ModSilo then
                            if not string.find(pre,"omnitech") then
                                cost = cost+get_cost(pre)*Set.CumulConst --adds all non-omni techs regardless
                            else
                                add = math.max(add,get_cost(pre)*Set.CumulOmConst) --adds only the most expensive omni tech
                            end
                        elseif not string.find(pre,"omnitech") then
                            cost = cost+get_cost(pre)
                        end
                    end
                end
                cost=cost+add--*Set.OmMaxConst --add==0 if not cumulative mode, so this line does nothing in exp mode

                if #techno.prerequisites == 1 and Set.Cumul then
                    local c = Set.CumulOmConst
                    local chain = Set.ChainConst
                    if omni.lib.start_with(tech,"omnitech") then
                        cost = cost*(1+Set.ChainOmConst*c/(c+1))
                    else
                        local lv = 1
                        local t = techno.prerequisites[1]
                        local count = 0
                        while data.raw.technology[t].prerequisites and #data.raw.technology[t].prerequisites >= 1 do
                            if count > 100 then
                                error("Technology loop detected with:"..data.raw.technology[t].name)
                            end
                            if data.raw.technology[t].prerequisites[1] == nil then --what the heck is going on here
                                log("nil detected in pre-req table of "..t)
                                log(serpent.block(data.raw.technology[t].prerequisites))
                                break
                            else
                                lv = lv+1
                                t = data.raw.technology[t].prerequisites[1]
                                count = count + 1
                            end
                        end
                        cost = cost*(math.pow(1+chain*c/(c+1),1+lv/(lv+1)))
                    end
                end
                table.insert(tech_list.cost,cost)
                table.insert(tech_list.height,h+1)
                table.remove(check_techs,i)
            end
        end
    end
    if Set.ModAllCost then
        for i,tech in pairs(tech_list.name) do
            local raw_tech = data.raw.technology[tech]
            if Set.Cumul then
                raw_tech.unit.count = math.ceil(tech_list.cost[i])
            elseif Set.Expon then
                raw_tech.unit.count = math.ceil(Set.ExponInit*math.pow(Set.ExponBase,tech_list.height[i]))
            else --no maths changing mode
                log("why bother with this mod if you don't want cumulative or exponential tech costs?")
            end
        end
    end
end