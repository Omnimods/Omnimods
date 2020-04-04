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