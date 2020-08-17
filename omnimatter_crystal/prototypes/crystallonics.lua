
local water = "water"
if mods["angelsrefining"] then water = "water-purified" end

RecGen:create("omnimatter_crystal","hydromnic-acid"):
	fluid():
	setBothColour(1,1,1):
	setEnergy(1):
	marathon():
	setCategory("omniplant"):
	setSubgroup("crystal-fluids"):
	setTechName("omnitech-omnic-acid-hydrolyzation-1"):
	setIngredients({
      {type = "item", name = "omnite", amount = 1},
      {type = "fluid", name = "omnic-acid", amount = 50},
      {type = "fluid", name = water, amount = 200},
    }):
	setResults({type = "fluid", name = "hydromnic-acid", amount = 500}):extend()


local dif = 1
if not mods["bobelectronics"] then dif=0 end

local cost_plant = OmniGen:create():
	building():
	setMissConstant(3)
local cost_omnizer = OmniGen:create():
	building():
	setMissConstant(3)
if mods["angelsindustries"] and angelsmods.industries.components then
	cost_plant:setQuant("construction-block",5):
	setQuant("electric-block",2):
	setQuant("fluid-block",5):
	setQuant("energy-block",1):
	setQuant("omni-block",1)
	cost_omnizer:setQuant("construction-block",5):
	setQuant("electric-block",2):
	setQuant("fluid-block",5):
	setQuant("enhancement-block",1):
	setQuant("omni-block",1)
else
	cost_plant:setQuant("pipe",15,2):
	setQuant("omniplate",10):
	setQuant("gear-wheel",10):
	setQuant("circuit",5,dif)
	cost_omnizer:setQuant("pipe",15,2):
	setQuant("omniplate",10):
	setQuant("gear-wheel",10):
	setQuant("circuit",5,dif)
end

