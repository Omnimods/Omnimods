
RecGen:create("omnimatter_energy","naturize-omnicell"):
	setItemName("omnicell-natured"):
	setIcons("omnicell-natured"):
	addSmallIcon("omnic-acid",3):
	setTechName("omnicells"):
	setTechPacks(4):
	setTechCost(250):
	setTechIcons("omnicell","omnimatter_energy"):
	setTechPrereq("fluid-handling"):
	setCategory("omniphlog"):
	setIngredients(
		{type="item",name="omnicell-denatured",amount=1},
		{type="fluid",name="omnic-acid",amount=120*3}):
	setResults("omnicell-natured"):
	marathon():
	setSubgroup("Omnicell"):
	setStacksize(50):
	setEnergy(1):extend()

RecGen:create("omnimatter_energy","omnicell-charged"):
	setTechName("omnicells"):
	setCategory("omniphlog"):
	setIngredients(
		{type="item",name="omnicell-natured",amount=1},
		{type="fluid",name="omniston",amount=50*3}):
	setResults("omnicell-charged"):
	marathon():
	setSubgroup("Omnicell"):
	setStacksize(50):
	setEnergy(1):extend()

ItemGen:create("omnimatter_energy","omnicell-denatured"):
	setStacksize(50):
	setSubgroup("Omnicell"):
	extend()

if mods["angellsrefining"] then
local main_ores = {"copper-ore","iron-ore"}
local bi_ores = {"lead-ore","tin-ore"}

for _,m in pairs(main_ores) do
	for _,b in pairs(bi_ores) do
		RecGen:create("omnimatter_energy","omnicell-natured-"..m.."-"..b):
			setLocName("item.name-omnicell-natured"):
			setTechName("omnicells"):
			setCategory("omniphlog"):
			setSubgroup("Omnicell"):			
			setIngredients(
				{type="item",name="omnicium-plate",amount=3},
				{type="item",name="omnite",amount=10},
				{type="item",name=m,amount=5},
				{type="item",name=b,amount=5}):
			setResults("omnicell-natured"):
			marathon():
			setEnergy(10):extend()
	end
end
end