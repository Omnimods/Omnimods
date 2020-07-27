-------------------------------------------------------------------------------
--[[Initialisation and Config Variables]]--
-------------------------------------------------------------------------------
omni.compression.stack_compensate = settings.startup["omnicompression_compensate_stacksizes"].value --kind of local
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

--set new fuel value
local new_fuel_value = function(effect,stack)
	if not effect then return nil end
	local eff = string.sub(effect,1,string.len(effect)-2)
	local value = string.sub(effect,string.len(effect)-1,string.len(effect)-1)
	if string.len(effect) == 2 then
		eff = string.sub(effect,1,1)
		value = ""
	end
	eff = tonumber(eff)*stack
	if eff > 1000 then
		eff = eff/1000
		if value == "k" then value = "M" elseif value == "M" then value = "G" end
	end
	return eff..value.."J"
end
--update science packs in labs
local is_science = function(item)
	for _, lab in pairs(data.raw.lab) do
		for _, input in pairs(lab.inputs) do
			if item.name == input then return true end
		end
	end
	return false
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
      --Common Variables
      loc_key = new_fluid.localised_name or {"fluid-name."..new_fluid.name}

      --Create the item
      new_fluid.name = "concentrated-"..new_fluid.name
			new_fluid.sub_group = "fluids"
			new_fluid.order = fluid.order or "z".."[concentrated-"..fluid.name .."]"
			new_fluid.icons = omni.compression.add_overlay(fluid.name,"compress")
      new_fluid.localised_name = {"fluid-name.concentrated-fluid", loc_key}
      new_fluid.localised_description = {"fluid-description.concentrated-fluid", loc_key}
      new_fluid.heat_capacity = new_fuel_value(new_fluid.heat_capacity,concentrationRatio)
      new_fluid.fuel_value = new_fuel_value(new_fluid.fuel_value,concentrationRatio)

      compressed_item_names[#compressed_item_names+1] = new_fluid.name
      compress_items[#compress_items+1] = new_fluid
      
      --Create the compress recipe
      local compress = {
        type = "recipe",
        name = "compress-"..fluid.name,
        localised_name = {"recipe-name.concentrate-fluid", loc_key},
        localised_description = {"recipe-description.concentrate-fluid", loc_key},
        category = "fluid-concentration",
        enabled = true,
        hidden = true,
        icons = omni.compression.add_overlay(fluid.name,"compress"),
        icon_size = 32,
        order = fluid.order or "z".."[concentrated-"..fluid.name .."]",
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
        }
      }
      --omni.marathon.standardise(compress)
      standardized_recipes["compress-"..fluid.name] = true
      compress_recipes[#compress_recipes+1] = compress

      --The uncompress recipe
      local uncompress = {
        type = "recipe",
        name = "uncompress-"..fluid.name,
        localised_name = {"recipe-name.deconcentrate-fluid", loc_key},
        localised_description = {"recipe-description.deconcentrate-fluid", loc_key},
        icons = omni.compression.add_overlay(fluid.name,"uncompress"),
        icon_size = 32,
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
for _, group in pairs({"item", "ammo", "module", "rail-planner", "repair-tool", "capsule", "mining-tool", "tool","gun","armor"}) do
  for _, item in pairs(data.raw[group]) do
		--Check for hidden flag to skip later
    local hidden = omni.compression.is_hidden(item) --check hidden
    if item.stack_size >= 1 and item.stack_size <= max_stack_size_to_compress and omni.compression.is_stackable(item) and
      not (hidden or item.name:find("creative-mode")) then--and
      --string.find(item.name,"compress") ==nil and string.find(item.name,"concentrat") ==nil then --not already compressed
      --stack size settings
      if omni.compression.stack_compensate and item.stack_size > 1 then --setting variable and stack size exclusion
				if not item.place_result or omni.lib.find_entity_prototype(item.place_result) == nil then
					item.stack_size = omni.lib.round_up(item.stack_size/60)*60
				else
					item.stack_size = omni.lib.round_up(item.stack_size/6)*6
				end
      end
      --localisation (thse 4 seem to work)
			local loc_key = {"item-name."..item.name}
			if item.localised_name then
				loc_key = table.deepcopy(item.localised_name)
			elseif item.place_result then
				loc_key = {"entity-name."..item.place_result}
			elseif item.placed_as_equipment_result then
				loc_key = {"equipment-name."..item.placed_as_equipment_result}
      end
      --recipe/item order
      local order = "z"
      if item.order then
        order = item.order
      elseif item.normal and item.normal.order then
        order = item.normal.order
      end
      order = order .."[concentrated-"..item.name .."]"
      --set type
			local it_type = "item"
			if is_science(item) then it_type = "tool" end
      --set up new item
			local new_item = {
				type = it_type,
				name = "compressed-"..item.name,
				localised_name = {"item-name.compressed-item", loc_key},
				localised_description = {"item-description.compressed-item", loc_key},
				flags = item.flags,
				icons = omni.compression.add_overlay(item.name,"compress"),
				icon_size = 32,
				subgroup = item.subgroup,
				order = order,
				stack_size = compressed_item_stack_size,
				fuel_value = new_fuel_value(item.fuel_value,item.stack_size),
				fuel_category = item.fuel_category,
				fuel_acceleration_multiplier = item.fuel_acceleration_multiplier,
				fuel_top_speed_multiplier = item.fuel_top_speed_multiplier,
				durability = item.durability
			}

      compressed_item_names[#compressed_item_names+1] = new_item.name
      compress_items[#compress_items+1] = new_item

      --The compress recipe
			local compress = {
				type = "recipe",
				name = "compress-"..item.name,
				localised_name = {"recipe-name.compress-item", loc_key},
				localised_description = {"recipe-description.compress-item", loc_key},
				category = "compression",
				enabled = true,
        hidden = true,
        icons=omni.compression.add_overlay(item.name,"compress"),
				icon_size = 32,
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
        },
      }

      --omni.marathon.standardise(compress)
      standardized_recipes["compress-"..item.name] = true
      compress_recipes[#compress_recipes+1] = compress
			--The uncompress recipe
			local uncompress = {
				type = "recipe",
				name = "uncompress-"..item.name,
				localised_name = {"recipe-name.uncompress-item", loc_key},
				localised_description = {"recipe-description.uncompress-item", loc_key},
				icons = omni.compression.add_overlay(item.name,"uncompress"),
				icon_size = 32,
				category = "compression",
				enabled = true,
        hidden = true,
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
        },
      }
      --omni.marathon.standardise(uncompress)
      standardized_recipes["uncompress-"..item.name] = true
			uncompress_recipes[#uncompress_recipes+1] = uncompress
    else--exclude item
      excluded_items[item.name] = true
    end
	end
end
--log(serpent.block(excluded_items))

for _, rec in pairs(data.raw.recipe) do
  for _, dif in pairs({"normal", "expensive"}) do
    for _, ing in pairs(rec[dif].ingredients) do
      if excluded_items[ing.name] then
        omni.lib.log("Excluded recipe '"..rec.name.."' due to '"..ing.name.."' being on the blacklist", false)
        omni.compression.exclude_recipe(rec.name)
      end
    end
  end
end

data:extend(compress_items)
data:extend(compress_recipes)
data:extend(uncompress_recipes)
log("end item compression")
