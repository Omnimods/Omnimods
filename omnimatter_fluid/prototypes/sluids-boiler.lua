omni.fluid.boiler_images =	{
	animation = make_4way_animation_from_spritesheet({
	layers = {
		{
			filename = "__omnimatter_fluid__/graphics/boiler/boiler-off.png",
			width = 160,
			height = 160,
			frame_count = 1,
			shift = util.by_pixel(-5, -4.5),
			},
		}
	}),
	working_visualisations =
	{
		{
		north_position = util.by_pixel(35, -23),-- 30,-24
		west_position = util.by_pixel(1, -49.5), -- 1, -49.5
		south_position = util.by_pixel(-35, -48), -- -30, -48
		east_position = util.by_pixel(-11, -1),-- -11, -1
		apply_recipe_tint = "primary",
		{
			apply_recipe_tint = "tertiary",
			north_position = {0, 0},
			west_position = {0, 0},
			south_position = {0, 0},
			east_position = {0, 0},
			north_animation =
			{
				filename = "__omnimatter_fluid__/graphics/boiler/boiler-north-off.png",
				frame_count = 1,
				width = 160,
				height = 160,
			},
			east_animation =
			{
				filename = "__omnimatter_fluid__/graphics/boiler/boiler-east-off.png",
				frame_count = 1,
				width = 160,
				height = 160,
			},
			west_animation =
			{
				filename = "__omnimatter_fluid__/graphics/boiler/boiler-west-off.png",
				frame_count = 1,
				width = 160,
				height = 160,
			},
			south_animation =
			{
				filename = "__omnimatter_fluid__/graphics/boiler/boiler-south-off.png",
				frame_count = 1,
				width = 160,
				height = 160,
			}
		}
	}
},
}
omni.fluid.exchanger_images =	{
	animation = make_4way_animation_from_spritesheet({
	layers = {
		{
			filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-off.png",
			width = 160,
			height = 160,
			frame_count = 1,
			shift = util.by_pixel(-5, -4.5),
			},
		}
	}),
	working_visualisations =
	{
		{
		--north_position = util.by_pixel(-16, -16),
		--west_position = util.by_pixel(1, -49.5),
		--south_position = util.by_pixel(-30, -48),
		--east_position = util.by_pixel(-11, -1),
		apply_recipe_tint = "primary",
		{
			apply_recipe_tint = "tertiary",
			north_position = {0, 0},
			west_position = {0, 0},
			south_position = {0, 0},
			east_position = {0, 0},
			north_animation =
			{
				filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-south-off.png",
				frame_count = 1,
				width = 160,
				height = 160,
			},
			east_animation =
			{
				filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-west-off.png",
				frame_count = 1,
				width = 160,
				height = 160,
			},
			west_animation =
			{
				filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-east-off.png",
				frame_count = 1,
				width = 160,
				height = 160,
			},
			south_animation =
			{
				filename = "__omnimatter_fluid__/graphics/exchanger/exchanger-north-off.png",
				frame_count = 1,
				width = 160,
				height = 160,
			}
		}
	}
},
}
omni.fluid.heat_pipe_images = {
	connections =
	{
		{
			position = {0, 1},
			direction = defines.direction.south
		}
	},
	pipe_covers =
		make_4way_animation_from_spritesheet(
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-endings.png",
			width = 32,
			height = 32,
			direction_count = 4,
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-endings.png",
				width = 64,
				height = 64,
				direction_count = 4,
				scale = 0.5
			}
		}),
	heat_pipe_covers =
		make_4way_animation_from_spritesheet(
		apply_heat_pipe_glow{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-endings-heated.png",
			width = 32,
			height = 32,
			direction_count = 4,
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-endings-heated.png",
				width = 64,
				height = 64,
				direction_count = 4,
				scale = 0.5
			}
		}),
	heat_picture =
	{
		north = apply_heat_pipe_glow
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-N-heated.png",
			priority = "extra-high",
			width = 24,
			height = 48,
			shift = util.by_pixel(-1, 16),
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-N-heated.png",
				priority = "extra-high",
				width = 44,
				height = 96,
				shift = util.by_pixel(-0.5, 16.5),
				scale = 0.5
			}
		},
		east = apply_heat_pipe_glow
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-E-heated.png",
			priority = "extra-high",
			width = 40,
			height = 40,
			shift = util.by_pixel(-36, -20),
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-E-heated.png",
				priority = "extra-high",
				width = 80,
				height = 80,
				shift = util.by_pixel(-36, -20),
				scale = 0.5
			}
		},
		south = apply_heat_pipe_glow
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-S-heated.png",
			priority = "extra-high",
			width = 16,
			height = 20,
			shift = util.by_pixel(-1, -55),
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-S-heated.png",
				priority = "extra-high",
				width = 28,
				height = 40,
				shift = util.by_pixel(-1, -55),
				scale = 0.5
			}
		},
		west = apply_heat_pipe_glow
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-W-heated.png",
			priority = "extra-high",
			width = 32,
			height = 40,
			shift = util.by_pixel(40, -21),
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-W-heated.png",
				priority = "extra-high",
				width = 64,
				height = 76,
				shift = util.by_pixel(40, -21),
				scale = 0.5
			}
		}
	},
	heat_glow =
	{
		north = apply_heat_pipe_glow
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-N-heated.png",
			priority = "extra-high",
			width = 24,
			height = 48,
			shift = util.by_pixel(-1, 8*2),
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-N-heated.png",
				priority = "extra-high",
				width = 44,
				height = 96,
				shift = util.by_pixel(-0.5, 8.5*2),
				scale = 0.5
			}
		},
		east = apply_heat_pipe_glow
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-E-heated.png",
			priority = "extra-high",
			width = 40,
			height = 40,
			shift = util.by_pixel(-21, -13*2),
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-E-heated.png",
				priority = "extra-high",
				width = 80,
				height = 80,
				shift = util.by_pixel(-21, -13*2),
				scale = 0.5
			}
		},
		south = apply_heat_pipe_glow
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-S-heated.png",
			priority = "extra-high",
			width = 16,
			height = 20,
			shift = util.by_pixel(-1, -30*2),
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-S-heated.png",
				priority = "extra-high",
				width = 28,
				height = 40,
				shift = util.by_pixel(-1, -30*2),
				scale = 0.5
			}
		},
		west = apply_heat_pipe_glow
		{
			filename = "__base__/graphics/entity/heat-exchanger/heatex-W-heated.png",
			priority = "extra-high",
			width = 32,
			height = 40,
			shift = util.by_pixel(23, -13*2),
			hr_version =
			{
				filename = "__base__/graphics/entity/heat-exchanger/hr-heatex-W-heated.png",
				priority = "extra-high",
				width = 64,
				height = 76,
				shift = util.by_pixel(23, -13*2),
				scale = 0.5
			}
		}
	}
}


