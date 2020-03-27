local res = {}

RecGen:create("omnimatter","omnicium-plate-pure"):
	setItemName("omnicium-plate"):
	setIcons("omnicium-plate","omnimatter"):
	setStacksize(400):
	setIngredients({ "crushed-omnite", 10}):
	setResults("omnicium-plate"):
	setCategory("smelting"):
	setEnergy(5):
	setSubgroup("raw-material"):
	setEnabled():
	extend()

RecGen:create("omnimatter","omnicium-plate-mix"):
	setSubgroup("intermediate-product"):
	setIngredients({type="item", name="omnite",amount=4}):
	ifModsAddIngredients("angelsrefining",{"angels-ore1-crushed",4},{"angels-ore3-crushed",4}):
	ifAddIngredients(not mods["angelsrefining"],{"copper-ore",1},{"iron-ore",1}):
	setResults({type="item", name="omnicium-plate",amount=2}):
	addProductivity():
	setIcons("omnicium-plate","omnimatter"):
	addSmallIngIcon(2,1):
	addSmallIngIcon(3,3):
	setCategory("omnifurnace"):
	marathon():
	setEnergy(5):
	setEnabled():
	extend()

RecGen:create("omnimatter","omnicium-gear-wheel"):
	setStacksize(100):
	setSubgroup("intermediate-product"):
	setIngredients({normal = {{"omnicium-plate", 3}},expensive={{"omnicium-plate",2}}}):
	setResults({normal = {{"omnicium-gear-wheel", 2}},expensive={{"omnicium-gear-wheel",1}}}):
	addProductivity():
	setEnabled():
	setEnergy(1):
	extend()

RecGen:create("omnimatter","omnicium-iron-gear-box"):
	setStacksize(100):
	setSubgroup("intermediate-product"):
	setIngredients({"omnicium-gear-wheel", 1},{"iron-gear-wheel", 1}):
	addProductivity():
	setEnabled():
	setEnergy(0.25):
	extend()

BuildGen:create("omnimatter","omni-furnace"):
	setEnergy(5):
	setIngredients({ "omnicium-plate", 5},{ "stone-brick", 5},{ "stone-furnace", 1}):
	setStacksize(20):
	setSubgroup("omnitractor"):
	setSize(2):
	setCrafting("smelting","omnifurnace"):
	setUsage(45):
	setEnabled():
	setBurner(1,1):
	setAnimation({
      layers = {
        {
          filename = "__omnimatter__/graphics/entity/buildings/omni-furnace.png",
          priority = "high",
          width = 85,
          height = 87,
          frame_count = 1,
          shift = util.by_pixel(-1.5, 1.5),
          hr_version = {
            filename = "__omnimatter__/graphics/entity/buildings/hr-omni-furnace.png",
            priority = "high",
            width = 171,
            height = 174,
            frame_count = 1,
            shift = util.by_pixel(-1.25, 2),
            scale = 0.5
          }
        },
        {
          filename = "__base__/graphics/entity/steel-furnace/steel-furnace-shadow.png",
          priority = "high",
          width = 139,
          height = 43,
          frame_count = 1,
          draw_as_shadow = true,
          shift = util.by_pixel(39.5, 11.5),
          hr_version = {
            filename = "__base__/graphics/entity/steel-furnace/hr-steel-furnace-shadow.png",
            priority = "high",
            width = 277,
            height = 85,
            frame_count = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(39.25, 11.25),
            scale = 0.5
          }
        },
      },
    }):
	setWorkVis({
      {
        north_position = {0.0, 0.0},
        east_position = {0.0, 0.0},
        south_position = {0.0, 0.0},
        west_position = {0.0, 0.0},
        animation =
        {
          filename = "__base__/graphics/entity/steel-furnace/steel-furnace-fire.png",
          priority = "high",
          line_length = 8,
          width = 29,
          height = 40,
          frame_count = 48,
          axially_symmetrical = false,
          direction_count = 1,
          shift = util.by_pixel(-0.5, 6),
          hr_version = {
            filename = "__base__/graphics/entity/steel-furnace/hr-steel-furnace-fire.png",
            priority = "high",
            line_length = 8,
            width = 57,
            height = 81,
            frame_count = 48,
            axially_symmetrical = false,
            direction_count = 1,
            shift = util.by_pixel(-0.75, 5.75),
            scale = 0.5
          }
        },
        light = {intensity = 1, size = 1, color = {r = 1.0, g = 1.0, b = 1.0}}
      },
      {
        north_position = {0.0, 0.0},
        east_position = {0.0, 0.0},
        south_position = {0.0, 0.0},
        west_position = {0.0, 0.0},
        effect = "flicker", -- changes alpha based on energy source light intensity
        animation =
        {
          filename = "__base__/graphics/entity/steel-furnace/steel-furnace-glow.png",
          priority = "high",
          width = 60,
          height = 43,
          frame_count = 1,
          shift = {0.03125, 0.640625},
          blend_mode = "additive"
        }
      },
      {
        north_position = {0.0, 0.0},
        east_position = {0.0, 0.0},
        south_position = {0.0, 0.0},
        west_position = {0.0, 0.0},
        effect = "flicker", -- changes alpha based on energy source light intensity
        animation =
        {
          filename = "__base__/graphics/entity/steel-furnace/steel-furnace-working.png",
          priority = "high",
          line_length = 8,
          width = 64,
          height = 75,
          frame_count = 1,
          axially_symmetrical = false,
          direction_count = 1,
          shift = util.by_pixel(0, -4.5),
          blend_mode = "additive",
          hr_version = {
            filename = "__base__/graphics/entity/steel-furnace/hr-steel-furnace-working.png",
            priority = "high",
            line_length = 8,
            width = 130,
            height = 149,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            shift = util.by_pixel(0, -4.25),
            blend_mode = "additive",
            scale = 0.5
          }
        }
      },
    }):
	setReplace("furnace"):extend()

