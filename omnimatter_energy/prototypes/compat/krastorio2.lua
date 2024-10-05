if mods["Krastorio2"] then
    ----------------------
    ----- Tech compat-----
    ----------------------

    --Create a new tech for basic tech card
    RecGen:import("basic-tech-card"):
        setEnabled(false):
        setTechName("basic-tech-card"):
        setTechCost(45):
        setTechIcons({{icon = "__Krastorio2Assets__/icons/cards/basic-tech-card.png",icon_size = 64}}):
        setTechPacks({{"energy-science-pack", 1}}):
        setTechPrereq("omnitech-anbaric-lab"):
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

    --Move lab behind anbaricity again
    omni.lib.replace_prerequisite("omnitech-anbaric-lab", "omnitech-anbaric-electronics", "omnitech-anbaricity")

    --Move basic tech card techs without prereq behind that
    omni.lib.add_prerequisite("kr-automation-core", "basic-tech-card")
    omni.lib.add_prerequisite("kr-iron-pickaxe", "basic-tech-card")
    omni.lib.add_prerequisite("military", "basic-tech-card")

    --Remove anbaric-electronics, K2 fixed up vanilla electronics
    omni.lib.replace_prerequisite("omnitech-anbaric-inserter", "omnitech-anbaric-electronics", "electronics")
    --omni.lib.replace_prerequisite("omnitech-anbaric-lab", "omnitech-anbaric-electronics", "electronics")
    TechGen:import("omnitech-anbaric-electronics"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()

    --remove omni mining drill tech
    TechGen:import("omnitech-anbaric-mining"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()

    --remove omni inserter tech
    TechGen:import("omnitech-anbaric-inserter"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()

    --unify kr-steam-engine tech and omni steam-engine tech
    omni.lib.replace_prerequisite("nuclear-power", "omnitech-steam-power", "kr-steam-engine")
    omni.lib.add_prerequisite("kr-steam-engine", "omnitech-basic-omnium-power")
    TechGen:import("omnitech-steam-power"):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()

    --Fix automation SP locales
    data.raw.technology["automation-science-pack"].localised_name = {"technology-name.automation-tech-card"}

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

    --Crash site lab needs to accept energy SP
    table.insert(data.raw["lab"]["kr-crash-site-lab-repaired"].inputs, 1, "energy-science-pack")

    ----------------------
    ----- Item compat-----
    ----------------------

    --Add omnitors to some recipes
    omni.lib.add_recipe_ingredient("inserter-parts",{"omnitor",2})
    omni.lib.add_recipe_ingredient("kr-crusher",{"omnitor",2})

    --Fix inserter recipes to be like normal K2 (omnitor is already in inserter parts) and set them to require their previous tier
    omni.lib.replace_recipe_ingredient("burner-inserter","omnitor","inserter-parts")
    omni.lib.replace_recipe_ingredient("inserter","electronic-circuit","inserter-parts")
    omni.lib.add_recipe_ingredient("inserter","automation-core")

    omni.lib.replace_recipe_ingredient("burner-filter-inserter","omnitor",{"inserter-parts",1})

    omni.lib.add_recipe_ingredient("fast-inserter","inserter")
    omni.lib.add_recipe_ingredient("long-handed-inserter","inserter")
    omni.lib.add_recipe_ingredient("filter-inserter","inserter")
    omni.lib.add_recipe_ingredient("bulk-inserter","fast-inserter")
    omni.lib.add_recipe_ingredient("stack-filter-inserter","bulk-inserter")

    omni.lib.add_recipe_ingredient("kr-superior-inserter","fast-inserter")
    omni.lib.add_recipe_ingredient("kr-superior-long-inserter","long-handed-inserter")
    omni.lib.add_recipe_ingredient("kr-superior-filter-inserter","filter-inserter")
    omni.lib.add_recipe_ingredient("kr-superior-long-filter-inserter","long-handed-inserter")


    --Add vehicle fuel cat to burner filter inserter
    data.raw["inserter"]["burner-filter-inserter"].energy_source.fuel_category = nil
    data.raw["inserter"]["burner-filter-inserter"].energy_source.fuel_categories = {"chemical","vehicle-fuel"}
end