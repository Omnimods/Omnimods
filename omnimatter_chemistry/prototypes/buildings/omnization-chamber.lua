local reg={}
local science_pack = {"science-pack-1","science-pack-2","omni-pack","science-pack-3","production_science_pack","hightech_science_pack"}

local parts={"plate","gear","circuit","bearing",}

local quant={}
local component={}
quant["gear"]=10
quant["plate"]=20
quant["circuit"]=5
quant["bearing"]=10

component["circuit"]={"electronic-circuit","basic-crystallonic","basic-oscillo-crystallonic"}
component["gear"]= {"omnicium-iron-gear-box","omnicium-steel-gear-box"}
component["plate"]= {"omnicium-iron-alloy","omnicium-steel-alloy","omnicium-aluminium-alloy",}
component["bearing"]={"steel-bearing",nil,"titanium-bearing"}

local get_cost = function(tier)
    local ing = {}
    --ing[#ing+1]={type="item",name="omnicium-plate",amount=10+8*tier}
    if tier == 1 then
        --ing[#ing+1]={type="item",name="omnicium-gear-wheel",amount=7+3*tier}
    end
    for _,part in pairs(parts) do
        local amount = quant[part]
        if type(quant[part])=="table" then amount=quant[part][tier] end
        for i=tier,1,-1 do
            if component[part] and component[part][i]~="" and component[part][i]~=nil then
                ing[#ing+1]={type="item",name=component[part][i],amount=amount}
                break
            else
                amount = 2*amount
            end
        end
    end
    if tier > 1 then
        ing[#ing+1]={type="item",name="omnization-chamber-"..tier-1,amount=1}
    end
    return ing
end

for i=1, 4 do
    reg[#reg+1]={
    type = "assembling-machine",
    name = "omnization-chamber-"..i,
    icons = {
        {icon="__omnimatter_chemistry__/graphics/icons/omnization-chamber.png",},
        {icon = "__omnimatter__/graphics/icons/extraction-"..i..".png"},
        },
    flags = {"placeable-neutral","player-creation"},
    minable = {mining_time = 1, result = "omnization-chamber-"..i},
    fast_replaceable_group = "omnization-chamber",
    max_health = 300,
    icon_size = 32,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
    selection_box = {{-2, -2}, {2, 2}},
    crafting_categories = {"omnization"},
    crafting_speed = 1+i/4,
    source_inventory_size = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.04 / 3.5
    },
    energy_usage = "150kW",
    ingredient_count = 9,
    fluid_boxes =
    {
      {
        production_type = "input",
        pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0, -2} }}
      },
      {
        production_type = "output",
        pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 1,
        pipe_connections = {{ type="output", position = {0, 2} }}
      },
    },
    animation ={
    layers={
    {
        filename = "__omnimatter_chemistry__/graphics/entities/omnization-chamber.png",
        priority = "extra-high",
        width = 320,
        height = 384,
        frame_count = 30,
        line_length = 6,
        shift = {0.00, -0.05},
        scale = 0.50,
        animation_speed = 0.5
    },
    }
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound = { filename = "__omnimatter__/sound/ore-crusher.ogg", volume = 0.8 },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 2,
    },
    }
    reg[#reg+1]={
    type = "item",
    name = "omnization-chamber-"..i,
    icons = {
        {icon="__omnimatter_chemistry__/graphics/icons/omnization-chamber.png",},
        {icon = "__omnimatter__/graphics/icons/extraction-"..i..".png"},
        },
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "omnitractor",
    order = "d[solar-panel]-aa[solar-panel-1-a]",
    stack_size = 100,
    place_result = "omnization-chamber-"..i,
  }
    reg[#reg+1]={
    type = "recipe",
    name = "omnization-chamber-"..i,
    icon_size = 32,
    enabled = false,
    energy_required = 5,
    subgroup = "omnitractor",
    ingredients =get_cost(i),
    results = {{"omnization-chamber-"..i,1}}
  }
    local spacks={}
    for j=1, i do
        spacks[#spacks+1]={science_pack[j],1}
    end
    local r = {}
    if i==1 then
        r={"omni-sorting-electric-1","basic-chemistry"}
    else
        r={"omnization-chamber-"..i-1,"omni-sorting-electric-"..i}
    end
    reg[#reg+1]={
    type = "technology",
    name = "omnization-chamber-"..i,
    icon = "__omnimatter_chemistry__/graphics/technology/omnichem.png",
    icon_size = 128,
    order = "z",
    effects = {
        {type = "unlock-recipe",
        recipe="omnization-chamber-"..i},
    },
    upgrade = i>1,
    prerequisites = r,
    unit =
    {
        count = 50+75*i+math.pow(2,i),
        ingredients = spacks,
        time = 10+5*i
    }
    }
end

data:extend(reg)