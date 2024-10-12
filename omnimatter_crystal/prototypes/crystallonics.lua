
local water = "water"
if mods["angelsrefining"] then water = "water-purified" end

RecGen:create("omnimatter_crystal","hydromnic-acid"):
    fluid():
    setBothColour(1,1,1):
    setEnergy(1):
    setIcons({"hydromnic-acid", 32}):
    setCategory("omniplant"):
    setSubgroup("crystal-fluids"):
    setTechName("omnitech-omnic-acid-hydrolyzation-1"):
    setIngredients({
        {type = "item", name = "omnite", amount = 1},
        {type = "fluid", name = "omnic-acid", amount = 50},
        {type = "fluid", name = water, amount = 200},
    }):
    setResults({type = "fluid", name = "hydromnic-acid", amount = 500}):extend()

--[[                         ]]
--[[         Omnine          ]]
--[[                         ]]

RecGen:create("omnimatter_crystal","omnine"):
    setSubgroup("omnine"):
    setCategory("omniplant"):
    setEnergy(10):
    setIcons({"omnine", 32}):
    setStacksize(200):
    --setFuelValue(18):
    --setFuelCategory("crystal"):
    setTechName("omnitech-crystallology-1"):
    setIngredients({
    {type = "item", name = "omnine-shards", amount=1},
    {type = "fluid", name = "omnisludge", amount=100},
    }):
    setResults({type = "item", name = "omnine", amount=5}):
    extend()

RecGen:create("omnimatter_crystal","omnine-distillation-quick"):
    setSubgroup("omnine"):
    setCategory("omniplant"):
    setEnergy(180):
    setTechName("omnitech-crystallology-1"):
    setIngredients({type = "fluid", name = "omnisludge", amount=20000}):
    setResults({type = "item", name = "omnine", amount=1}):
    extend()

RecGen:create("omnimatter_crystal","omnine-distillation-slow"):
    setSubgroup("omnine"):
    setCategory("omniplant"):
    setEnergy(1800):
    setTechName("omnitech-crystallology-1"):
    setIngredients({type = "fluid", name = "omnisludge", amount=2000}):
    setResults({type = "item", name = "omnine", amount=1}):
    extend()

local cat = "ore-refining-t1"
if not mods["angelsrefining"] then cat = nil end

RecGen:create("omnimatter_crystal","omnine-shards"):
    setSubgroup("omnine"):
    setIcons({"omnine-shards", 32}):
    setCategory(cat):
    setStacksize(200):
    --setFuelValue(3.5):
    --setFuelCategory("crystal"):
    setEnergy(1):
    setTechName("omnitech-crystallology-1"):
    setIngredients({type = "item", name = "omnine", amount=1}):
    setResults({type = "item", name = "omnine-shards", amount=10}):
    extend()


--[[                         ]]
--[[      Crystallonics      ]]
--[[          Parts          ]]
--[[                         ]]

local crystal_cat = "crystallomnizer"
if mods["bobplates"] or (mods["angelsindustries"] and angelsmods.industries and angelsmods.industries.overhaul) then
    ore_circuit = "lead-ore"
    cry_rod = "tin-ore-crystal"
else
    ore_circuit = "coal"
    cry_rod = "copper-ore-crystal"
end


RecGen:create("omnimatter_crystal","crystal-rod"):
    setEnergy(1):
    setIcons({"crystal-rod", 32}):
    setStacksize(100):
    setSubgroup("crystal-part"):
    setOrder("aa-[crystal-rod]"):
    setCategory("crystallomnizer"):
    setTechName("omnitech-crystallonics-1"):
    addProductivity():
    setIngredients({type="item",name= cry_rod ,amount=2}):
    setResults({type="item",name="crystal-rod",amount=3}):
    extend()

