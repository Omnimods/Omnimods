-------------------------------------------------------------------------------
--[[Inits, Local lists and variables]]--
-------------------------------------------------------------------------------
local multiplier = settings.startup["omnicompression_multiplier"].value
omni.compression.bld_lvls = settings.startup["omnicompression_building_levels"].value --kind of local
omni.compression.one_list = settings.startup["omnicompression_one_list"].value
omni.compression.hide_handcraft =  settings.startup["omnicompression_hide_handcraft"].value or nil--Don't override to false
local cost_multiplier = settings.startup["omnicompression_cost_mult"].value
local energy_multiplier = settings.startup["omnicompression_energy_mult"].value
local black_list = {--By name
  "creative",
  {"burner", "turbine"},
  {"crystal","reactor"},
  {"factory","port","marker"},
  {"biotech","biosolarpanel","solarpanel"},
  "bucketw"
}
local building_list = {--Types
  ["boiler"] = true,
  ["lab"] = true,
  ["assembling-machine"] = true,
  ["furnace"] = true,
  ["mining-drill"] = true,
  ["solar-panel"] = true,
  ["reactor"] = true,
  ["heat-pipe"] = true,
  ["accumulator"] = true,
  ["transport-belt"] = true,
  ["loader"] = true,
  ["splitter"] = true,
  ["underground-belt"] = true,
  ["beacon"] = true,
  ["electric-pole"] = true,
  ["offshore-pump"] = true,
  ["inserter"] = true,
  ["loader-1x1"] = true,
  ["burner-generator"] = true,
  ["rocket-silo"] = true
}
local not_energy_use = {--Types
  "solar-panel",
  "reactor",
  "boiler",
  "generator",
  "accumulator",
  "transport-belt",
  "loader",
  "splitter",
  "underground-belt",
  "electric-pole",
  "offshore-pump",
  "loader-1x1",
  "inserter",
  "burner-generator"
}

if mods["omnimatter_fluid"] then building_list["boiler"] = nil end
building_list["generator"] = true

local recipe_category = {} --category additions
local compress_level = {"Compact","Nanite","Quantum","Singularity"}
local already_compressed = {}
local compressed_buildings = {}
-------------------------------------------------------------------------------
--[[Compression Specific Support Functions]]--
-------------------------------------------------------------------------------
--set naming convention
local find_top_tier = function(build, kind)
	local name = build.name
	if not settings.startup["omnicompression_final_building"].value then
		return build
	elseif omni.lib.is_number(omni.lib.get_end(name,2)) then
		name = string.sub(name,1,string.len(name)-2)
	elseif omni.lib.is_number(omni.lib.get_end(name,1)) then
		name = string.sub(name,1,string.len(name)-1)
	elseif not data.raw[kind][name.."-2"] and not data.raw[kind][name.."2"] then
		return build
	end
	local nr = 1
	local found = true
	while found do
    nr = nr+1
		if not data.raw[kind][name.."-"..nr] and data.raw[kind][name.."-"..nr-1] then
			found = false
			return data.raw[kind][name.."-"..nr-1]
		elseif not data.raw[kind][name..nr] and data.raw[kind][name..nr-1] then
			found = false
			return data.raw[kind][name..nr-1]
		end
	end
