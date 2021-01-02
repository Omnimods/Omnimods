--for _,loco in pairs(data.raw.locomotive) do
--	if loco.burner and loco.burner.fuel_category == "chemical" then
--		loco.burner.effectivity = loco.burner.effectivity*0.5
--	end
--end

omni.lib.add_recipe_ingredient("wooden-board", {normal = {"omni-tablet",1}, expensive = {"omni-tablet",2}})
omni.lib.add_unlock_recipe("omnitech-anbaricity", "wooden-board")

ItemGen:import("omnite"):setFuelCategory("omnite"):extend()
ItemGen:import("crushed-omnite"):setFuelCategory("omnite"):extend()
ItemGen:importIf("omniwood"):setFuelCategory("omnite"):extend()

--Nil fuelvalues of the items saved in fuel.lua
for _,fuel in pairs(omni.nil_fuels) do
	if data.raw.item[fuel] then
		local fuelitem = data.raw.item[fuel]

		--Nil all fuel values. Could cause crashes if 1 is overseen. if it doesnt weork out, go back to changing fuel cat to omni-0
		--fuelitem.fuel_category = "omni-0"
		fuelitem.fuel_category = nil
    	fuelitem.fuel_value = nil
    	fuelitem.fuel_acceleration = nil
    	fuelitem.fuel_acceleration_multiplier = nil
    	fuelitem.fuel_top_speed = nil
    	fuelitem.fuel_top_speed_multiplier = nil
    	fuelitem.fuel_emissions = nil
    	fuelitem.fuel_emissions_multiplier = nil
		fuelitem.fuel_glow_color = nil
	end
end

local burnerEntities = {
	"burner-mining-drill",
	"burner-research_facility",
	"burner-omnicosm",
	"burner-omniphlog",
	"burner-omnitractor",
	"burner-omniplant",
	"burner-inserter",
	"burner-filter-inserter",
	"burner-ore-crusher",
  	"stone-furnace",
	"stone-mixing-furnace",
	"stone-chemical-furnace",
	"burner-assembling-machine",
	"burner-mining-drill",
	"omnitor-lab",
	"omnitor-assembling-machine",
	"burner-omni-furnace"
}
local fuelcats = {
	"omnite",
	"chemical"
}
if mods["Krastorio2"] then fuelcats[#fuelcats+1] = "vehicle-fuel" end

for _,entity in pairs(burnerEntities) do
	local build = omni.lib.find_entity_prototype(entity)
	if build then
		build.energy_source.fuel_category = nil
		build.energy_source.fuel_categories = fuelcats
	end
end

--Find all remaining Techs without any prereqs that unlock entities that require electricity and move them behind anbaricity
for _,tech in pairs(data.raw.technology) do 
	local ent
	if tech.effects and (tech.prerequisites == nil or next(tech.prerequisites) == nil) then
		for _,eff in pairs(tech.effects) do
			if eff.type == "unlock-recipe" then
				ent = omni.lib.find_entity_prototype(eff.recipe)
				if ent and ent.energy_source and ent.energy_source.type == "electric" then
					omni.lib.add_prerequisite(tech.name, "omnitech-anbaricity")
				end
			end
		end
	end
end