local plates = {"steel","brass","titanium","tungsten","nitinol"}
local plateTech = {"steel-processing","zinc-processing","titanium-processing","tungsten-processing","nitinol-processing"}
for i,p in pairs(plates) do
	RecGen:create("omnimatter","omnicium-"..p.."-gear-box"):
		setSubgroup("intermediate-product"):
		setStacksize(100):
		setReqAllMods("bobplates"):
		setEnergy(0.25):
		addProductivity():
		setIngredients("omnicium-gear-wheel",p.."-gear-wheel"):
		setCategory("crafting"):
		setTechName(plateTech[i]):
		extend()
end
if mods["bobplates"] then
	data.raw.item["brass-gear-wheel"].icon="__omnimatter__/graphics/icons/brass-gear-wheel.png"
	data.raw.item["steel-gear-wheel"].icon="__omnimatter__/graphics/icons/steel-gear-wheel.png"
end

data.raw.item["iron-gear-wheel"].icons={{icon="__omnimatter__/graphics/icons/iron-gear-wheel.png",icon_size=32,mipmaps=1}}

ItemGen:import("ingot-iron"):
	setName("ingot-omnicium","omnimatter"):
	setSubgroup("angels-omnicium"):
	setReqAllMods("angelssmelting"):
	setIcons("ingot-omnicium","omnimatter"):
	extend()

RecGen:import("iron-ore-smelting"):
	setName("omnite-smelting","omnimatter"):
	setIngredients({type="item", name="iron-ore", amount=24},
		{type="item", name="copper-ore", amount=24},
		{type="item", name="omnite", amount=48}):
	replaceResults("ingot-iron","ingot-omnicium"):
	setSubgroup("angels-omnicium"):
	setReqAllMods("angelssmelting"):
	setIcons("ingot-omnicium","omnimatter"):
	addSmallIcon("iron-ore",3):
	addSmallIcon("copper-ore",1):
	setTechName("angels-omnicium-smelting-1"):
	setTechIcon("smelting-omnicium"):
	extend()

RecGen:import("molten-iron-smelting-1"):
	setName("molten-omnicium-smelting-1","omnimatter"):
	setItemName("liquid-molten-omnicium"):
	replaceIngredients("ingot-iron","ingot-omnicium"):
	replaceResults("liquid-molten-iron","liquid-molten-omnicium"):
	setSubgroup("omnicium-casting"):
	setIcons("molten-omnicium","omnimatter"):
	setReqAllMods("angelssmelting"):
	setBothColour({r = 125/255, g = 0/255, b = 161/255}):
	setTechName("angels-omnicium-smelting-1"):extend()

