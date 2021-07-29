--Dont mess with recipes when angels component mode is active
local nocomps = true
if mods["angelsindustries"] and angelsmods.industries.components then
    nocomps = false
end

if mods["bobpower"] then
    omni.lib.add_prerequisite("bob-steam-engine-2", "omnitech-steam-power")
    omni.lib.add_prerequisite("bob-boiler-2", "omnitech-steam-power")
    data.raw.technology["bob-solar-energy-2"].hidden = true
    data.raw.technology["bob-solar-energy-3"].hidden = true
    data.raw.technology["bob-solar-energy-4"].hidden = true

elseif nocomps then
    omni.lib.add_recipe_ingredient("steam-turbine",{"anbaric-omnitor",10})
end


if mods["bobmining"] then
    omni.lib.add_prerequisite("bob-drills-1", "omnitech-anbaric-mining")
end

if mods["boblogistics"] and settings.startup["bobmods-logistics-beltoverhaul"].value then
    --move logistics behind red SP tech again
    omni.lib.replace_prerequisite("logistics", "logistics-0", "automation-science-pack")

    --Update subgroup
    data.raw.recipe["burner-filter-inserter"].subgroup = "bob-logistic-tier-0"
    data.raw.recipe["basic-transport-belt"].subgroup = "bob-logistic-tier-0"
    data.raw.recipe["basic-underground-belt"].subgroup = "bob-logistic-tier-0"
    data.raw.recipe["basic-splitter"].subgroup = "bob-logistic-tier-0"
    data.raw.recipe["transport-belt"].subgroup = "bob-logistic-tier-1"
    data.raw.recipe["underground-belt"].subgroup = "bob-logistic-tier-1"
    data.raw.recipe["splitter"].subgroup = "bob-logistic-tier-1"

end


if mods["bobelectronics"] then
    omni.lib.add_recipe_ingredient("wooden-board", {normal = {"omni-tablet",1}, expensive = {"omni-tablet",2}})
    omni.lib.add_unlock_recipe("omnitech-anbaric-electronics", "wooden-board")
    omni.lib.add_unlock_recipe("omnitech-anbaric-electronics", "basic-circuit-board")
end


if mods["bobassembly"] then
    --Simple automation is between red SP and automation, move its steam assembler behind omnis basic automation, remoce bobs burner assembler
    omni.lib.replace_prerequisite("basic-automation", "automation-science-pack", "omnitech-simple-automation")
    omni.lib.replace_prerequisite("automation", "basic-automation", "automation-science-pack")
    omni.lib.remove_science_pack("basic-automation", "automation-science-pack")
    omni.lib.remove_unlock_recipe("basic-automation", "burner-assembling-machine")

    --Update subgroup
    data.raw.recipe["omnitor-assembling-machine"].subgroup = "bob-assembly-machine"
    data.raw.recipe["assembling-machine-1"].subgroup = "bob-assembly-machine"
end


if mods["bobwarfare"] then
    --Non component mode part
    if nocomps then
        omni.lib.add_recipe_ingredient("bob-sniper-turret-1",{"omnitor", 4})
        omni.lib.add_recipe_ingredient("bob-plasma-turret-1",{"anbaric-omnitor", 15})
    end
end