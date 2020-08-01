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
local is_science = function(item)
	for _, lab in pairs(data.raw.lab) do
		for _, input in pairs(lab.inputs) do
			if item.name == input then return true end
		end
	end
	return false
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
      new_fluid.icons = omni.lib.add_overlay(fluid.name,"compress")
      new_fluid.icon = nil
      new_fluid.heat_capacity = new_fluid.heat_capacity and omni.lib.mult_fuel_value(new_fluid.heat_capacity, concentrationRatio)
      new_fluid.fuel_value = new_fluid.fuel_value and omni.lib.mult_fuel_value(new_fluid.fuel_value, concentrationRatio)

      compressed_item_names[#compressed_item_names+1] = new_fluid.name
      compress_items[#compress_items+1] = new_fluid
      
      --Create the compress recipe
      local compress = {
        type = "recipe",
        name = "compress-"..fluid.name,
        localised_name = omni.locale.custom_name(fluid, 'recipe-name.concentrate-fluid'),
        category = "fluid-concentration",
        enabled = true,
        hidden = true,
        icons = omni.lib.add_overlay(fluid.name,"compress"),
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
        icons = omni.lib.add_overlay(fluid.name,"uncompress"),
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
  local place_result = omni.locale.find(item.place_result, "entity", true)
  if omni.compression.stack_compensate and item.stack_size > 1 then --setting variable and stack size exclusion
    if not item.place_result or place_result == nil then
      item.stack_size = omni.lib.round_up(item.stack_size/60)*60
    else
      item.stack_size = omni.lib.round_up(item.stack_size/6)*6
    end
  end
  -- Rockets and whatnot
  if place_result and place_result.fixed_recipe and data.raw["recipe"][place_result.fixed_recipe] then
    local old_recipe = omni.locale.get_main_product(omni.locale.find(place_result.fixed_recipe, "recipe"))
    if old_recipe then
      generate_compressed_item(
        omni.locale.find(old_recipe.name, "item")
      )
      omni.compression.include_recipes = omni.compression.include_recipes or {}
      omni.compression.include_recipes[#omni.compression.include_recipes+1] = place_result.fixed_recipe
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
    localised_name = omni.locale.custom_name(item, 'compressed-item'),
    localised_description = omni.locale.custom_name(item, 'compressed-item'),
    flags = item.flags,
    icons = omni.lib.add_overlay(item.name,"compress"),
    subgroup = item.subgroup,
    order = order,
    stack_size = compressed_item_stack_size,
    fuel_value = item.fuel_value and omni.lib.mult_fuel_value(item.fuel_value,item.stack_size),
    fuel_category = item.fuel_category,
    fuel_acceleration_multiplier = item.fuel_acceleration_multiplier,
    fuel_top_speed_multiplier = item.fuel_top_speed_multiplier,
    durability = item.durability
  }

  if science_list[item.name] then new_item.type = "tool" end
  local base_product = item.rocket_launch_product and item.rocket_launch_product[1]
  if base_product and not base_product:find("^compressed%-") then
    if data.raw["item"][base_product] then
      new_item.rocket_launch_product = {
        "compressed-" .. item.rocket_launch_product[1],
        item.rocket_launch_product[2] 
      }

      if is_science(item) then new_item.type = "tool" end

      compressed_item_names[#compressed_item_names+1] = new_item.name
      compress_items[#compress_items+1] = new_item

      --The compress recipe
			local compress = {
				type = "recipe",
				name = "compress-"..item.name,
				localised_name = omni.locale.custom_name(item, 'recipe-name.compress-item', class),
				localised_description = omni.locale.custom_description(item, 'recipe-description.compress-item', class),
				category = "compression",
				enabled = true,
        hidden = true,
        icons = omni.lib.add_overlay(item.name,"compress"),
        order = order,
        normal = {
          ingredients = {
            {type = "item", name = item.name, amount = item.stack_size}
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
            {type = "item", name = item.name, amount = item.stack_size}
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
				localised_name = omni.locale.custom_name(item, 'recipe-name.uncompress-item', class),
				localised_description = omni.locale.custom_description(item, 'recipe-description.uncompress-item', class),
				icons = omni.lib.add_overlay(item.name,"uncompress"),
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
            {type = "item", name = item.name, amount = item.stack_size}
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
            {type = "item", name = item.name, amount = item.stack_size}
          },
          energy_required = item.stack_size / speed_div,
          enabled = true,
          hidden = true,
          hide_from_player_crafting = omni.compression.hide_handcraft
        },
<<<<<<< HEAD
      }
      --omni.marathon.standardise(uncompress)
      standardized_recipes["uncompress-"..item.name] = true
			uncompress_recipes[#uncompress_recipes+1] = uncompress
    else--exclude item
=======
        energy_required = item.stack_size / speed_div,
        enabled = true,
        hidden = true,
        hide_from_player_crafting = omni.compression.hide_handcraft
      },
    }

    --omni.marathon.standardise(compress)
    standardized_recipes["compress-"..item.name] = true
    compress_recipes[#compress_recipes+1] = compress
  end
  --The uncompress recipe
  local uncompress = {
    type = "recipe",
    name = "uncompress-"..item.name,
    localised_name = omni.locale.custom_name(item, 'recipe-name.uncompress-item', class),
    localised_description = omni.locale.custom_description(item, 'recipe-description.uncompress-item', class),
    icons = omni.lib.add_overlay(item.name,"uncompress"),
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
        {type = "item", name = item.name, amount = item.stack_size}
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
        {type = "item", name = item.name, amount = item.stack_size}
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
for _, group in pairs({"item", "ammo", "module", "rail-planner", "repair-tool", "capsule", "mining-tool", "tool","gun","armor"}) do
  for _, item in pairs(data.raw[group]) do
		--Check for hidden flag to skip later
    local hidden = omni.compression.is_hidden(item) --check hidden
    if item.stack_size >= 1 and
      (item.stack_size <= max_stack_size_to_compress or science_list[item.name]) and
      omni.compression.is_stackable(item) and
      not (hidden or item.name:find("creative-mode"))
    then
      generate_compressed_item(item)
    elseif not data.raw["item"]["compressed-"..item.name] then--exclude item
>>>>>>> a1f5280... More improvements (paving)
      excluded_items[item.name] = true
    end
	end
end
--log(serpent.block(excluded_items))

for _, rec in pairs(data.raw.recipe) do
  for _, dif in pairs({"normal", "expensive"}) do
    for _, ing in pairs(rec[dif].ingredients) do
      if excluded_items[ing.name] and not data.raw.item["compressed-" .. ing.name] then
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
