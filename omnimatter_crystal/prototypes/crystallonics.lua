
local water = "water"
if mods["angelsrefining"] then water = "water-purified" end

RecGen:create("omnimatter_crystal","hydromnic-acid"):
	fluid():
	setBothColour(1,1,1):
	setEnergy(1):
	setSubgroup("crystallization"):
	marathon():
	setCategory("omniplant"):
	setTechName("omnitech-omnic-acid-hydrolyzation-1"):
	setIngredients({
      {type = "item", name = "omnite", amount = 1},
      {type = "fluid", name = "omnic-acid", amount = 50},
      {type = "fluid", name = water, amount = 200},
    }):
	setResults({type = "fluid", name = "hydromnic-acid", amount = 500}):extend()
	
	
local dif = 1
if not mods["bobelectronics"] then dif=0 end

local cost = OmniGen:create():
	building():
	setMissConstant(3):
	setQuant("pipe",15,2):
	setQuant("omniplate",10):
	setQuant("gear-wheel",10):
	setQuant("circuit",5,dif)
	
	
BuildChain:create("omnimatter_crystal","omniplant"):
	setSubgroup("crystallization"):
	setLocName("omniplant"):
	setIcons("omniplant","omnimatter_crystal"):
	setIngredients(cost:ingredients()):
	setEnergy(25):
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
	

cost = OmniGen:create():
	building():
	setMissConstant(4):
	setQuant("pipe",5,2):
	setQuant("omniplate",10):
	setQuant("gear-wheel",5,1):
	setQuant("circuit",15)
	
local tmp = {{"advanced-electronics"}}
BuildChain:create("omnimatter_crystal","crystallomnizer"):
	setSubgroup("crystallization"):
	setIcons("crystallomnizer","omnimatter_crystal"):
	setLocName("crystallomnizer"):
	setIngredients(cost:ingredients()):
	setEnergy(25):
	setUsage(function(level,grade) return (200+50*grade).."kW" end):
	setTechPrereq(get_pure_req):
	addElectricIcon():
	allowProductivity():
	setTechName("crystallonics"):
	setTechIcon("omnimatter_crystal","crystallonics"):
	setTechCost(get_tech_times):
	setTechPacks(function(levels,grade) return grade end):
	setReplace("crystallomnizer"):
	setTechTime(function(levels,grade) return 15*grade end):
	setTechPrereq(function(levels,grade)
		local tmp = {"crystallology-"..math.min(grade,omni.max_tier-1)}
		if grade == 1 then 
			tmp[#tmp+1]="advanced-electronics" 
		elseif grade == omni.max_tier then
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

if mods["bobores"] then
	omni.lib.replace_recipe_ingredient("crystal-rod","copper-ore-crystal","tin-ore-crystal")
end