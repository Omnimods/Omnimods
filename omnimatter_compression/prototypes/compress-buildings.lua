
local multiplier = settings.startup["omnicompression_multiplier"].value

--for _,kind in pairs({"mining-drill"})
log("started building compression")
local new_icon = function(build,level)
	local icons_1 = {icon = "__omnimatter_compression__/graphics/compress-"..level.."-32.png", icon_size = 32, scale=1}
	local icons={}
	if build.icons then
		icons=build.icons
		table.insert(icons,icons_1)
		local ic_sz=32
		if build.icon_size then
			ic_sz=build.icon_size
		elseif build.icons.icon_size then
			ic_sz=build.icons.icon_size
		end
		for pos,icon in pairs(icons) do
			if not icon.icon_size then
				--back-up setting icon size if not found
				icon.icon_size=ic_sz
			end
		end
	else
		icons[1]=icons_1
		icons[2]={icon=build.icon, icon_size = build.icon_size or 32}
	end
	return icons
end

local find_top_tier = function(build,kind)
	local name = build.name
	if not settings.startup["omnicompression_final_building"].value then
		return build
	elseif omni.lib.is_number(omni.lib.get_end(name,2)) then
		name=string.sub(name,1,string.len(name)-2)
	elseif omni.lib.is_number(omni.lib.get_end(name,1)) then
		name=string.sub(name,1,string.len(name)-1)
	elseif not data.raw[kind][name.."-2"] and not data.raw[kind][name.."2"] then
		return build
	end
	local nr = 1
	local found = true
	while found do
		nr=nr+1
		if not data.raw[kind][name.."-"..nr] and data.raw[kind][name.."-"..nr-1] then
			found = false
			return data.raw[kind][name.."-"..nr-1]
		elseif not data.raw[kind][name..nr] and data.raw[kind][name..nr-1] then
			found = false
			return data.raw[kind][name..nr-1]
		end
	end
end

local new_effect = function(effect,level,linear,constant)
	local eff = string.sub(effect,1,string.len(effect)-2)
	local value = string.sub(effect,string.len(effect)-1,string.len(effect)-1)
	if string.len(effect)==2 then
		eff = string.sub(effect,1,1)
		value = ""
	end
	eff=tonumber(eff)
	if linear then
		eff=eff*(level+1)
	elseif constant then
		eff=eff*(constant)
	else
		eff = eff*math.pow(multiplier+1,level)
	end
	if eff > 1000 then
		eff=eff/1000
		if value == "k" then value = "M" elseif value == "M" then value = "G" end
	end
	return eff..value.."W"
end



local new_effect_gain = function(effect,level,linear,constant)
	local eff = string.sub(effect,1,string.len(effect)-2)
	local value = string.sub(effect,string.len(effect)-1,string.len(effect)-1)
	if string.len(effect)==2 then
		eff = string.sub(effect,1,1)
		value = ""
	end
	eff=tonumber(eff)
	if linear then
		eff=eff*(level+1)
	elseif constant then
		eff=eff*(constant)
	else
		eff = eff*math.pow(multiplier,level)
	end
	if eff > 1000 then
		eff=eff/1000
		if value == "k" then value = "M" elseif value == "M" then value = "G" elseif value=="G" then value="T" end
	end
	return eff..value.."W"
end

local find_placing_item = function(build)
	for _, item in pairs(data.raw.item) do
		if item.place_result and item.place_result == build.name then return item end
	end
end

local category_exists = function(build)
	if not build.crafting_categories then return true end
	for i, cat in pairs(build.crafting_categories) do
		if data.raw["recipe-category"][cat.."-compressed"] then return true end
	end
	return false
end

local find_recipe = function(product)
	for _,recipe in pairs(data.raw.recipe) do
		omni.marathon.standardise(recipe)
		if #recipe.normal.results == 1 and recipe.normal.results[1].name == product then
			return recipe
		end
	end
	return nil
end

local compress_level = {"Compact","Nanite","Quantum","Singularity"}

local not_energy_use = {"solar-panel","reactor","boiler","generator","accumulator","transport-belt","loader","splitter","underground-belt","electric-pole"}
local black_list = {"creative",{"burner","turbine"},{"crystal","reactor"},{"factory","port","marker"},{"biotech","biosolarpanel","solarpanel"},"bucketw"}

