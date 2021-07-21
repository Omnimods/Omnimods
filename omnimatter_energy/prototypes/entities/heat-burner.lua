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
    setResults({type="fluid",name="heat",amount=2*60+1,temperature=250}):
    extend()

data.raw.fluid.heat.auto_barrel = false

--Heat Burner
BuildGen:import("steam-turbine"):
    setName("omni-heat-burner","omnimatter_energy"):
    --setFluidBox("XTX.XXX.XXX.XXX.XGX","heat",400)
    setLocName():
    setFilter("heat"):
    nullIngredients():
    setNormalIngredients({{"anbaric-omnitor",4},{"omnicium-gear-wheel",5},{"stone-furnace",1}}):
    setReplace("heat-burner"):
    setSubgroup("omnienergy-power"):
    setOrder("aa"):
    setTechName("omnitech-anbaricity"):
    setFluidConsumption(1):
    setEffectivity(2/13.5/2):
    setMaxTemp(250):
    setNextUpgrade():extend()