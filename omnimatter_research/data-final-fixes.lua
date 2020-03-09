
require("prototypes.omnissence")


omni.lib.add_unlock_recipe("omnitractor-electric-1","omnissenced-wood")
omni.lib.add_unlock_recipe("crystallology-1","omnissenced-iron-crystal")


--omnicium-plate
RecGen:importIf("omnite-smelting"):replaceIngredients("copper-ore",{"copper-iron-ore-mix",24}):removeIngredients("iron-ore"):extend()

RecGen:importIf("omnicium-processing"):replaceIngredients("copper-ore",{"copper-iron-ore-mix",4}):removeIngredients("iron-ore"):extend()

omni.lib.add_unlock_recipe("omnipack-technology","ingot-mingnisium")
omni.lib.add_unlock_recipe("omnitractor-electric-3","crushed-mixture")
omni.lib.add_unlock_recipe("omnitractor-electric-3","hydrosalamite")
omni.lib.add_unlock_recipe("omnitractor-electric-3","omnissenced-plastic")

if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("ore-mix-essence")
	omni.marathon.exclude_recipe("copper-iron-ore-mix")
end
local cost = OmniGen:create():
	building():
	setMissConstant(2):
	setPreRequirement("burner-omnicosm"):
	setQuant("circuit",5):
	setQuant("omniplate",20):
	setQuant("gear-box",10,-1)

if mods["bobplates"] then
	cost:setQuant("bearing",5,-1)
end

BuildChain:create("omnimatter_research","omnicosm"):
	setSubgroup("omnitractor"):
	setLocName("omnicosm"):
	setIngredients(cost:ingredients()):
	setEnergy(15):
	setUsage(function(level,grade) return (100+25*grade).."kW" end):
	addElectricIcon():
	setTechName("omnitractor-electric"):
	--[[setTechIcon("omnimatter_ressearch","omnicosm"):
	setTechPrereq(get_pure_req):
	setTechCost(function(levels,grade) return 250*math.pow(2,grade-1) end):
	setTechPacks(function(levels,grade) return grade end):
	setTechTime(function(levels,grade) return 15*grade end):
	setTechLocName("electric-omnicosm"):]]
	setReplace("omnicosm"):
	setStacksize(10):
	setSize(3):
	setLevel(omni.max_tier):
	setSoundWorking("ore-crusher",nil,"omnimatter"):
	setSoundVolume(2):
	allowProductivity():
	setModSlots(function(levels,grade) return grade end):
	setCrafting({"omnicosm"}):
	setSpeed(function(levels,grade) return 0.5+grade/2 end):
	setAnimation({
	layers={
	{
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
          priority = "high",
          line_length = 8,
          width = 78,
          height = 117,
          frame_count = 64,
          shift = util.by_pixel(0, 0),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B.png",
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 156,
            height = 234,
            frame_count = 64,
            shift = util.by_pixel(0, 0)
          }
        },
	},
	}):
	setFluidBox("XWX.XXX.XKX"):
	extend()
	
cost = OmniGen:create():
	building():
	setMissConstant(2):
	setPreRequirement("burner-research_facility"):
	setQuant("circuit",5):
	setQuant("omniplate",10):
	setQuant("pipe",10):
	setQuant("gear-box",5)

log("I HAVE ARRIVED!")
	
BuildChain:create("omnimatter_research","research_facility"):
	setSubgroup("omnitractor"):
	setLocName("research_facility"):
	setIngredients(cost:ingredients()):
	setEnergy(15):
	addElectricIcon():
	setReplace("research_facility"):
	setUsage(function(level,grade) return (100+25*grade).."kW" end):
	setTechName("omnitractor-electric"):
	--[[setTechPrereq(get_pure_req):
	setTechIcon("omnimatter_ressearch","research_facility"):
	setTechCost(function(levels,grade) return 250*math.pow(2,grade-1) end):
	setTechPacks(function(levels,grade) return grade end):
	setTechTime(function(levels,grade) return 15*grade end):
	setTechLocName("electric-research-facility"):]]
	setStacksize(10):
	setSize(3):
	setLevel(omni.max_tier):
	setSoundWorking("ore-crusher",nil,"omnimatter"):
	setSoundVolume(2):
	allowProductivity():
	setModSlots(function(levels,grade) return grade end):
	setCrafting({"research-facility"}):
	setSpeed(function(levels,grade) return 0.5+grade/2 end):
	setAnimation({
		filename = "__omnimatter_research__/graphics/entity/research-facility.png",
		priority = "high",
		width = 128,
		height = 128,
		frame_count = 29,
		line_length = 6,
		animation_speed = 1,
		shift = {0,-0.3}
	}):
	setFluidBox("WXW.XXX.KXK"):
	extend()

log("I HAVE DEPARTED!")

RecGen:import("automation-science-pack"):setNormalIngredients({name="liquid-molten-omnicium",amount=100,type="fluid"},{"ore-mix-essence",2}):
	setExpensiveIngredients({name="liquid-molten-omnicium",amount=200,type="fluid"},{"ore-mix-essence",3}):
	marathon():extend()

RecGen:import("logistic-science-pack"):setIngredients({"orthomnide",3},"omnidized-steel",{"omnissenced-wood",2}):
	setResults({"logistic-science-pack",3}):setEnabled(false):extend()
	
RecGen:import("chemical-science-pack"):setIngredients({"chlorodizing-omnikaryote",10},{"hydrosalamite",1},{"carbomnilline",2},{"omnissenced-plastic",1}):extend()

RecGen:import("omni-pack"):setIngredients({"omnissenced-iron-crystal",3},{type="fluid",name="omniaescene",amount=75},{"ingot-mingnisium",2}):extend()

RecGen:importIf("ingot-iron-smelting"):setTechName("angels-iron-smelting-1"):extend()

local packs = {}
for _, lab in pairs(data.raw["lab"]) do
	for _, input in pairs(lab.inputs) do
		local rec = omni.lib.find_recipe(input)
		if rec then 
			data.raw.recipe[rec.name].category="research-facility"
			if rec.normal then
				data.raw.recipe[rec.name].normal.category="research-facility"
				data.raw.recipe[rec.name].expensive.category="research-facility"
			end
			packs[#packs+1]=data.raw.recipe[rec.name]
		end
	end
end