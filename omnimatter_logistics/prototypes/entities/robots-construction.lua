local nr_bots = settings.startup["omnilogistics-nr-bots"].value
require("prototypes.entities.entity-parts-tables")
local bot = {}
local costs= {circuit={},mechanical={},plate={}}

--ingredient listings (consider adding more "omni" ingredients to this)
if mods["angelsindustries"] and angelsmods.industries.components then 
  costs.circuit[#costs.circuit+1] = {name = "circuit-grey", quant={5,7,10,10,10,10}}
elseif mods["bobelectronics"] then
	costs.circuit[#costs.circuit+1] = {name = "basic-circuit-board", quant={5,7,10,15,15,15}}
else
  costs.circuit[#costs.circuit+1] = {name = "electronic-circuit", quant={10,16,16,16,16}}
end

if mods["aai-industry"] then
	costs.mechanical[#costs.mechanical+1]={name = "motor", quant={5,8,12,12,12}}
  costs.mechanical[#costs.mechanical+1]={name = "electric-motor", quant={7,7,7,7,7}}
else
	costs.mechanical[#costs.mechanical+1]={name = "iron-gear-wheel", quant={10,14,2,30,40,60}}
end

if mods["bobplates"] then
  costs.plate[#costs.plate+1]={name = "steel-plate", quant={12,8,8,8,8}}
	costs.plate[#costs.plate+1]={name = "bronze-alloy", quant={10,7,15,15,15}}
else
	costs.plate[#costs.plate+1]={name = "steel-plate", quant={5,8,12,15,20}}
end

--bots by tier
for i=1,nr_bots do
  --create item
	bot[#bot+1] = {
    type = "item",
    name = "omni-construction-robot-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-construction-bot.png",
    icon_size = 32,
	  localised_name = {"item-name.omni-construction-bot", i},
    flags = {},
    order = "c[angels-construction-robot]",
    subgroup = "omni-bots",
    place_result = "omni-construction-robot-"..i,
    stack_size = 20
    }
	
  local c = {}
  local left = i
	for _,kind in pairs(costs) do
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
    subgroup = "omni-bots",
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
    minable = { mining_time = 0.1, result = "omni-construction-robot-"..i},
    resistances = { { type = "fire", percent = 85 } },
    max_health = 100,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
    max_payload_size = 2*i,
    speed = 0.10*i/nr_bots,
    max_energy = "1MJ",
    energy_per_tick = "0.075kJ",
    speed_multiplier_when_out_of_energy = 0.5,
    energy_per_move = "7.5kJ",
    min_to_charge = 0.4,
    max_to_charge = 0.95,
    working_light = {intensity = 0.8, size = 3},
    idle ={
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
    in_motion ={
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
    shadow_idle = omni.logistics.construction_bot_parts.shadow_idle,
    shadow_in_motion = omni.logistics.construction_bot_parts.shadow_in_motion,
    working ={
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
    shadow_working = omni.logistics.construction_bot_parts.shadow_working,
    smoke = omni.logistics.construction_bot_parts.smoke,
    sparks = omni.logistics.construction_bot_parts.sparks,
    working_sound = omni.logistics.flying_robot(0.5),
    cargo_centered = {0.0, 0.2},
    construction_vector = {0.30, 0.22},
  }
  local req = {}
  if i==1 then req={"omniquipment-basic"} else req={"omnibots-construction-"..i-1} end
  bot[#bot+1] = { 
    type = "technology",
    name = "omnibots-construction-"..i,
    localised_name={"technology-name.omnibots-construction",i},
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
	  --{"logistic-science-pack", 1},
	  },
      time = 60
    },
    order = "c-a"
    }
end
  
  
data:extend(bot)