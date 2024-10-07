RecGen:create("omnimatter","stone"):
    setSubgroup("omni-solids"):
    setStacksize(200):
    setEnergy(0.25):
    setCategory():
    setIcons("stone"):
    setIngredients({"stone-crushed", 2}):
    setResults({type="item", name="stone", amount=1}):
    setEnabled():
    extend()

local c = nil
if mods["angelsrefining"] then c = "ore-refining-t1" end
RecGen:create("omnimatter","stone-crushed"):
    setSubgroup("omni-crushing"):
    setStacksize(200):
    setEnergy(0.1):
    setCategory(c):
    setIngredients({"stone", 1}):
    setResults({type="item", name="stone-crushed", amount=2}):
    setEnabled():
    extend()

RecGen:create("omnimatter","crushed-omnite"):
    setSubgroup("omni-crushing"):
    setStacksize(500):
    setCategory(c):
    setEnergy(0.2):
    setFuelValue(0.85):
    setIngredients({type="item", name="omnite", amount=1}):
    setResults({type="item", name="crushed-omnite", amount=1}):
    setIcons({{icon ="crushed-omnite", icon_size = 32}}, "omnimatter"):
    extend()

RecGen:create("omnimatter","crushing-omnite-by-hand"):
    setSubgroup("omni-crushing"):
    setEnergy(0.25):
    setCategory("crafting"):
    setEnabled():
    setIngredients({"omnite", 2}):
    setResults({
        {type="item", name="crushed-omnite", amount=1},
        {type="item", name="stone-crushed", amount=1}
    }):
    setIcons({{icon ="crushed-omnite", icon_size = 32}}, "omnimatter"):
    extend()
    
RecGen:create("omnimatter","pulverized-omnite"):
    setSubgroup("omni-crushing"):
    setStacksize(500):
    setCategory(c):
    setIngredients({"crushed-omnite", 1}):
    setResults({type="item", name="pulverized-omnite", amount=1}):
    setEnergy(0.2):
    extend()

RecGen:create("omnimatter","pulverized-stone"):
    setSubgroup("omni-crushing"):
    setStacksize(500):
    setEnergy(0.1):
    setCategory(c):
    setIngredients({"stone-crushed", 1}):
    setResults({type="item", name="pulverized-stone", amount=1}):
    extend()

ItemGen:create("omnimatter","omnic-waste"):
    fluid():
    setBothColour(0,0,1):
    extend()

ItemGen:create("omnimatter","omnic-water"):
    fluid():
    setBothColour(1,0,1):
    extend()

ItemGen:create("omnimatter","omniston"):
    fluid():
    setBothColour(0.34,0.92,0.92):
    extend()

ItemGen:create("omnimatter","omnic-acid"):
    fluid():
    setBothColour(0.63,0.34,0.90):
    extend()

ItemGen:create("omnimatter","omnisludge"):
    fluid():
    setBothColour(0.41,0.34,0.49):
    extend()

    
RecGen:create("omnimatter","pulver-omnic-waste"):
    setSubgroup("omni-fluids"):
    setCategory("omniphlog"):
    setIcons("omnic-waste"):
    setIngredients({"pulverized-omnite", 1},{"pulverized-stone", 6}):
    setResults({type="fluid", name="omnic-waste", amount=120}):
    setEnergy(0.8):
    extend()