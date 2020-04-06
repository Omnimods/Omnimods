local nr_bots = settings.startup["omnilogistics-nr-bots"].value
local bot = {}
  bot[#bot+1] = {
    type = "item-subgroup",
    name = "omni-construction",
	group = "omnilogistics",
	order = "aa",
  }

local costs= {circuit={},mechanical={},plate={}}

local function construction_robot(volume)
	return {
		sound = {
			{
				filename = "__base__/sound/construction-robot-1.ogg", volume = volume
			},
			{
				filename = "__base__/sound/construction-robot-2.ogg", volume = volume
			},
			{
				filename = "__base__/sound/construction-robot-3.ogg", volume = volume
			},
			{
				filename = "__base__/sound/construction-robot-4.ogg", volume = volume
			},
			{
				filename = "__base__/sound/construction-robot-5.ogg", volume = volume
			},
			{
				filename = "__base__/sound/construction-robot-6.ogg", volume = volume
			},
			{
				filename = "__base__/sound/construction-robot-7.ogg", volume = volume
			},
			{
				filename = "__base__/sound/construction-robot-8.ogg", volume = volume
			},
			{
				filename = "__base__/sound/construction-robot-9.ogg", volume = volume
			}
		},
		max_sounds_per_type = 1,
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
    name = "omni-construction-robot-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-construction-bot.png",
    icon_size = 32,
	localised_name = {"item-name.omni-construction-bot", i},
    flags = {},
    order = "c[angels-construction-robot]",
    subgroup = "omni-construction",
    place_result = "omni-construction-robot-"..i,
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
	if i > 1 then c[#c+1]={type="item",name="omni-construction-robot-"..i-1,amount=1} end
	bot[#bot+1] = {
    type = "recipe",
    name = "omni-construction-robot-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-construction-bot.png",
    icon_size = 32,
    subgroup = "omni-construction",
    order = "g[hydromnic-acid]",
	energy_required = 10,
    enabled = false,
    ingredients =c,
    results =
    {
      {type="item", name="omni-construction-robot-"..i, amount=1},
    },
	}
	
	bot[#bot+1] = {
    type = "construction-robot",
    name = "omni-construction-robot-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-construction-bot.png",
    icon_size = 32,
	localised_name = {"item-name.omni-construction-bot", i},
    flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map"},
    minable = {hardness = 0.1, mining_time = 0.1, result = "omni-construction-robot-"..i},
    resistances = { { type = "fire", percent = 85 } },
    max_health = 100,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
    max_payload_size = 2*i,
    speed = 0.10*i/nr_bots,
    transfer_distance = 0.5,
    max_energy = "1MJ",
    energy_per_tick = "0.075kJ",
    speed_multiplier_when_out_of_energy = 0.5,
    energy_per_move = "7.5kJ",
    min_to_charge = 0.4,
    max_to_charge = 0.95,
    working_light = {intensity = 0.8, size = 3},
    idle =
    {
      filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-"..i..".png",
      priority = "high",
      line_length = 16,
      width = 128,
      height = 128,
      frame_count = 1,
      shift = {0, 0},
	  scale = 0.375,
      direction_count = 16,
    },
    in_motion =
    {
      filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-"..i..".png",
      priority = "high",
      line_length = 16,
      width = 128,
      height = 128,
      frame_count = 1,
      shift = {0, 0},
	  scale = 0.375,
      direction_count = 16,
      y = 128
    },
    shadow_idle =
    {
      filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 64,
      height = 64,
      frame_count = 1,
      shift = {0, 0},
	  scale = 0.75,
      direction_count = 16
    },
    shadow_in_motion =
    {
      filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 64,
      height = 64,
      frame_count = 1,
      shift = {0, 0},
	  scale = 0.75,
      direction_count = 16
    },
    working =
    {
      filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-working-"..i..".png",
      priority = "high",
      line_length = 2,
      width = 128,
      height = 128,
      frame_count = 2,
      shift = {0, 0},
	  scale = 0.375,
      direction_count = 16,
      animation_speed = 0.3,
    },
    shadow_working =
    {
      stripes = util.multiplystripes(2,
      {
        {
		  filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-shadow.png",
          width_in_frames = 16,
          height_in_frames = 1,
        }
      }),
      priority = "high",
      width = 64,
      height = 64,
      frame_count = 2,
      shift = {0, 0},
      direction_count = 16
    },
    smoke =
    {
      filename = "__base__/graphics/entity/smoke-construction/smoke-01.png",
      width = 39,
      height = 32,
      frame_count = 19,
      line_length = 19,
      shift = {0.078125, -0.15625},
      animation_speed = 0.3,
    },
    sparks =
    {
      {
        filename = "__base__/graphics/entity/sparks/sparks-01.png",
        width = 39,
        height = 34,
        frame_count = 19,
        line_length = 19,
        shift = {-0.109375, 0.3125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-02.png",
        width = 36,
        height = 32,
        frame_count = 19,
        line_length = 19,
        shift = {0.03125, 0.125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-03.png",
        width = 42,
        height = 29,
        frame_count = 19,
        line_length = 19,
        shift = {-0.0625, 0.203125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-04.png",
        width = 40,
        height = 35,
        frame_count = 19,
        line_length = 19,
        shift = {-0.0625, 0.234375},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-05.png",
        width = 39,
        height = 29,
        frame_count = 19,
        line_length = 19,
        shift = {-0.109375, 0.171875},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-06.png",
        width = 44,
        height = 36,
        frame_count = 19,
        line_length = 19,
        shift = {0.03125, 0.3125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
    },
    working_sound = construction_robot(0.5),
    cargo_centered = {0.0, 0.2},
    construction_vector = {0.30, 0.22},
  }
  local req = {}
  if i==1 then req={"omniquipment-basic"} else req={"omnibots-construction-"..i-1} end
  bot[#bot+1] = { 
    type = "technology",
    name = "omnibots-construction-"..i,
    icon = "__omnimatter_logistics__/graphics/technology/omni-construction-bot.png",
	icon_size = 128,
	prerequisites = req,
    effects =
    {
	  {
        type = "unlock-recipe",
        recipe = "omni-construction-robot-"..i
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