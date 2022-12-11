if mods["Krastorio2"] then
    --Remove the basic tech card from omnium processing
    omni.lib.remove_science_pack("omnitech-omnium-processing", "basic-tech-card")
    omni.lib.remove_prerequisite("omnitech-omnium-processing", "basic-tech-card")

    --Add the basic tech card to all late omni techs that miss it
    for _,tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients and #tech.unit.ingredients <= 2 and omni.lib.is_in_table("automation-science-pack", tech.unit.ingredients[1]) then
            omni.lib.add_science_pack(tech.name, "basic-tech-card")
        end
    end

    --Add the energy pack to all basic/Red SP techs
    for _,tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients and omni.lib.is_in_table("basic-tech-card", tech.unit.ingredients[1]) or omni.lib.is_in_table("automation-science-pack", tech.unit.ingredients[1]) then
            omni.lib.add_science_pack(tech.name, "energy-science-pack")
        end
    end
end