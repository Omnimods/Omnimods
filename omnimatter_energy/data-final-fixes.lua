for _,loco in pairs(data.raw.locomotive) do
	if loco.burner and loco.burner.fuel_category == "chemical" then
		loco.burner.effectivity = loco.burner.effectivity*0.5
	end
end

BuildGen:import("burner-omnitractor"):setFuelCategory("omnite"):setFluidBox("XIX.XXX.XXX"):extend()


RecGen:importIf("wooden-board"):addNormalIngredients({"omni-tablet",1}):addExpensiveIngredients({"omni-tablet",2}):setTechName("anbaricity"):extend()


local burnerEntities = {
	"burner-mining-drill",
	"burner-research_facility",
	"burner-omnicosm",
	"burner-omniphlog",
	"burner-omni-furnace",
	"burner-ore-crusher",
	"mixing-steel-furnace",
	"mixing-furnace",
	"chemical-steel-furnace",
	"chemical-boiler",
	"steel-furnace",
	"stone-furnace",
	"burner-assembling-machine",
}
log(serpent.block(data.raw["assembling-machine"]["mixing-furnace"]))
for _,entity in pairs(burnerEntities) do
	BuildGen:importIf(entity):setFuelCategory("omnite"):extend()
end
log(serpent.block(data.raw["assembling-machine"]["mixing-furnace"]))
--error("merp")

BuildGen:create("omnimatter_crystal","omniplant"):
	setSubgroup("crystallization"):
	setLocName("omniplant-burner"):
	setIcons("omniplant","omnimatter_crystal"):
	setIngredients({"copper-pipe",15},{"omnicium-plate",5},{"basic-circuit-board",5},{"omnite-brick",10},{"iron-gear-wheel",10}):
	setBurner(0.75,2):
	setEnergy(25):
	setFuelCategory("omnite"):
	setUsage(function(level,grade) return "750kW" end):
	setTechName("omnitractor-electric-1"):
	setReplace("omniplant"):
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