local compressed_buildings={}
local already_compressed = {}
local building_list = {"lab","assembling-machine","furnace","mining-drill","solar-panel","reactor","accumulator","transport-belt","loader","splitter","underground-belt","beacon","electric-pole"}
if not mods["omnimatter_fluid"] then building_list[#building_list+1]="boiler" end
building_list[#building_list+1]="generator"
for _,kind in pairs(building_list) do
	for _,b in pairs(data.raw[kind]) do
		if (b.icon_size or 31)%32 == 0 and math.log(b.icon_size or 32)/math.log(2) > 4 and not omni.lib.string_contained_list(b.name,black_list) and (not compress_entity[b] or (compress_entity[b] and (not compress_entity[b].exclude or compress_entity[b].include))) then
			local build = find_top_tier(b,kind)
			if not omni.lib.is_in_table(build.name,already_compressed) and category_exists(build) and build.minable and build.minable.result and data.raw.item[build.minable.result] then
				local rc=find_recipe(build.name)
				if find_placing_item(build) and rc then
					already_compressed[#already_compressed+1]=build.name
					for i=1,settings.startup["omnicompression_building_levels"].value do
						local new = table.deepcopy(build)
						local icons = new_icon(new,i)

						local loc = {"entity-name."..build.name}

						if build.localised_name then loc = build.localised_name end

						new.localised_name = {"entity-name.compressed_building",loc,compress_level[i]}
						new.icons = icons
						new.icon_size = nil
						new.icon = nil
						new.name = new.name.."-compressed-"..string.lower(compress_level[i])

						new.max_health=new.max_health*math.pow(multiplier,i)

						--new.minable.mining_time = new.minable.mining_time * i
						new.minable.result = new.name

						if new.energy_source and new.energy_source.emissions then new.energy_source.emissions = new.energy_source.emissions * math.pow(multiplier,i+1) end
						if not omni.lib.is_in_table(kind,not_energy_use) then
							if omni.lib.string_contained_list(new.name,{"boiler","omnifluid"}) then
								new.energy_usage = new_effect_gain(new.energy_usage,i)
							else
								new.energy_usage = new_effect(new.energy_usage,i)
							end
						end
						if new.module_specification then new.module_specification.module_slots = new.module_specification.module_slots * (i+1) end

						if kind == "assembling-machine" or kind == "furnace" then
							local new_cat = {}
							for i, cat in pairs(new.crafting_categories) do
								if data.raw["recipe-category"][cat.."-compressed"] then
									new_cat[#new_cat+1]=cat.."-compressed"
								end
							end

							new.crafting_categories=new_cat
							new.crafting_speed = new.crafting_speed* math.pow(multiplier,i)
						end
						if kind == "mining-drill" then
							new.mining_speed = new.mining_speed * math.pow(multiplier,i/2)
							--new.mining_power = new.mining_power * math.pow(multiplier,i/2)

							new.resource_searching_radius = new.resource_searching_radius *(i+1)
						end
						if kind=="solar-panel" then
							new.production = new_effect_gain(new.production,i)
						elseif kind=="reactor" then
							new.consumption = new_effect(new.consumption,i)
							if new.heatbuffer then
								new.heatbuffer.specific_heat = new_effect(new.heatbuffer.specific_heat,i,true)
								new.heatbuffer.max_transfer = new_effect(new.heatbuffer.max_transfer,i,true)
							end
						end

						if kind=="lab" then
							for i,input in pairs(new.inputs) do
								if data.raw.tool["compressed-"..input] then
									new.inputs[i]="compressed-"..input
								end
							end
							if new.researching_speed then new.researching_speed = new.researching_speed * (i+1) end
						end
						if kind == "boiler" then
							--if new.energy_consumption then new.energy_consumption = new_effect(new.energy_consumption,i) end
							if new.energy_source.fuel_inventory_size then new.energy_source.fuel_inventory_size = new.energy_source.fuel_inventory_size*(i+1) end
							--if new.energy_source.effectivity then new.energy_source.effectivity = math.pow(new.energy_source.effectivity,1/(i+1)) end
							if new.output_fluid_box and new.output_fluid_box.filter and not data.raw.fluid[new.output_fluid_box.filter.."-concentrated-grade-"..i] then
								local newFluid=table.deepcopy(data.raw.fluid[new.output_fluid_box.filter])
								newFluid.localised_name={"fluid-name.compressed-fluid",{"fluid-name."..newFluid.name},i}
								newFluid.name = newFluid.name.."-concentrated-grade-"..i
								newFluid.heat_capacity = tonumber(string.sub(newFluid.heat_capacity,1,string.len(newFluid.heat_capacity)-2))*math.pow(multiplier,i)..string.sub(newFluid.heat_capacity,string.len(newFluid.heat_capacity)-1,string.len(newFluid.heat_capacity))
								if newFluid.fuel_value then
									newFluid.fuel_value=tonumber(string.sub(newFluid.fuel_value,1,string.len(newFluid.fuel_value)-2))*math.pow(multiplier,i)..string.sub(newFluid.fuel_value,string.len(newFluid.fuel_value)-2,string.len(newFluid.fuel_value))
								end
								if newFluid.icon then
									newFluid.icons = {{icon=newFluid.icon,icon_size=newFluid.icon_size or 32}}
									newFluid.icon=nil
								end
								table.insert(newFluid.icons,{icon="__omnilib__/graphics/lvl"..i..".png",icon_size=32})
								data:extend({newFluid})
							end
							new.output_fluid_box.filter = new.output_fluid_box.filter.."-concentrated-grade-"..i
						end
						if kind == "generator" and new.fluid_box and new.fluid_box.filter and  data.raw.fluid[new.fluid_box.filter.."-concentrated-grade-"..i] then
							--new.fluid_usage_per_tick = new.fluid_usage_per_tick*math.pow(multiplier,i)
							new.fluid_box.filter = new.fluid_box.filter.."-concentrated-grade-"..i
							--new.effectivity = new.effectivity*math.pow(multiplier,i)
						end
						if kind == "accumulator" then
							local eff = new_effect(new.energy_source.buffer_capacity,i)
							new.energy_source.buffer_capacity = string.sub(eff,1,string.len(eff)-1).."J"
							new.energy_source.input_flow_limit=new_effect(new.energy_source.input_flow_limit,i)
							new.energy_source.output_flow_limit=new_effect(new.energy_source.output_flow_limit,i)
						end
						if kind=="transport-belt" or kind=="loader" or kind== "splitter" or kind=="underground-belt" then
							if new.animation_speed_coefficient then new.animation_speed_coefficient=new.animation_speed_coefficient*(i+2) end
							new.speed = new.speed*(i+2)
						end
						if kind == "beacon" then
							if new.supply_area_distance*(i+1) <= 64 then
								new.supply_area_distance = new.supply_area_distance*(i+1)
							else
								new.supply_area_distance = 64
							end
							new.module_specification.module_slots=new.module_specification.module_slots*(i+1)
						end
						if kind == "electric-pole" then
							new.maximum_wire_distance = math.min(new.maximum_wire_distance*multiplier*i,64)
							new.supply_area_distance=math.min(new.supply_area_distance*(i+1),64)
						end

						compressed_buildings[#compressed_buildings+1]=new

						local item = table.deepcopy(find_placing_item(build))
						item.localised_name = new.localised_name
						item.name = new.name
						item.place_result = new.name
						item.stack_size=5
						if kind=="transport-belt" or kind=="loader" or kind== "splitter" or kind=="underground-belt" then
							item.stack_size=10
						else
							item.stack_size=5
						end
						item.icons=new_icon(item,i)
						item.icon=nil
						if settings.startup["omnicompression_one_list"].value then
							if not data.raw["item-subgroup"]["compressor-"..item.subgroup.."-"..math.floor((i-1)/2)+1] then
								local item_cat = {
									type = "item-subgroup",
									name = "compressor-"..item.subgroup.."-"..math.floor((i-1)/2)+1,
									group = "compressor-buildings",
									order = a
								}
								data:extend({item_cat})
							end
							item.subgroup = "compressor-"..item.subgroup.."-"..math.floor((i-1)/2)+1
						end

						compressed_buildings[#compressed_buildings+1]=item
						local rec_name = rc.name
						local ing = {}
						if i == 1 then ing={{build.name,multiplier}} else ing={{build.name.."-compressed-"..string.lower(compress_level[i-1]),multiplier}} end
						local recipe = {
							type = "recipe",
							name = rec_name.."-compressed-"..string.lower(compress_level[i]),
							ingredients = ing,
							icon_size = 32,
							result = new.name,
							energy_required = 5*math.floor(math.pow(multiplier,i/2)),
							enabled = false,
						}
						--log("compressed building recipe: "..recipe.name)
						recipe.localised_name = new.localised_name
						compressed_buildings[#compressed_buildings+1]=recipe

						local uncompress = {
							type = "recipe",
							name = "uncompress-"..string.lower(compress_level[i]).."-"..rec_name,
							localised_name = {"recipe-name.uncompress-item", loc_key},
							localised_description = {"recipe-description.uncompress-item", loc_key},
							icons = icons,
							icon_size = 32,
							subgroup=data.raw.item[build.minable.result].subgroup,
							category = "compression",
							enabled = true,
							hidden = true,
							ingredients = {
								{new.name, 1}
							},
							results = ing,
							inter_item_count = item_count,
							energy_required = 5*math.floor(math.pow(multiplier,i/2)),
						}
						compressed_buildings[#compressed_buildings+1]=uncompress
					end
				end
			end
		end
	end
end
log("end building compression")
data:extend(compressed_buildings)