RecChain:create("omnimatter_crystal","pseudoliquid-amorphous-crystal"):
    fluid():
    setBothColour(1,0,1):
    setEnergy(function(levels,grade) return 0.5+grade/2 end):
    setIcons({"pseudoliquid-amorphous-crystal", 32}):
    setSubgroup("crystal-part"):
    setCategory("crystallomnizer"):
    setIngredients({type="item",name="omnine",amount=12}):
    setResults(function (levels,grade) return {{type="fluid",name="pseudoliquid-amorphous-crystal",amount=240+2160*(grade-1)/levels}} end):
    setLevel(omni.fluid_levels):
    setTechName("omnitech-pseudoliquid-amorphous-crystal"):
    setTechLocName("omnitech-pseudoliquid-amorphous-crystal",function (levels,grade) return grade end):
    setTechIcons("amorphous-crystal","omnimatter_crystal"):
    setTechCost(function(levels,grade) return 500+50*grade end):
    setTechPacks(function(levels,grade) return 3+math.floor(grade*3/levels) end):
    setTechTime(60):
    setTechPrereq(function(levels,grade)
        local req = {}
        if grade==1 then
            req={"omnitech-crystallonics-1"}
        else
            req={"omnitech-pseudoliquid-amorphous-crystal-"..grade-1}
        end
        local c = omni.lib.round(levels/3)
        if grade%c==0 and grade>1 and grade <= omni.max_tier then
            req[#req+1]="omnitech-crystallonics-"..math.floor(grade/c)+1
        end
        return req
    end):
    extend()

RecGen:create("omnimatter_crystal","shattered-omnine"):
    setEnergy(0.5):
    setIcons({"shattered-omnine", 32}):
    setStacksize(600):
    setSubgroup("crystal-part"):
    addProductivity():
    setCategory(cat):
    setTechName("omnitech-crystallonics-2"):
    setIngredients({type="item",name="omnine",amount=2}):
    setResults({type="item",name="shattered-omnine",amount=3}):
    extend()

RecGen:create("omnimatter_crystal","impure-crystal-rod"):
    setEnergy(2):
    setIcons({"impure-crystal-rod", 32}):
    setStacksize(150):
    setSubgroup("crystal-part"):
    setOrder("ab-[impure-crystal-rod]"):
    setCategory("crystallomnizer"):
    addProductivity():
    setTechName("omnitech-crystallonics-2"):
    setIngredients({
        {type="item",name="shattered-omnine",amount=1},
        {type="fluid",name="pseudoliquid-amorphous-crystal",amount=150},
        {type="item",name=ore_circuit,amount=2}
    }):
    setResults({type="item",name="impure-crystal-rod",amount=3}):
    extend()

RecGen:create("omnimatter_crystal","fragment-iron-crystal"):
    setEnergy(2):
    setIcons({"fragment-iron-crystal", 32}):
    setStacksize(400):
    setSubgroup("crystal-part"):
    setCategory("advanced-crafting"):
    addProductivity():
    setTechName("omnitech-crystallonics-2"):
    setIngredients({type="item",name="iron-ore-crystal",amount=1}):
    setResults({type="item",name="fragmented-iron-crystal",amount=3}):
    extend()

RecGen:create("omnimatter_crystal","fragment-copper-crystal"):
    setEnergy(2):
    setIcons({"fragment-copper-crystal", 32}):
    setStacksize(400):
    setSubgroup("crystal-part"):
    setCategory("advanced-crafting"):
    addProductivity():
    setTechName("omnitech-crystallonics-2"):
    setIngredients({type="item",name="copper-ore-crystal",amount=1}):
    setResults({type="item",name="fragmented-copper-crystal",amount=3}):
    extend()

RecGen:create("omnimatter_crystal","omnilgium"):
    setEnergy(3):
    setIcons({"omnilgium", 32}):
    setStacksize(400):
    setSubgroup("crystal-part"):
    setTechName("omnitech-crystallonics-2"):
    addProductivity():
    setCategory("crystallomnizer"):
    setIngredients({
        {type="item",name="fragmented-copper-crystal",amount=2},
        {type="item",name="fragmented-iron-crystal",amount=2},
        {type="fluid",name="pseudoliquid-amorphous-crystal",amount=100},
    }):
    setResults({type="item",name="omnilgium",amount=2}):
    extend()

RecGen:create("omnimatter_crystal","quasi-solid-omnistal"):
    setEnergy(1):
    setIcons({"quasi-solid-omnistal", 32}):
    setStacksize(200):
    setSubgroup("crystal-part"):
    setCategory("crystallomnizer"):
    setTechName("omnitech-crystallonics-2"):
    addProductivity():
    setIngredients({
        {type="item",name="shattered-omnine",amount=1},
        {type="fluid",name="pseudoliquid-amorphous-crystal",amount=20},
    }):
    setResults({type="item",name="quasi-solid-omnistal",amount=5}):
    extend()
    
--[[                         ]]
--[[      Crystals           ]]
--[[                         ]]


RecGen:create("omnimatter_crystal","omnine-structure-crystal"):
    setEnergy(1):
    setIcons({"omnine-structure-crystal", 32}):
    setStacksize(100):
    setSubgroup("crystal"):
    setOrder("aa-[omnine-structure-crystal]"):
    setCategory("crystallomnizer"):
    addProductivity():
    setTechName("omnitech-crystallonics-1"):
    setIngredients({type="item",name="omnine",amount=3}):
    setResults({type="item",name="omnine-structure-crystal",amount=2}):
    extend()

RecGen:create("omnimatter_crystal","oscillocrystal"):
    setEnergy(3):
    setIcons({"oscillocrystal", 32}):
    setStacksize(500):
    setSubgroup("crystal"):
    setOrder("av-[oscillocrystal"):
    setCategory("crystallomnizer"):
    addProductivity():
    setTechName("omnitech-crystallonics-2"):
    setIngredients({
        {type="item",name="impure-crystal-rod",amount=3},
        {type="item",name="omnilgium",amount=2},
    }):
    setResults({type="item",name="oscillocrystal",amount=5}):
    extend()

RecGen:create("omnimatter_crystal","electrocrystal"):
    setEnergy(2):
    setIcons({"electrocrystal", 32}):
    setStacksize(500):
    setSubgroup("crystal"):
    setOrder("ac-[electrocrystal]"):
    setCategory("crystallomnizer"):
    setTechName("omnitech-crystallonics-3"):
    addProductivity():
    setIngredients({
        {type="item",name="impure-crystal-rod",amount=3},
        {type="item",name="omnilgium",amount=2},
        {type="item",name="crystal-rod",amount=2},
    }):
    setResults({type="item",name="electrocrystal",amount=6}):
    extend()


--[[                         ]]
--[[      Crystallonics      ]]
--[[                         ]]


RecGen:create("omnimatter_crystal","basic-crystallonic"):
    setEnergy(1):
    setIcons({"basic-crystallonic", 32}):
    setStacksize(200):
    setSubgroup("crystallonic"):
    setOrder("aa-[basic-crystallonic]"):
    setTechName("omnitech-crystallonics-1"):
    setCategory("crystallomnizer"):
    addProductivity():
    setIngredients({
        {type="item",name="omnine-structure-crystal",amount=1},
        {type="item",name="crystal-rod",amount=2}
    }):
    setResults({type="item",name="basic-crystallonic",amount=1}):
    extend()

RecGen:create("omnimatter_crystal","basic-oscillo-crystallonic"):
    setEnergy(1):
    setIcons({"basic-oscillo-crystallonic", 32}):
    setStacksize(200):
    setSubgroup("crystallonic"):
    setOrder("ab-[basic-oscillo-crystallonic]"):
    setCategory("crystallomnizer"):
    setTechName("omnitech-crystallonics-2"):
    addProductivity():
    setIngredients({
        {type="item",name="basic-crystallonic",amount=1},
        {type="item",name="quasi-solid-omnistal",amount=2},
        {type="item",name="oscillocrystal",amount=1}
    }):
    setResults({type="item",name="basic-oscillo-crystallonic",amount=1}):
    extend()

--TODO Add this, electrocrystals have no usage atm.
-- RecGen:create("omnimatter_crystal","basic-electro-crystallonic"):
--     setEnergy(1):
--     setStacksize(200):
--     setSubgroup("crystallonic"):
--     setOrder("ac-[basic-electro-crystallonic]"):
--     setCategory("crystallomnizer"):
--     setTechName("omnitech-crystallonics-2"):
--     addProductivity():
--     setIngredients({
--         {type="item",name="basic-crystallonic",amount=1},
--         {type="item",name="quasi-solid-omnistal",amount=2},
--         {type="item",name="electrocrystal",amount=1}
--     }):
--     setResults({type="item",name="basic-oscillo-crystallonic",amount=1}):
--     extend()


if omni.rocket_locked then
    local i = 1
    while data.raw.technology["omnitech-pseudoliquid-amorphous-crystal-"..i+1] do
        i=i+1
    end
    omni.lib.add_prerequisite("rocket-silo","omnitech-pseudoliquid-amorphous-crystal-"..i)
end

if data.raw.item["tin-ore"] and data.raw.item["tin-ore-crystal"] then
    omni.lib.replace_recipe_ingredient("crystal-rod","copper-ore-crystal","tin-ore-crystal")
end
