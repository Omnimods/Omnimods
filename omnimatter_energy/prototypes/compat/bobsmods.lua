--Dont mess with recipes when angels component mode is active
local nocomps = true
if mods["angelsindustries"] and angelsmods.industries.components then
    nocomps = false
end

if mods["bobpower"] then
    -- --Point prereqs to our techs again
    omni.lib.set_prerequisite("bob-steam-engine-2", "steam-power")
    omni.lib.set_prerequisite("bob-boiler-2", "steam-power")

    --Disable and hide bobs tech
    if data.raw.technology["bob-solar-energy-2"] then data.raw.technology["bob-solar-energy-2"].hidden = true end
    if data.raw.technology["bob-solar-energy-3"] then data.raw.technology["bob-solar-energy-3"].hidden = true end
    if data.raw.technology["bob-solar-energy-4"] then data.raw.technology["bob-solar-energy-4"].hidden = true end

elseif nocomps then
    omni.lib.add_recipe_ingredient("steam-turbine",{"anbaric-omnitor",10})
end

if mods["boblogistics"] then
    --Update subgroup of omnienergy basic belts
    data.raw.recipe["basic-transport-belt"].subgroup = "bob-logistic-tier-0"
    data.raw.recipe["basic-underground-belt"].subgroup = "bob-logistic-tier-0"
    data.raw.recipe["basic-splitter"].subgroup = "bob-logistic-tier-0"
    data.raw.recipe["transport-belt"].subgroup = "bob-logistic-tier-1"
    data.raw.recipe["underground-belt"].subgroup = "bob-logistic-tier-1"
    data.raw.recipe["splitter"].subgroup = "bob-logistic-tier-1"

    --Remove bobs basic transport belts
    omni.lib.replace_all_ingredient("bob-basic-transport-belt", "basic-transport-belt")
    data.raw.recipe["bob-basic-transport-belt"].enabled = false

    --Remove bob basic belts from yellows
    omni.lib.remove_recipe_ingredient("transport-belt", "bob-basic-transport-belt")
    omni.lib.remove_recipe_ingredient("underground-belt", "bob-basic-underground-belt")
    omni.lib.remove_recipe_ingredient("splitter", "bob-basic-splitter")

end

if mods["bobelectronics"] then
    omni.lib.add_recipe_ingredient("bob-wooden-board", {"omni-tablet",1})
    omni.lib.add_unlock_recipe("electronics", "wooden-board")
    omni.lib.add_unlock_recipe("electronics", "bob-basic-circuit-board")
end

if mods["bobassembly"] then
    --Simple automation is between red SP and automation, move its steam assembler behind omnis basic automation, remove bobs burner assembler
    omni.lib.replace_prerequisite("bob-basic-automation", "automation-science-pack", "omnitech-simple-automation")
    omni.lib.remove_science_pack("bob-basic-automation", "automation-science-pack")
    omni.lib.remove_unlock_recipe("bob-basic-automation", "bob-burner-assembling-machine")

    if settings.startup["bobmods-assembly-burner"].value then
        omni.lib.replace_prerequisite("automation", "basic-automation", "automation-science-pack")
    end

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