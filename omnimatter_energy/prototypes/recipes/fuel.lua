--Save item names where the fuel values should be nilled, nil in final-fixes
omni.nil_fuels = {}

----------------------
-----IGNORE LISTS-----
----------------------

--Fuels to ignore, no Omnified Fuel will be created, Fuel Value will be decreased by 20%
local ignore = {
    "omnite",
    "crushed-omnite",
    "omniwood",
    "seedling",
    "omniseedling",
}

--Fuels to disable,no omnified version will be created, fuel values will be nilled
local nilfuel = {
    "wooden-chest",
    "small-electric-pole"
}

--Fuel categories that get omnified
local fuelcats = {
    "chemical",
    "vehicle-fuel" --K2 thing
}

-- Things to only insert if certain mods are present
if mods["omnimatter_wood"] then
    table.insert(nilfuel, "wood")
end
--nil Bob´s carbon if angel is present
if mods["angelspetrochem"] then
    table.insert(nilfuel, "carbon")
end

-----------------------
-----FUEL CREATION-----
-----------------------

for _,fuelitem in pairs(data.raw.item) do
    --Check if item is on the "ignore" list
    for _,blockeditem in pairs(ignore) do
        if fuelitem.name == blockeditem and fuelitem.fuel_category then
            fuelitem.fuel_value = omni.lib.mult_fuel_value(fuelitem.fuel_value, 0.8)
            goto continue 
        end
    end
    --Check if item is on the "to nil" list
    for _,nilit in pairs(nilfuel) do
        if fuelitem.name == nilit and fuelitem.fuel_category then
            omni.nil_fuels[#omni.nil_fuels+1] = fuelitem.name
            goto continue 
        end
    end

    --Generate Chemical Fuel Recipes
    if omni.lib.is_in_table(fuelitem.fuel_category, fuelcats) and fuelitem.fuel_value and not (fuelitem.subgroup and string.find(fuelitem.subgroup, "omnienergy-fuel", 1, true)) then

        --lets define the variables first, then jump in and create it all in one go:
        --Get fuel number in MJ (divide by 10^6)
        local FV=omni.lib.get_fuel_number(fuelitem.fuel_value)/10^6
        local props={
            [5]={ing_add={"crushed-omnite",1}, cat="crafting", sub="omnienergy-fuel-1", time=1.0, tech="omnitech-omnium-power-1", fuelmult = 1.50},
            [10]={ing_add={"pulverized-omnite",2}, cat="omnifurnace", sub="omnienergy-fuel-2", time=2.0,tech="omnitech-omnium-power-2", fuelmult = 1.45},
            [40]={ing_add={type = "fluid", name = "omnic-acid", amount = 20}, cat="omnite-extraction", sub="omnienergy-fuel-3", time=2.0,tech="omnitech-omnium-power-3", fuelmult = 1.40},
            [250]={ing_add={type = "fluid", name = "omnisludge", amount = 80}, cat="omniphlog", sub="omnienergy-fuel-4", time=4.0,tech="omnitech-omnium-power-4", fuelmult = 1.35},
            [300]={ing_add={type = "fluid", name = "omniston", amount = 40}, cat="omniphlog", sub="omnienergy-fuel-5", time=4.0,tech="omnitech-omnium-power-5", fuelmult = 1.30}
        }
        if mods["omnimatter_crystal"] then props[300].cat = "omniplant" end
            local props_add={}
        if FV<=5 then
            props_add=props[5]
        elseif FV<=10 then
            props_add=props[10]
        elseif FV<=40 then
            props_add=props[40]
        elseif FV<=250 then
            props_add=props[250]
        else
            props_add=props[300]
        end
        RecGen:create("omnimatter_energy","omnified-"..fuelitem.name):
            setLocName("item-name.omnified", "item-name."..fuelitem.name):
            setIcons(omni.lib.icon.of(fuelitem)):
            addSmallIcon("__omnimatter_energy__/graphics/icons/omnicell-charged.png",3):
            setResults({"omnified-"..fuelitem.name,1}):
            setSubgroup(props_add.sub):
            setIngredients({fuelitem.name,1},props_add.ing_add):
            setCategory(props_add.cat):
            setEnergy(props_add.time):
            setTechName(props_add.tech):
            addTechPrereq(omni.lib.get_tech_name(fuelitem.name)):
            setEnabled(false):
            setStacksize(fuelitem.stack_size):
            setOrder("b[omnified-"..fuelitem.name.."]"):
            setFuelCategory(fuelitem.fuel_category):
            setFuelValue(omni.lib.mult_fuel_value(fuelitem.fuel_value, props_add.fuelmult)):
            extend()
            omni.lib.add_prerequisite(props_add.tech,omni.lib.get_tech_name(fuelitem.name))

        --Copy over fuel related values
        data.raw.item["omnified-"..fuelitem.name].fuel_acceleration_multiplier = fuelitem.fuel_acceleration_multiplier
        data.raw.item["omnified-"..fuelitem.name].fuel_acceleration_multiplier = fuelitem.fuel_acceleration_multiplier
        data.raw.item["omnified-"..fuelitem.name].fuel_top_speed_multiplier = fuelitem.fuel_top_speed_multiplier
        data.raw.item["omnified-"..fuelitem.name].fuel_top_speed_multiplier = fuelitem.fuel_top_speed_multiplier
        data.raw.item["omnified-"..fuelitem.name].fuel_emissions_multiplier = fuelitem.fuel_emissions_multiplier
        data.raw.item["omnified-"..fuelitem.name].fuel_emissions_multiplier = fuelitem.fuel_emissions_multiplier
        data.raw.item["omnified-"..fuelitem.name].fuel_glow_color = fuelitem.fuel_glow_color 

        --Nil fuel related values
        omni.nil_fuels[#omni.nil_fuels+1] = fuelitem.name
    end
::continue::
end

--Add Solid Fuel Tech Prereqs manually
if mods["angelspetrochem"] then
    if data.raw.technology["gas-processing"] and data.raw.technology["gas-processing"].hidden ~= true then
        omni.lib.add_prerequisite("omnitech-omnium-power-3", "gas-processing")
    end
    if data.raw.technology["oil-processing"] and data.raw.technology["oil-processing"].hidden ~= true then
        omni.lib.add_prerequisite("omnitech-omnium-power-3", "oil-processing")
    end
else
    if data.raw.technology["solid-fuel"] and data.raw.technology["solid-fuel"].hidden ~= true then
        omni.lib.add_prerequisite("omnitech-omnium-power-3","solid-fuel")
    end
    if data.raw.technology["advanced-oil-processing"] and data.raw.technology["advanced-oil-processing"].hidden ~= true then
        omni.lib.add_prerequisite("omnitech-omnium-power-3", "advanced-oil-processing")
    end
end

RecGen:create("omnimatter_energy","purified-omnite"):
    setIngredients({type="item", name="crushed-omnite", amount=5}):
    setResults({type="item", name="purified-omnite", amount=4}):
    setIcons({"purified-omnite", 32}):
    setStacksize(200):
    setCategory("omnifurnace"):
    setSubgroup("omnienergy-fuel-1"):
    setOrder("a"):
    setFuelCategory("chemical"):
    setFuelValue(2.4):
    setEnergy(4.0):
    setEnabled(false):
    setTechName("omnitech-basic-omnium-power"):
    setTechCost(55):
    setTechPacks({"energy-science-pack", 1}):
    setTechIcons("purified-omnite","omnimatter_energy"):
    setTechPrereq("omnitech-anbaricity"):
    extend()

--remove upper omnium-power techs that unlock nothing
for i=5,2,-1 do
    local tech = data.raw.technology["omnitech-omnium-power-"..i]
    if not next(tech.effects) then
        TechGen:import(tech.name):setPrereq(nil):setUpgrade(false):setEnabled(true):nullUnlocks():sethidden():extend()
    --Break when the highest omnium power tech that has an effect is reached
    else
        break
    end
end