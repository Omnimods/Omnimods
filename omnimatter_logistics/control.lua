local start_with = function(a,b)
    return string.sub(a,1,string.len(b)) == b
end
local start_within_table = function(a,b)
    return string.sub(a,1,string.len(b)) == b
end



script.on_event(defines.events.on_research_finished, function(event)
    local tech = event.research
    if start_with(tech.name,"omnireactor-effiency-") or start_with(tech.name,"omnireactor-slots-") then
        local length = string.len(tech.name)
        local eff = 1
        while tech.force.technologies["omnireactor-effiency-"..eff] and tech.force.technologies["omnireactor-effiency-"..eff].researched do
            eff=eff+1
        end
        local slots = 1
        while tech.force.technologies["omnireactor-slots-"..slots] and tech.force.technologies["omnireactor-slots-"..slots].researched do
            slots=slots+1
        end
        if eff >= 1 or slots >= 1 then
            for i=1, eff do
                for j=1,slots do
                    if tech.force.recipes["omni-generator-eff-"..i.."-slot-"..j] then
                        tech.force.recipes["omni-generator-eff-"..i.."-slot-"..j].enabled = true
                    end
                end
            end
        end
    end
end)

script.on_configuration_changed( function(conf)
    for each, force in pairs(game.forces) do
        local eff = 1
        while force.technologies["omnireactor-effiency-"..eff+1] and force.technologies["omnireactor-effiency-"..eff+1].researched do
            eff=eff+1
        end
        local slots = 1
        while force.technologies["omnireactor-slots-"..slots+1] and force.technologies["omnireactor-slots-"..slots+1].researched do
            slots=slots+1
        end
        if eff >= 1 or slots >= 1 then
            for i=1, eff do
                for j=1, slots do
                    force.recipes["omni-generator-eff-"..i.."-slot-"..j].enabled = true
                end
            end
        end
    end
end)