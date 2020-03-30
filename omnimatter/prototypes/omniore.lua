ItemGen:create("omnimatter","omnite"):
setFuelValue(2):
setStacksize(500):extend()

RecGen:create("omnimatter","stone"):
	setSubgroup("omni-solids"):
	setStacksize(200):
	setEnergy(0.5):
	setCategory():
	marathon():
	setIcons("stone", "base"):
	setIngredients({"stone-crushed", 4}):
	setResults({type="item", name="stone", amount=2}):
	setEnabled():extend()

local c = nil
if mods["angelsrefining"] then c = "ore-sorting-t1" end
RecGen:create("omnimatter","stone-crushed"):
	setSubgroup("omni-crushing"):
	setStacksize(200):
	setEnergy(0.5):
	setCategory(c):
	marathon():
	setIngredients({"stone", 5}):
	setResults({type="item", name="stone-crushed", amount=10}):
	setEnabled():extend()
	
RecGen:create("omnimatter","crushed-omnite"):
	setSubgroup("omni-crushing"):
	setStacksize(500):
	setCategory(c):
	marathon():
	setEnergy(0.5):
	setFuelValue(0.85):
	setIngredients({"omnite",5}):
	setResults({type="item", name="crushed-omnite", amount=10}):extend()

RecGen:create("omnimatter","crushing-omnite-by-hand"):
	setSubgroup("omni-crushing"):
	setEnergy(0.25):
	setCategory("crafting"):
	setEnabled():
	setIngredients({"omnite", 4}):
	marathon():
	setResults({
		  {type="item", name="crushed-omnite", amount=2},
		  {type="item", name="stone-crushed", amount=1}
		}):
	setIcons("crushed-omnite","omnimatter"):extend()
	
RecGen:create("omnimatter","pulverized-omnite"):
	setSubgroup("omni-crushing"):
	setStacksize(500):
	setCategory(c):
	marathon():
	setIngredients({"crushed-omnite", 10}):
	setResults({type="item", name="pulverized-omnite", amount=10}):
	setEnergy(0.5):extend()

RecGen:create("omnimatter","pulverized-stone"):
	setSubgroup("omni-crushing"):
	setStacksize(500):
	setEnergy(0.5):
	--setReqAllMods("omnimatter_crystal"):
	setCategory(c):
	--setEnabled():
	marathon():
	setIngredients({"stone-crushed", 10}):
	setResults({type="item", name="pulverized-stone", amount=10}):extend()



local q_in = 7
local out1 = {{type="item", name="iron-ore", amount=1},
    {type="item", name="stone-crushed", amount=6}}
local out2 = {{type="item", name="copper-ore", amount=1},
    {type="item", name="stone-crushed", amount=6}}
if mods["angelsrefining"] then
	q_in=6
	out1 = {{type="item", name="angels-ore1", amount=1},
    {type="item", name="stone-crushed", amount=5}}
	out2 = {{type="item", name="angels-ore3", amount=1},
    {type="item", name="stone-crushed", amount=5}}
end

RecGen:create("omnimatter","initial-omnitraction-1"):
setCategory("omnite-extraction-burner"):
setEnergy(5):
setEnabled():
noItem():
setSubgroup("omni-basic"):
setIngredients({"omnite",q_in}):
setResults(out1):
setIcons(out1[1].name):
marathon():
setLocName("recipe-name.initial-omni","item-name."..out1[1].name):
addSmallIcon("stone-crushed",3):extend()

RecGen:create("omnimatter","initial-omnitraction-2"):
setCategory("omnite-extraction-burner"):
setEnergy(5):
setEnabled():
noItem():
setSubgroup("omni-basic"):
setIngredients({"omnite",q_in}):
setResults(out2):
setIcons(out2[1].name):
marathon():
setLocName("recipe-name.initial-omni","item-name."..out2[1].name):
addSmallIcon("stone-crushed",3):extend()

ItemGen:create("omnimatter","omnic-waste"):
	fluid():
	setBothColour(0,0,1):extend()
	
ItemGen:create("omnimatter","omnic-water"):
	fluid():
	setBothColour(1,0,1):extend()

ItemGen:create("omnimatter","omniston"):
fluid():
setBothColour(0.34,0.92,0.92):extend()

ItemGen:create("omnimatter","omnic-acid"):
fluid():
setBothColour(0.63,0.34,0.90):extend()

ItemGen:create("omnimatter","omnisludge"):
fluid():
setBothColour(0.41,0.34,0.49):extend()

	
RecGen:create("omnimatter","pulver-omnic-waste"):
	setSubgroup("omni-solids"):
	setCategory("omniphlog"):
	setIcons("omnic-waste"):
	marathon():
	setIngredients({"pulverized-omnite", 5},{"pulverized-stone", 15}):
	setResults({type="fluid", name="omnic-waste", amount=300}):
	setEnergy(2):extend()