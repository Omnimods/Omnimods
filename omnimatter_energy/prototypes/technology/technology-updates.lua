--Move all pre electric onnitractor techs to energy SP
local working_techs = {"omnitech-omnitractor-electric-1"}
local tech_to_rem = {}
local count = 0

while #working_techs > 0 do
    count = count + 1
    for _, t in pairs(working_techs) do
        local tech = data.raw.technology[t]
        if not tech then
            log("Invalid technology "..t)
        elseif tech.prerequisites and next(tech.prerequisites) then
            for _,req in pairs(tech.prerequisites) do
                if not omni.lib.is_in_table(req, tech_to_rem) then
                    tech_to_rem[#tech_to_rem+1] = req
                    working_techs[#working_techs+1] = req
                end
            end
            omni.lib.remove_from_table(t, working_techs)
        else
            omni.lib.remove_from_table(t, working_techs)
        end
    end
    if count > 50 then error("A critical error occured, please contact the Devs of Omnimods") end
end

for _, tech in pairs(tech_to_rem) do
    omni.lib.replace_science_pack(tech,"automation-science-pack", "energy-science-pack")
end

--Move basic omnitraction prereq from red to energy sp
omni.lib.replace_prerequisite("omnitech-base-impure-extraction", "automation-science-pack", "omnitech-energy-science-pack")
--Electric omnitractor needs to prereq automation sp
omni.lib.add_prerequisite("omnitech-omnitractor-electric-1", "automation-science-pack")

--Move all red SP techs without a prereq behind the automation sp
local nolock ={}
for _,tech in pairs(data.raw.technology) do
    if tech.prerequisites == nil or next(tech.prerequisites) == nil then
        if tech.unit and tech.unit.ingredients and #tech.unit.ingredients == 1 and omni.lib.is_in_table("automation-science-pack", tech.unit.ingredients[1])
            and not omni.lib.is_in_table(tech.name, nolock) then
            omni.lib.add_prerequisite(tech.name, "automation-science-pack")
        end
    end
end

--Add the energy pack to all techs
for _,tech in pairs(data.raw.technology) do
    if tech.unit and tech.unit.ingredients and omni.lib.is_in_table("automation-science-pack", tech.unit.ingredients[1]) then
        omni.lib.add_science_pack(tech.name, "energy-science-pack")
    end
end