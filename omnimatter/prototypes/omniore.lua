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
		  {type="item", name="crushed-omnite", amount=4},
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

	
local initial_recipes = {}
local inputs = {}
if mods["angelsrefining"] then
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "angels-ore1",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 5
		},
	}
	inputs[#inputs + 1] = 6
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "angels-ore3",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 5
		},
	}
	inputs[#inputs + 1] = 6
else
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "iron-ore",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 6
		},
	}
	inputs[#inputs + 1] = 7
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "copper-ore",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 6
		},
	}
	inputs[#inputs + 1] = 7
end

if mods["pyrawores"] then
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "ore-aluminium",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 13
		},
	}
	inputs[#inputs + 1] = 14
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "ore-tin",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 11
		},
	}
	inputs[#inputs + 1] = 12
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "ore-quartz",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 11
		},
	}
	inputs[#inputs + 1] = 12
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "raw-coal",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 9
		},
	}
	inputs[#inputs + 1] = 10
	initial_recipes[#initial_recipes + 1] = {
		{
			type = "item",
			name = "nexelit-ore",
			amount = 1
		},
		{
			type = "item",
			name = "stone-crushed",
			amount = 6
		},
	}
	inputs[#inputs + 1] = 7
end

for index, result in pairs(initial_recipes) do
	RecGen:create("omnimatter","initial-omnitraction-" .. result[1].name):
	setCategory("omnite-extraction-burner"):
	setEnergy(5):
	setEnabled():
	noItem():
	setSubgroup("omni-basic"):
	setIngredients({"omnite", inputs[index]}):
	setResults(result):
	setIcons(result[1].name):
	marathon():
	setLocName("recipe-name.initial-omni","item-name."..result[1].name):
	addSmallIcon(result[2].name, 3):extend()
end

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
	setSubgroup("omni-fluids"):
	setCategory("omniphlog"):
	setIcons("omnic-waste"):
	marathon():
	setIngredients({"pulverized-omnite", 5},{"pulverized-stone", 15}):
	setResults({type="fluid", name="omnic-waste", amount=300}):
	setEnergy(2):extend()