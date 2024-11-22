TechGen:import("automation-science-pack"):
    setTrigger():
    setPacks({"energy-science-pack", 1}):
    setCost(60):
    setPrereq("electric-mining-drill", "electronics"):
    extend()

--Create new "anbaric" electronic tech which unlocks electornic circuits and other early entities that are enabled by default
TechGen:import("electronics"):
    setCost(35):
    setTrigger():
    setPacks({"energy-science-pack", 1}):
    setPrereq("omnitech-anbaricity"):
    extend()

RecGen:import("inserter"):
    setIngredients({"burner-inserter",1},{"anbaric-omnitor",1},{component["circuit"][1],1}):
    extend()

RecGen:import("electric-mining-drill"):
    ifSetIngredients(not (mods["angelsindustries"] and angelsmods.industries.components),
    {
        {type="item", name="iron-gear-wheel", amount=4},
        {type="item", name="anbaric-omnitor", amount=2},
        {type="item", name="burner-mining-drill", amount=1}}):
    setTechCost(40):
    setTechPacks({"energy-science-pack", 1}):
    setTechPrereq("omnitech-anbaricity"):
    extend()

TechGen:import("electric-mining-drill"):
    setCost(40):
    setPacks({"energy-science-pack", 1}):
    setPrereq("omnitech-anbaricity"):
    extend()


TechGen:import("steam-power"):
    setTrigger():
    setPacks(1):
    setCost(120):
    setPrereq("automation-science-pack","omnitech-basic-omnium-power"):
    extend()

RecGen:import("boiler"):
    addIngredients("omni-heat-burner"):
    extend()

RecGen:import("steam-engine"):
    ifSetIngredients(not (mods["angelsindustries"] and angelsmods.industries.components), {
        {type="item", name="iron-plate", amount=10},
        {type="item", name="iron-gear-wheel", amount=5},
        {type="item", name="anbaric-omnitor", amount=3},
        {type="item",name="omni-heat-burner",amount=1}
    }):
    extend()

RecGen:import("lab"):
    addIngredients({"omnitor-lab",1}):
    extend()

--Some vanilla techs to move from red to energy SP that are required early(turrets,walls,...)
omni.lib.replace_science_pack("gun-turret", "automation-science-pack", "energy-science-pack")
omni.lib.replace_science_pack("stone-wall", "automation-science-pack", "energy-science-pack")
omni.lib.replace_science_pack("military", "automation-science-pack", "energy-science-pack")

--Move gun turret tech behind military
omni.lib.replace_prerequisite("military", "automation-science-pack", "omnitech-energy-science-pack")
omni.lib.replace_prerequisite("gun-turret", "automation-science-pack", "military")
omni.lib.replace_prerequisite("stone-wall", "automation-science-pack", "omnitech-energy-science-pack")
omni.lib.replace_prerequisite("omnitech-omnium-processing", "automation-science-pack", "omnitech-energy-science-pack")

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