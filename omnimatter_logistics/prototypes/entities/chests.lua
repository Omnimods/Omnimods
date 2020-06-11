require("prototypes.entities.entity-parts-tables")
if not mods["angelsindustries"] then --no need to add duplicates
  logistic_list={"requester","passive-provider","active-provider","buffer","storage"}
  local chests={}

  chests[#chests+1]={
    type = "item",
    name = "angels-big-chest",
    icon = "__omnimatter_logistics__/graphics/icons/chest-big-ico.png",
    icon_size = 32,
    subgroup = "omni-chests",
    order = "a[angels-big-chest]",
    place_result = "angels-big-chest",
    stack_size = 50
  }
  chests[#chests+1]={
    type = "container",
    name = "angels-big-chest",
    icon = "__omnimatter_logistics__/graphics/icons/chest-big-ico.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "angels-big-chest"},
    max_health = 200,
    corpse = "small-remnants",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    resistances =
    {
      {
        type = "fire",
        percent = 90
      },
      {
        type = "impact",
        percent = 60
      }
    },
    collision_box = {{-0.75, -0.75}, {0.75, 0.75}},
    selection_box = {{-1, -1}, {1, 1}},
    fast_replaceable_group = "container",
    inventory_size = 60,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture =
    {
      filename = "__omnimatter_logistics__/graphics/entity/chests/chest-big.png",
      priority = "extra-high",
      width = 128,
      height = 128,
      shift = {0, 0}
    },
    circuit_wire_connection_point = omni.logistics.circuit_connector_definitions["angels-big-chest"].points,
    circuit_connector_sprites = omni.logistics.circuit_connector_definitions["angels-big-chest"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance
  }
  for _,type in pairs(logistic_list) do
    chests[#chests+1]={
      type = "item",
      name = "angels-logistic-chest-"..type,
      icon = "__omnimatter_logistics__/graphics/icons/chest-big-"..type.."-ico.png",
      icon_size = 32,
      subgroup = "omni-chests",
      order = "b[angels-big-chest-"..type.."]",
      place_result = "angels-logistic-chest-"..type,
      stack_size = 50
    }
    local slot_count=nil --allow for special case of requester/storage having filters
    if type=="requester" or type=="buffer" then
      slot_count=12
    elseif type=="storage" then
      slot_count=1
    end
    chests[#chests+1]={
      type = "logistic-container",
      name = "angels-logistic-chest-"..type,
      icon = "__omnimatter_logistics__/graphics/icons/chest-big-"..type.."-ico.png",
      icon_size = 32,
      flags = {"placeable-player", "player-creation"},
      minable = {hardness = 0.2, mining_time = 0.5, result = "angels-logistic-chest-"..type},
      max_health = 350,
      corpse = "small-remnants",
      collision_box = {{-0.75, -0.75}, {0.75, 0.75}},
      selection_box = {{-1, -1}, {1, 1}},
      resistances =
      {
        {
          type = "fire",
          percent = 90
        },
        {
          type = "impact",
          percent = 60
        }
      },
      fast_replaceable_group = "container",
      inventory_size = 60,
      logistic_slots_count = slot_count,
      logistic_mode = type,
      open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
      close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
      vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
      picture =
      {
        filename = "__omnimatter_logistics__/graphics/entity/chests/chest-big-"..type..".png",
        priority = "extra-high",
        width = 128,
        height = 128,
        shift = {0, 0}
      },
      circuit_wire_connection_point = omni.logistics.circuit_connector_definitions["angels-big-chest"].points,
      circuit_connector_sprites = omni.logistics.circuit_connector_definitions["angels-big-chest"].sprites,
      circuit_wire_max_distance = default_circuit_wire_max_distance
    }
  end
  data:extend(chests)
end
