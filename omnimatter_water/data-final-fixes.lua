if mods["aai-industry"] then
    data.raw["burner-generator"]["burner-turbine"].energy_source.effectivity=0.9/3
end

--Disable all Pump recipes
for _,pump in pairs(data.raw["offshore-pump"]) do
    --Get the according recipe
    local recs = omni.lib.find_recipes(pump.name)
    for _, rec in pairs(recs) do
        --Remove recipe from Techs and disable it
        omni.lib.remove_recipe_all_techs(rec.name)
        --If any recipes use this pump as ingredient, replace it with the vanilla pump
        omni.lib.replace_all_ingredient(pump.name, "pump")
        rec.enabled = false
    end
end