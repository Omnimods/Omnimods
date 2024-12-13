ItemGen:import("omnite"):setFuelCategory("omnite"):extend()
ItemGen:import("crushed-omnite"):setFuelCategory("omnite"):extend()
ItemGen:importIf("omniwood"):setFuelCategory("omnite"):extend()

--Nil fuelvalues of the items saved in fuel.lua
for _,fuel in pairs(omni.nil_fuels) do
    if data.raw.item[fuel] then
        local fuelitem = data.raw.item[fuel]

        --Nil all fuel values. Could cause crashes if 1 is overseen. if it doesnt work out, go back to changing fuel cat to omni-0
        --fuelitem.fuel_category = "omni-0"
        fuelitem.fuel_category = nil
        fuelitem.fuel_value = nil
        fuelitem.fuel_acceleration_multiplier = nil
        fuelitem.fuel_top_speed_multiplier = nil
        fuelitem.fuel_emissions_multiplier = nil
        fuelitem.fuel_glow_color = nil
    end
end

for type, enti in pairs(data.raw) do
    if omni.lib.locale.inherits(type, "entity-with-owner") then
        for _, proto in pairs(enti) do
            if proto.energy_source and proto.energy_source.initial_fuel then
                local it = proto.energy_source.initial_fuel
                if omni.lib.string_contained_list(it, omni.nil_fuels) then
                    proto.energy_source.initial_fuel = "omnified-"..it
                end
            end
        end
    end
end

--Update fuel categories of burner entities
local burnerEntities = {
    "burner-mining-drill",
    "burner-research_facility",
    "burner-omnicosm",
    "burner-omniphlog",
    "burner-omnitractor",
    "burner-omniplant",
    "burner-inserter",
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