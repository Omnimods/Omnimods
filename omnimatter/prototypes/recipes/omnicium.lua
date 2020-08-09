local res = {}

RecGen:create("omnimatter","omnicium-plate-pure"):
	setItemName("omnicium-plate"):
	setIcons("omnicium-plate","omnimatter"):
	setStacksize(200):
	setIngredients({ "crushed-omnite", 10}):
	setResults("omnicium-plate"):
	setCategory("smelting"):
	setSubgroup("omnicium"):
	setOrder("aa"):
	setEnergy(25):
	setEnabled():
	extend()

RecGen:create("omnimatter","omnicium-plate-mix"):
	setIngredients({type="item", name="omnite",amount=4}):
	ifModsAddIngredients("angelsrefining",{"angels-ore1-crushed",4},{"angels-ore3-crushed",4}):
	ifAddIngredients(not mods["angelsrefining"],{"copper-ore",1},{"iron-ore",1}):
	setResults({type="item", name="omnicium-plate",amount=2}):
	addProductivity():
	setIcons("omnicium-plate","omnimatter"):
	addSmallIngIcon(2,1):
	addSmallIngIcon(3,3):
	setCategory("omnifurnace"):
	setSubgroup("omnicium"):
	setOrder("ab"):
	marathon():
	setEnergy(5):
	setEnabled():
	extend()

RecGen:create("omnimatter","omnicium-gear-wheel"):
	setStacksize(100):
	setIngredients({normal = {{"omnicium-plate", 2}},expensive={{"omnicium-plate",2}}}):
	setResults({normal = {{"omnicium-gear-wheel", 2}},expensive={{"omnicium-gear-wheel",1}}}):
	addProductivity():
	setSubgroup("omni-gears"):
	setOrder("aa"):
	setEnabled():
	setEnergy(1):
	extend()

RecGen:create("omnimatter","omnicium-iron-gear-box"):
	setStacksize(100):
	setSubgroup("omni-gears"):
	setIngredients({"omnicium-gear-wheel", 1},{"iron-gear-wheel", 1}):
	addProductivity():
	setEnabled():
	setEnergy(0.25):
	extend()

local plates = {"steel","brass","titanium","tungsten","nitinol"}
local plateTech = {"steel-processing","zinc-processing","titanium-processing","tungsten-processing","nitinol-processing"}
for i,p in pairs(plates) do
	RecGen:create("omnimatter","omnicium-"..p.."-gear-box"):
		setStacksize(100):
		setReqAllMods("bobplates"):
		setEnergy(0.25):
		addProductivity():
		setIngredients("omnicium-gear-wheel",p.."-gear-wheel"):
		setCategory("crafting"):
		setSubgroup("omni-gears"):
		setTechName(plateTech[i]):
		extend()
end
if mods["bobplates"] then
	data.raw.item["brass-gear-wheel"].icon="__omnimatter__/graphics/icons/brass-gear-wheel.png"
	data.raw.item["brass-gear-wheel"].icon_size=32
	data.raw.item["steel-gear-wheel"].icon="__omnimatter__/graphics/icons/steel-gear-wheel.png"
	data.raw.item["steel-gear-wheel"].icon_size=32
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
	setOrder("rc"):
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
	setOrder("ua"):
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
	setOrder("ra"):
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
	setOrder("rd"):
	setIcons("ingot-omnicium","omnimatter"):
	addSmallIcon("processed-omnicium",3):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-2"):extend()

RecGen:import("iron-processed-processing"):
	setName("omnicium-processed-processing","omnimatter"):
	setItemName("pellet-omnicium"):
	replaceIngredients("processed-iron","processed-omnicium"):
	replaceResults("pellet-iron","pellet-omnicium"):
	setOrder("rb"):
	setSubgroup("angels-omnicium"):
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
	setSubgroup("angels-omnicium"):
	setOrder("re"):
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

	RecGen:create("omnimatter","omnicium-gear-wheel-casting"):
	setStacksize(100):
	setSubgroup("omnicium-casting"):
	setOrder("ub"):
	setIngredients({normal = {{type="fluid",name="liquid-molten-omnicium",amount=40}},expensive={{type="fluid",name="liquid-molten-omnicium",amount=40}}}):
	setCategory("casting"):
	setResults({normal = {{"omnicium-gear-wheel", 6}},expensive={{"omnicium-gear-wheel",6}}}):
	addProductivity():
	setEnergy(2):
	setReqAllMods("angelssmelting"):
	setTechName("angels-omnicium-smelting-1"):extend()

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
