if mods["Krastorio2"] then
    ----------------------
    ----- Tech compat-----
    ----------------------
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
    omni.lib.remove_science_pack("automation","logistic-science-pack")
    omni.lib.add_science_pack("automation","automation-science-pack")
    omni.lib.replace_prerequisite("automation","kr-automation-core","omnitech-anbaricity")

    --Add automation as prereq for logi sp and remove electronics as prereq from automation 2
    omni.lib.add_prerequisite("logistic-science-pack","automation")
    omni.lib.remove_prerequisite("automation-2","electronics")

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

    --Move wind turbine to anbaricity
    RecGen:import("kr-wind-turbine"):
        setEnabled(false):
        setTechName("omnitech-anbaricity"):
        extend()

    --Make crash site lab and assembler burner and set fuel cat to omni
    local burners = {
        "kr-crash-site-assembling-machine-1-repaired",
        "kr-crash-site-assembling-machine-2-repaired",
        "kr-crash-site-lab-repaired"
    }
    for _,b in pairs(burners) do
        local e = data.raw["assembling-machine"][b] or data.raw["lab"][b]
        e.energy_source = {
            type = "burner",
            effectivity = 0.5,
            fuel_inventory_size = 1,
            fuel_categories = {"omnite","chemical","vehicle-fuel"},
            emissions = 0.01,
            smoke = {{
                name = "smoke",
                deviation = {0.1, 0.1},
                frequency = 5,
                position = {1.0, -0.8},
                starting_vertical_speed = 0.08,
                starting_frame_deviation = 60
            }}
        }
    end
    
    --Set crash site reactor output to 0 until K2 added the commented out interface below to remove it.
    --remote.interfaces["kr-crash-site"].remove_crash_site_entity("kr-crash-site-generator")
    data.raw["electric-energy-interface"]["kr-crash-site-generator"].energy_source = {
        type = "electric",
    	buffer_capacity = "0kJ",
    	usage_priority = "primary-output",
    	input_flow_limit = "0kW",
    	output_flow_limit = "0kW"}
    data.raw["electric-energy-interface"]["kr-crash-site-generator"].energy_production  = "0kW"

    --Add Basic tech card to all omni science up to t2(greens)
    --Baic tech cards are not used for mid-late game techs, thats why we cant add them as t1 pack to lib
    for _,tech in pairs(data.raw.technology) do
        if tech.unit.ingredients and #tech.unit.ingredients < 3 then
            omni.lib.add_science_pack(tech.name,"basic-tech-card")
        end
    end

    --Balance out early tech cost (mainly moved stuff)
    data.raw.technology["omnitech-simple-automation"].unit.count = 30
    data.raw.technology["omnitech-anbaric-lab"].unit.count = 65
    data.raw.technology["kr-crusher"].unit.count = 45
    data.raw.technology["optics"].unit.count = 75
    data.raw.technology["electronics"].unit.count = 65
    data.raw.technology["kr-electric-mining-drill"].unit.count = 65
    data.raw.technology["automation"].unit.count = 60
    data.raw.technology["automation"].unit.count = 90

    ----------------------
    ----- Item compat-----
    ----------------------
    omni.lib.add_recipe_ingredient("inserter-parts",{"omnitor",2})
    omni.lib.add_recipe_ingredient("kr-crusher",{"omnitor",2})

end