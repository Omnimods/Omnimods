--mapping of unlocks for omnienergy vs bobs vs burner phase
--For the benefit of cleaning up the tech tree and assisting people in "going down the right path"
--General rule of thumb... burner-->steam-->heat based power-->steam based power
--First step (clobber bobs burner lab)
--second step, remove steam engine from steam power tech (leave offshore pump and boiler)
--add anbaricity as a pre-req to steam power and electricity
--remove anbaric lab tech
--remove mining drill and small-electric pole and inserter from electricity
--tempted to move steam-engine behind green in the interim (but can balance that back out)
--consider shifting everything pre-"lab" to steam science packs, then pre-req of red science to be steam power (not engine)
if mods["bobtech"] and settings.startup["bobmods-burnerphase"].value then
-- Remove bobs burner lab
    table.insert(data.raw["lab"]["omnitor-lab"].inputs, "steam-science-pack")
    omni.lib.disable_recipe("burner-lab")
    omni.lib.remove_recipe_ingredient("lab", "burner-lab")

    -- Remove steam engine from steam power technology
    omni.lib.remove_unlock_recipe("omnitech-steam-power","steam-engine")

    -- Add anbarcity to pre-requisites
    omni.lib.add_prerequisite("omnitech-steam-power", "omnitech-anbaricity")
    omni.lib.add_prerequisite("electricity", "omnitech-anbaricity")
    data.raw.technology["omnitech-anbaric-lab"].hidden=true --i hope this works

    -- Remove duplicate recipe unlocks
    omni.lib.remove_unlock_recipe("electricity","small-electric-pole")
    omni.lib.remove_unlock_recipe("electricity","electric-mining-drill")
    omni.lib.remove_unlock_recipe("electricity","inserter")

    -- Move steam-engine waaay back
    if data.raw.technology["bob-steam-engine-1"] then
        omni.lib.add_prerequisite("bob-steam-engine-1", "logistic-science-pack")
        omni.lib.add_science_pack("bob-steam-engine-1", "logistic-science-pack")
        omni.lib.add_science_pack("bob-steam-engine-2", "logistic-science-pack")

        omni.lib.remove_prerequisite("bob-steam-engine-2","omnitech-steam-power")
        omni.lib.remove_prerequisite("bob-boiler-2","omnitech-steam-power")
        omni.lib.remove_prerequisite("omnitech-omnium-power-1","omnitech-steam-power")
        data.raw.technology["omnitech-steam-power"].hidden=true
    else
        omni.lib.remove_unlock_recipe("electricity","steam-engine")
        omni.lib.add_unlock_recipe("automation", "steam-engine")
    end

    omni.lib.add_prerequisite("automation-science-pack", "electricity")
    omni.lib.add_prerequisite("automation-science-pack", "steam-power")

    --change technologies to be steam pack in place of red packs
    omni.lib.replace_science_pack("omnitech-base-impure-extraction","automation-science-pack", "steam-science-pack")
    omni.lib.replace_science_pack("omnitech-anbaricity","automation-science-pack", "steam-science-pack")
    omni.lib.replace_science_pack("omnitech-simple-automation","automation-science-pack", "steam-science-pack")

    if mods["bobassembly"] and settings.startup["bobmods-assembly-burner"].value then
        omni.lib.remove_prerequisite("steam-automation","basic-automation")
        data.raw.technology["basic-automation"].unit.count = 15
        data.raw.technology["steam-automation"].unit.count = 65
    end

    data.raw.technology["omnitech-steam-power"].unit.count = 60
    data.raw.technology["automation-science-pack"].unit.count = 75

    if mods["boblogistics"] and settings.startup["bobmods-logistics-beltoverhaul"].value then
        omni.lib.replace_science_pack("omnitech-basic-belt-logistics","automation-science-pack", "steam-science-pack")
        omni.lib.replace_science_pack("omnitech-basic-underground-logistics","automation-science-pack", "steam-science-pack")
        omni.lib.replace_science_pack("omnitech-basic-splitter-logistics","automation-science-pack", "steam-science-pack")
    end
    if data.raw.technology["bob-steam-engine-1"] then
       omni.lib.replace_science_pack("bob-steam-engine-1", "steam-science-pack","automation-science-pack")
       omni.lib.replace_science_pack("bob-steam-engine-2", "steam-science-pack","automation-science-pack")
    end
end