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
  --cost indexation
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
  if i > 1 then c[#c+1]={type="item",name="omni-logistic-robot-"..i-1,amount=1} end
  --recipe
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
	--entity
	bot[#bot+1] = {
    type = "logistic-robot",
    name = "omni-logistic-robot-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-logistic-bot.png",
    icon_size = 32,
	  localised_name = {"item-name.omni-logistic-bot", i},
    flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map"},
    minable = {hardness = 0.1, mining_time = 0.1, result = "omni-logistic-robot-"..i},
    resistances = { { type = "fire", percent = 85 } },
    max_health = 100*i/2,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
    max_payload_size = omni.lib.round(25/nr_bots*i),
    speed = 0.05*i/nr_bots,
    transfer_distance = 0.5,
    max_energy = 10*2/3*i.."MJ",
    energy_per_tick = 0.075*2/3*i.."kJ",
    speed_multiplier_when_out_of_energy = 0.9-(i-1)*0.1,
    energy_per_move = 2*2/3*i.."kJ",
    min_to_charge = 0.4,
    max_to_charge = 0.95,
    working_light = {intensity = 0.8, size = 3},
    idle = cargo_bot_images.idle,
    idle_with_cargo = cargo_bot_images.idle_with_cargo,
    in_motion = cargo_bot_images.in_motion,
    in_motion_with_cargo = cargo_bot_images.in_motion_with_cargo,
    shadow_idle = cargo_bot_images.shadow_idle,
    shadow_idle_with_cargo = cargo_bot_images.shadow_idle_with_cargo,
    shadow_in_motion = cargo_bot_images.shadow_in_motion,
    shadow_in_motion_with_cargo = cargo_bot_images.shadow_in_motion_with_cargo,
    working_sound = flying_robot(0.5),
    cargo_centered = {0.0, 0.2},
  }
  --technology
  local req = {}
  if i==1 then req={"omniquipment-basic"} else req={"omnibots-logistic-"..i-1} end
  bot[#bot+1] = { 
    type = "technology",
    name = "omnibots-logistic-"..i,
    localised_name={"technology-name.omnibots-logistic",i},
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
	      --{"logistic-science-pack", 1},
	    },
      time = 60
    },
    order = "c-a"
  }
end
  
data:extend(bot)