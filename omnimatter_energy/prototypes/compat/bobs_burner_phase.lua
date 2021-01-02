--mapping of unlocks for omnienergy vs bobs vs burner phase
--For the benefit of cleaning up the tech tree and assisting people in "going down the right path"
--General rule of thumb... burner-->steam-->heat based power (anbaricity)-->steam based (electric) power

if mods["bobtech"] and settings.startup["bobmods-burnerphase"].value then
    --Make the omnitor lab only accept steam sp
    data.raw["lab"]["omnitor-lab"].inputs = {"steam-science-pack"}
    --omnitor lab-->burner-lab(steam)-->normal lab
    omni.lib.remove_recipe_ingredient("lab", "omnitor-lab")

    -- Remove steam engine from steam power technology
    omni.lib.remove_unlock_recipe("omnitech-steam-power","steam-engine")

    -- Add anbarcity as electricity prereq
    omni.lib.add_prerequisite("electricity", "omnitech-anbaricity")

    -- Remove duplicate recipe unlocks from electricity
    omni.lib.remove_unlock_recipe("electricity","small-electric-pole")
    omni.lib.remove_unlock_recipe("electricity","electric-mining-drill")
    omni.lib.remove_unlock_recipe("electricity","inserter")

    --Remove techs that prereq electricity that get moved behind logistic sp
    omni.lib.remove_prerequisite("bob-steam-engine-1","electricity")
    omni.lib.remove_prerequisite("automation","electricity")

    --Move anbaricity behind automation science (prereqs steam power) and add splitter/ug techs as prereq for steam power
    if data.raw.technology["omnitech-basic-belt-logistics"] then
        omni.lib.remove_prerequisite("omnitech-anbaricity","omnitech-basic-splitter-logistics")
        omni.lib.remove_prerequisite("omnitech-anbaricity","omnitech-basic-underground-logistics")
        omni.lib.add_prerequisite("steam-power","omnitech-basic-splitter-logistics")
        omni.lib.add_prerequisite("steam-power","omnitech-basic-underground-logistics")
    else
        omni.lib.remove_prerequisite("omnitech-anbaricity","omnitech-splitter-logistics")
        omni.lib.remove_prerequisite("omnitech-anbaricity","omnitech-underground-logistics")
        omni.lib.add_prerequisite("steam-power","omnitech-splitter-logistics")
        omni.lib.add_prerequisite("steam-power","omnitech-underground-logistics")
    end
    omni.lib.add_prerequisite("omnitech-anbaricity","automation-science-pack")

    --Make bobs burner lab a steam lab
    BuildGen:import("burner-lab"):
        setSteam():
        setName("burner-lab"):
        --setFluidBox("XWX.XXX.XXX",true):
        addIngredients("omnitor-lab"):
        setEnabled(false):
        setTechName("lab"):
        setLocName("recipe-name.steam-powered-lab"):
        extend()

    data.raw.technology["lab"].localised_name = {"recipe-name.steam-powered-lab"}
    data.raw.item["burner-lab"].localised_name = {"recipe-name.steam-powered-lab"}
    data.raw.recipe["burner-lab"].localised_name = {"recipe-name.steam-powered-lab"}
    omni.lib.remove_unlock_recipe("lab","lab")

    --reuse bobs lab tech for it (move logi sp from prereqing lab to anbaric lab tech)
    omni.lib.replace_prerequisite("logistic-science-pack","lab","omnitech-anbaric-lab")
    --replace electricity prereq with steam
    omni.lib.replace_prerequisite("lab","electricity","steam-power")

    --Move Automation science pack behind steam lab and steam automation
    omni.lib.remove_prerequisite("lab", "automation-science-pack")
    omni.lib.add_prerequisite("automation-science-pack", "lab")
    omni.lib.add_prerequisite("automation-science-pack", "steam-automation")

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
        --omni.lib.add_unlock_recipe("automation", "steam-engine") -- unlocked with omnitech steam power?
    end

    --change technologies to be steam pack in place of red packs
    omni.lib.replace_science_pack("omnitech-base-impure-extraction","automation-science-pack", "steam-science-pack")
    omni.lib.replace_science_pack("omnitech-burner-filter","automation-science-pack", "steam-science-pack")
    omni.lib.replace_science_pack("omnitech-simple-automation","automation-science-pack", "steam-science-pack")

    --Remove red sp from lab tech
    omni.lib.remove_science_pack("lab","automation-science-pack")

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