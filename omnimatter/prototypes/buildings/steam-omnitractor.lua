log("steam found!")

local steam_ingredients = {}
if mods["angelsindustries"] and angelsmods.industries.components then
	steam_ingredients = {
	{name="block-construction-1", amount=1},
	{name="block-fluidbox-1", amount=3},
	{name="block-omni-0", amount=3}}
else
	steam_ingredients = {
	{name="omnicium-iron-gear-box", amount=2},
	{name="omnicium-gear-wheel", amount=3},
	{name="iron-plate", amount=6}}
end

BuildGen:create("omnimatter","omnitractor"):
	setSubgroup("omnitractor"):
	setIngredients(steam_ingredients):
	setEnergy(10):
	setSteam(1,1):
	setUsage(100):
	setReplace("omnitractor"):
	setStacksize(10):
	setSize(3):
	setCrafting({"omnite-extraction-both","omnite-extraction-burner"}):
	setSpeed(1):
	setSoundWorking("ore-crusher"):
	setSoundVolume(2):
	setAnimation({
	layers={
	{
        filename = "__omnimatter__/graphics/entity/buildings/tractor.png",
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
	}):setOverlay("tractor-over",0):
	setFluidBox("WXW.XXX.KXK",true):
	extend()

omni.lib.add_unlock_recipe("basic-automation", "steam-omnitractor")