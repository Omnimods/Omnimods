--Burner
local phlog_cost = {}
if mods["angelsindustries"] and angelsmods.industries.components then
	phlog_cost = {
	{name="block-construction-1", amount=3},
	{name="block-electronics-0", amount=1},
	{name="block-fluidbox-1", amount=2},
	{name="block-omni-0", amount=1}}
else
	phlog_cost = {
		  {type = "item", name = "omnicium-plate", amount = 10},
		  {type = "item", name = "omnicium-gear-wheel", amount = 15},
		  {type = "item", name = "iron-plate", amount = 10},
		  {type = "item", name = "copper-plate", amount = 5},
		}
end

BuildGen:create("omnimatter","omniphlog"):
setBurner(0.75,1):
setStacksize(10):
setSubgroup("omniphlog"):
setReplace("omniphlog"):
setNextUpgrade("omniphlog-1"):
setSize(3):
setCrafting("omniphlog"):
setFluidBox("XWX.XXX.XKX"):
setUsage(300):
setAnimation({
layers={
{
	filename = "__omnimatter__/graphics/entity/buildings/omniphlog.png",
	priority = "extra-high",
	width = 160,
	height = 160,
	frame_count = 36,
	line_length = 6,
	shift = {0.00, -0.05},
	scale = 0.90,
	animation_speed = 0.5
},
}
}):
setIngredients(phlog_cost):
setEnabled():extend()
--Electric
local cost = OmniGen:create():
		building():
		setMissConstant(3):
		setPreRequirement("burner-omniphlog")

if mods["angelsindustries"] and angelsmods.industries.components then
	cost:setQuant("construction-block",5):
	setQuant("electric-block",2):
	setQuant("fluid-block",5):
	setQuant("logistic-block",1):
	setQuant("omni-block",1)
else
	cost:setQuant("omniplate",10):
	setQuant("plates",20):
	setQuant("gear-box",15)
end

BuildChain:create("omnimatter","omniphlog"):
	setSubgroup("omniphlog"):
	setLocName("omniphlog"):
	setIngredients(cost:ingredients()):
	setEnergy(5):
	setUsage(function(level,grade) return (200+100*grade).."kW" end):
	addElectricIcon():
	setReplace("omniphlog"):
	setStacksize(10):
	setSize(3):
	setTechName("omnitech-omnitractor-electric"):
	setFluidBox("XWX.XXX.XKX"):
	setLevel(omni.max_tier):
	setSoundWorking("ore-crusher"):
	setSoundVolume(2):
	setModSlots(function(levels,grade) return grade end):
	setCrafting("omniphlog"):
	setSpeed(function(levels,grade) return 0.5+grade/2 end):
	setAnimation({
	layers={
	{
		filename = "__omnimatter__/graphics/entity/buildings/omniphlog.png",
		priority = "extra-high",
		width = 160,
		height = 160,
		frame_count = 36,
		line_length = 6,
		shift = {0.00, -0.05},
		scale = 0.90,
		animation_speed = 0.5
	},
	},
	}):setOverlay("tractor-over"):
	extend()

if mods["angelsindustries"] and angelsmods.industries.components then
	for i=1,settings.startup["omnimatter-max-tier"].value do
		-- Remove previous tier buildings from the recipes
		if i == 1 then
			omni.lib.remove_recipe_ingredient("omniphlog-1", "burner-omniphlog")
		else
			omni.lib.remove_recipe_ingredient("omniphlog-"..i, "omniphlog-"..i-1)
		end
	end
end