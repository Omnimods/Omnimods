RecGen:create("omnimatter_energy","omnitor"):
    setStacksize(100):
    addMask(197/255,58/255,97/255):
    setCategory("crafting"):
    setSubgroup("omnienergy-intermediates"):
    setOrder("a"):
    setEnergy(0.75):
    setIngredients({type="item", name="omnicium-plate", amount=1},{type="item", name="omnicium-gear-wheel", amount=1}):
    addProductivity():
    setEnabled():
    extend()

RecGen:create("omnimatter_energy","anbaric-omnitor"):
    setIngredients({type="item", name="omnicium-plate", amount=2},{type="item", name="copper-cable", amount=2},{type="item", name="omnitor", amount=1}):
    addProductivity():
    setStacksize(100):
    addMask(0/255,186/255,184/255):
    setCategory("crafting"):
    setSubgroup("omnienergy-intermediates"):
    setOrder("b"):
    setEnergy(0.75):
    setTechName("omnitech-anbaricity"):
    setTechIcons(omni.lib.icon.of("electric-engine", "technology")):
    setTechPrereq("basic-splitter-logistics", "basic-underground-logistics"):
    setTechCost(40):
    setTechPacks({{"energy-science-pack", 1}}):
    extend()

RecGen:create("omnimatter_energy", "omni-tablet"):
    setIngredients("omnite-brick"):
    setResults({"omni-tablet",2}):
    setStacksize(200):
    setSubgroup("omnienergy-intermediates"):
    setEnabled(true):
    setEnergy(0.5):
    extend()