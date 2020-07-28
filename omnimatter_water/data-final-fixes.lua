if mods["aai-industry"] then
	data.raw["burner-generator"]["burner-turbine"].energy_source.effectivity=0.9/3
end

--Disable all Pump recipes
for _,pump in pairs(data.raw["offshore-pump"]) do
	--Find recipes
	local rec = omni.lib.find_recipe(pump.name)
	--Remove recipe from Techs and disable it
	omni.lib.remove_recipe_all_techs(rec.name)
	--If any recipes use this pump as ingredient, replace it with the vanilla pump
	omni.lib.replace_all_ingredient(pump.name,"pump")

	if rec.normal or rec.expensive then
		rec.normal.enabled = false
		rec.expensive.enabled = false
	else
		rec.enabled = false
	end
end