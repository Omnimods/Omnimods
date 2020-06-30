--for _,loco in pairs(data.raw.locomotive) do
--	if loco.burner and loco.burner.fuel_category == "chemical" then
--		loco.burner.effectivity = loco.burner.effectivity*0.5
--	end
--end

RecGen:importIf("wooden-board"):addNormalIngredients({"omni-tablet",1}):addExpensiveIngredients({"omni-tablet",2}):setTechName("anbaricity"):extend()

ItemGen:import("omnite"):setFuelCategory("omnite"):extend()
ItemGen:import("crushed-omnite"):setFuelCategory("omnite"):extend()
ItemGen:importIf("omniwood"):setFuelCategory("omnite"):extend()

local burnerEntities = {
	"burner-mining-drill",
	"burner-research_facility",
	"burner-omnicosm",
	"burner-omniphlog",
	"burner-omnitractor",
	"burner-omniplant",
	"burner-ore-crusher",
	"mixing-furnace",
  "chemical-boiler", --old bobs
  "stone-chemical-furnace", --new bobs
	"stone-furnace",
	"burner-assembling-machine",
	"burner-mining-drill"
}


for _,entity in pairs(burnerEntities) do
	BuildGen:importIf(entity):setFuelCategory("omnite"):extend()
end

--Overwrite the localised name of the Burner inserter
data.raw.recipe["burner-inserter"].localised_name = {"entity-name.burner-inserter-1"}