RecGen:import("angels-plate-iron"):
	setName("angels-plate-omnicium","omnimatter"):
	replaceIngredients("liquid-molten-iron","liquid-molten-omnicium"):
	replaceResults("angels-plate-iron","omnicium-plate"):
	setSubgroup("omnicium-casting"):
	setIcons("omnicium-plate","omnimatter"):
	addSmallIcon("molten-omnicium",3):
	addProductivity():
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-1"):extend()

RecGen:import("iron-ore-processing"):
	setName("omnicium-processing","omnimatter"):
	setItemName("processed-omnicium"):
	setIngredients({"iron-ore",4},{"copper-ore",4},{"omnite",8}):
	replaceResults("processed-iron","processed-omnicium"):
	setSubgroup("angels-omnicium"):
	setIcons("processed-omnicium","omnimatter"):
	addSmallIcon("molten-omnicium",3):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-2"):
	setTechPrereq("angels-omnicium-smelting-1"):
	setTechIcon("smelting-omnicium"):extend()

RecGen:import("processed-iron-smelting"):
	setName("processed-omnicium-smelting","omnimatter"):
	setItemName("processed-omnicium"):
	replaceIngredients("processed-iron","processed-omnicium"):
	replaceIngredients("solid-coke",{type="fluid",name="omnic-acid",amount=40}):
	replaceResults("ingot-iron","ingot-omnicium"):
	setSubgroup("angels-omnicium"):
	setIcons("ingot-omnicium","omnimatter"):
	addSmallIcon("processed-omnicium",3):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-2"):extend()

RecGen:import("iron-processed-processing"):
	setName("omnicium-processed-processing","omnimatter"):
	setItemName("pellet-omnicium"):
	replaceIngredients("processed-iron","processed-omnicium"):
	replaceResults("pellet-iron","pellet-omnicium"):
	setSubgroup("omnicium-casting"):
	setIcons("pellet-omnicium","omnimatter"):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-3"):
	setTechPrereq("angels-omnicium-smelting-2"):
	setTechIcon("smelting-omnicium"):extend()

RecGen:import("pellet-iron-smelting"):
	setName("pellet-omnicium-smelting","omnimatter"):
	replaceIngredients("pellet-iron","pellet-omnicium"):
	replaceIngredients("solid-limestone",{type="fluid", name="omnic-acid", amount = 30}):
	ifModsReplaceIngredients("omnimatter_crystal","solid-coke","omnine"):
	replaceResults("ingot-iron","ingot-omnicium"):
	setSubgroup("omnicium-casting"):
	setIcons("ingot-omnicium","omnimatter"):
	addSmallIcon("pellet-omnicium",3):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-3"):
	setTechIcon("smelting-omnicium"):extend()

RecGen:import("roll-iron-casting"):
	setName("roll-omnicium-casting","omnimatter"):
	setItemName("angels-roll-omnicium"):
	setIcons("roll-omnicium","omnimatter"):
	replaceIngredients("liquid-molten-iron","liquid-molten-omnicium"):
	replaceResults("angels-roll-iron","angels-roll-omnicium"):
	setSubgroup("omnicium-casting"):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-2"):extend()

RecGen:import("roll-iron-casting-fast"):
	setName("roll-omnicium-casting-fast","omnimatter"):
	setIcons("roll-omnicium","omnimatter"):
	replaceIngredients("liquid-molten-iron","liquid-molten-omnicium"):
	replaceResults("angels-roll-iron","angels-roll-omnicium"):
	setSubgroup("omnicium-casting"):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-3"):extend()

RecGen:import("angels-roll-iron-converting"):
	setName("angels-roll-omnicium-converting","omnimatter"):
	setIcons("omnicium-plate"):
	addSmallIcon("angels-roll-omnicium",4):
	replaceIngredients("angels-roll-iron","angels-roll-omnicium"):
	replaceResults("angels-plate-iron","omnicium-plate"):
	setSubgroup("omnicium-casting"):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-2"):extend()



if mods["angelssmelting"] then
	data:extend({
  {
    type = "item-subgroup",
    name = "omnicium-casting",
    group = "angels-casting",
    order = "u",
  },
  {
    type = "item-subgroup",
    name = "angels-omnicium",
    group = "angels-smelting",
    order = "r",
  },
  })
  data.raw.item["omnicium-plate"].subgroup = "omnicium-casting"
end
if mods["only-smelting"] then
else
	data.raw.recipe["iron-plate"].hidden = false
	data.raw.recipe["copper-plate"].hidden = false
end
