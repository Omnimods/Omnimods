--Offshore pump should output omnic water
for _,pump in pairs(data.raw["offshore-pump"]) do
    if pump.fluid == "water" then
        pump.fluid = "omnic-water"
        pump.fluid_box.filter = "omnic-water"
    end
end
--Check assemblers aswell, some mods add electric "offshore pumps"
for _,pump in pairs(data.raw["assembling-machine"]) do
    if pump.fixed_recipe and pump.fluid and pump.fluid  == "water" then
        local rec = data.raw.recipe[pump.fixed_recipe]
        if omni.lib.recipe_result_contains(rec.name, "water") then
            omni.lib.replace_recipe_result(rec.name, "water", "omnic-water")
            pump.fluid = "omnic-water"
            pump.fluid_box.filter = "omnic-water"
        end
    end
end

--Add a waste-water to omnic water recycling recipe
RecGen:create("omnimatter", "omnic-waste-recycling"):
    setIngredients({type = "fluid", amount = 420, name = "omnic-waste"}):
    setResults({type = "fluid", amount = 60, name = "omnic-water"}):
    setIcons("omnic-water"):
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
            setIcons("omnic-water"):
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
    if not rec.hidden and not string.find(rec.name, "barrel") then
        for _, flu in pairs(fluids) do
            if  omni.lib.recipe_result_contains(rec.name, flu) then
                local techname = omni.lib.get_tech_name(rec.name)
                if rec.enabled or (rec.normal and rec.normal.enabled) or (rec.expensive and rec.expensive.enabled) then
                    omni.lib.enable_recipe("omniflush-"..flu)
                elseif techname then
                    omni.lib.add_unlock_recipe(techname, "omniflush-"..flu)
                end
            end
        end
    end
end