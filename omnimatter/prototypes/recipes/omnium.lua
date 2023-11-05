RecGen:create("omnimatter","omnicium-plate"):
    setItemName("omnicium-plate"):
    setIcons("omnicium-plate","omnimatter"):
    setStacksize(200):
    setIngredients({normal = {{"omnite",2},{"stone-crushed",2}},expensive={{"omnite",3},{"stone-crushed",3}}}):
    ifSetIngredients(mods["angelsrefining"],{normal={{"omnite",3},{"stone-crushed",4}},expensive={{"omnite",4},{"stone-crushed",6}}}):
    setResults({normal = {{"omnicium-plate", 2}},expensive={{"omnicium-plate",2}}}):
    setCategory("smelting"):
    setSubgroup("omnium"):
    setOrder("ab"):
    setEnergy(1.6):
    setEnabled():
    extend()

--Starter Recipe. Can be made in a normal furnace (And a backup to not get stuck when losing the omnifurnace)
RecGen:create("omnimatter","omnicium-plate-pure"):
    setItemName("omnicium-plate"):
    setStacksize(200):
    setIngredients({normal = {{"crushed-omnite",25}},expensive={{"crushed-omnite",40}}}):
    setResults("omnicium-plate"):
    setIcons("omnicium-plate","omnimatter"):
    addSmallIngIcon(1,3):
    setCategory("smelting"):
    setSubgroup("omnium"):
    setOrder("aa"):
    setEnergy(10):
    setEnabled():
    extend()


--Replace iron plates with omnicium plates for vanilla burner entities
omni.lib.replace_recipe_ingredient("burner-inserter", "iron-plate", {"omnicium-plate", 2})
omni.lib.replace_recipe_ingredient("burner-mining-drill", "iron-plate", {"omnicium-plate", 6})

ItemGen:create("omnimatter","omnium-plate"):
    setIcons("omnium-plate","omnimatter"):
    setStacksize(200):
    setSubgroup("omnium"):
    setOrder("ac"):
    extend()

RecGen:create("omnimatter","omnium-plate-mix"):
    setIngredients({"omnite",2}):
    ifModsAddIngredients("angelsrefining",{"angels-ore1-crushed",2},{"angels-ore3-crushed",2}):
    ifAddIngredients(not mods["angelsrefining"],{"copper-ore",1},{"iron-ore",1}):
    setResults({normal = {{"omnium-plate", 2}},expensive={{"omnium-plate",1}}}):
    addProductivity():
    setIcons("omnium-plate","omnimatter"):
    addSmallIngIcon(2,1):
    addSmallIngIcon(3,3):
    setCategory("omnifurnace"):
    setSubgroup("omnium"):
    setOrder("ac"):
    setEnergy(5):
    setTechName("omnitech-omnium-processing"):
    setTechIcons("omnium-plate", 32):
    setTechPacks(1):
    setTechCost(15):
    --setTechPrereq("omnitech-angels-omnium-smelting-1"):
    extend()

--Move Steel tech behind omnicium
omni.lib.add_prerequisite("steel-processing", "omnitech-omnium-processing")

RecGen:create("omnimatter","omnium-gear-wheel"):
    setStacksize(100):
    setIngredients({normal = {{"omnium-plate", 1}},expensive={{"omnium-plate",2}}}):
    setResults({normal = {{"omnium-gear-wheel", 1}},expensive={{"omnium-gear-wheel",1}}}):
    addProductivity():
    setSubgroup("omni-gears"):
    setOrder("aa"):
    setTechName("omnitech-omnium-processing"):
    setEnergy(1):
    extend()

RecGen:create("omnimatter","omnium-iron-gear-box"):
    setStacksize(100):
    setSubgroup("omni-gears"):
    setIngredients({"omnium-gear-wheel", 1},{"iron-gear-wheel", 1}):
    addProductivity():
    setTechName("omnitech-omnium-processing"):
    setEnergy(0.25):
    extend()

