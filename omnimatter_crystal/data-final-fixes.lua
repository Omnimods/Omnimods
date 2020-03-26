if angelsmods and angelsmods.refining then
	----log("test: "..settings.startup["omnicrystal-sloth"].value)
	--"angelsore7-crystallization-"
	if not settings.startup["omnicrystal-sloth"].value then
		for _,rec in pairs(data.raw.recipe) do
			if omni.lib.start_with(rec.name,"slag-processing-") and not omni.lib.recipe_result_contains(rec.name,{"slag-slurry","mineral-sludge"}) and rec.name ~= "slag-processing-stone" then
				omni.lib.remove_recipe_all_techs(rec.name)
				rec.enabled = false
			end
		end
	end
end


local omnitem = {}
local check_items = {}
local base_items = {}
local excluded_items = {}
for _,item in pairs(data.raw.item) do
	if string.find(item.name,"plate") then
		omnitem[#omnitem+1]={name=item.name,cost=12/13}
	elseif not string.find(item.name,"ore") and not omni.lib.is_in_table(item.name,excluded_items) then
		check_items[#check_items+1]=item.name
	end
end

for i=2,4 do
	if not (data.raw.technology["crystallonics-"..i-1].enabled and data.raw.technology["crystallonics-"..i].effects and #data.raw.technology["crystallonics-"..i].effects>0) then
		--data.raw.technology["crystallonics-"..i].enabled = false
	end
end
local pipeadd="pipe" --vanilla set
local elecadd="electronic-circuit" --vanilla set
if data.raw.item["copper-pipe"] then
	pipeadd="copper-pipe"
end
if data.raw.item["basic-circuit-board"] then
	elecadd="basic-circuit-board"
end
BuildGen:create("omnimatter_crystal","omniplant"):
	setSubgroup("crystallization"):
	setLocName("omniplant-burner"):
	setIcons("omniplant","omnimatter_crystal"):
	setIngredients({pipeadd,15},{"omnicium-plate",5},{elecadd,5},{"omnite-brick",10},{"iron-gear-wheel",10}):
	setBurner(0.75,2):
	setEnergy(25):
	setUsage(function(level,grade) return "750kW" end):
	setTechName("omnitractor-electric-1"):
	setReplace("omniplant"):
	setStacksize(20):
	setSize(5):
	setCrafting({"omniplant"}):
	setSpeed(1):
	setSoundWorking("oil-refinery",1,"base"):
	setSoundVolume(2):
	setAnimation({
	layers={
	{
        filename = "__omnimatter_crystal__/graphics/buildings/omni-plant.png",
		priority = "extra-high",
        width = 224,
        height = 224,
        frame_count = 36,
		line_length = 6,
        shift = {0.00, -0.05},
		scale = 1,
		animation_speed = 0.5
	},
	}
	}):
	setOverlay("omni-plant-overlay"):
	setFluidBox("XWXWX.XXXXX.XXXXX.XXXXX.XKXKX"):
	extend()

RecGen:import("omniplant-1"):addIngredients({"burner-omniplant",1}):extend()
