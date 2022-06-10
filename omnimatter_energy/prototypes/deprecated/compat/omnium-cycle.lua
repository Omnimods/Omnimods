local salts = {}

local omnide_salt_loss = 0.1

for _, item in pairs(data.raw.item) do
    if omni.lib.string_contained_list(item.name,{{"omnide","salt"}}) then
        salts[#salts+1]=item.name
    end
end
local reg = {}

if not mods["angelssmelting"] then
    
--[[{
    type = "fluid",
    name = "liquid-coolant",
    icon = "__angelssmelting__/graphics/icons/liquid-coolant.png",
    icon_size = 32,
    default_temperature = 25,
    heat_capacity = "0.1KJ",
    base_color = {r = 109/255, g = 136/255, b = 179/255},
    flow_color = {r = 109/255, g = 136/255, b = 179/255},
    max_temperature = 300,
},
{
    type = "fluid",
    name = "liquid-coolant-used",
    icon = "__angelssmelting__/graphics/icons/liquid-coolant-used.png",
    icon_size = 32,
    default_temperature = 25,
    heat_capacity = "0.1KJ",
    base_color = {r = 68/255, g = 85/255, b = 112/255},
    flow_color = {r = 68/255, g = 85/255, b = 112/255},
    max_temperature = 300,
    auto_barrel = false
},]]
end


--[[reg[#reg+1]={
    type = "item",
    name = "hydromnide-salt",
    icons = {
        {icon = "__omnimatter_energy__/graphics/icons/hydromnide-salt.png"}
    },
    icon_size = 32,
    flags = {"goes-to-main-inventory"},
    subgroup = "electro-components",
    order="a",
    stack_size = 100}]]

FluidGen:create("omnimatter_energy","molten-oxyomnide-salt"):extend()
ItemGen:create("omnimatter_energy","hydromnide-salt"):
    setStacksize(100):extend()
    
RecGen:create("omnimatter_energy","oxyomnide-hydromnization"):
    setTechName("omnium-power"):
    setTechPacks(4):
    setIcons("hydromnide-salt"):
    addSmallIcon("hydromnic-acid",3):
    setTechCost(250):
    setTechIcons("omnium-power","omnimatter_energy"):
    setTechPrereq(
        "omnicells",
        "omnitech-crystallonics-2"):
    addCondPrereq(
        "boblogistics",
        "fluid-handling",":"
        --"bob-fluid-handling-2"
    ):
    setCategory("omniplant"):
    setIngredients(
        {type="item",name="oxyomnide-salt",amount=1},
        {type="fluid",name="hydromnic-acid",amount=75*3}):
    setResults("hydromnide-salt"):
    marathon():
    setSubgroup("Omnicell"):
    setIcons("hydromnide-salt","omnimatter_energy"):
    setEnergy(1.5):extend()
    
--log("omnium salt stuff")
for _,salt in pairs(salts) do
    local metal = string.sub(salt,1,string.len(salt)-string.len("-omnide-salt"))
    local tech_found = false
    local level = 0
    for i=1,4 do
        for _,eff in pairs(data.raw.technology["omnitech-crystallology-"..i].effects) do
            if eff.type == "unlock-recipe" and not string.find(eff.recipe,"hydronmization") then
                omni.lib.standardise(data.raw.recipe[eff.recipe])
                local recipe = data.raw.recipe[eff.recipe]
                if #recipe.normal.results == 1 and recipe.normal.results[1].name == salt then
                    level = i
                    --omni.lib.add_unlock_recipe("omnitech-crystallology-"..i,salt.."-hydronmization")
                    tech_found=true
                    break
                end
            end
        end
        if tech_found then break end
    end
    RecGen:create("omnimatter_energy",salt.."-hydronmization"):
    setItemName("hydromnide-salt"):
    setTechName("omnitech-crystallology-"..level):
    setCategory("omniplant"):
    setIngredients(salt,{type="fluid",name="hydromnic-acid",amount=60}):
    setResults({type = "item", name = "hydromnide-salt", amount=3},
        {type = "item", name = metal, amount=2}):
    setMain("hydromnide-salt"):
    setSubgroup("Omnicell"):
    setIcons("hydromnide-salt","omnimatter_energy"):
    addSmallIcon(data.raw.item[salt].icons[2].icon,3):
    setStacksize(100):
    setEnergy(1.5):extend()
end

BuildGen:create("omnimatter_energy","omnictor"):
    setSubgroup("hydromnide"):
    setStacksize(20):
    setEnergy(25):
    setIngredients({"omnicium-plate",20},{"basic-oscillo-crystallonic",10},{"boiler",3},{"steel-plate",10}):
    setTechName("omnium-power"):
    ifModsReplaceIngredients("bobpower","boiler","boiler-3"):
    setCrafting("omnictor"):
    setUsage(250):
    setAnimation({
    layers={
    {
        filename = "__omnimatter_energy__/graphics/entity/buildings/omnictor.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        frame_count = 16,
        line_length = 4,
        shift = {0.40, -0.40},
        scale = 1,
        animation_speed = 0.5
    },
    }
    }):
    setSoundWorking("oil-refinery",1,"base"):
    setSoundIdle("idle1",0.5,"base"):
    setFluidBox("XIX.XXX.XXX"):extend()
    
RecGen:create("omnimatter_energy","molten-hydromnide-salt"):
    fluid():
    setTechName("omnium-power"):
    setCategory("omnictor"):
    setIngredients(
            {type="item",name="hydromnide-salt",amount = 1},
            {type="item",name="omnicell-charged",amount = 1}):
    setResults(
        {type="fluid",name="molten-hydromnide-salt",amount = 100},
        {type="item",name="omnicell-denatured",amount = 1}):
    setMain("molten-hydromnide-salt"):
    setSubgroup("omnielectrobuildings"):
    marathon():
    setStacksize(100):
    setEnergy(5):extend()
    
  
BuildGen:create("omnimatter_energy","omnium-reactor"):
    setSubgroup("omnielectrobuildings"):
    setStacksize(20):
    setEnergy(30):
    setIngredients({"omnicium-plate",50},{"basic-oscillo-crystallonic",3},{"boiler",10},{"omnicium-steel-gear-box",10}):
    setFluidBox("XWXWX.XXXXX.XXXXX.XXXXX.KXKXK"):
    ifModsReplaceIngredients("bobpower","boiler","boiler-3"):
    setTechName("omnium-power"):
    setCrafting("omnium-reactor"):
    setUsage(250):
    setAnimation({
    layers={
    {
        filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-reactor.png",
        priority = "extra-high",
        width = 420,
        height = 360,
        frame_count = 1,
        line_length = 1,
        shift = {0.50, -0.30},
        scale = 0.45,
        animation_speed = 0.5
    },
    }
    }):
    setSoundWorking("oil-refinery",1,"base"):
    setSoundIdle("idle1",0.5,"base"):extend()
    
FluidGen:create("omnimatter_energy","molten-oxyomnide-salt"):setMaxTemp(600):extend()

local waterLoss = 0.1



RecGen:create("omnimatter_energy","omnium"):
    fluid():
    setMaxTemp(600):
    setCapacity(5):
    setTechName("omnium-power"):
    setCategory("omnium-reactor"):
    setIngredients(
        {type="fluid",name="water",amount = 200},
        {type="fluid",name="molten-hydromnide-salt",amount = 300}):
    setResults(
        {type="fluid",name="molten-oxyomnide-salt",amount = 300*(1-omnide_salt_loss), temperature = 500},
        {type="fluid",name="omnium",amount = 200*(1-waterLoss), temperature = 500},
        {type="fluid",name="omnic-waste",amount = 200*waterLoss+300*omnide_salt_loss}):
    setMain("omnium"):
    setSubgroup("omnielectrobuildings"):
    marathon():
    setEnergy(3):extend()

    FluidGen:create("omnimatter_energy","molten-oxyomnide-salt"):
        setMaxTemp(600):
        setSubgroup("coolant"):
        extend()
        
for i=5,3,-1 do
        
    RecGen:create("omnimatter_energy","oxyomnide-cooling-"..i*100):
        setIcons("molten-oxyomnide-salt"):
        setLocName("recipe-name.cooling-oxomnide",i*100):
        setTechName("omnium-power"):
        setCategory("cooling"):
        setIngredients(
            {type="fluid",name="molten-oxyomnide-salt",amount = 100,minimum_temperature=100*i-50,maximum_temperature = 100*i+50},
            {type="fluid", name="water", amount=50}):
        setResults(
            {type="fluid",name="molten-oxyomnide-salt",amount = 100, temperature = (i-1)*100},
            {type="fluid", name="steam", amount=50, temperature = 200}):
        --setMain("molten-oxyomnide-salt"):
        setSubgroup("coolant"):
        marathon():
        setEnergy(1):extend()
end
    
RecGen:create("omnimatter_energy","oxyomnide-solidification"):
    setItemName("oxyomnide-salt"):
    setStacksize(500):
    setTechName("omnium-power"):
    setCategory("cooling"):
    setIcons("oxyomnide-salt"):
    setIngredients(
        {type="fluid",name="molten-oxyomnide-salt",amount = 100,maximum_temperature = 250},
        {type="fluid", name="water", amount=50}):
    setResults(
        {type="item",name="oxyomnide-salt",amount = 1},
        {type="fluid", name="steam", amount=50, temperature = 200}):
    setMain("oxyomnide-salt"):
    setSubgroup("coolant"):
    marathon():
    setEnergy(1):extend()

--[[
if mods["bobpower"] then
    omni.lib.replace_recipe_ingredient("omnictor", "boiler","boiler-2")
    omni.lib.replace_recipe_ingredient("omnium-reactor", "boiler","boiler-2")
    omni.lib.replace_recipe_ingredient("omnium-turbine","steam-engine","steam-engine-2")
end
ifModsReplaceIngredients("bobpower","boiler","boiler-3"):
]]    

BuildGen:create("omnimatter_energy","omnium-turbine"):
        setEnergy(30):
        setGenerator():
        setIngredients(
            {"omnicium-plate",50},
            {"basic-oscillo-crystallonic",3},
            {"steam-engine",10}
        ):
        setSubgroup("omnielectrobuildings"):
        setStacksize(20):
        setTechName("omnium-power"):
        setEffectivity(3):
        setFluidConsumption(1):
        setMaxTemp(500):
        ifModsReplaceIngredients("bobpower","steam-engine","steam-engine-3"):
        setFluidBurn(false):
        setReplace("omnium"):
        setSize(3,5):
        setFluidBox("XXX.XXX.FXH.XXX.XXX","omnium",400):
        setEnergySupply():
        setVerticalAnimation({
         layers =
         {
            {
              filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-turbine-v.png",
              width = 160,
              height = 224,
              frame_count = 36,
              line_length = 6,
              --shift = util.by_pixel(5, 6.5),
            },
          },
        }):
        setHorizontalAnimation({
          layers =
          {
            {
              filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-turbine-h.png",
              width = 224,
              height = 160,
              frame_count = 36,
              line_length = 6,
              --shift = util.by_pixel(0, -2.5),
            },
          },
        }):extend()

    --[[
    reg[#reg+1]={
    type = "generator",
    name = "omnium-turbine",
    icon = "__base__/graphics/icons/steam-turbine.png",
    icon_size = 32,
    flags = {"placeable-neutral","player-creation"},
    minable = {mining_time = 1, result = "steam-turbine"},
    max_health = 300,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    alert_icon_shift = util.by_pixel(0, -12),
    effectivity = 2,
    fluid_usage_per_tick = 1,
    maximum_temperature = 600,
    burns_fluid = false,
    resistances =
    {
      {
        type = "fire",
        percent = 70
      }
    },
    fast_replaceable_group = "steam-engine",
    collision_box = {{-1.35, -2.35}, {1.35, 2.35}},
    selection_box = {{-1.5, -2.5}, {1.5, 2.5}},
    fluid_box =
    {
      base_area = 1,
      height = 2,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        { type = "input-output", position = {2, 0} },
        { type = "input-output", position = {-2, 0} },
      },
      production_type = "input-output",
      filter = "omnium",
      minimum_temperature = 400.0
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-output"
    },
    horizontal_animation =
    {
      layers =
      {
        {
          filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-turbine-h.png",
          width = 224,
          height = 160,
          frame_count = 36,
          line_length = 6,
          --shift = util.by_pixel(0, -2.5),
        },
      },
    },
    vertical_animation =
    {
     layers =
     {
        {
          filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-turbine-v.png",
          width = 160,
          height = 224,
          frame_count = 36,
          line_length = 6,
          --shift = util.by_pixel(5, 6.5),
        },
      },
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/steam-engine-90bpm.ogg",
        volume = 0.6
      },
      match_speed_to_activity = true,
    },
    min_perceived_performance = 0.25,
    performance_to_sound_speedup = 0.5
  }]]
