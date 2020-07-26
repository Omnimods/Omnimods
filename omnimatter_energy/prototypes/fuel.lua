--Fuels to ignore, no Omnified Fuel will be created, Fuel Value will be decreased by 10%
local ignore = {
	"omnite",
    "crushed-omnite",
    "omniwood",
    "seedling",
    "omniseedling",
}

--Fuels to disable,no omnified version will be created, fuel values will be nilled
local nilfuel = {}

if mods["omnimatter_wood"] then
    table.insert(nilfuel, "wood")
end

--nil Bob´s carbon if angel is present
if mods["angelspetrochem"] then
    table.insert(nilfuel, "carbon")
end

for _,fuelitem in pairs(data.raw.item) do  

    for _,blockeditem in pairs(ignore) do
        if fuelitem.name == blockeditem then
            fuelitem.fuel_value = omni.lib.multFuelValue(fuelitem.fuel_value, 0.9)
            goto continue 
        end
    end

    for _,nilit in pairs(nilfuel) do
        if fuelitem.name == nilit then
            --fuelitem.fuel_value = "1kJ"
            fuelitem.fuel_category = "omni-0"
            goto continue 
        end
    end

    --Generate Chemical Fuel Recipes
    if fuelitem.fuel_category == "chemical" and fuelitem.fuel_value and not string.find(fuelitem.subgroup, "omnienergy-fuel", 1, true) then

        --lets define the variables first, then jump in and create it all in one go:
        local FV=omni.lib.getFuelNumberInMJ(fuelitem.fuel_value)
        local props={
            [5]={ing_add={"crushed-omnite",2}, cat="crafting", sub="omnienergy-fuel-1", time=1.0, tech="omnium-power-1", fuelmult = 1.30},
            [10]={ing_add={"pulverized-omnite",4}, cat="omnite-extraction", sub="omnienergy-fuel-2", time=2.0,tech="omnium-power-2", fuelmult = 1.25},
            [40]={ing_add={type = "fluid", name = "omnic-acid", amount = 20}, cat="omniphlog", sub="omnienergy-fuel-3", time=2.0,tech="omnium-power-3", fuelmult = 1.20},
            [250]={ing_add={type = "fluid", name = "omnisludge", amount = 80}, cat="omniplant", sub="omnienergy-fuel-4", time=4.0,tech="omnium-power-4", fuelmult = 1.15},
            [300]={ing_add={type = "fluid", name = "omniston", amount = 40}, cat="omniplant", sub="omnienergy-fuel-5", time=4.0,tech="omnium-power-5", fuelmult = 1.10},}
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
            setIcons(fuelitem.icons or {{icon = fuelitem.icon,icon_size = fuelitem.icon_size}}):
            addSmallIcon("__omnimatter_energy__/graphics/icons/omnicell-charged.png",3):
            setResults({"omnified-"..fuelitem.name,1}):
            setSubgroup(props_add.sub):
            setIngredients({fuelitem.name,1},props_add.ing_add):
            setCategory(props_add.cat):
            setEnergy(props_add.time):
            setTechName(props_add.tech):
            addTechPrereq(omni.lib.find_tech_name(fuelitem.name)):
            setEnabled(false):
            setStacksize(fuelitem.stack_size):
            setOrder("b"):
            setFuelCategory(fuelitem.fuel_category):
            setFuelValue(omni.lib.multFuelValue(fuelitem.fuel_value, props_add.fuelmult)):
            extend()
            omni.lib.add_prerequisite(props_add.tech,omni.lib.find_tech_name(fuelitem.name))

        --Copy over fuel related values
        data.raw.item["omnified-"..fuelitem.name].fuel_acceleration = fuelitem.fuel_acceleration
        data.raw.item["omnified-"..fuelitem.name].fuel_acceleration_multiplier = fuelitem.fuel_acceleration_multiplier
        data.raw.item["omnified-"..fuelitem.name].fuel_top_speed = fuelitem.fuel_top_speed
        data.raw.item["omnified-"..fuelitem.name].fuel_top_speed_multiplier = fuelitem.fuel_top_speed_multiplier
        data.raw.item["omnified-"..fuelitem.name].fuel_emissions = fuelitem.fuel_emissions
        data.raw.item["omnified-"..fuelitem.name].fuel_glow_color = fuelitem.fuel_glow_color

        --fuelitem.fuel_value = "1kJ" not needed since the fuel category is changed
        fuelitem.fuel_category = "omni-0"

        if omni.lib.debug_mode then 
            log("Created Omnified "..fuelitem.name)
        end
      -- log(serpent.block(data.raw["item"]["omni-energy-"..fuelitem.name]))
    end
::continue::
end

--Add Solid Fuel Tech Prereq manually
if data.raw.technology["solid-fuel"] then
    omni.lib.add_prerequisite("omnium-power-3","solid-fuel")
elseif data.raw.technology["advanced-oil-processing"] then
    omni.lib.add_prerequisite("omnium-power-3","advanced-oil-processing")
end

RecGen:create("omnimatter_energy","purified-omnite"):
    setIngredients({type="item", name="crushed-omnite", amount=5}):
    setResults({type="item", name="purified-omnite", amount=2}):
	setStacksize(200):
    setCategory("omnifurnace"):
    setSubgroup("omnienergy-fuel-1"):
    setOrder("a"):
	setFuelCategory("chemical"):
	setFuelValue(2.4):
    setEnergy(2.0):
    setEnabled(false):
    setTechName("basic-omnium-power"):
	setTechCost(55):
	setTechIcon("omnimatter_energy","purified-omnite"):
    setTechPrereq("anbaricity"):extend()
  
omni.lib.add_prerequisite("burner-filter-2","basic-omnium-power")
omni.lib.add_prerequisite("omnium-power-1","basic-omnium-power")