--Omniplant
BuildChain:create("omnimatter_crystal","omniplant"):
	setSubgroup("omniplant"):
	setLocName("omniplant"):
	setIcons("omniplant","omnimatter_crystal"):
	setIngredients(cost_plant:ingredients()):
	setEnergy(5):
	setUsage(function(level,grade) return (200+50*grade).."kW" end):
	setTechPrereq(get_pure_req):
	addElectricIcon():
	setTechName(function(levels,grade) if grade == 1 then return "omnitech-omnic-acid-hydrolyzation-1" else return "crystallology" end end):
	setTechIcon("omnimatter_crystal","crystallology"):
	setTechCost(get_tech_times):
	setTechPacks(function(levels,grade) return grade end):
	setTechPrereq(function(levels,grade)
		local req = {}
		if grade < omni.max_tier then req[#req+1]="omnitractor-electric-"..grade end
		if grade > 2 then req[#req+1]="crystallology-"..(grade-2) end
		return req end):
	setReplace("omniplant"):
	setTechTime(function(levels,grade) return 15*grade end):
	setStacksize(20):
	setSize(5):
	setLevel(omni.max_tier):
	setModSlots(function(levels,grade) return grade end):
	setCrafting({"omniplant"}):
	setSpeed(function(levels,grade) return 0.5+grade/2 end):
	setSoundWorking("oil-refinery",1,"base"):
	setSoundVolume(2):
	allowProductivity():
	setAnimation({
	layers={
	{
        filename = "__omnimatter_crystal__/graphics/buildings/omni-plant.png",
		priority = "extra-high",
        width = 224,
        height = 224,
        frame_count = 36,
		line_length = 6,
        shift = {0.00, -0.05},
		scale = 1,
		animation_speed = 0.5
	},
	}
	}):
	setOverlay("omni-plant-overlay"):
	setFluidBox("XWXWX.XXXXX.XXXXX.XXXXX.XKXKX"):
	extend()

	-- Burner Omniplant
	--SETTING VANILLA INGREDIENTS FIRST
	local pipe="pipe"
	local electronic="electronic-circuit"
	if mods["boblogistics"] then pipe="copper-pipe" end
	if mods["bobelectronics"] then electronic="basic-circuit-board" end

    local burner_ings = {}
	if mods["angelsindustries"] and angelsmods.industries.components then
		burner_ings = {
		{name="block-construction-1", amount=5},
		{name="block-electronics-0", amount=3},
		{name="block-fluidbox-1", amount=5},
		{name="block-omni-0", amount=5}
		}
	else
		burner_ings = {{pipe,15},{"omnicium-plate",5},{electronic,5},{"omnite-brick",10},{"iron-gear-wheel",10}}
	end
	BuildGen:create("omnimatter_crystal","omniplant"):
	setBurner(0.75,2):
	setSubgroup("omniplant"):
	setIcons("omniplant","omnimatter_crystal"):
	setIngredients(burner_ings):
	setEnergy(5):
	setUsage(function(level,grade) return "750kW" end):
	--setTechName("omnitractor-electric-1"): --Done in final-fixes for now
	setReplace("omniplant"):
	setNextUpgrade("omniplant-1"):
	setStacksize(20):
	setSize(5):
	setCrafting({"omniplant"}):
	setSpeed(1):
	setSoundWorking("oil-refinery",1,"base"):
	setSoundVolume(2):
	setAnimation({
	layers={
	{
        filename = "__omnimatter_crystal__/graphics/buildings/omni-plant.png",
		priority = "extra-high",
        width = 224,
        height = 224,
        frame_count = 36,
		line_length = 6,
        shift = {0.00, -0.05},
		scale = 1,
		animation_speed = 0.5
	},
	}
	}):
	setOverlay("omni-plant-overlay"):
	setFluidBox("XWXWX.XXXXX.XXXXX.XXXXX.XKXKX"):
	extend()

RecGen:import("omniplant-1"):addIngredients({"burner-omniplant",1}):extend()

local tmp = {{"advanced-electronics"}}
BuildChain:create("omnimatter_crystal","crystallomnizer"):
	setSubgroup("crystallomnizer"):
	setIcons("crystallomnizer","omnimatter_crystal"):
	setLocName("crystallomnizer"):
	setIngredients(cost_omnizer:ingredients()):
	setEnergy(5):
	setUsage(function(level,grade) return (200+50*grade).."kW" end):
	setTechPrereq(get_pure_req):
	addElectricIcon():
	allowProductivity():
	setTechName("crystallonics"):
	setTechIcon("omnimatter_crystal","crystallonics"):
	setTechCost(get_tech_times):
	setTechPacks(function(levels,grade) return grade + 1 end):
	setReplace("crystallomnizer"):
	setTechTime(function(levels,grade) return 15*grade end):
	setTechPrereq(function(levels,grade)
		local tmp = {"crystallology-"..math.min(grade,omni.max_tier-1)}
		if grade == 1 then
			tmp[#tmp+1]="advanced-electronics"
		else
			tmp[#tmp+1]="crystallonics-"..(grade-1)
		end
		return tmp end):
	setStacksize(20):
	setSize(3):
	setLevel(omni.max_tier):
	setModSlots(function(levels,grade) return grade end):
	setCrafting({"crystallomnizer"}):
	setSpeed(function(levels,grade) return 0.5+grade/2 end):
	setSoundWorking("oil-refinery",1,"base"):
	setSoundVolume(2):
	setAnimation({
	layers={
	{
        filename = "__omnimatter_crystal__/graphics/buildings/iron-curtain.png",
		priority = "extra-high",
        width = 164,
        height = 162,
        frame_count = 36,
		line_length = 6,
        shift = {0.00, -0.8},
		scale = 0.8,
		animation_speed = 0.3
	},
	}
	}):
	setFluidBox("XWX.XXX.XKX"):
	extend()

if mods["angelsindustries"] and angelsmods.industries.components then
	for i=1,settings.startup["omnimatter-max-tier"].value do
		-- Remove previous tier buildings from the recipes
		if i == 1 then
			omni.lib.remove_recipe_ingredient("omniplant-1", "burner-omniplant")
		else
			omni.lib.remove_recipe_ingredient("omniplant-"..i, "omniplant-"..i-1)
			omni.lib.remove_recipe_ingredient("crystallomnizer-"..i, "crystallomnizer-"..i-1)
		end
	end
end

--[[                         ]]
--[[         Omnine          ]]
--[[                         ]]

RecGen:create("omnimatter_crystal","omnine"):
	setSubgroup("omnine"):
	setCategory("omniplant"):
	setEnergy(10):
	setStacksize(200):
	setFuelValue(18):
	setFuelCategory("crystal"):
	marathon():
	setTechName("crystallology-1"):
	setIngredients({
    {type = "item", name = "omnine-shards", amount=1},
    {type = "fluid", name = "omnisludge", amount=100},
    }):
	setResults({type = "item", name = "omnine", amount=5}):extend()

RecGen:create("omnimatter_crystal","omnine-distillation-quick"):
	setSubgroup("omnine"):
	setCategory("omniplant"):
	setEnergy(180):
	marathon():
	setTechName("crystallology-1"):
	setIngredients({type = "fluid", name = "omnisludge", amount=20000}):
	setResults({type = "item", name = "omnine", amount=1}):extend()

RecGen:create("omnimatter_crystal","omnine-distillation-slow"):
	setSubgroup("omnine"):
	setCategory("omniplant"):
	setEnergy(1800):
	marathon():
	setTechName("crystallology-1"):
	setIngredients({type = "fluid", name = "omnisludge", amount=2000}):
	setResults({type = "item", name = "omnine", amount=1}):extend()

local cat = "ore-sorting-t1"
if not mods["angelsrefining"] then cat = nil end
RecGen:create("omnimatter_crystal","omnine-shards"):
	setSubgroup("omnine"):
	setCategory(cat):
	setStacksize(200):
	setFuelValue(3.5):
	setFuelCategory("crystal"):
	setEnergy(1):
	marathon():
	setTechName("crystallology-1"):
	setIngredients({type = "item", name = "omnine", amount=1}):
	setResults({type = "item", name = "omnine-shards", amount=10}):extend()


--[[                         ]]
--[[      Crystallonics      ]]
--[[          Parts          ]]
--[[                         ]]

local crystal_cat = "crystallomnizer"

local ore_circuit = "coal"
if mods["bobores"] then ore_circuit = "lead-ore" end


RecGen:create("omnimatter_crystal","omnine-structure-crystal"):
	setEnergy(1):
	setStacksize(100):
	setSubgroup("crystallonic-part"):
	setCategory("crystallomnizer"):
	addProductivity():
	setTechName("crystallonics-1"):
	setIngredients({type="item",name="omnine",amount=3}):
	setResults({type="item",name="omnine-structure-crystal",amount=2}):extend()

RecGen:create("omnimatter_crystal","crystal-rod"):
	setEnergy(1):
	setStacksize(100):
	setSubgroup("crystallonic-part"):
	setCategory("crystallomnizer"):
	setTechName("crystallonics-1"):
	addProductivity():
	setIngredients({type="item",name="copper-ore-crystal",amount=2}):
	setResults({type="item",name="crystal-rod",amount=3}):extend()

RecGen:create("omnimatter_crystal","basic-crystallonic"):
	setEnergy(1):
	setStacksize(200):
	setSubgroup("crystallonic"):
	setTechName("crystallonics-1"):
	setCategory("crystallomnizer"):
	addProductivity():
	setIngredients({
		{type="item",name="omnine-structure-crystal",amount=1},
		{type="item",name="crystal-rod",amount=2}
	}):
	setResults({type="item",name="basic-crystallonic",amount=1}):extend()

RecChain:create("omnimatter_crystal","pseudoliquid-amorphous-crystal"):
	fluid():
	setBothColour(1,0,1):
	setEnergy(function(levels,grade) return 0.5+grade/2 end):
	setSubgroup("crystallonic-part"):
	setCategory("crystallomnizer"):
	setIngredients({type="item",name="omnine",amount=12}):
	setResults(function (levels,grade) return {{type="fluid",name="pseudoliquid-amorphous-crystal",amount=240+2160*(grade-1)/levels}} end):
	setLevel(omni.fluid_levels):
	setTechName("pseudoliquid-amorphous-crystal"):
	setTechLocName("pseudoliquid-amorphous-crystal",grade):
	setTechIcon("omnimatter_crystal","amorphous-crystal"):
	setTechCost(function(levels,grade) return 500+50*grade end):
	setTechPacks(function(levels,grade) return 3+math.floor(grade*3/levels) end):
	setTechTime(60):
	setTechPrereq(function(levels,grade)
		local req = {}
		if grade==1 then
			req={"crystallonics-1"}
		else
			req={"omnitech-pseudoliquid-amorphous-crystal-"..grade-1}
		end
		local c = omni.lib.round(levels/3)
		if grade%c==0 and grade>1 then
			req[#req+1]="crystallonics-"..math.floor(grade/c)+1
		end
		return req
	end):extend()


RecGen:create("omnimatter_crystal","shattered-omnine"):
	setEnergy(0.5):
	setStacksize(600):
	setSubgroup("crystallonic-part"):
	addProductivity():
	setCategory(cat):
	setTechName("crystallonics-2"):
	setIngredients({type="item",name="omnine",amount=2}):
	setResults({type="item",name="shattered-omnine",amount=3}):extend()

RecGen:create("omnimatter_crystal","impure-crystal-rod"):
	setEnergy(2):
	setStacksize(150):
	setSubgroup("crystallonic-part"):
	setCategory("crystallomnizer"):
	addProductivity():
	setTechName("crystallonics-2"):
	setIngredients({
		{type="item",name="shattered-omnine",amount=1},
		{type="fluid",name="pseudoliquid-amorphous-crystal",amount=150},
		{type="item",name=ore_circuit,amount=2}
	}):
	setResults({type="item",name="impure-crystal-rod",amount=3}):extend()

RecGen:create("omnimatter_crystal","fragment-iron-crystal"):
	setEnergy(2):
	setStacksize(400):
	setSubgroup("crystallonic-part"):
	setCategory("advanced-crafting"):
	addProductivity():
	setTechName("crystallonics-2"):
	setIngredients({type="item",name="iron-ore-crystal",amount=1}):
	setResults({type="item",name="fragmented-iron-crystal",amount=3}):extend()

RecGen:create("omnimatter_crystal","fragment-copper-crystal"):
	setEnergy(2):
	setStacksize(400):
	setSubgroup("crystallonic-part"):
	setCategory("advanced-crafting"):
	addProductivity():
	setTechName("crystallonics-2"):
	setIngredients({type="item",name="copper-ore-crystal",amount=1}):
	setResults({type="item",name="fragmented-copper-crystal",amount=3}):extend()

RecGen:create("omnimatter_crystal","omnilgium"):
	setEnergy(3):
	setStacksize(400):
	setSubgroup("crystallonic-part"):
	setTechName("crystallonics-2"):
	addProductivity():
	setCategory("crystallomnizer"):
	setIngredients({
		{type="item",name="fragmented-copper-crystal",amount=2},
		{type="item",name="fragmented-iron-crystal",amount=2},
		{type="fluid",name="pseudoliquid-amorphous-crystal",amount=100},
	}):
	setResults({type="item",name="omnilgium",amount=2}):extend()

RecGen:create("omnimatter_crystal","oscillocrystal"):
	setEnergy(3):
	setStacksize(500):
	setSubgroup("crystallonic-part"):
	setCategory("crystallomnizer"):
	addProductivity():
	setTechName("crystallonics-2"):
	setIngredients({
		{type="item",name="impure-crystal-rod",amount=3},
		{type="item",name="omnilgium",amount=2},
	}):
	setResults({type="item",name="oscillocrystal",amount=5}):extend()

RecGen:create("omnimatter_crystal","oscillocrystal"):
	setEnergy(3):
	setStacksize(500):
	setSubgroup("crystallonic-part"):
	setCategory("crystallomnizer"):
	addProductivity():
	setTechName("crystallonics-2"):
	setIngredients({
		{type="item",name="impure-crystal-rod",amount=3},
		{type="item",name="omnilgium",amount=2},
	}):
	setResults({type="item",name="oscillocrystal",amount=5}):extend()

RecGen:create("omnimatter_crystal","electrocrystal"):
	setEnergy(2):
	setStacksize(500):
	setSubgroup("crystallonic-part"):
	setCategory("crystallomnizer"):
	setTechName("crystallonics-3"):
	addProductivity():
	setIngredients({
		{type="item",name="impure-crystal-rod",amount=3},
		{type="item",name="omnilgium",amount=2},
		{type="item",name="crystal-rod",amount=2},
	}):
	setResults({type="item",name="electrocrystal",amount=6}):extend()

RecGen:create("omnimatter_crystal","quasi-solid-omnistal"):
	setEnergy(1):
	setStacksize(200):
	setSubgroup("crystallonic-part"):
	setCategory("crystallomnizer"):
	setTechName("crystallonics-2"):
	addProductivity():
	setIngredients({
		{type="item",name="shattered-omnine",amount=1},
		{type="fluid",name="pseudoliquid-amorphous-crystal",amount=20},
	}):
	setResults({type="item",name="quasi-solid-omnistal",amount=5}):extend()

--[[                         ]]
--[[      Crystallonics      ]]
--[[                         ]]

RecGen:create("omnimatter_crystal","basic-oscillo-crystallonic"):
	setEnergy(1):
	setStacksize(200):
	setSubgroup("crystallonic"):
	setCategory("crystallomnizer"):
	setTechName("crystallonics-2"):
	addProductivity():
	setIngredients({
		{type="item",name="basic-crystallonic",amount=1},
		{type="item",name="quasi-solid-omnistal",amount=2},
		{type="item",name="oscillocrystal",amount=1}
	}):
	setResults({type="item",name="basic-oscillo-crystallonic",amount=1}):extend()




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
