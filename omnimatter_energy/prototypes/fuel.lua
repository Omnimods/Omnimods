local ignore = {
	"omnite",
    "crushed-omnite",
    "omniwood",
    "seedling",
    "omniseedling",
}

if mods["omnimatter-wood"] then
    table.insert(ignore, "wood")
    data.raw.item["wood"].fuel_value = nil
    data.raw.item["wood"].fuel_category = nil
end

for _,fuelitem in pairs(data.raw.item) do  

    for _,blockeditem in pairs(ignore) do
        if fuelitem.name == blockeditem then
            fuelitem.fuel_value = omni.lib.multFuelValue(fuelitem.fuel_value, 0.75)
            goto continue 
        end
    end

    --Generate Chemical Fuel Recipes
    if fuelitem.fuel_category == "chemical" and fuelitem.fuel_value and fuelitem.subgroup ~= "omnicell" then
        log("IMPORTING: "..fuelitem.name)
        --log(serpent.block(fuelitem))

        RecGen:create("omni-energy-"..fuelitem.name):
            setName("omni-energy-"..fuelitem.name,"omnimatter_energy"):
            setItemName("omni-energy-"..fuelitem.name):
            setIcons(fuelitem.icons or {{icon = fuelitem.icon,icon_size = fuelitem.icon_size}}):
            addSmallIcon("__omnimatter_energy__/graphics/icons/omnicell-charged.png",3):
            setResults({"omni-energy-"..fuelitem.name,1}):
            setSubgroup("omnicell"):
            setEnabled(false):
            extend()

        if omni.lib.getFuelNumberInMJ(fuelitem.fuel_value) <= 5.0 then
            RecGen:import("omni-energy-"..fuelitem.name,"omnimatter_energy"):
            setIngredients({fuelitem.name,1},{"crushed-omnite",2}):
            setCategory("crafting"):
            setEnergy(1.0):
            setTechName("omnium-power-1"):
            --addTechPrereq(omni.lib.find_tech_name(fuelitem.name)):
            extend() 
            omni.lib.add_prerequisite("omnium-power-1", omni.lib.find_tech_name(fuelitem.name))  
        elseif omni.lib.getFuelNumberInMJ(fuelitem.fuel_value) <= 10.0 then
            RecGen:import("omni-energy-"..fuelitem.name,"omnimatter_energy"):
            setIngredients({fuelitem.name,1},{"pulverized-omnite",4}):
            setCategory("omnitractor"):
            setEnergy(2.0):
            setTechName("omnium-power-2"):
           -- addTechPrereq(omni.lib.find_tech_name(fuelitem.name)):
            extend()
            omni.lib.add_prerequisite("omnium-power-2", omni.lib.find_tech_name(fuelitem.name))
        elseif omni.lib.getFuelNumberInMJ(fuelitem.fuel_value) <=40.0 then
            RecGen:import("omni-energy-"..fuelitem.name,"omnimatter_energy"):
            setIngredients({fuelitem.name,1},{type = "fluid", name = "omnic-acid", amount = 20}):
            setCategory("omniphlog"):
            setEnergy(2.0):
            setTechName("omnium-power-3"):
            --addTechPrereq(omni.lib.find_tech_name(fuelitem.name)):
            extend()
            omni.lib.add_prerequisite("omnium-power-3", omni.lib.find_tech_name(fuelitem.name))
        elseif omni.lib.getFuelNumberInMJ(fuelitem.fuel_value) <= 250.0 then
            RecGen:import("omni-energy-"..fuelitem.name,"omnimatter_energy"):
            setIngredients({fuelitem.name,1},{type = "fluid", name = "omnisludge", amount = 80}):
            setCategory("omniplant"):
            setEnergy(4.0):
            setTechName("omnium-power-4"):
            --addTechPrereq(omni.lib.find_tech_name(fuelitem.name)):
            extend()
            omni.lib.add_prerequisite("omnium-power-4", omni.lib.find_tech_name(fuelitem.name))
        else 
            RecGen:import("omni-energy-"..fuelitem.name,"omnimatter_energy"):
            setIngredients({fuelitem.name,1},{type = "fluid",name = "omniston", amount = 40}):
            setCategory("omniplant"):
            setEnergy(4.0):
            setTechName("omnium-power-5"):
            --addTechPrereq(omni.lib.find_tech_name(fuelitem.name)):
            extend()
            omni.lib.add_prerequisite("omnium-power-5", omni.lib.find_tech_name(fuelitem.name))
        end

        --Copy over fuel related values
        data.raw.item["omni-energy-"..fuelitem.name].fuel_category = fuelitem.fuel_category
        data.raw.item["omni-energy-"..fuelitem.name].fuel_value = fuelitem.fuel_value
        data.raw.item["omni-energy-"..fuelitem.name].fuel_acceleration = fuelitem.fuel_acceleration
        data.raw.item["omni-energy-"..fuelitem.name].fuel_acceleration_multiplier = fuelitem.fuel_acceleration_multiplier
        data.raw.item["omni-energy-"..fuelitem.name].fuel_top_speed = fuelitem.fuel_top_speed
        data.raw.item["omni-energy-"..fuelitem.name].fuel_top_speed_multiplier = fuelitem.fuel_top_speed_multiplier
        data.raw.item["omni-energy-"..fuelitem.name].fuel_emissions = fuelitem.fuel_emissions
        data.raw.item["omni-energy-"..fuelitem.name].fuel_glow_color = fuelitem.fuel_glow_color

        --Remove Fuel related values on the old item
        --FUCKS UP COMPATIBILITY!!!!
        --fuelitem.fuel_acceleration = nil
        --fuelitem.fuel_acceleration_multiplier = nil
        --fuelitem.fuel_top_speed = nil
        --fuelitem.fuel_top_speed_multiplier = nil
        --fuelitem.fuel_emissions = nil
        --fuelitem.fuel_glow_color = nil
        fuelitem.fuel_value = "1kJ"
        fuelitem.fuel_category = "omni-0"


       log("DONE WITH: "..fuelitem.name)
      -- log(serpent.block(data.raw["item"]["omni-energy-"..fuelitem.name]))
   
    end
::continue::
end