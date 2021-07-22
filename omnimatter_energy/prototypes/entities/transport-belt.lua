---------------
-----Items-----
---------------

local ibelt = table.deepcopy(data.raw.item["transport-belt"])
ibelt.name = "basic-transport-belt"
ibelt.icon = "__omnimatter_energy__/graphics/icons/basic-transport-belt.png"
ibelt.order = "a[basic-transport-belt]-a[basic-transport-belt]"
ibelt.place_result = "basic-transport-belt"

local iunder = table.deepcopy(data.raw.item["underground-belt"])
iunder.name = "basic-underground-belt"
iunder.icon = "__omnimatter_energy__/graphics/icons/basic-underground-belt.png"
iunder.order = "b[basic-underground-belt]-a[basic-underground-belt]"
iunder.place_result = "basic-underground-belt"

local isplitter = table.deepcopy(data.raw.item["splitter"])
isplitter.name = "basic-splitter"
isplitter.icon = "__omnimatter_energy__/graphics/icons/basic-splitter.png"
isplitter.order = "c[basic-splitter]-a[basic-splitter]"
isplitter.place_result = "basic-splitter"

data:extend({ibelt, iunder, isplitter})


------------------
-----Entities-----
------------------
--Basic Belt
local ebelt = table.deepcopy(data.raw["transport-belt"]["transport-belt"])
ebelt.name = "basic-transport-belt"
ebelt.belt_animation_set.animation_set.filename = "__omnimatter_energy__/graphics/entity/basic-transport-belt/basic-transport-belt.png"
ebelt.belt_animation_set.animation_set.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-transport-belt/hr-basic-transport-belt.png"
ebelt.corpse = "basic-transport-belt-remnants"

ebelt.icon = "__omnimatter_energy__/graphics/icons/basic-transport-belt.png"
ebelt.minable.result = "basic-transport-belt"
ebelt.next_upgrade = "transport-belt"
ebelt.related_underground_belt = "basic-underground-belt"
ebelt.speed = 0.015625

--Baic UG
local eunder= table.deepcopy(data.raw["underground-belt"]["underground-belt"])
eunder.name = "basic-underground-belt"
eunder.belt_animation_set.animation_set.filename = "__omnimatter_energy__/graphics/entity/basic-transport-belt/basic-transport-belt.png"
eunder.belt_animation_set.animation_set.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-transport-belt/hr-basic-transport-belt.png"
eunder.corpse = "basic-underground-belt-remnants"

eunder.structure.direction_in.sheet.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/basic-underground-belt-structure.png"
eunder.structure.direction_in.sheet.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/hr-basic-underground-belt-structure.png"
eunder.structure.direction_in_side_loading.sheet.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/basic-underground-belt-structure.png"
eunder.structure.direction_in_side_loading.sheet.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/hr-basic-underground-belt-structure.png"
eunder.structure.direction_out.sheet.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/basic-underground-belt-structure.png"
eunder.structure.direction_out.sheet.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/hr-basic-underground-belt-structure.png"
eunder.structure.direction_out_side_loading.sheet.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/basic-underground-belt-structure.png"
eunder.structure.direction_out_side_loading.sheet.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/hr-basic-underground-belt-structure.png"

eunder.icon = "__omnimatter_energy__/graphics/icons/basic-underground-belt.png"
eunder.minable.result = "basic-underground-belt"
eunder.next_upgrade = "underground-belt"
eunder.speed = 0.015625
eunder.max_distance = 2

--Basic splitter
local esplitter= table.deepcopy(data.raw["splitter"]["splitter"])
esplitter.name = "basic-splitter"
esplitter.belt_animation_set.animation_set.filename = "__omnimatter_energy__/graphics/entity/basic-transport-belt/basic-transport-belt.png"
esplitter.belt_animation_set.animation_set.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-transport-belt/hr-basic-transport-belt.png"
esplitter.corpse = "basic-splitter-remnants"

esplitter.structure.east.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/basic-splitter-east.png"
esplitter.structure.east.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/hr-basic-splitter-east.png"
esplitter.structure.north.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/basic-splitter-north.png"
esplitter.structure.north.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/hr-basic-splitter-north.png"
esplitter.structure.south.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/basic-splitter-south.png"
esplitter.structure.south.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/hr-basic-splitter-south.png"
esplitter.structure.west.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/basic-splitter-west.png"
esplitter.structure.west.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/hr-basic-splitter-west.png"
esplitter.structure_patch.east.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/basic-splitter-east-top_patch.png"
esplitter.structure_patch.east.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/hr-basic-splitter-east-top_patch.png"
esplitter.structure_patch.west.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/basic-splitter-west-top_patch.png"
esplitter.structure_patch.west.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/hr-basic-splitter-west-top_patch.png"

esplitter.icon = "__omnimatter_energy__/graphics/icons/basic-splitter.png"
esplitter.minable.result = "basic-splitter"
esplitter.next_upgrade = "splitter"
esplitter.speed = 0.015625

data:extend({ebelt, eunder, esplitter})


