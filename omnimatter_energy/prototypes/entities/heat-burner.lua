--Heat
RecGen:create("omnimatter_energy","heat"):
	fluid():
	setIcons({{icon = "__omnilib__/graphics/icons/small/burner.png", icon_size = 32}}):
	setBothColour(1,0,0):
	setCategory("omnite-extraction-burner"):
	setSubgroup("omnienergy-power"):
	setOrder("ab"):
	setEnergy(20):
	setMaxTemp(250):
	setFuelCategory("thermo"):
	setCapacity(1):
	setTechName("omnitech-anbaricity"):
	setTechCost(40):
	setTechIcons({{"electric-engine",256}},"base"):
	setTechPrereq():
	ifAddTechPrereq(settings.startup["bobmods-logistics-beltoverhaul"] and settings.startup["bobmods-logistics-beltoverhaul"].value,
		"omnitech-basic-splitter-logistics","omnitech-basic-underground-logistics"):
	ifAddTechPrereq(not (settings.startup["bobmods-logistics-beltoverhaul"] and settings.startup["bobmods-logistics-beltoverhaul"].value),
		"omnitech-splitter-logistics","omnitech-underground-logistics"):
	setTechPacks(1):	
	setResults({type="fluid",name="heat",amount=2*60+1,temperature=250}):
	extend()

data.raw.fluid.heat.auto_barrel = false

--MOVE
local regular_cost = {}
local expensive cost = {}
if mods["angelsindustries"] and angelsmods.industries.components then
	regular_cost = {{"stone-furnace", 1}, {"block-omni-1", 4}, {"construction-frame-1", 4}, {"block-fluidbox-1", 4}}
	expensive_cost = {{"stone-furnace", 2}, {"block-omni-1", 10}, {"construction-frame-1", 10}, {"block-fluidbox-1", 10}}
else
	regular_cost = {{"anbaric-omnitor",4},{"omnicium-gear-wheel",5},{"stone-furnace",1}}
	expensive_cost = {{"anbaric-omnitor",9},{"omnicium-gear-wheel",12},{"stone-furnace",2}}
end



--Heat Burner
BuildGen:import("steam-turbine"):
	setName("omni-heat-burner","omnimatter_energy"):
	--setFluidBox("XTX.XXX.XXX.XXX.XGX","heat",400)
	setLocName():
	setFilter("heat"):
	nullIngredients():
	setNormalIngredients(regular_cost):
	setExpensiveIngredients(expensive_cost):
	setReplace("heat-burner"):
	setSubgroup("omnienergy-power"):
	setOrder("aa"):
	setTechName("omnitech-anbaricity"):
	setFluidConsumption(1):
	setEffectivity(2/13.5/2):
	setMaxTemp(250):
	setNextUpgrade():extend()