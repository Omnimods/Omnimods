RecGen:import("automation-science-pack"):
    setEnabled(false):
    setOrder("ab[automation-science-pack]"):
    setTechName("automation-science-pack"):
    setTechLocName("automation-science-pack"):
    setTechIcons(omni.lib.icon.of("automation-science-pack","tool")):
    setTechPacks({{"energy-science-pack", 1}}):
    setTechCost(60):
    setTechPrereq("omnitech-anbaric-inserter","omnitech-anbaric-lab","omnitech-anbaric-mining"):
    extend()

--Create new "anbaric" electronic tech which unlocks electornic circuits and other early entities that are enabled by default
TechGen:create("omnimatter_energy","omnitech-anbaric-electronics"):
    setCost(35):
    setIcons({{icon = "__omnimatter_energy__/graphics/technology/anbaric-electronics.png", icon_size=256}}):
    setPacks({{"energy-science-pack", 1}}):
    setPrereq("omnitech-anbaricity"):
    extend()

--Check if enabled before adding, could be behind a later tech (bobs), replacements are added in compat files
if omni.lib.recipe_is_enabled("electronic-circuit") then omni.lib.add_unlock_recipe("omnitech-anbaric-electronics", "electronic-circuit") end
if omni.lib.recipe_is_enabled("radar") then omni.lib.add_unlock_recipe("omnitech-anbaric-electronics", "radar") end

RecGen:import("inserter"):
    setIngredients({"burner-inserter",1},{"anbaric-omnitor",1},{component["circuit"][1],1}):
    setEnabled(false):
    setTechName("omnitech-anbaric-inserter"):
    setTechCost(45):
    setTechIcons("electric-inserter","omnimatter_energy"):
    setTechPacks({{"energy-science-pack", 1}}):
    setTechPrereq("omnitech-anbaric-electronics"):
    extend()

RecGen:import("electric-mining-drill"):
    ifSetIngredients(not (mods["angelsindustries"] and angelsmods.industries.components),
    {
        {type="item", name="iron-gear-wheel", amount=4},
        {type="item", name="anbaric-omnitor", amount=2},
        {type="item", name="burner-mining-drill", amount=1}}):
    setEnabled(false):
    setTechName("omnitech-anbaric-mining"):
    setTechCost(40):
    setTechIcons("mining-drill","omnimatter_energy"):
    setTechPacks({{"energy-science-pack", 1}}):
    setTechPrereq("omnitech-anbaricity"):
    extend()

RecGen:import("boiler"):
    addIngredients("omni-heat-burner"):
    setEnabled(false):
    setTechName("omnitech-steam-power"):
    setTechCost(120):
    setTechLocName("omnitech-steam-power"):
    setTechPrereq("automation-science-pack","omnitech-basic-omnium-power"):
    setTechIcons("steam-power","omnimatter_energy"):
    setTechPacks(1):
    extend()

RecGen:import("steam-engine"):
    ifSetIngredients(not (mods["angelsindustries"] and angelsmods.industries.components),
    {
        {type="item", name="iron-plate", amount=10},
        {type="item", name="iron-gear-wheel", amount=5},
        {type="item", name="anbaric-omnitor", amount=3},
        {type="item",name="omni-heat-burner",amount=1}}):
    equalize("omni-heat-burner"):
    setEnabled(false):
    setTechName("omnitech-steam-power"):
    extend()



--Check if the vanilla lab is locked behind a tech /disabled. If yes, modify the tech
if data.raw.recipe["lab"].enabled == false then
    RecGen:import("lab"):
        setTechLocName("omnitech-anbaric-lab"):
        addIngredients({"omnitor-lab",1}):
        setTechIcons("lab","omnimatter_energy"):
        setTechCost(45):
        setTechPrereq("omnitech-anbaric-electronics"):
        extend()

    --omni.lib.add_prerequisite(omni.lib.get_tech_name("lab"), "omnitech-anbaric-electronics")
else
--Create a new tech
    RecGen:import("lab"):
        setEnabled(false):
        setTechName("omnitech-anbaric-lab"):
        setTechLocName("omnitech-anbaric-lab"):
        addIngredients({"omnitor-lab",1}):
        setTechCost(45):
        setTechIcons("lab","omnimatter_energy"):
        setTechPacks({{"energy-science-pack", 1}}):
        setTechPrereq("omnitech-anbaric-electronics"):
        extend()
end

--Move logi SP behind electronics (seems weird if it just prereqs automation SP)
omni.lib.add_prerequisite("logistic-science-pack", "electronics")

--Some vanilla techs to move from red to energy SP that are required early(turrets,walls,...)
omni.lib.replace_science_pack("gun-turret", "automation-science-pack", "energy-science-pack")
omni.lib.replace_science_pack("stone-wall", "automation-science-pack", "energy-science-pack")
omni.lib.replace_science_pack("military", "automation-science-pack", "energy-science-pack")

--Move gun turret tech behind military
omni.lib.add_prerequisite("gun-turret", "military")

local function get_packs(tier)
    local c = {}
    local length = math.min(tier,#omni.sciencepacks)
    for l=1,length do
        c[#c+1] = {omni.sciencepacks[l],1}
    end
    return c
end

data:extend({
    { 
        type = "technology",
        name = "omnitech-omnium-power-1",
        localised_name = {"technology-name.omnitech-omnium-power-1"},
        localised_description = {"technology-description.omnitech-omnium-power-1"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-basic-omnium-power",
            "automation-science-pack"
        },
        effects =
        {
        },
        unit =
        {
            count = 80,
            ingredients = get_packs(1),
            time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnitech-omnium-power-2",
        localised_name = {"technology-name.omnitech-omnium-power-2"},
        localised_description = {"technology-description.omnitech-omnium-power-2"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-omnium-power-1",
        },
        effects =
        {
        },
        unit =
        {
            count = 160,
            ingredients = get_packs(2),
            time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnitech-omnium-power-3",
        localised_name = {"technology-name.omnitech-omnium-power-3"},
        localised_description = {"technology-description.omnitech-omnium-power-3"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-omnium-power-2",
        },
        effects =
        {
        },
        unit =
        {
            count = 175,
            ingredients = get_packs(3),
            time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnitech-omnium-power-4",
        localised_name = {"technology-name.omnitech-omnium-power-4"},
        localised_description = {"technology-description.omnitech-omnium-power-4"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-omnium-power-3",
        },
        effects =
        {
        },
        unit =
        {
            count = 250,
            ingredients = get_packs(4),
            time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnitech-omnium-power-5",
        localised_name = {"technology-name.omnitech-omnium-power-5"},
        localised_description = {"technology-description.omnitech-omnium-power-5"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-omnium-power-4",
        },
        effects =
        {
        },
        unit =
        {
            count = 400,
            ingredients = get_packs(5),
            time = 30
        },
        order = "c-a"
    },
    {
        type = "technology",
        name = "omnitech-omni-solar-road",
        localised_name = {"technology-name.omnitech-omni-solar-road"},
        icon = "__omnimatter_energy__/graphics/technology/omni-solar-road.png",
        icon_size = 128,
        prerequisites =
        {
            "concrete",
            "omnitech-crystal-solar-panel-tier-"..settings.startup["omnielectricity-solar-tiers"].value.."-size-"..settings.startup["omnielectricity-solar-size"].value,
            "space-science-pack",
        },
        effects =
        {
            {type = "unlock-recipe",recipe = "omni-solar-road"}
        },
        unit =
        {
            count = 2000,
            ingredients = get_packs(6),
            time = 30
        },
        order = "c-a"
    },
})