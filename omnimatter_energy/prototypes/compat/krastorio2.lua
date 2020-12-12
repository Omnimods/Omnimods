if mods["Krastorio2"] then
    --Fix Tech order
    omni.lib.remove_prerequisite("electronics","logistic-science-pack")
    omni.lib.remove_science_pack("electronics","logistic-science-pack")
    omni.lib.remove_prerequisite("electronics","automation")
    
    --Move simple automation behind automation core (basic tech cards) and add it as prereq for automation card
    omni.lib.remove_science_pack("omnitech-simple-automation","automation-science-pack")
    omni.lib.add_prerequisite("omnitech-simple-automation","kr-automation-core")
    omni.lib.replace_prerequisite("automation-science-pack","kr-automation-core","omnitech-simple-automation")
    omni.lib.remove_prerequisite("omnitech-belt-logistics","omnitech-simple-automation")

    --Move Automation behind automation tech card and add back automation sp
    omni.lib.remove_prerequisite("automation","logistic-science-pack")
    omni.lib.add_science_pack("automation","automation-science-pack")
    omni.lib.replace_prerequisite("automation","kr-automation-core","omnitech-anbaricity")

    --unify kr and omni mining drill tech
    omni.lib.replace_prerequisite("kr-electric-mining-drill","automation-science-pack","omnitech-anbaricity")
    TechGen:import("omnitech-anbaric-mining"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()

    --unify kr-steam-engine techand omni steam-engine tech
    omni.lib.replace_prerequisite("nuclear-power","kr-steam-engine","omnitech-steam-power")
    TechGen:import("kr-steam-engine"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()

    --Move crusher behind anbaricity and add automation cards to it and following techs
    omni.lib.replace_prerequisite("kr-crusher","kr-automation-core","omnitech-anbaricity")
    omni.lib.add_science_pack("kr-crusher","automation-science-pack")
    omni.lib.add_science_pack("kr-stone-processing","automation-science-pack")
    omni.lib.add_science_pack("kr-greenhouse","automation-science-pack")
    omni.lib.add_science_pack("kr-decorations","automation-science-pack")
    omni.lib.remove_prerequisite("kr-greenhouse","kr-automation-core")

    --Move basic fluid handling behind automation science
    omni.lib.replace_prerequisite("kr-basic-fluid-handling","kr-automation-core","automation-science-pack")
    omni.lib.add_science_pack("kr-basic-fluid-handling","automation-science-pack")

    --Move electric opener techs behind anbaricity
    omni.lib.add_prerequisite("optics","omnitech-anbaricity")
    omni.lib.add_prerequisite("electronics","omnitech-anbaricity")

    --Put Logi Tech behind anbaric lab
    omni.lib.replace_prerequisite("logistic-science-pack","automation-science-pack","omnitech-anbaric-lab")

    -- Lock omnitor lab behind a basic tech card tech (crash site lab --> omnitor lab --> normal lab)
    RecGen:import("omnitor-lab"):
        setEnabled(false):
        setTechName("omnitech-simple-research"):
	    setTechCost(30):
        setTechPacks({{"basic-tech-card",1}}):
        setTechIcons("lab","omnimatter_energy"):
        setTechPrereq("kr-automation-core"):
        extend()
    omni.lib.add_prerequisite("automation-science-pack","omnitech-simple-research")

    --Fix that the omnitor lab doesnt accept basic tech cards:
    table.insert(data.raw["lab"]["omnitor-lab"].inputs,"basic-tech-card")

    --Add Basic tech card to all omni science up to t2(greens)
    --Baic tech cards are not used for mid-late game techs, thats why we cant add them as t1 pack to lib
    for _,tech in pairs(data.raw.technology) do
        if tech.unit.ingredients and #tech.unit.ingredients < 3 then
            omni.lib.add_science_pack(tech.name,"basic-tech-card")
        end
    end
end