------------------
-----Remnants-----
------------------
--Basic Belt
local rbelt= table.deepcopy(data.raw["corpse"]["transport-belt-remnants"])
rbelt.name = "basic-transport-belt-remnants"
rbelt.icon = "__omnimatter_energy__/graphics/icons/basic-transport-belt.png"
rbelt.animation = make_rotated_animation_variations_from_sheet (2,
{
    filename = "__omnimatter_energy__/graphics/entity/basic-transport-belt/remnants/basic-transport-belt-remnants.png",
    line_length = 1,
    width = 54,
    height = 52,
    frame_count = 1,
    variation_count = 1,
    axially_symmetrical = false,
    direction_count = 4,
    shift = util.by_pixel(1, 0),
    hr_version =
    {
        filename = "__omnimatter_energy__/graphics/entity/basic-transport-belt/remnants/hr-basic-transport-belt-remnants.png",
        line_length = 1,
        width = 106,
        height = 102,
        frame_count = 1,
        variation_count = 1,
        axially_symmetrical = false,
        direction_count = 4,
        shift = util.by_pixel(1, -0.5),
        scale = 0.5
    }
})

--Basic UG
local runder= table.deepcopy(data.raw["corpse"]["underground-belt-remnants"])
runder.name = "basic-underground-belt-remnants"
runder.icon = "__omnimatter_energy__/graphics/icons/basic-underground-belt.png"
runder.animation.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/remnants/basic-underground-belt-remnants.png"
runder.animation.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-underground-belt/remnants/hr-basic-underground-belt-remnants.png"


--Basic Splitter
local rsplitter= table.deepcopy(data.raw["corpse"]["splitter-remnants"])
rsplitter.name = "basic-splitter-remnants"
rsplitter.icon = "__omnimatter_energy__/graphics/icons/basic-splitter.png"
rsplitter.animation.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/remnants/basic-splitter-remnants.png"
rsplitter.animation.hr_version.filename = "__omnimatter_energy__/graphics/entity/basic-splitter/remnants/hr-basic-splitter-remnants.png"

data:extend({rbelt, runder, rsplitter})


-----------------
-----Recipes-----
-----------------
--Nil logistics-0 if it already exists, RecGen doesnt overwrite tech values atm for some reason
if data.raw.technology["logistics-0"] then data.raw.technology["logistics-0"] = nil end

RecGen:create("omnimatter_energy", "basic-transport-belt"):
    setIngredients({"omnicium-gear-wheel", 1}, {"omni-tablet", 1}):
    setResults({"basic-transport-belt", 2}):
    setSubgroup("belt"):
    setEnergy(0.5):
    setIcons({{icon = "basic-transport-belt", icon_size = 64}}, "omnimatter_energy"):
    setOrder("a[basic-transport-belt]-a[basic-transport-belt]"):
    setEnabled(false):
    setTechName("logistics-0"):
    setTechLocName("technology-name.logistics-0"):
    setTechIcons("logistics","omnimatter_energy"):
    setTechPacks({{"energy-science-pack", 1}}):
    setTechCost(15):
    setTechPrereq("omnitech-simple-automation"):
    extend()

RecGen:create("omnimatter_energy", "basic-underground-belt"):
    setIngredients({"basic-transport-belt", 5}, {"omnicium-plate", 10}):
    setResults({"basic-underground-belt", 2}):
    setSubgroup("belt"):
    setEnergy(0.5):
    setIcons({{icon = "basic-underground-belt", icon_size = 64}}, "omnimatter_energy"):
    setOrder("b[basic-underground-belt]-a[basic-underground-belt]"):
    setTechName("basic-underground-logistics"):
    setTechIcons("logistics","omnimatter_energy"):
    setTechPacks({{"energy-science-pack", 1}}):
    setTechCost(20):
    setTechPrereq("logistics-0"):
    extend()

RecGen:create("omnimatter_energy", "basic-splitter"):
    setIngredients({"basic-transport-belt", 4}, {"omnicium-iron-gear-box", 2}, {"omnicium-gear-wheel", 4}):
    setResults({"basic-splitter", 1}):
    setSubgroup("belt"):
    setEnergy(0.5):
    setIcons({{icon = "basic-splitter", icon_size = 64}}, "omnimatter_energy"):
    setOrder("c[basic-splitter]-a[basic-splitter]"):
    setTechName("basic-splitter-logistics"):
    setTechIcons("logistics","omnimatter_energy"):
    setTechPacks({{"energy-science-pack", 1}}):
    setTechCost(20):
    setTechPrereq("logistics-0"):
    extend()


-----------------------------------------
-----Modify higher tier belt recipes-----
-----------------------------------------

--Create seperate techs for Belt, Splitter and UG TODO Create 7.5 speed belt like bob???
RecGen:import("transport-belt"):
    setEnabled(false):
    setTechName("logistics"):
    setTechPrereq("automation-science-pack"):
    setIngredients(
        {"basic-transport-belt", 1}, {"omnitor", 1}):
    extend()

RecGen:import("underground-belt"):
    setIngredients({"basic-underground-belt", 2}, {"iron-gear-wheel", 20}):
    extend()

RecGen:import("splitter"):
    setIngredients({"basic-splitter", 1}, {"iron-gear-wheel", 5}, {"electronic-circuit", 5}):
    extend()