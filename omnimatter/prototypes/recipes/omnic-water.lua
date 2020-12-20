--Offshore pump should output omnic water
for _,pump in pairs(data.raw["offshore-pump"]) do
	if pump.fluid == "water" then
		pump.fluid="omnic-water"
		pump.fluid_box.filter="omnic-water"
	end
end

--Create omnic water recipes for every fluid
local fluids = {}
for _, fluid in pairs(data.raw.fluid) do
	if fluid.name ~= "heat" and fluid.name ~= "omnic-water" then
		RecGen:create("omnimatter","omniflush-"..fluid.name):
			setIngredients({type="fluid",amount=360,name=fluid.name}):
			setResults({type="fluid",amount=60,name="omnic-water"}):
			setIcons("omnic-water"):
			addSmallIcon(omni.icon.of(fluid.name, "fluid"),3):
			setCategory("omniphlog"):
			setEnabled(fluid.name=="omnic-waste"):
			--setSubgroup(fluid.subgroup):
			setSubgroup("omnilation"):
			--Same subgroup & order, but put the omnic water block behind all other recipes in that subgroup
			setOrder("zzz"..(fluid.order or "")):
			setLocName({"recipe-name.omnilation", omni.locale.of(fluid).name }):
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