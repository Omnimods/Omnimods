if mods["Krastorio2"] then
    --Remove the basic tech card from omnium processing
    omni.lib.remove_science_pack("omnitech-omnium-processing", "kr-basic-tech-card")
    omni.lib.remove_prerequisite("omnitech-omnium-processing", "kr-basic-tech-card")

    --Add the basic tech card to all late omni techs that miss it
    for _,tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients and #tech.unit.ingredients <= 2 and omni.lib.is_in_table("automation-science-pack", tech.unit.ingredients[1]) then
            omni.lib.add_science_pack(tech.name, "kr-basic-tech-card")
        end
    end

    --Add the energy pack to all basic/Red SP techs
    --Remove it from late game techs where K2 removed red SP too as those are researched in special labs
    for _, tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients and (omni.lib.has_science_pack(tech.name, "kr-basic-tech-card") or omni.lib.has_science_pack(tech.name, "automation-science-pack")) then
            omni.lib.add_science_pack(tech.name, "energy-science-pack")
        elseif tech.unit and tech.unit.ingredients and #tech.unit.ingredients >= 2 and omni.lib.has_science_pack(tech.name, "energy-science-pack") and not (omni.lib.has_science_pack(tech.name, "kr-basic-tech-card") or omni.lib.has_science_pack(tech.name, "automation-science-pack")) then
            log(serpent.block(tech.unit.ingredients ))
            omni.lib.remove_science_pack(tech.name, "energy-science-pack")
        end
    end
end