--[[
local new_boiler = {}
local fix_boilers_recipe = {}
local fix_boilers_item = {}

for _,boiler in pairs(data.raw.boiler) do
	--clobber fluid box filter on existing
	if generator_fluid[boiler.output_fluid_box.filter] then
		generator_fluid[boiler.output_fluid_box.filter] = nil
	end
	--check if valid before progressing
	if not forbidden_boilers[boiler.name] and data.raw.fluid[boiler.fluid_box.filter] and data.raw.fluid[boiler.fluid_box.filter].heat_capacity and boiler.minable then
		local rec = omni.lib.find_recipe(boiler.minable.result)
		--add in recipe category for new boiler
		new_boiler[#new_boiler+1] = {
			type = "recipe-category",
			name = "boiler-omnifluid-"..boiler.name,
		}
		--enforce standardization
		if standardized_recipes[boiler.name] == nil then
			omni.marathon.standardise(data.raw.recipe[boiler.name])
		end
		--append fix lists
		fix_boilers_recipe[#fix_boilers_recipe+1] = rec.name
		fix_boilers_item[boiler.minable.result] = true

		data.raw.recipe[rec.name].normal.results[1].name = boiler.name.."-converter"
		data.raw.recipe[rec.name].normal.main_product = boiler.name.."-converter"
		data.raw.recipe[rec.name].expensive.results[1].name = boiler.name.."-converter"
		data.raw.recipe[rec.name].expensive.main_product = boiler.name.."-converter"
		data.raw.recipe[rec.name].main_product = boiler.name.."-converter"

		local water = boiler.fluid_box.filter or "water"
		local water_cap = omni.fluid.convert_mj(data.raw.fluid[water].heat_capacity)
		local water_delta_tmp = data.raw.fluid[water].max_temperature-data.raw.fluid[water].default_temperature
		local steam = boiler.output_fluid_box.filter or "steam"
		local steam_cap = omni.fluid.convert_mj(data.raw.fluid[steam].heat_capacity)
		local steam_delta_tmp = boiler.target_temperature-data.raw.fluid[water].max_temperature
		local prod_steam = omni.fluid.round_fluid(omni.lib.round(omni.fluid.convert_mj(boiler.energy_consumption)/(water_delta_tmp*water_cap+steam_delta_tmp*steam_cap)),1)
		local lcm = omni.lib.lcm(prod_steam,sluid_contain_fluid)
		local prod = lcm/sluid_contain_fluid
		local tid = lcm/prod_steam

		--omni.lib.replace_all_ingredient(boiler.name,boiler.name.."-converter")

		new_boiler[#new_boiler+1] = {
			type = "recipe",
			name = boiler.name.."-boiling-steam-".. boiler.target_temperature,
			icons = {{icon = "__base__/graphics/icons/fluid/steam.png", icon_size = 64}},
			subgroup = "fluid-recipes",
			category = "boiler-omnifluid-".. boiler.name,
			order = "g[hydromnic-acid]",
			energy_required = tid,
			enabled = true,
			--icon_size = 32,
			main_product = steam,
			ingredients =
			{
				{type = "item", name = "solid-".. water, amount = prod},
			},
			results =
			{
				{type = "fluid", name = steam, amount = sluid_contain_fluid*prod, temperature = math.min(boiler.target_temperature,data.raw.fluid[steam].max_temperature)},
			},
	  }
		new_boiler[#new_boiler+1] = {
			type = "recipe",
			name = boiler.name.."-boiling-solid-steam-"..boiler.target_temperature,
			icons = {{icon = "__base__/graphics/icons/fluid/steam.png", icon_size = 64}},
			subgroup = "fluid-recipes",
			category = "boiler-omnifluid-"..boiler.name,
			order = "g[hydromnic-acid]",
			energy_required = tid,
			enabled = true,
			--icon_size = 32,
			main_product = steam,
			ingredients =
			{
				{type = "item", name = "solid-"..water, amount = prod},
			},
			results =
			{
				{type = "item", name = "solid-"..steam, amount = prod},
			},
	  }
		if mods["omnimatter_marathon"] then omni.marathon.exclude_recipe(boiler.name.."-boiling-solid-steam-"..boiler.target_temperature) end
		if mods["omnimatter_marathon"] then omni.marathon.exclude_recipe(boiler.name.."-boiling-steam-"..boiler.target_temperature) end

		local loc_key = {"entity-name."..boiler.name}
		local new_item = table.deepcopy(data.raw.item[boiler.name])
		new_item.name = boiler.name.."-converter"
		new_item.place_result = boiler.name.."-converter"
		new_item.localised_name = {"item-name.boiler-converter", loc_key}
		new_boiler[#new_boiler+1] = new_item

		boiler.minable.result = boiler.name.."-converter"

		loc_key = {"entity-name."..boiler.name}
		forbidden_assembler[boiler.name.."-converter"] = true
		local new = {
			type = "assembling-machine",
			name = boiler.name.."-converter",
			localised_name = {"entity-name.boiler-converter", loc_key},
			icon = boiler.icon,
			icons = boiler.icons,
			icon_size = boiler.icon_size or 32,
			flags = {"placeable-neutral","placeable-player", "player-creation"},
			minable = {hardness = 0.2, mining_time = 0.5, result = boiler.name.."-converter"},
			max_health = 300,
			corpse = "big-remnants",
			dying_explosion = "medium-explosion",
			collision_box = {{-1.29, -1.29}, {1.29, 1.29}},
			selection_box = {{-1.5, -1.5}, {1.5, 1.5}},

			animation = make_4way_animation_from_spritesheet({
				layers = {
					{
						filename = "__omnimatter_fluid__/graphics/boiler-off.png",
						width = 160,
						height = 160,
						frame_count = 1,
						shift = util.by_pixel(-5, -4.5),
						},
					}
				}),
				working_visualisations =
				{
					{
					north_position = util.by_pixel(30, -24),
					west_position = util.by_pixel(1, -49.5),
					south_position = util.by_pixel(-30, -48),
					east_position = util.by_pixel(-11, -1),
					apply_recipe_tint = "primary",
					{
						apply_recipe_tint = "tertiary",
						north_position = {0, 0},
						west_position = {0, 0},
						south_position = {0, 0},
						east_position = {0, 0},
						north_animation =
						{
							filename = "__omnimatter_fluid__/graphics/boiler-north-off.png",
							frame_count = 1,
							width = 160,
							height = 160,
						},
						east_animation =
						{
							filename = "__omnimatter_fluid__/graphics/boiler-east-off.png",
							frame_count = 1,
							width = 160,
							height = 160,
						},
						west_animation =
						{
							filename = "__omnimatter_fluid__/graphics/boiler-west-off.png",
							frame_count = 1,
							width = 160,
							height = 160,
						},
						south_animation =
						{
							filename = "__omnimatter_fluid__/graphics/boiler-south-off.png",
							frame_count = 1,
							width = 160,
							height = 160,
						}
					}
				}
			},
			vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
			working_sound =
			{
				sound =
				{
				{
					filename = "__base__/sound/chemical-plant.ogg",
					volume = 0.8
				}
				},
				idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
				apparent_volume = 1.5,
			},
			crafting_speed = 1,
			energy_source = boiler.energy_source,
			energy_usage = boiler.energy_consumption,
			ingredient_count = 4,
			crafting_categories = {"boiler-omnifluid-"..boiler.name,"general-omni-boiler"},
			fluid_boxes =
			{
				{
				production_type = "output",
				pipe_covers = pipecoverspictures(),
				base_level = 1,
				pipe_connections = {{type = "output", position = {0, -2}}}
				}
			}
	  }

		new_boiler[#new_boiler+1]=new
	end
end

	new_boiler[#new_boiler+1]={
		type = "recipe-category",
		name = "general-omni-boiler",
	}
if #new_boiler > 0 then
	data:extend(new_boiler)
end]]