if mods["bobplates"] then
    local plates = {"steel","brass","titanium","tungsten","nitinol"}
    local plateTech = {"steel-processing","zinc-processing","titanium-processing","tungsten-processing","nitinol-processing"}

    for i,p in pairs(plates) do
        RecGen:create("omnimatter","omnium-"..p.."-gear-box"):
            setStacksize(100):
            setEnergy(0.25):
            addProductivity():
            setIngredients("omnium-gear-wheel",p.."-gear-wheel"):
            setCategory("crafting"):
            setSubgroup("omni-gears"):
            setTechName(plateTech[i]):
            extend()
    end

    data.raw.item["brass-gear-wheel"].icon="__omnimatter__/graphics/icons/brass-gear-wheel.png"
    data.raw.item["brass-gear-wheel"].icon_size=32
    data.raw.item["steel-gear-wheel"].icon="__omnimatter__/graphics/icons/steel-gear-wheel.png"
    data.raw.item["steel-gear-wheel"].icon_size=32
end

data.raw.item["iron-gear-wheel"].icons={{icon="__omnimatter__/graphics/icons/iron-gear-wheel.png",icon_size=32,mipmaps=1}}

if mods["angelssmelting"] then
    --Get rid of the ore processor 1 ingredient count limit to allow for omnium processing
    data.raw["assembling-machine"]["ore-processing-machine"].ingredient_count = 255

    ItemGen:import("ingot-iron"):
        setName("ingot-omnium","omnimatter"):
        setSubgroup("angels-omnium"):
        setIcons({{icon ="ingot-omnium", icon_size = 32}}, "omnimatter"):
        extend()

    RecGen:import("iron-ore-smelting"):
        setName("omnite-smelting","omnimatter"):
        setIngredients(
            {type="item", name="iron-ore", amount=12},
            {type="item", name="copper-ore", amount=12},
            {type="item", name="omnite", amount=24}):
        replaceResults("ingot-iron","ingot-omnium"):
        setSubgroup("angels-omnium"):
        setIcons("ingot-omnium","omnimatter"):
        addSmallIcon({{icon = "__omnilib__/graphics/icons/small/num_1.png", icon_size = 32, tint = {a=1,b=0,g=0.8,r=1}}}, 2):
        setTechName("omnitech-angels-omnium-smelting-1"):
        setTechLocName("technology-name.omnitech-angels-omnium-smelting-casting",1):
        setTechIcons("casting-omnium-tech", 256):
        extend()

    RecGen:import("molten-iron-smelting-1"):
        setName("molten-omnium-smelting-1","omnimatter"):
        setItemName("liquid-molten-omnium"):
        replaceIngredients("ingot-iron","ingot-omnium"):
        replaceResults("liquid-molten-iron","liquid-molten-omnium"):
        setSubgroup("omnium-casting"):
        setIcons({{icon = "molten-omnium", icon_size = 256}}, "omnimatter"):
        setBothColour({r = 125/255, g = 0/255, b = 161/255}):
        setTechName("omnitech-angels-omnium-smelting-1"):
        extend()

    RecGen:import("angels-plate-iron"):
        setName("angels-plate-omnium","omnimatter"):
        replaceIngredients("liquid-molten-iron","liquid-molten-omnium"):
        replaceResults("angels-plate-iron","omnium-plate"):
        setSubgroup("omnium-casting"):
        setIcons("omnium-plate","omnimatter"):
        addSmallIcon("molten-omnium",1):
        addProductivity():
        setTechName("omnitech-angels-omnium-smelting-1"):
        extend()

    RecGen:import("iron-ore-processing"):
        setName("omnium-processing","omnimatter"):
        setItemName("processed-omnium"):
        setIngredients({"iron-ore",2},{"copper-ore",2},{"omnite",4}):
        replaceResults("processed-iron","processed-omnium"):
        setSubgroup("angels-omnium"):
        setIcons("processed-omnium","omnimatter"):
        setTechName("omnitech-angels-omnium-smelting-2"):
        setTechPrereq("omnitech-angels-omnium-smelting-1", "ore-processing-1"):
        setTechIcons("smelting-omnium-tech", 256):
        extend()

    RecGen:import("processed-iron-smelting"):
        setName("processed-omnium-smelting","omnimatter"):
        setItemName("processed-omnium"):
        replaceIngredients("processed-iron","processed-omnium"):
        replaceIngredients("solid-coke",{type="fluid",name="omnic-acid",amount=40}):
        replaceResults("ingot-iron","ingot-omnium"):
        setSubgroup("angels-omnium"):
        setIcons("ingot-omnium","omnimatter"):
        addSmallIcon({{icon = "__omnilib__/graphics/icons/small/num_2.png", icon_size = 32, tint = {a=1,b=0,g=0.8,r=1}}}, 2):
        setTechName("omnitech-angels-omnium-smelting-2"):
        extend()

    RecGen:import("iron-processed-processing"):
        setName("omnium-processed-processing","omnimatter"):
        setItemName("pellet-omnium"):
        replaceIngredients("processed-iron","processed-omnium"):
        replaceResults("pellet-iron","pellet-omnium"):
        setSubgroup("angels-omnium"):
        setIcons("pellet-omnium","omnimatter"):
        setTechName("omnitech-angels-omnium-smelting-3"):
        setTechPrereq("omnitech-angels-omnium-smelting-2", "ore-processing-2"):
        setTechIcons("smelting-omnium-tech", 256):
        extend()

    RecGen:import("pellet-iron-smelting"):
        setName("pellet-omnium-smelting","omnimatter"):
        replaceIngredients("pellet-iron","pellet-omnium"):
        replaceIngredients("solid-limestone",{type="fluid", name="omnic-acid", amount = 30}):
        ifModsReplaceIngredients("omnimatter_crystal","solid-coke","omnine"):
        replaceResults("ingot-iron","ingot-omnium"):
        setSubgroup("angels-omnium"):
        setIcons("ingot-omnium","omnimatter"):
        addSmallIcon({{icon = "__omnilib__/graphics/icons/small/num_3.png", icon_size = 32, tint = {a=1,b=0,g=0.8,r=1}}}, 2):
        setTechName("omnitech-angels-omnium-smelting-3"):
        setTechIcons("smelting-omnium-tech", 256):
        extend()

    RecGen:import("roll-iron-casting"):
        setName("roll-omnium-casting","omnimatter"):
        setItemName("angels-roll-omnium"):
        replaceIngredients("liquid-molten-iron","liquid-molten-omnium"):
        replaceResults("angels-roll-iron","angels-roll-omnium"):
        setSubgroup("omnium-casting"):
        setIcons("roll-omnium","omnimatter"):
        addSmallIcon({{icon = "__omnilib__/graphics/icons/small/num_1.png", icon_size = 32, tint = {a=1,b=0,g=0.8,r=1}}}, 2):
        setTechName("omnitech-angels-omnium-smelting-2"):
        extend()

    RecGen:import("roll-iron-casting-fast"):
        setName("roll-omnium-casting-fast","omnimatter"):
        replaceIngredients("liquid-molten-iron","liquid-molten-omnium"):
        replaceResults("angels-roll-iron","angels-roll-omnium"):
        setSubgroup("omnium-casting"):
        setIcons("roll-omnium","omnimatter"):
        addSmallIcon({{icon = "__omnilib__/graphics/icons/small/num_2.png", icon_size = 32, tint = {a=1,b=0,g=0.8,r=1}}}, 2):
        setTechName("omnitech-angels-omnium-smelting-3"):
        extend()

    RecGen:import("angels-roll-iron-converting"):
        setName("angels-roll-omnium-converting","omnimatter"):
        replaceIngredients("angels-roll-iron","angels-roll-omnium"):
        replaceResults("angels-plate-iron","omnium-plate"):
        setSubgroup("omnium-casting"):
        setIcons("omnium-plate"):
        addSmallIcon("angels-roll-omnium", 2):
        setTechName("omnitech-angels-omnium-smelting-2"):
        extend()

    --Fix item icons
    ItemGen:import("angels-roll-omnium"):setIcons("roll-omnium","omnimatter"):extend()

    RecGen:create("omnimatter","omnium-gear-wheel-casting"):
        setStacksize(100):
        setSubgroup("omnium-casting"):
        setOrder("ub"):
        setIngredients({normal = {{type="fluid",name="liquid-molten-omnium",amount=40}},expensive={{type="fluid",name="liquid-molten-omnium",amount=40}}}):
        setCategory("casting"):
        setResults({normal = {{"omnium-gear-wheel", 6}},expensive={{"omnium-gear-wheel",6}}}):
        addProductivity():
        setEnergy(2):
        setTechName("omnitech-angels-omnium-smelting-1"):
        extend()

    data:extend({
        {
            type = "item-subgroup",
            name = "angels-omnium",
            group = "angels-smelting",
            order = "r",
        },
        {
            type = "item-subgroup",
            name = "omnium-casting",
            group = "angels-casting",
            order = "u",
        },
        {
            type = "item-subgroup",
            name = "omnium-alloy-casting",
            group = "angels-casting",
            order = "v",
        },
    })
    data.raw.item["omnium-plate"].subgroup = "omnium-casting"
end