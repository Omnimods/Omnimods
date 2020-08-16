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
  	"stone-furnace",
	"stone-mixing-furnace",
	"stone-chemical-furnace",
	"burner-assembling-machine",
	"burner-mining-drill"
}

for _,entity in pairs(burnerEntities) do
	local build = omni.lib.find_entity_prototype(entity)
	if build then
		build.energy_source.fuel_category = "omnite"
	end
end

--Overwrite the localised name of the Burner inserter
data.raw.recipe["burner-inserter"].localised_name = {"entity-name.burner-inserter-1"}

--Find all remaining Techs that unlock entities that require electricity and move them behind anbaricity
for _,tech in pairs(data.raw.technology) do 
	local ent
	if tech.effects and (tech.prerequisites == nil or next(tech.prerequisites) == nil) then
		for _,eff in pairs(tech.effects) do
			if eff.type == "unlock-recipe" then
				ent = omni.lib.find_entity_prototype(eff.recipe)
				if ent and ent.energy_source and ent.energy_source.type == "electric" then
					omni.lib.add_prerequisite(tech.name, "anbaricity")
				end
			end
		end
	end
end