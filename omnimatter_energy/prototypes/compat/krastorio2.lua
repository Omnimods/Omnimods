if mods["Krastorio2"] then
    ----------------------
    ----- Tech compat-----
    ----------------------
    --Progression: Puzt energy-science in fron of kr-basic-tech-card (both burner/semi electric) pre red tech stage

    --Add kr-basic-tech-card to the omnitor lab
    BuildGen:import("omnitor-lab"):
        setInputs("energy-science-pack", "kr-basic-tech-card")

    --Create a new tech for basic tech card
    RecGen:import("kr-basic-tech-card"):
        setEnabled(false):
        setTechName("kr-basic-tech-card"):
        setTechCost(45):
        setTechIcons({{icon = "__Krastorio2Assets__/icons/cards/basic-tech-card.png",icon_size = 64}}):
        setTechPacks({{"energy-science-pack", 1}}):
        setTechPrereq("omnitech-anbaricity"):
        setTechLocName(omni.lib.locale.of("kr-basic-tech-card", "recipe").name):
        extend()

    --Turn the energy SP into a "card", thanks to the K2 team for letting us use a changed version of their card icon
    RecGen:import("energy-science-pack"):
        setIcons({{icon = "__omnimatter_energy__/graphics/icons/energy-tech-card.png",icon_size = 64}}):
        setTechIcons({{icon = "__omnimatter_energy__/graphics/icons/energy-tech-card.png",icon_size = 64}}):
        setLocName({"technology-name.energy-tech-card"}):
        setTechLocName({"technology-name.energy-tech-card"}):
        extend()

    data.raw.tool["energy-science-pack"].icons = {{icon = "__omnimatter_energy__/graphics/icons/energy-tech-card.png",icon_size = 64}}
    data.raw.tool["energy-science-pack"].localised_name = {"technology-name.energy-tech-card"}

    --Move automation sp behing labs and re-add basic tech card
    omni.lib.replace_prerequisite("automation-science-pack", "electric-mining-drill", "kr-laboratory")
    omni.lib.add_science_pack("automation-science-pack", "kr-basic-tech-card")

    --Move basic tech card techs without prereq behind that
    omni.lib.add_prerequisite("kr-iron-pickaxe", "kr-basic-tech-card")
    omni.lib.add_prerequisite("kr-automation-core", "kr-basic-tech-card")
    omni.lib.add_prerequisite("military", "kr-basic-tech-card")

    --K2 already fixes up electronics to be researched after automation-science-pack
    --energy-science-pack is added automatically by dynamic functions in technology-updates.lua


    --Move wind turbine to anbaricity
    RecGen:import("kr-wind-turbine"):
        setEnabled(false):
        setTechName("omnitech-anbaricity"):
        extend()

    --Make crash site lab and assembler burner and set fuel cat to omni
    local burners = {
        "kr-spaceship-material-fabricator-1",
        "kr-spaceship-material-fabricator-2",
        "kr-spaceship-research-computer"
    }
    for _,b in pairs(burners) do
        local e = data.raw["assembling-machine"][b] or data.raw["lab"][b]
        e.energy_source = {
            type = "burner",
            effectivity = 0.5,
            fuel_inventory_size = 1,
            fuel_categories = {"omnite","chemical","kr-vehicle-fuel"},
            emissions_per_minute = {pollution = 0.01},
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

    --Crash site lab needs to accept energy SP
    table.insert(data.raw["lab"]["kr-spaceship-research-computer"].inputs, 1, "energy-science-pack")

    ----------------------
    ----- Item compat-----
    ----------------------

    --Add omnitors to some recipes
    omni.lib.add_recipe_ingredient("kr-inserter-parts",{"omnitor",2})
    omni.lib.add_recipe_ingredient("kr-crusher",{"omnitor",2})

    --Fix inserter recipes to be like default K2 (omnitor is already in inserter parts) and set them to require their previous tier
    omni.lib.replace_recipe_ingredient("burner-inserter","omnitor","kr-inserter-parts")
    omni.lib.replace_recipe_ingredient("inserter","electronic-circuit","kr-inserter-parts")
    omni.lib.add_recipe_ingredient("inserter","kr-automation-core")

    omni.lib.add_recipe_ingredient("fast-inserter","inserter")
    omni.lib.add_recipe_ingredient("long-handed-inserter","inserter")
    omni.lib.add_recipe_ingredient("bulk-inserter","fast-inserter")

    omni.lib.add_recipe_ingredient("kr-superior-inserter","fast-inserter")
    omni.lib.add_recipe_ingredient("kr-superior-long-inserter","long-handed-inserter")
end