local nr_bots = settings.startup["omnilogistics-nr-bots"].value
local bot = {}
  bot[#bot+1] = {
    type = "item-subgroup",
    name = "omni-logistic",
	group = "omnilogistics",
	order = "aa",
  }

local costs= {circuit={},mechanical={},plate={}}

local function flying_robot(volume)
	return {
		sound = {
			{
				filename = "__base__/sound/flying-robot-1.ogg", volume = volume
			},
			{
				filename = "__base__/sound/flying-robot-2.ogg", volume = volume
			},
			{
				filename = "__base__/sound/flying-robot-3.ogg", volume = volume
			},
			{
				filename = "__base__/sound/flying-robot-4.ogg", volume = volume
			},
			{
				filename = "__base__/sound/flying-robot-5.ogg", volume = volume
			},
			{
				filename = "__base__/sound/flying-robot-6.ogg", volume = volume
			},
			{
				filename = "__base__/sound/flying-robot-7.ogg", volume = volume
			},
			{
				filename = "__base__/sound/flying-robot-8.ogg", volume = volume
			},
			{
				filename = "__base__/sound/flying-robot-9.ogg", volume = volume
			}
		},
		max_sounds_per_type = 5,
		audible_distance_modifier = 1,
		probability = 1 / (10 * 60) -- average pause between the sound is 10 seconds
	}
end

if not mods["bobelectronics"] then
	costs.circuit[#costs.circuit+1] = {name = "electronic-circuit", quant={10,11,19,33,58}}
else
	costs.circuit[#costs.circuit+1] = {name = "basic-circuit-board", quant={15,14,25}}
	costs.circuit[#costs.circuit+1] = {name = "electronic-circuit", quant={10,16}}
end
if not mods["aai-industry"] then
	costs.mechanical[#costs.mechanical+1]={name = "iron-gear-wheel", quant={40,30,65,68,102}}
else
	costs.mechanical[#costs.mechanical+1]={name = "motor", quant={10,8,12}}
	costs.mechanical[#costs.mechanical+1]={name = "electric-motor", quant={7,7}}
end
if not mods["bobplates"] then
	costs.plate[#costs.plate+1]={name = "steel-plate", quant={20,9,12,15,20}}
else
	costs.plate[#costs.plate+1]={name = "steel-plate", quant={15,8}}
	costs.plate[#costs.plate+1]={name = "bronze-alloy", quant={10,7,8}}
end
  
for i=1,nr_bots do
	bot[#bot+1] = {
    type = "item",
    name = "omni-logistic-robot-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-logistic-bot.png",
    icon_size = 32,
	localised_name = {"item-name.omni-logistic-bot", i},
    flags = {},
    order = "c[angels-logistic-robot]",
    subgroup = "omni-logistic",
    place_result = "omni-logistic-robot-"..i,
    stack_size = 20
    }
	
	local c = {}
	for _,kind in pairs(costs) do
		local left = i
		local level = 1
		while kind[level].quant[left] == nil do
			left=left-#kind[level].quant
			level=level+1
		end
		c[#c+1]={type="item",name=kind[level].name,amount=kind[level].quant[left]}
	end
	if i > 1 then c[#c+1]={type="item",name="omni-logistic-robot-"..i-1,amount=1} end
	bot[#bot+1] = {
    type = "recipe",
    name = "omni-logistic-robot-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-logistic-bot.png",
    icon_size = 32,
    subgroup = "omni-logistic",
    order = "g[hydromnic-acid]",
	energy_required = 10,
    enabled = false,
    ingredients =c,
    results =
    {
      {type="item", name="omni-logistic-robot-"..i, amount=1},
    },
	}
	
	bot[#bot+1] = {
    type = "logistic-robot",
    name = "omni-logistic-robot-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-logistic-bot.png",
    icon_size = 32,
	localised_name = {"item-name.omni-logistic-bot", i},
    flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map"},
    minable = {hardness = 0.1, mining_time = 0.1, result = "omni-logistic-robot-"..i},
    resistances = { { type = "fire", percent = 85 } },
    max_health = 100,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
    max_payload_size = omni.lib.round(25/nr_bots*i),
    speed = 0.05*i/nr_bots,
    transfer_distance = 0.5,
    max_energy = "10MJ",
    energy_per_tick = "0.075kJ",
    speed_multiplier_when_out_of_energy = 0.9-(i-1)*0.1,
    energy_per_move = "2kJ",
    min_to_charge = 0.4,
    max_to_charge = 0.95,
    working_light = {intensity = 0.8, size = 3},
    idle =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot.png",
      priority = "high",
      line_length = 16,
      width = 128,
      height = 128,
	  scale = 0.5,
      frame_count = 1,
      shift = {0, 0},
      direction_count = 16,
      y = 128
    },
    idle_with_cargo =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot.png",
      priority = "high",
      line_length = 16,
      width = 128,
      height = 128,
	  scale = 0.5,
      frame_count = 1,
      shift = {0, 0},
	  scale = 0.5,
      direction_count = 16,
    },
    in_motion =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot.png",
      priority = "high",
      line_length = 16,
      width = 128,
      height = 128,
	  scale = 0.5,
      frame_count = 1,
      shift = {0, 0},
	  scale = 0.5,
      direction_count = 16,
      y = 384
    },
    in_motion_with_cargo =
    {
	  filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot.png",
	  priority = "high",
      line_length = 16,
      width = 128,
      height = 128,
	  scale = 0.5,
      frame_count = 1,
      shift = {0, 0},
	  scale = 0.5,
      direction_count = 16,
      y = 256
    },
    shadow_idle =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 64,
      height = 64,
      frame_count = 1,
      shift = {0, 0},
      direction_count = 16,
    },
    shadow_idle_with_cargo =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 64,
      height = 64,
      frame_count = 1,
      shift = {0, 0},
      direction_count = 16
    },
    shadow_in_motion =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 64,
      height = 64,
      frame_count = 1,
      shift = {0, 0},
      direction_count = 16,
    },
    shadow_in_motion_with_cargo =
    {
      filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 64,
      height = 64,
      frame_count = 1,
      shift = {0, 0},
      direction_count = 16
    },
    working_sound = flying_robot(0.5),
    cargo_centered = {0.0, 0.2},
  }
  local req = {}
  if i==1 then req={"omniquipment-basic"} else req={"omnibots-logistic-"..i-1} end
  bot[#bot+1] = { 
    type = "technology",
    name = "omnibots-logistic-"..i,
    icon = "__omnimatter_logistics__/graphics/technology/omni-logistic-bot.png",
	icon_size = 128,
	prerequisites = req,
    effects =
    {
	  {
        type = "unlock-recipe",
        recipe = "omni-logistic-robot-"..i
      },
    },
    unit =
    {
      count = 350+50*(math.pow(2,i-1)-1),
      ingredients = {
	  {"automation-science-pack", 1},
	  {"logistic-science-pack", 1},
	  },
      time = 60
    },
    order = "c-a"
    }
end
  
  
data:extend(bot)