end
--set category if it does not exist
local category_exists = function(build)
	if build.crafting_categories then --no crafting_categories, don't loop
    for i, cat in pairs(build.crafting_categories) do --check crafting_categories and add compressed version if does not already exist
      if not data.raw["recipe-category"][cat.."-compressed"] then
        if not omni.lib.is_in_table(cat.."-compressed", recipe_category) then --check not already in table (in case of data:extend being done right at the end)
          recipe_category[#recipe_category+1] = {type = "recipe-category",name = cat.."-compressed"}
        end
      end
    end
  end
end

local recipe_results = {}

for _, recipe in pairs(data.raw.recipe) do
  local product = omni.lib.locale.get_main_product(recipe)
  product = product and data.raw[product.type][product.name]
  if product then
    local place_result = (data.raw[product.type][product.name] or {}).place_result
    place_result = place_result and omni.lib.locale.find(place_result, 'entity', true)
    if place_result and -- Valid
    building_list[place_result.type] and
    not omni.lib.string_contained_list(place_result.name, black_list) and --not on exclusion list
    not omni.compression.is_hidden(place_result) and (--Not hidden
      not compress_entity[place_result] or (
        compress_entity[place_result] and (
          not compress_entity[place_result].exclude or compress_entity[place_result].include
        ) -- Not excluded or included
      )) 
    then
      local top_result =  find_top_tier(place_result, place_result.type)
      if top_result and building_list[top_result.type] then
        recipe_results[top_result.name] = recipe_results[top_result.name] or {}
        local res = recipe_results[top_result.name]
        res[#res+1] = {
          recipe = recipe,
          item = product,
          building = top_result,
          base = place_result
        }
      end
    end
  end
end

--find placing item
local find_placing_item = function(build)
	for _, item in pairs(data.raw.item) do
		if item.place_result and item.place_result == build.name then return item end
	end
end
--find recipe
local find_recipe = function(product)
  for _,recipe in pairs(data.raw.recipe) do
    omni.lib.standardise(recipe)
    if #recipe.normal.results == 1 and recipe.normal.results[1].name == product then
      return recipe
    end
  end
	return nil
end

local new_effect = function(effect, level, linear, constant)
  local mult = (
    (linear and level + 1)
    or constant or
    math.pow(multiplier + 1, level)
  )
  return omni.lib.mult_fuel_value(effect, mult)
end

--new fluids for boilers and generators
local create_concentrated_fluid = function(fluid,tier)
  local new_fluid = table.deepcopy(data.raw.fluid[fluid])

  new_fluid.localised_name = omni.lib.locale.custom_name(new_fluid, "compressed-fluid", tier)
  new_fluid.name = new_fluid.name.."-concentrated-grade-"..tier
  if new_fluid.heat_capacity then
    new_fluid.heat_capacity = new_effect(new_fluid.heat_capacity, tier, nil, multiplier^tier)
  end
  
  if new_fluid.fuel_value then
    new_fluid.fuel_value = new_effect(new_fluid.fuel_value, tier)
  end
  new_fluid.icons = omni.lib.add_overlay(new_fluid, "compress-fluid", tier)
  new_fluid.icon = nil
  data:extend{new_fluid}

  local base_fluid = fluid
  -- if tier > 1 then baseFluid = baseFluid.."-concentrated-grade-"..(tier-1) end
  local base_fluid_data = {{name = base_fluid, type = "fluid", amount = sluid_contain_fluid*multiplier^(tier+1)}}
  local compress_fluid_data = {{name = "concentrated-"..base_fluid, type = "fluid", amount = multiplier^(tier+1)}}
  local grade_fluid_data = {{name = fluid.."-concentrated-grade-"..tier, type = "fluid", amount = sluid_contain_fluid*multiplier}}
  local grade_recipe_data = {
    energy_required = multiplier^(tier+1)/60,
    enabled = false,
    hide_from_player_crafting = true
  }
  local ungrade_recipe_data = table.deepcopy(grade_recipe_data) --deepcopy to safeguard against pointer nonsense
  
  local grade_compressed_recipe_data = table.deepcopy(grade_recipe_data)
  local ungrade_compressed_recipe_data = table.deepcopy(grade_compressed_recipe_data)

  grade_recipe_data.ingredients = base_fluid_data
  grade_recipe_data.results = grade_fluid_data
  grade_compressed_recipe_data.ingredients = compress_fluid_data
  grade_compressed_recipe_data.results = table.deepcopy(grade_fluid_data)

  ungrade_recipe_data.ingredients = table.deepcopy(grade_fluid_data)
  ungrade_recipe_data.results = table.deepcopy(base_fluid_data)
  ungrade_compressed_recipe_data.ingredients = table.deepcopy(grade_fluid_data)
  ungrade_compressed_recipe_data.results = table.deepcopy(compress_fluid_data)

  local grade = {
    type = "recipe",
    name = fluid.."-concentrated-grade-"..tier,
    --localised_name = omni.lib.locale.custom_name(data.raw.fluid[fluid], 'fluid-name.compressed-fluid', tier),
    category = "fluid-condensation",
    enabled = false,
    icons = new_fluid.icons,
    order = new_fluid.order or "z".."[condensed-"..fluid .."]"
  }
  local ungrade = {
    type = "recipe",
    name = "uncompress-"..fluid.."-concentrated-grade-"..tier,
    --localised_name = omni.lib.locale.custom_name(data.raw.fluid[fluid], 'fluid-name.compressed-fluid', tier),
    icons = omni.lib.add_overlay(fluid,"uncompress"),
    category = "fluid-condensation",
    subgroup = "concentrator-fluids",
    enabled = false,
    order = new_fluid.order or "z".."[condensed-"..fluid .."]"
  }
  local grade_compressed = table.deepcopy(grade)
  grade_compressed.name = "concentrated-"..grade.name
  local ungrade_compressed = table.deepcopy(ungrade)
  ungrade_compressed.name = "uncompress-concentrated-"..fluid.."-concentrated-grade-"..tier

  grade.normal = grade_recipe_data
  grade.expensive = table.deepcopy(grade_recipe_data)
  ungrade.normal = ungrade_recipe_data
  ungrade.expensive = table.deepcopy(ungrade_recipe_data)

  grade_compressed.normal = grade_compressed_recipe_data
  grade_compressed.expensive = table.deepcopy(grade_compressed_recipe_data)
  ungrade_compressed.normal = ungrade_compressed_recipe_data
  ungrade_compressed.expensive = table.deepcopy(ungrade_compressed_recipe_data)

  data:extend{grade,ungrade,grade_compressed,ungrade_compressed}
end


local process_fluid_box = function(fluid_box, i, is_graded)
  if not fluid_box then return end
  local fl_name
  if fluid_box.filter then
    if is_graded then
      fl_name = fluid_box.filter.."-concentrated-grade-"..i
    else
      fl_name = "concentrated-" .. fluid_box.filter
    end
    if not data.raw.fluid[fl_name] then 
      create_concentrated_fluid(fluid_box.filter,i)
    end
    fluid_box.filter = fl_name
  end
  -- if fluid_box.base_area then
  --   fluid_box.base_area = fluid_box.base_area * math.pow(multiplier, i) / sluid_contain_fluid
  -- end
  for I=1, #fluid_box do
    if fluid_box[I] then
      if fluid_box.filter then
        local fl_name
        if is_graded then
          fl_name = fluid_box.filter.."-concentrated-grade-"..i
        else
          fl_name = "concentrated-" .. fluid_box.filter
        end
        if not data.raw.fluid[fl_name] then 
          create_concentrated_fluid(fluid_box[I].filter,i)
        end
        fluid_box[I].filter = fl_name
      end
      -- if fluid_box[I].base_area then
      --   fluid_box[I].base_area = fluid_box[I].base_area * math.pow(multiplier, i) / sluid_contain_fluid
      -- end
    end
  end
end
-- These names are ass
local modspec = {
  slot_count = "module_slots",
  columns = "module_info_max_icons_per_row",
  rows = "module_info_max_icon_rows",
  shift = "module_info_icon_shift",
  scale = "module_info_icon_scale",
  gap_size = "module_info_separation_multiplier",
  y_offset = "module_info_multi_row_initial_height_modifier"
}
-- Help us keep the code clean
setmetatable(modspec, {
  __call = function(self, proto, key, expression)
    if expression then
      proto.module_specification[self[key]] = expression(proto.module_specification[self[key]])
    end
    return proto.module_specification[self[key]]
  end
})
-------------------------------------------------------------------------------
--[[Entity Type Specific Properties]]--
-------------------------------------------------------------------------------
local run_entity_updates = function(new, kind, i)
  --[[assembly type updates]]--
  --module slots
  if new.module_specification then
    -- Add slots
    modspec(
      new,
      "slot_count", 
      function(x) 
        return x and (x * (i + 1))
      end
    )
    -- Make sure we don't occlude nearby entities
    local bounding_box = new.selection_box or {
      {
        x = 0,
        y = 0
      },
      {
        x = 0,
        y = 0
      }
    }
    for entry=1, #bounding_box do -- Remove numbered and convert to explicit 
      for index=1, #bounding_box[entry] do
        bounding_box[entry][string.char(119+index)] = bounding_box[entry][index]
        bounding_box[entry][index] = nil
      end
    end
    -- Onwards!
    modspec(
      new,
      "scale", 
      function(x)
        x = modspec(new, "slot_count")
        -- Approach according to module count
        x = (x * 0.33) / (x + 2) + 0.25
        return x
      end
    )
    local scale_factor = modspec(new, "scale") / 0.5
    modspec(
      new,
      "shift", 
      function(x) 
        x = x or {0, 0.7}
        x[1] = x[1]
        x[2] = x[2]
        return x
      end
    )
    modspec(
      new,
      "gap_size", 
      function(x) 
        return x or 1.1
      end
    )
    modspec(
      new,
      "y_offset", 
      function(x) 
        return x or -0.1
      end
    )
    modspec(
      new,
      "columns", 
      function(x)
        x = util.distance(
          {bounding_box[1].x, 0},
          {bounding_box[2].x, 0}
        ) * 1.85
        -- Account for shift
        x = x - modspec(new, "shift")[1]
        -- And for gap size as well
        x = x - 0.05 * modspec(new, "gap_size") * scale_factor
        -- Apply scale
        x = x  / scale_factor
        return math.max(1, x)
      end
    )
    modspec(
      new,
      "rows", 
      function(x)
        -- Get our stock height
        x = util.distance(
          {0, bounding_box[1].y},
          {0, bounding_box[2].y}
        ) * 0.9
        -- Take out shift
        x = x - modspec(new, "shift")[2]
        -- y offset
        x = x - modspec(new, "y_offset")
        -- And for gap size as well
        x = x - 0.05 * modspec(new, "gap_size") * scale_factor
        -- Scale
        x = x / scale_factor
        return math.max(1, x)
      end
    )
  end
  --recipe category settings for assembly/furnace types
  if kind == "assembling-machine" or kind == "furnace" or kind == "rocket-silo" then
    local new_cat = table.deepcopy(new.crafting_categories) --revert each time
    for j, cat in pairs(new.crafting_categories) do
      if not data.raw["recipe-category"][cat.."-compressed"] then --check if category exists
        if not omni.lib.is_in_table(cat.."-compressed", recipe_category) then --check not already in the to-expand table
          recipe_category[#recipe_category+1] = {type = "recipe-category",name = cat.."-compressed"}
        end
      end
      new_cat[#new_cat+1] = cat.."-compressed" --add cat
    end
    if kind == "assembling-machine" and string.find(new.name,"assembling") then
      new_cat[#new_cat+1] = "general-compressed"
    end
    new.crafting_categories = new_cat
    new.crafting_speed = new.crafting_speed * math.pow(multiplier,i)
    if new.fluid_boxes then
      --process_fluid_box(new.fluid_boxes, i, false)
    end
  end
  --lab vial slot update (may want to move this to recipe update since tools/items are done later...)
  if kind == "lab" then
    for i,input in pairs(new.inputs) do
      if data.raw.tool["compressed-"..input] then
        new.inputs[i] = "compressed-"..input
      end
    end
    if new.researching_speed then new.researching_speed = new.researching_speed * (i+1) end
  end
  --[[Power type updates]]--
  --energy source
  if new.energy_source and new.energy_source.emissions_per_minute then new.energy_source.emissions_per_minute = new.energy_source.emissions_per_minute * math.pow(multiplier,i+1) end
  --power production tweaks
  if kind == "solar-panel" then
    new.production = new_effect(new.production,i)
  elseif kind == "reactor" then
    new.consumption = new_effect(new.consumption,i)
    if new.heat_buffer then
      new.heat_buffer.specific_heat = new_effect(new.heat_buffer.specific_heat,i)
      new.heat_buffer.max_transfer = new_effect(new.heat_buffer.max_transfer,i)
    end
  end
  --Heat Pipe
  if kind == "heat-pipe" then
    if new.heat_buffer then
      new.heat_buffer.specific_heat = new_effect(new.heat_buffer.specific_heat,i)
      new.heat_buffer.max_transfer = new_effect(new.heat_buffer.max_transfer,i)
    end
  end
  --Boiler
  if kind == "boiler" then
    if new.energy_consumption then new.energy_consumption = new_effect(new.energy_consumption, i, nil, multiplier^i) end
    if new.energy_source.fuel_inventory_size then new.energy_source.fuel_inventory_size = new.energy_source.fuel_inventory_size*(i+1) end
    if new.energy_source.effectivity then new.energy_source.effectivity = math.pow(new.energy_source.effectivity,1/(i+1)) end
    if new.energy_source.specific_heat then new.energy_source.specific_heat = new_effect(new.energy_source.specific_heat, i, nil, multiplier^i) end
    if new.energy_source.max_transfer then new.energy_source.max_transfer = new_effect(new.energy_source.max_transfer, i, nil, multiplier^i) end
    process_fluid_box(new.output_fluid_box, i, true)
    process_fluid_box(new.fluid_box, i, true)
  end
  --Generator
  if kind == "generator" and new.fluid_box then
    process_fluid_box(new.output_fluid_box, i)
    process_fluid_box(new.fluid_box, i, true)
    new.scale_fluid_usage = true
    if new.max_power_output then
      new.max_power_output = new_effect(new.max_power_output, i)
    end
    -- new.fluid_usage_per_tick = new.fluid_usage_per_tick * math.pow(multiplier, i) / sluid_contain_fluid
     --new.fluid_usage_per_tick*math.pow((multiplier+1)/multiplier,i)
    --new.effectivity = new.effectivity*math.pow(multiplier,i)
  end
  --Accumulator
  if kind == "accumulator" then
    local eff = new_effect(new.energy_source.buffer_capacity,i)
    new.energy_source.buffer_capacity = string.sub(eff,1,string.len(eff)-1).."J"
    new.energy_source.input_flow_limit = new_effect(new.energy_source.input_flow_limit,i)
    if new.energy_source.usage_priority == "tertiary" then
      new.energy_source.output_flow_limit = new_effect(new.energy_source.output_flow_limit,i)
    end
  else
  --double check...input_flow_limit on non acumulators
    if new.energy_source and new.energy_source.input_flow_limit and type(new.energy_source.input_flow_limit)=="string" then
      new.energy_source.input_flow_limit = new_effect(new.energy_source.input_flow_limit,i)
    end
  end
  --[[Support type updates]]--
  --energy usage
  if not omni.lib.is_in_table(kind,not_energy_use) and new.energy_usage then
    if omni.lib.string_contained_list(new.name,{"boiler","omnifluid"}) then
      new.energy_usage = new_effect(new.energy_usage, i)
    else
      new.energy_usage = new_effect(new.energy_usage, i)
      new.energy_usage = new_effect(new.energy_usage, nil, nil, energy_multiplier)
    end
  end
  --mining speed and radius update
  if kind == "mining-drill" then
    new.mining_speed = new.mining_speed * math.pow(multiplier,i/2)
    --new.mining_power = new.mining_power * math.pow(multiplier,i/2)
    new.resource_searching_radius = new.resource_searching_radius *(i+1)
  end
  --belts
  if kind == "transport-belt" or kind == "loader" or kind == "splitter" or kind == "underground-belt" or kind == "loader-1x1" then
    if new.animation_speed_coefficient then new.animation_speed_coefficient = new.animation_speed_coefficient*(i+2) end
    new.speed = new.speed*(i+2)
  end
  --beacons
  if kind == "beacon" then
    if new.supply_area_distance*(i+1) <= 64 then
      new.supply_area_distance = new.supply_area_distance*(i+1)
    else
      new.supply_area_distance = 64
    end
    new.module_specification.module_slots = new.module_specification.module_slots*(i+1)
  end
  --power poles
  if kind == "electric-pole" then
    new.maximum_wire_distance = math.min(new.maximum_wire_distance*multiplier*i,64)
    new.supply_area_distance = math.min(new.supply_area_distance*(i+1),64)
  end
  --offshore pumps
  if kind == "offshore-pump" then
    -- new.fluid = "concentrated-"..new.fluid
    local fl_name = new.fluid.."-concentrated-grade-"..i
    if not data.raw.fluid[fl_name] then 
      create_concentrated_fluid(new.fluid,i)
    end
    new.fluid = fl_name
  end
  --Inserters!
  if kind == "inserter" then
    new.extension_speed = new.extension_speed *(i + 2)
    new.rotation_speed = new.rotation_speed * (i + 2)
  end
  --Generators!
  if kind == "burner-generator" then
    new.max_power_output = new_effect(new.max_power_output, i)
    new.burner.emissions_per_minute = (new.burner.emissions_per_minute or 0) * math.pow(multiplier,i+1)
  end
  -- Rockets!
  if kind == "rocket-silo" and new.fixed_recipe then
    new.door_opening_speed = new.door_opening_speed * math.pow(multiplier, i)
    new.rocket_result_inventory_size = 8
    new.light_blinking_speed = new.light_blinking_speed * math.pow(multiplier, i)
    new.rocket_rising_delay = math.ceil((new.rocket_rising_delay or 30) / math.pow(multiplier, i)) -- Defaults are NOT present on the prototype!
    new.launch_wait_time = math.ceil((new.launch_wait_time or 120) / math.pow(multiplier, i))
    local rocket = table.deepcopy(data.raw["rocket-silo-rocket"][new.rocket_entity])
    rocket.name = "compressed-" .. rocket.name .. "-" .. i
    new.rocket_entity = rocket.name
    rocket.rising_speed = rocket.rising_speed * math.pow(multiplier, i)
    rocket.engine_starting_speed = rocket.engine_starting_speed * math.pow(multiplier, i)
    rocket.flying_speed = rocket.flying_speed * math.pow(multiplier, i)
    rocket.flying_acceleration = rocket.flying_acceleration * math.pow(multiplier, i)
    data:extend({rocket})
  end
  return new
end
log("start building compression")
-------------------------------------------------------------------------------
--[[Build Compression Tier Recipes]]--
-------------------------------------------------------------------------------
for build_name, values in pairs(recipe_results) do
    for _, details in pairs(values) do --only building types
      --category check and create if not
      local build = details.building
      if build 
        and details.item 
        and details.recipe
        and not details.recipe.name:find("^uncompress%-")
        and details.base
        and build.minable 
        -- and build.minable.result 
        -- and data.raw.item[build.minable.result] 
      then --check that it is a minable entity
        category_exists(build)
        already_compressed[build_name] = true
        for i = 1, omni.compression.bld_lvls do
          local new = table.deepcopy(build)
          local item = table.deepcopy(details.item)
          local rc = table.deepcopy(details.recipe)
          -------------------------------------------------------------------------------
          --[[Set Specific Properties]]--
          -------------------------------------------------------------------------------
          --recipe/item subgrouping
          if omni.compression.one_list then --if not the same as the base item
            if not data.raw["item-subgroup"]["compressor-"..item.subgroup.."-"..build.type] then
              local item_cat = {
                type = "item-subgroup",
                name = "compressor-"..item.subgroup.."-"..build.type,
                group = "compressor-buildings",
                order = "a[compressor-"..item.subgroup.."-".. build.type .."]" --maintain some semblance of order
              }
              data:extend({item_cat}) --create it if it didn't already exist
            end
            item.subgroup = "compressor-"..item.subgroup.."-"..build.type
            rc.subgroup = item.subgroup
          else --clean up item ordering
            item.order = item.order or "z"..i.."-compressed" --should force it to match, but be after it under all circumstances
          end


          -------------------------------------------------------------------------------
          --[[Since running deepcopy, only need to override new props]]--
          -------------------------------------------------------------------------------
          --[[ENTITY CREATION]]--
          new.name = new.name.."-compressed-"..string.lower(compress_level[i])
          new.localised_name = omni.lib.locale.custom_name(details.base, "compressed-building", compress_level[i])
          new.localised_description = omni.lib.locale.custom_name(
            details.base,
            "entity-description.compressed-building",
            multiplier^i,
            {"description-modifier." .. i}
          )
          new.max_health = new.max_health*math.pow(multiplier,i)
          new.minable.result = new.name
          new.minable.mining_time = (new.minable.mining_time or 10) * i
          new.icons = omni.lib.add_overlay(build,"building",i)
          new.icon = nil
          run_entity_updates(new, new.type, i)
          compressed_buildings[#compressed_buildings+1] = new --add entity to the list

          --[[ITEM CREATION]]--
          item.localised_name = new.localised_name
          item.name = new.name
          item.place_result = new.name
          item.stack_size = 5
          if kind == "transport-belt" or kind=="loader" or kind== "splitter" or kind=="underground-belt" or kind=="loader-1x1" then
            item.stack_size = 10
          else
            item.stack_size = 5
          end
          item.icons = omni.lib.add_overlay(item,"building",i)
          item.icon = nil

          compressed_buildings[#compressed_buildings+1] = item
          --[[COMPRESSION/DE-COMPRESSION RECIPE CREATION]]--
          if i == 1 then ing  = {{
            details.item.name,
            multiplier * cost_multiplier
          }} else
            ing = {{
              build.name.."-compressed-"..string.lower(compress_level[i-1]),
              multiplier
            }}
          end


          local recipe = {
            type = "recipe",
            name = rc.name.."-compressed-"..string.lower(compress_level[i]),
            localised_name = new.localised_name,
            ingredients = ing,
            icons = omni.lib.add_overlay(rc,"building",i),
            result = new.name,
            energy_required = 5*math.floor(math.pow(multiplier,i/2)),
            enabled = false,
            category = "crafting-compressed",
            order = (rc.order or details.item.order or "") .. "-compressed",
            subgroup = rc.subgroup,
            hide_from_player_crafting = rc.hide_from_player_crafting or omni.compression.hide_handcraft
          }

          compressed_buildings[#compressed_buildings+1] = recipe
          local uncompress = {
            type = "recipe",
            name = "uncompress-"..string.lower(compress_level[i]).."-"..rc.name,
            localised_name = omni.lib.locale.custom_name(build, 'recipe-name.uncompress-item'),
            localised_description = omni.lib.locale.custom_description(build, 'recipe-description.uncompress-item'),
            icons = omni.lib.add_overlay(rc,"uncompress"),
            subgroup = rc.subgroup,
            order = (rc.order or details.item.order or "") .. "-compressed",
            category = "compression",
            enabled = true,
            hidden = true,
            ingredients = {
              {new.name, 1}
            },
            results = ing,
            inter_item_count = item_count,
            energy_required = 5*math.floor(math.pow(multiplier,i/2)),
            hide_from_player_crafting = rc.hide_from_player_crafting or omni.compression.hide_handcraft
          }
          compressed_buildings[#compressed_buildings+1] = uncompress
        end
      end
    end
end

-- create tiered fluid fuel
for fluidname, fluid in pairs(data.raw.fluid) do
  if fluid.fuel_value and not fluidname:find("concentrated%-") then
    for i = 1, omni.compression.bld_lvls do
      create_concentrated_fluid(fluidname,i)
    end
  end
end

--extend new categories
if #recipe_category > 0 then
  data:extend(recipe_category)
end
--extend new buildings
if #compressed_buildings > 0 then
  data:extend(compressed_buildings)
end
log("end building compression")
