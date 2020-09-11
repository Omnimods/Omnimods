-------------------------------------------------------------------------------
--[[Initialisation and Config Variables]]--
-------------------------------------------------------------------------------
omni.compression.stack_compensate = settings.startup["omnicompression_compensate_stacksizes"].value --kind of local
omni.compression.hide_handcraft =  settings.startup["omnicompression_hide_handcraft"].value or nil--Don't override to false
local compress_recipes, uncompress_recipes, compress_items = {}, {}, {}
compressed_item_names = {}  --global?
local item_count = 0
local concentrationRatio = sluid_contain_fluid --set in omnilib
local excluded_items = {}
--Config variables
local compressed_item_stack_size = 120 -- stack size for compressed items (not the items returned that is dynamic)
local max_stack_size_to_compress = 2000 -- Don't compress items over this stack size
local speed_div = 8 --Recipe speed is stack_size/speed_div
-------------------------------------------------------------------------------
--[[Item Functions]]--
-------------------------------------------------------------------------------
--update science packs in labs
local science_list = {}
for _, lab in pairs(data.raw.lab) do
  for _, input in pairs(lab.inputs) do
    science_list[input] = true
  end
end
for _, item in pairs(data.raw["tool"]) do
  science_list[item.name] = true
end
-------------------------------------------------------------------------------
--[[Create Dynamic Recipes from fluids]]--
-------------------------------------------------------------------------------
--set-up basic parameters (temperature, energy_value etc)
log("start item compressing")
for _, group in pairs({"fluid"}) do
	--Loop through all of the items in the category
	for _, fluid in pairs(data.raw[group]) do
    --Check for hidden flag to skip later
    omni.compression.is_hidden(fluid) --check hidden
    if not (hidden or fluid.name:find("creative-mode")) then--and
    --string.find(fluid.name,"^compress") ==nil and string.find(fluid.name,"^concentrat") ==nil then --not already compressed
      --copy original
      local new_fluid = table.deepcopy(fluid)

      --Create the item
      new_fluid.name = "concentrated-"..new_fluid.name
      new_fluid.localised_name = omni.locale.custom_name(fluid, 'concentrated-fluid')
			new_fluid.sub_group = "fluids"
			new_fluid.order = fluid.order or "z".."[concentrated-"..fluid.name .."]"
      new_fluid.icons = omni.lib.add_overlay(fluid, "compress")
      new_fluid.icon = nil
      -- This causes issues with boiler and fluid generator scaling
      --new_fluid.heat_capacity = new_fluid.heat_capacity and omni.lib.mult_fuel_value(new_fluid.heat_capacity, concentrationRatio)
      new_fluid.fuel_value = new_fluid.fuel_value and omni.lib.mult_fuel_value(new_fluid.fuel_value, concentrationRatio)
      compressed_item_names[new_fluid.name] = true
      compress_items[#compress_items+1] = new_fluid
      
      --Create the compress recipe
      local compress = {
        type = "recipe",
        name = "compress-"..fluid.name,
        localised_name = omni.locale.custom_name(fluid, 'recipe-name.concentrate-fluid'),
        category = "fluid-concentration",
        enabled = true,
        hidden = true,
        icons = omni.lib.add_overlay(fluid, "compress"),
        order = fluid.order or "z".."[concentrated-"..fluid.name .."]",
        subgroup = "concentrator-fluids",
        normal = {
          ingredients = {
            {name = fluid.name, type = "fluid", amount = sluid_contain_fluid*concentrationRatio}
          },
          subgroup = "concentrator-fluids",
          results = {
            {name = "concentrated-"..fluid.name, type = "fluid", amount = sluid_contain_fluid}
          },
          energy_required = sluid_contain_fluid / speed_div,
          enabled = true,
          hidden = true,
          hide_from_player_crafting = omni.compression.hide_handcraft
        },
        expensive={
          ingredients = {
            {name = fluid.name, type = "fluid", amount = sluid_contain_fluid*concentrationRatio}
          },
          subgroup = "concentrator-fluids",
          results = {
            {name = "concentrated-"..fluid.name, type = "fluid", amount = sluid_contain_fluid}
          },
          energy_required = sluid_contain_fluid / speed_div,
          enabled = true,
          hidden = true,
          hide_from_player_crafting = omni.compression.hide_handcraft
        }
      }
      --omni.marathon.standardise(compress)
      standardized_recipes["compress-"..fluid.name] = true
      compress_recipes[#compress_recipes+1] = compress

      --The uncompress recipe
      local uncompress = {
        type = "recipe",
        name = "uncompress-"..fluid.name,
        localised_name = omni.locale.custom_name(fluid, 'recipe-name.deconcentrate-fluid'),
        icons = omni.lib.add_overlay(fluid, "uncompress"),
        category = "fluid-concentration",
        enabled = true,
        hidden = true,
        order = fluid.order or "z".."[concentrated-"..fluid.name .."]",
        normal = {
          ingredients = {
            {name = "concentrated-"..fluid.name,type = "fluid", amount = sluid_contain_fluid}
          },
          subgroup = "compressor-out-fluids",
          results = {
            {name = fluid.name, type = "fluid", amount = sluid_contain_fluid*concentrationRatio}
          },
          enabled = true,
          hidden = true,
          hide_from_player_crafting = omni.compression.hide_handcraft,
          energy_required = concentrationRatio / speed_div,
        },
        expensive = {
          ingredients = {
            {name = "concentrated-"..fluid.name, type = "fluid", amount = sluid_contain_fluid}
          },
          subgroup = "compressor-out-fluids",
          results = {
            {name = fluid.name,type="fluid", amount=sluid_contain_fluid*concentrationRatio}
          },
          enabled = true,
          hidden = true,
          hide_from_player_crafting = omni.compression.hide_handcraft,
          energy_required = concentrationRatio / speed_div,
        },
      }
      --omni.marathon.standardise(uncompress)
      standardized_recipes["uncompress-"..fluid.name] = true
			uncompress_recipes[#uncompress_recipes+1] = uncompress
		end
	end
end
-------------------------------------------------------------------------------
--[[Create Dynamic Recipes from Items]]--
-------------------------------------------------------------------------------
local function generate_compressed_item(item, norecipe)
  if not item then return end
  local place_result = omni.locale.find(item.place_result, "entity", true)
  if omni.compression.stack_compensate and item.stack_size > 1 then --setting variable and stack size exclusion
    if not item.place_result or place_result == nil then
      item.stack_size = math.ceil(item.stack_size/60)*60
    else
      item.stack_size = math.ceil(item.stack_size/6)*6
    end
  end
  -- Rockets and whatnot
  if place_result and place_result.fixed_recipe and data.raw["recipe"][place_result.fixed_recipe] then
    local recipe = data.raw["recipe"][place_result.fixed_recipe] 
    for _, difficulty in pairs ({"normal", "expensive"}) do
      for _, ingredient in pairs(recipe[difficulty].ingredients) do
        ingredient = omni.locale.parse_ingredient(ingredient)
        if ingredient.type == "item" and
          not data.raw["item"]["compressed-"..ingredient.name]
        then
          generate_compressed_item(data.raw.item[ingredient.name])
        end
      end
      for _, result in pairs(recipe[difficulty].results) do
        result = omni.locale.parse_product(result)
        if result.type == "item" and
          not data.raw["item"]["compressed-" .. result.name]
        then
          omni.compression.include_recipe(result.name)
          generate_compressed_item(data.raw.item[result.name])
        end
      end
    end
  end
  --recipe/item order
  local order = "z"
  if item.order then
    order = item.order
  elseif item.normal and item.normal.order then
    order = item.normal.order
  end
  order = order .."[concentrated-"..item.name .."]"
  --set up new item
  local new_item = {
    type = "item",
    name = "compressed-"..item.name,
    localised_name = omni.locale.custom_name(item, 'item-name.compressed-item'),
    localised_description = omni.locale.custom_name(item, 'item-description.compressed-item'),
    flags = item.flags,
    icons = omni.lib.add_overlay(item, "compress"),
    subgroup = item.subgroup,
    order = order,
    stack_size = item.stack_size == 1 and 1 or compressed_item_stack_size,
    fuel_value = item.fuel_value and omni.lib.mult_fuel_value(item.fuel_value, item.stack_size),
    fuel_category = item.fuel_category,
    fuel_acceleration_multiplier = item.fuel_acceleration_multiplier,
    fuel_top_speed_multiplier = item.fuel_top_speed_multiplier,
    fuel_emissions_multiplier = item.fuel_emissions_multiplier,
    fuel_glow_color = item.fuel_glow_color,
    durability = item.durability,
    rocket_launch_product = table.deepcopy(item.rocket_launch_product),
    rocket_launch_products = table.deepcopy(item.rocket_launch_products)
  }
  if science_list[item.name] then
    new_item.type = "tool"
    new_item.stack_size = compressed_item_stack_size
  end
  -- Case: satellite
  local product_table = (
    new_item.rocket_launch_product and
    {new_item.rocket_launch_product}
    or new_item.rocket_launch_products
    or {}
  )
  for _, product in pairs(product_table) do
    -- Standardise
    product.name = product.name or product[1]
    product.amount = product.amount or product[2]
    product[1], product[2] = nil, nil

    -- Scale
    if product.name and product.amount and not data.raw.item["compressed-"..product.name] then
      generate_compressed_item(omni.locale.find(product.name, "item"))
      omni.compression.include_recipe(product.name)
      product.name = "compressed-" .. product.name
    end
  end
  -- Aaaand insert
  if #product_table > 0 then
    new_item.rocket_launch_products = product_table
    new_item.rocket_launch_product = nil
    omni.compression.include_recipe(item.name)
  end

  compressed_item_names[new_item.name] = true
  compress_items[#compress_items+1] = new_item
  if not norecipe and item.stack_size ~= 1 then
    --The compress recipe
    local compress = {
      type = "recipe",
      name = "compress-"..item.name,
      localised_name = omni.locale.custom_name(item, 'recipe-name.compress-item'),
      localised_description = omni.locale.custom_name(item, 'recipe-description.compress-item'),
      category = "compression",
      icons = omni.lib.add_overlay(item,"compress"),
      order = order,
      normal = {
        ingredients = {
        { type = "item",
          name = item.name,
          amount = math.min(item.stack_size, 65535)
        }
        },
        subgroup = "compressor-items",
        results = {
          {type = "item", name = "compressed-"..item.name, amount = 1}
        },
        energy_required = item.stack_size / speed_div,
        enabled = true,
        hidden = true,
        hide_from_player_crafting = omni.compression.hide_handcraft
      },
      expensive = {
        ingredients = {
          {type = "item", name = item.name, amount = math.min(item.stack_size,65535)}
        },
        subgroup = "compressor-items",
        results = {
          {type = "item", name = "compressed-"..item.name, amount = 1}
        },
        energy_required = item.stack_size / speed_div,
        enabled = true,
        hidden = true,
        hide_from_player_crafting = omni.compression.hide_handcraft
      },
    }

    --omni.marathon.standardise(compress)
    standardized_recipes["compress-"..item.name] = true
    compress_recipes[#compress_recipes+1] = compress
    --The uncompress recipe
    local uncompress = {
      type = "recipe",
      name = "uncompress-"..item.name,
      localised_name = omni.locale.custom_name(item, 'recipe-name.uncompress-item'),
      localised_description = omni.locale.custom_name(item, 'recipe-description.uncompress-item'),
      icons = omni.lib.add_overlay(item, "uncompress"),
      category = "compression",
      enabled = true,
      hidden = true,
      hide_from_player_crafting = omni.compression.hide_handcraft,
      order = order,
      normal = {
        ingredients = {
          {type = "item", name = "compressed-"..item.name, amount = 1}
        },
        subgroup = "compressor-out-items",
        results = {
          {type = "item", name = item.name, amount = math.min(item.stack_size,65535)}
        },
        energy_required = item.stack_size / speed_div,
        enabled = true,
        hidden = true,
        hide_from_player_crafting = omni.compression.hide_handcraft
      },
      expensive = {
        ingredients = {
          {type = "item", name = "compressed-"..item.name, amount = 1}
        },
        subgroup = "compressor-out-items",
        results = {
          {type = "item", name = item.name, amount = math.min(item.stack_size,65535)}
        },
        energy_required = item.stack_size / speed_div,
        enabled = true,
        hidden = true,
        hide_from_player_crafting = omni.compression.hide_handcraft
      },
    }
    --omni.marathon.standardise(uncompress)
    standardized_recipes["uncompress-"..item.name] = true
    uncompress_recipes[#uncompress_recipes+1] = uncompress
  end
end

for group in pairs(data.raw) do
  if omni.locale.inherits(group, "item") and not (
    omni.locale.inherits(group, "selection-tool") or
    omni.locale.inherits(group, "selection-tool")
    ) 
  then
    for _, item in pairs(data.raw[group]) do
      --Check for hidden flag to skip later
      local hidden = omni.compression.is_hidden(item) --check hidden
      if item.stack_size >= 1 and
        (item.stack_size <= max_stack_size_to_compress or science_list[item.name]) and
        omni.compression.is_stackable(item) and
        not (hidden or item.name:find("creative-mode"))
      then
        generate_compressed_item(item)
      elseif not compressed_item_names["compressed-"..item.name] then--exclude item
        excluded_items[item.name] = true
      end      
    end
  end
end
--log(serpent.block(excluded_items))

for _, rec in pairs(data.raw.recipe) do
  for _, dif in pairs({"normal", "expensive"}) do
    for _, ing in pairs(rec[dif].ingredients) do
      if excluded_items[ing.name] and not compressed_item_names["compressed-"..ing.name] then
        --log("Excluded recipe '"..rec.name.."' due to '"..ing.name.."' being on the blacklist")
        omni.compression.exclude_recipe(rec.name)
      end
    end
  end
end
data:extend(compress_items)
data:extend(compress_recipes)
data:extend(uncompress_recipes)
log("end item compression")
