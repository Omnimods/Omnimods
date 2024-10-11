-- Replace the water output from all diefferent types of "water pumps" with omnic water
--Ceck tile.fluid for possible pump outputs
for _, t in pairs(data.raw.tile) do
    if t.fluid and t.fluid== "water" then
        t.fluid = "omnic-water"
    end
end

--Check assemblers aswell, some mods add electric "offshore pumps"
for _,pump in pairs(data.raw["assembling-machine"]) do
    if pump.fixed_recipe and omni.lib.recipe_result_contains(pump.fixed_recipe, "water") then
        local rec = data.raw.recipe[pump.fixed_recipe]
        --check if the recipe has no ingredients
        if not (next(rec.ingredients)) then
            omni.lib.replace_recipe_result(rec.name, "water", "omnic-water")
        end
    end
end

--Mining drills
for _,pump in pairs(data.raw["mining-drill"]) do
    if pump.output_fluid_box and pump.output_fluid_box.filter == "water" then
        pump.output_fluid_box.filter  = "omnic-water"
    end
end

--Resources
for _,pump in pairs(data.raw["resource"]) do
    if pump.minable then
        if pump.minable.results then
            for _,res in pairs(pump.minable.results) do
                if res.type == "fluid" and res.name == "water" then
                    res.name  = "omnic-water"
                end
            end
        elseif pump.minable.result and pump.minable.result == "water" then
            pump.minable.result = "omnic-water"
        end
    end
end

--Add a waste-water to omnic water recycling recipe
RecGen:create("omnimatter", "omnic-waste-recycling"):
    setIngredients({type = "fluid", amount = 420, name = "omnic-waste"}):
    setResults({type = "fluid", amount = 60, name = "omnic-water"}):
    setIcons({"omnic-water", 32}):
    addSmallIcon(omni.lib.icon.of("omnic-waste", "fluid"), 3):
    setCategory("omniphlog"):
    setEnabled(true):
    setSubgroup("omni-fluids"):
    setOrder("b[omnic-waste-recycling]"):
    setLocName({"recipe-name.omnic-waste-recycling"}):
    extend()


--Create omnic water recipes for every fluid
local fluids = {}
for _, fluid in pairs(data.raw.fluid) do
    if fluid.name ~= "heat" and fluid.name ~= "omnic-water" and fluid.name ~= "omnic-waste" then
        RecGen:create("omnimatter","omniflush-"..fluid.name):
            setIngredients({type="fluid",amount=360,name=fluid.name}):
            setResults({type="fluid",amount=60,name="omnic-water"}):
            setIcons({"omnic-water", 32}):
            addSmallIcon(omni.lib.icon.of(fluid.name, "fluid"),3):
            setCategory("omniphlog"):
            setEnabled(fluid.name=="omnic-waste"):
            --setSubgroup(fluid.subgroup):
            setSubgroup("omnilation"):
            --Same subgroup & order, but put the omnic water block behind all other recipes in that subgroup
            setOrder("zzz"..(fluid.order or "")):
            setLocName({"recipe-name.omnilation", omni.lib.locale.of(fluid).name }):
            extend()
        fluids[#fluids+1] = fluid.name
    end
end

for _, rec in pairs(data.raw.recipe) do
    if not rec.hidden and not (string.find(rec.name, "barrel") or string.find(rec.name, "canister") ) then
        for _, flu in pairs(fluids) do
            if  omni.lib.recipe_result_contains(rec.name, flu) then
                local techname = omni.lib.get_tech_name(rec.name)
                if rec.enabled == true then
                    data.raw.recipe["omniflush-"..flu].enabled = true
                elseif techname then
                    omni.lib.add_unlock_recipe(techname, "omniflush-"..flu)
                end
            end
        end
    end
end