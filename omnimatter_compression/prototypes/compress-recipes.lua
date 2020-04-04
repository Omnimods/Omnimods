
local compress_recipes, uncompress_recipes, compress_items = {}, {}, {}
local item_count = 0

local concentrationRatio = sluid_contain_fluid



compressed_item_names = {}
random_recipes = {}

local max_module_speed = 0
local max_module_prod = 0
for _,modul in pairs(data.raw.module) do
	if modul.effect.speed and modul.effect.speed.bonus > max_module_speed then max_module_speed=modul.effect.speed.bonus end
	if modul.effect.productivity and modul.effect.productivity.bonus > max_module_prod then max_module_prod=modul.effect.productivity.bonus end
end
local max_cat = {}

local building_list = {"assembling-machine","furnace"}

for _,cat in pairs(data.raw["recipe-category"]) do
	max_cat[cat.name] = {speed = 0,modules = 0}
	for _,bcat in pairs(building_list) do
		for _,build in pairs(data.raw[bcat]) do
			if omni.lib.is_in_table(cat.name,build.crafting_categories) then
				if build.crafting_speed and build.crafting_speed > max_cat[cat.name].speed then max_cat[cat.name].speed = build.crafting_speed end
				if build.module_specification and build.module_specification.module_slots and build.module_specification.module_slots > max_cat[cat.name].modules then max_cat[cat.name].modules=build.module_specification.module_slots end
				--new.module_specification.module_slots
			end
		end
	end
end

-------------------------------------------------------------------------------
--[[Create Dynamic Recipes from Items]]--
-------------------------------------------------------------------------------
--Config variables
local compressed_item_stack_size = 120 -- stack size for compressed items (not the items returned that is dynamic)
local max_stack_size_to_compress = 2000 -- Don't compress items over this stack size
local speed_div = 8 --Recipe speed is stack_size/speed_div

local hcn = {1, 2, 4, 6, 12, 24, 36, 48, 60, 120, 180, 240, 360, 720, 840, 1260, 1680, 2520}
function roundHcn(nr)
	if math.floor(nr)==nr then
		for i=1,#hcn-1 do
			if hcn[i+1]>nr and hcn[i]<=nr then
				if hcn[i+1]-nr<= nr-hcn[i] then
					return hcn[i+1]
				else
					return hcn[i]
				end
			end
		end
	else
		return nr
	end
end
function roundUpHcn(nr)
	if math.floor(nr)==nr then
		for i=1,#hcn-1 do
			if hcn[i+1]>=nr and hcn[i]<nr then
				return hcn[i+1]
			end
		end
	else
		return nr
	end
end

local get_icons = function(item)
	--Build the icons table
	local icons_1 = {icon = "__omnimatter_compression__/graphics/compress-32.png", icon_size = 32}
	local icons={}
	if item.icons then
		icons=table.deepcopy(item.icons)
		table.insert(icons,icons_1)
		if item.icon_size and not item.icons[1].icon_size then
			icons[1].icon_size=item.icon_size
		end
		for pos,icon in pairs(icons) do
			if not icon.icon_size then
				--back-up setting icon size to 32 if not found
				icon.icon_size=32
			end
		end

	else
		icons[1] = icons_1
		icons[2] = {icon = item.icon, icon_size = item.icon_size or 32}
	end
	return icons
end

local find_icon = function(item)
	for _, p in pairs({"item","mining-tool","gun","ammo","armor","repair-tool","capsule","module","tool","rail-planner","item-with-entity-data","fluid"}) do
		if data.raw[p][item] then
			if data.raw[p][item].icons then
				return data.raw[p][item].icons
			else
				return {{icon=data.raw[p][item].icon,icon_size=data.raw[p][item].icon_size}}
			end
		end
	end
end


local get_icons_rec = function(rec)
	--Build the icons table
	local icons = {}
	local icons_1 = {icon = "__omnimatter_compression__/graphics/compress-32.png",icon_size=32}
	if rec.icons then
		icons=table.deepcopy(rec.icons)
		table.insert(icons,icons_1)
		if rec.icon_size and not rec.icons[1].icon_size then
			icons[1].icon_size=rec.icon_size
		end
	else
		if rec.icon then
			icons[1] = icons_1
			icons[2] = {icon=rec.icon,icon_size=rec.icon_size}
		else
			local process = {}
			if rec.result or (rec.normal and rec.normal.result) then
				if rec.result then
					process = find_icon(rec.result)
				else
					process = find_icon(rec.normal.result)
				end
			else
				if rec.results then
					process = find_icon(rec.results[1].name)
				else
					process = find_icon(rec.normal.results[1].name)
				end
			end
			icons[1]=icons_1
			for _,p in pairs(process) do
				icons[#icons+1]=p
			end
		end
	end
	return icons
end

local uncompress_icons = function(icons)
	local u_icons={}
	local u_icons_1 = {icon = "__omnimatter_compression__/graphics/compress-out-arrow-32.png", icon_size = 32}
	table.insert(u_icons,u_icons_1)
	return u_icons
end

local new_fuel_value = function(effect,stack)
	if not effect then return nil end
	local eff = string.sub(effect,1,string.len(effect)-2)
	local value = string.sub(effect,string.len(effect)-1,string.len(effect)-1)
	if string.len(effect)==2 then
		eff = string.sub(effect,1,1)
		value = ""
	end
	eff=tonumber(eff)*stack
	if eff > 1000 then
		eff=eff/1000
		if value == "k" then value = "M" elseif value == "M" then value = "G" end
	end
	return eff..value.."J"
end

local is_science = function(item)
	for _, lab in pairs(data.raw.lab) do
		for _, input in pairs(lab.inputs) do
			if item.name == input then return true end
		end
	end
	return false
end

--Create concentrated
for _, group in pairs({"fluid"}) do
	--Loop through all of the items in the category
	for _, item in pairs(data.raw[group]) do
		--Check for hidden flag to skip later
		local hidden = false
		for _, flag in ipairs(item.flags or {}) do
			if flag == "hidden" then hidden = true end
		end
		if not (hidden or item.name:find("creative-mode")) then
			local icon = {icon = item.icon, icon_size = item.icon_size or 32}
			if not icon.icon then
				icon = item.icons[1]
			end
			local oldsize = icon.icon_size or item.icon_size or 32
			local oldscale = icon.scale or oldsize/32
			local iconsize = oldsize * oldscale

			if math.log(iconsize)/math.log(2) > 4 then

				--Variables to use on each iteration
				local sub_group = "fluids"
				local order = "concentrated-"..item.name
				local icons = get_icons(item)

				--Try the best option to get a valid localised name
				local loc_key = {"fluid-name."..item.name}
				if item.localised_name then
					loc_key = item.localised_name
				end

				local new_item = {
					type = "fluid",
					name = "concentrated-"..item.name,
					localised_name = {"fluid-name.concentrated-fluid", table.deepcopy(loc_key)},
					localised_description = {"fluid-description.concentrated-fluid", table.deepcopy(loc_key)},
					icons = icons,
					icon_size = item.icon_size or 32,
					order = order,
					default_temperature = item.default_temperature,
					max_temperature = item.max_temperature,
					pressure_to_speed_ratio = item.pressure_to_speed_ratio,
					flow_to_energy_ratio = item.flow_to_energy_ratio,
					heat_capacity = new_fuel_value(item.heat_capacity,concentrationRatio),
					base_color = item.base_color,
					flow_color = item.flow_color,
					fuel_value = new_fuel_value(item.fuel_value,concentrationRatio),
					fuel_category = item.fuel_category,
				}

				--The compress recipe
				local compress = {
					type = "recipe",
					name = "compress-"..item.name,
					localised_name = {"recipe-name.concentrate-fluid", loc_key},
					localised_description = {"recipe-description.concentrate-fluid", loc_key},
					category = "fluid-concentration",
					enabled = true,
					hidden = true,
					ingredients = {
						{name=item.name,type="fluid", amount=sluid_contain_fluid*concentrationRatio}
					},
					subgroup = "concentrator-"..sub_group,
					icons=icons,
					icon_size=item.icon_size or 32,
					order = order,
					results={
						{name="concentrated-"..item.name,type="fluid", amount=sluid_contain_fluid}
					},
					energy_required = sluid_contain_fluid / speed_div,
				}

				icons = uncompress_icons(icons)
				--The uncompress recipe
				local uncompress = {
					type = "recipe",
					name = "uncompress-"..item.name,
					localised_name = {"recipe-name.deconcentrate-fluid", loc_key},
					localised_description = {"recipe-description.deconcentrate-fluid", loc_key},
					icons = icons,
					icon_size=item.icon_size or 32,
					category = "fluid-concentration",
					enabled = true,
					hidden = true,
					ingredients = {
						{name="concentrated-"..item.name,type="fluid", amount=sluid_contain_fluid}
					},
					subgroup = "compressor-out-"..sub_group,
					order = order,
					results={
						{name=item.name,type="fluid", amount=sluid_contain_fluid*concentrationRatio}
					},
					energy_required = concentrationRatio / speed_div,
				}

				-- if item.name == "crude-oil" then log(serpent.block(uncompress)) end

				--The compressed item

				--Insert the recipes and item into tables that we will extend into the game later.
				compressed_item_names[#compressed_item_names+1]="compressed-"..item.name
				compress_recipes[#compress_recipes+1] = compress
				uncompress_recipes[#uncompress_recipes+1] = uncompress
				compress_items[#compress_items+1] = new_item
				--add_compression_tech(item.name)
				--Get the technology we want to use and add our recipes as unlocks
			end
		end
	end
end
--Loop through all of these item categories

for _, group in pairs({"item", "ammo", "module", "rail-planner", "repair-tool", "capsule", "mining-tool", "tool","gun","armor"}) do
	--Loop through all of the items in the category
	for _, item in pairs(data.raw[group]) do
		--Check for hidden flag to skip later
		local hidden = false
		for _, flag in ipairs(item.flags or {}) do
			if flag == "hidden" then hidden = true end
		end
		--log("compressing item: "..item.name..":"..item.stack_size)
		--Don't compress items that only stack to 1
		--Skip items with a super high stack size, Why compress something already this compressed!!!! (also avoids errors)
		--Skip hidden items and creative mode mod items
		if item.stack_size > 1 and item.stack_size <= max_stack_size_to_compress and not (hidden or item.name:find("creative-mode")) and (item.icon_size or 0)%32 == 0 and math.log(item.icon_size or 32)/math.log(2) > 4 then
			--Not really needed but we will save into the item in case we want to use it before we extend the items/recipes
			item_count = item_count + 1
			if settings.startup["omnicompression_compensate_stacksizes"].value then
				if not item.place_result or omni.lib.find_entity_prototype(item.place_result) == nil then
					item.stack_size=omni.lib.round_up(item.stack_size/60)*60
				else
					item.stack_size=omni.lib.round_up(item.stack_size/6)*6
				end
			end

			--Variables to use on each iteration
			local sub_group = "items"
			local order = "compressed-"..item.name
			local icons = get_icons(item)

			--Try the best option to get a valid localised name
			local loc_key = {"item-name."..item.name}
			if item.localised_name then
				loc_key = table.deepcopy(item.localised_name)
			elseif item.place_result then
				loc_key = {"entity-name."..item.place_result}
			elseif item.placed_as_equipment_result then
				loc_key = {"equipment-name."..item.placed_as_equipment_result}
			end
			--Get the techname to assign this too
			local it_type = "item"
			if is_science(item) then it_type = "tool" end
			local new_item = {
				type = it_type,
				name = "compressed-"..item.name,
				localised_name = {"item-name.compressed-item", loc_key},
				localised_description = {"item-description.compressed-item", loc_key},
				flags = item.flags,
				icons = icons,
				icon_size = item.icon_size or 32,
				subgroup = item.subgroup,
				order = order,
				stack_size = compressed_item_stack_size,
				inter_item_count = item_count,
				fuel_value = new_fuel_value(item.fuel_value,item.stack_size),
				fuel_category = item.fuel_category,
				fuel_acceleration_multiplier = item.fuel_acceleration_multiplier,
				fuel_top_speed_multiplier = item.fuel_top_speed_multiplier,
				durability=item.durability
			}

			--The compress recipe
			local compress = {
				type = "recipe",
				name = "compress-"..item.name,
				localised_name = {"recipe-name.compress-item", loc_key},
				localised_description = {"recipe-description.compress-item", loc_key},
				category = "compression",
				enabled = true,
				hidden=true,
				ingredients = {
					{item.name, item.stack_size}
				},
				subgroup = "compressor-"..sub_group,
				icons=icons,
				icon_size = item.icon_size or 32,
				order = order,
				inter_item_count = item_count,
				result = "compressed-"..item.name,
				energy_required = item.stack_size / speed_div,
			}

			icons = uncompress_icons(icons)
			--The uncompress recipe
			local uncompress = {
				type = "recipe",
				name = "uncompress-"..item.name,
				localised_name = {"recipe-name.uncompress-item", loc_key},
				localised_description = {"recipe-description.uncompress-item", loc_key},
				icons = icons,
				icon_size = item.icon_size or 32,
				category = "compression",
				enabled = true,
				hidden = true,
				ingredients = {
					{"compressed-"..item.name, 1}
				},
				subgroup = "compressor-out-"..sub_group,
				order = order,
				result = item.name,
				result_count = item.stack_size,
				inter_item_count = item_count,
				energy_required = item.stack_size / speed_div,
			}
			omni.marathon.standardise(compress)
			omni.marathon.standardise(uncompress)
			--The compressed item

			--Insert the recipes and item into tables that we will extend into the game later.
			compressed_item_names[#compressed_item_names+1]="compressed-"..item.name
			compress_recipes[#compress_recipes+1] = compress
			uncompress_recipes[#uncompress_recipes+1] = uncompress
			compress_items[#compress_items+1] = new_item
			--add_compression_tech(item.name)
			--Get the technology we want to use and add our recipes as unlocks
		end
	end
end
data:extend(compress_items)

local compressed_recipes = {}

local not_only_fluids = function(recipe)
	local all_ing = {}
	local all_res = {}
	if recipe.normal and recipe.normal.ingredients then
		all_ing=recipe.normal.ingredients
	else
		all_ing=recipe.ingredients
	end
	if recipe.normal and recipe.normal.results then
		all_res=recipe.normal.results
	elseif recipe.results then
		all_res=recipe.results
	elseif recipe.normal and recipe.normal.result then
		all_res=recipe.normal.result
	elseif recipe.result then
		all_res=recipe.result
	end
	if type(all_ing)=="table" then
		for _,ing in pairs(all_ing) do
			if ing[1] or (ing.type ~= "fluid") then return true end
		end
	elseif type(all_ing)=="string" then
		return true
	end
	if type(all_res)=="table" then
		for _,ing in pairs(all_res) do
			if ing[1] or (ing.type ~= "fluid") then return true end
		end
	else
		if type(all_res) == "string" or all_res[1] or all_res.type~="fluid" then
			return true
		end
	end
	return false
end

local compress_based_recipe = {}

local not_random = function(recipe)
	local results = {}
	if recipe.normal and recipe.normal.results then
		results = omni.lib.union(recipe.normal.results,recipe.expensive.results or {})
	elseif recipe.results then
		results = recipe.results
	elseif recipe.result then
		return true
	end
	for _,r in pairs(results) do
		if r.amount_min or (r.probability and r.probability > 0) or r.amount_max then
			return false
		end
	end
	return true
end

local seperate_fluid_solid = function(collection)
	local fluid = {}
	local solid = {}
	if type(collection) == "table" then
		for _,thing in pairs(collection) do
			if thing.type and thing.type == "fluid" then
				fluid[#fluid+1]=thing
			else
				if type(thing)=="table" then
					if thing.type then
						solid[#solid+1] = thing
					elseif thing[1] then
						solid[#solid+1] = {type="item",name=thing[1],amount=thing[2]}
					elseif thing.name then
						solid[#solid+1] = {type="item",name=thing.name,amount=thing.amount}
					end
				else
					solid[#solid+1] = {type="item",name=thing[1],amount=1}
				end
			end
		end
	else
		solid[#solid+1] = {type="item",name=collection,amount=1}
	end
	return {fluid = fluid,solid = solid}
end

function get_recipe_values(ingredients,results)
	local parts={}
	local lng = {0,0}

	local all_ing = seperate_fluid_solid(ingredients)
	local all_res = seperate_fluid_solid(results)

	for _,comp in pairs({all_ing.solid,all_res.solid}) do
		for _,  resing in pairs(comp) do
			parts[#parts+1]={name=resing.name,amount=resing.amount}
		end
	end

	local lcm_rec = 1
	local gcd_rec = 0
	local mult_rec = 1
	local lcm_stack = 1
	local gcd_stack = 0
	local mult_stack = 1
	--calculate lcm of the parts and stacks
	for _, p in pairs(parts) do
		if gcd_rec==0 then
			gcd_rec=p.amount
		else
			gcd_rec = omni.lib.gcd(gcd_rec,p.amount)
		end
		lcm_rec=omni.lib.lcm(lcm_rec,p.amount)
		mult_rec = mult_rec*p.amount
		local stacksize = omni.lib.find_stacksize(p.name)
		if gcd_stack == 0 then
			gcd_stack=stacksize
		else
			gcd_stack = omni.lib.gcd(gcd_stack,stacksize)
		end
		lcm_stack=omni.lib.lcm(lcm_stack,stacksize)
		mult_stack = mult_stack*stacksize
	end
	--lcm_rec = mult_rec/gcd_rec
	--lcm_stack = mult_stack/gcd_stack
	local new_parts = {}
	local new_stacks = {}
	for i, p in pairs(parts) do
		new_parts[i]={name = p.name, amount = lcm_rec/p.amount}
		local stacksize = omni.lib.find_stacksize(p.name)
		new_stacks[i]={name = p.name, amount = lcm_stack/stacksize}
	end
	local new = {}
	local new_gcd = 0
	local new_lcm = lcm_rec*lcm_stack--rec_max*stack_max/omni.lib.gcd(rec_max,stack_max)
	for i,p in pairs(new_parts) do
		new[i]=new_lcm*new_stacks[i].amount/new_parts[i].amount
		new[i]=math.floor(new[i]+0.5) --round 
		if new_gcd == 0 then
			new_gcd = new[i]
		else
			new_gcd=omni.lib.gcd(new_gcd,new[i])
		end
	end
	for i,p in pairs(new_parts) do
		new[i]=new[i]/new_gcd
	end
	local total_mult = new[1]*omni.lib.find_stacksize(parts[1].name)/parts[1].amount
	local newing = {}
	for i=1,#all_ing.solid do
		newing[#newing+1]={type="item",name="compressed-"..parts[i].name,amount=new[i]}
	end
	for _,f in pairs(all_ing.fluid) do
		newing[#newing+1]={type="fluid",name="concentrated-"..f.name,amount=f.amount*total_mult/concentrationRatio, minimum_temperature = f.minimum_temperature, maximum_temperature = f.maximum_temperature}
	end
	local newres = {}
	for i=1,#all_res.solid do
		newres[#newres+1]={type="item",name="compressed-"..parts[#all_ing.solid+i].name,amount=new[#all_ing.solid+i]}
	end
	for _,f in pairs(all_res.fluid) do
		newres[#newres+1]={type="fluid",name="concentrated-"..f.name,amount=f.amount*total_mult/concentrationRatio, temperature = f.temperature}
	end
	return {ingredients = newing , results = newres}
end

local more_than_one = function(recipe)
	if recipe.result or (recipe.normal and recipe.normal.result) then
		if recipe.result then
			if type(recipe.result)=="table" then
				if recipe.result[1] then
					return omni.lib.find_stacksize(recipe.result[1]) > 1
				else
					return omni.lib.find_stacksize(recipe.result.name) > 1
				end
			else
				return omni.lib.find_stacksize(recipe.result) > 1
			end
		else
			if type(recipe.normal.result)=="table" then
				if recipe.normal.result[1] then
					return omni.lib.find_stacksize(recipe.normal.result[1]) > 1
				else
					return omni.lib.find_stacksize(recipe.normal.result.name) > 1
				end
			else
				return omni.lib.find_stacksize(recipe.normal.result) > 1
			end
		end
	else
		if (recipe.results and #recipe.results > 1) or (recipe.normal and recipe.normal.results and #recipe.normal.results>1) then
			return true
		else
			if recipe.results then
				if type(recipe.results[1])=="table" then
					if recipe.results[1][1] then
						return omni.lib.find_stacksize(recipe.results[1][1]) > 1
					else
						return omni.lib.find_stacksize(recipe.results[1].name) > 1
					end
				else
					return omni.lib.find_stacksize(recipe.results[1]) > 1
				end
			else
				if type(recipe.normal.results[1])=="table" then
					if recipe.normal.results[1][1] then
						return omni.lib.find_stacksize(recipe.normal.results[1][1]) > 1
					elseif omni.lib.find_stacksize(recipe.normal.results[1].name) then
						return omni.lib.find_stacksize(recipe.normal.results[1].name) > 1
					else
						return false
					end
				else
					if omni.lib.find_stacksize(recipe.normal.results[1].name) then
						return omni.lib.find_stacksize(recipe.normal.results[1].name) > 1
					else
						--log("Something is not right, item  "..recipe.normal.results[1].name.." has no stacksize.")
						return false
					end
				end
			end
		end
	end
end

local compressed_ingredients_exist = function(ingredients,results)
	if #ingredients > 0 then
		for _, ing in pairs(ingredients) do
			if not omni.lib.is_in_table("compressed-"..ing.name,compressed_item_names) then return false end
		end
	end
	if type(results)=="table" then
		if #results > 0 then
			for _, res in pairs(results) do
				if not omni.lib.is_in_table("compressed-"..res.name,compressed_item_names) then return false end
			end
		end
	else
		if not omni.lib.is_in_table("compressed-"..results,compressed_item_names) then return false end
	end
	return true
end
local supremumTime = settings.startup["omnicompression_too_long_time"].value

function adjustOutput(recipe)
	for _, dif in pairs({"normal","expensive"}) do
		local gcd = 0
		local tooMuchIng = nil
		for _, ing in pairs(recipe[dif].ingredients) do
			if ing.type ~= "fluid" then
				if gcd == 0 then
					gcd = ing.amount
				else
					gcd = omni.lib.gcd(gcd,ing.amount)
				end
				if ing.amount > 65535 then
					if not tooMuchIng then
						tooMuchIng = ing.amount
					else
						tooMuchIng = math.max(ing.amount,tooMuchIng)
					end
				end
			end
		end
		if gcd > 0 then
			local divisors = omni.lib.divisors(gcd)
			local div = nil
			if recipe[dif].energy_required > supremumTime or tooMuchIng then
				for i=1,#divisors do
					if recipe[dif].energy_required/divisors[i]<supremumTime and (tooMuchIng == nil or tooMuchIng/divisors[i] < 65535) then
						if div and div > divisors[i] then
							div=divisors[i]
						elseif not div then
							div=divisors[i]
						end
					end
				end
			end
			for _,res in pairs(recipe[dif].results) do
				if div then
					res.amount = res.amount/div
				end
				if res.type == "item" then
					if res.amount_max then res.amount = (res.amount_max+res.amount_min)/2 end
					if res.probability then res.amount = res.amount*res.probability end
					while res.amount > compressed_item_stack_size do
						local add = table.deepcopy(res)
						add.amount = compressed_item_stack_size
						res.amount = res.amount - compressed_item_stack_size
						table.insert(recipe[dif].results,add)
					end
					if res.amount and math.floor(res.amount) ~= res.amount and res.amount > 1 then
						local add = table.deepcopy(res)
						add.probability = res.amount-math.floor(res.amount)
						res.amount = math.floor(res.amount)
						add.amount = 1
						table.insert(recipe[dif].results,add)
					end
				end
			end
			if div then
				for _, ing in pairs(recipe[dif].ingredients) do
					ing.amount = ing.amount/div
				end
				recipe[dif].energy_required=recipe[dif].energy_required/div
			end
		end
	end
	return recipe
end

local generatorFluidRecipes = {}

for _, gen in pairs(data.raw.generator) do
	if not string.find(gen.name,"creative") then
		if not gen.burns_fluid and gen.fluid_box and gen.fluid_box.filter then
			if not generatorFluidRecipes[gen.fluid_box.filter] then
				generatorFluidRecipes[gen.fluid_box.filter]={name=gen.fluid_box.filter,temperature={},recipes = {}}
				generatorFluidRecipes[gen.fluid_box.filter].temperature[1]={min = gen.fluid_box.minimum_temperature, max=gen.maximum_temperature}
			else
				table.insert(generatorFluidRecipes[gen.fluid_box.filter].temperature,{min = gen.fluid_box.minimum_temperature, max=gen.maximum_temperature})
			end
		end
	end
end

function create_compression_recipe(recipe)
	if (recipe.icon_size or 0)%32 == 0 and math.log(recipe.icon_size or 32)/math.log(2) > 4 and recipe.normal.results and #recipe.normal.results > 0 and not_only_fluids(recipe) and not_random(recipe) and not omni.lib.is_in_table(recipe.name,excluded_recipes) and (more_than_one(recipe) or omni.lib.is_in_table(recipe.name,include_recipes)) and not string.find(recipe.name,"creative") then
		local parts = {}
		--log("creating compressed recipe for "..recipe.name)
		--get list of ingredients and results
		local res = {}
		local ing = {}
		local subgr = {regular = {}}
		ing={normal=table.deepcopy(recipe.normal.ingredients),expensive=table.deepcopy(recipe.expensive.ingredients)}
		res={normal=table.deepcopy(recipe.normal.results),expensive=table.deepcopy(recipe.expensive.results)}
		local gcd = {normal = 0, expensive = 0}
		local generatorfluid = nil
		for _,dif in pairs({"normal","expensive"}) do
			for _,ingres in pairs({"ingredients","results"}) do
				if #recipe[dif][ingres] > 0 then
					for _,component in pairs(recipe[dif][ingres]) do
						if component.type ~= "fluid" then
							if gcd[dif]==0 then
								gcd[dif]=component.amount
							else
								gcd[dif]=omni.lib.gcd(gcd[dif],component.amount or math.floor((component.amount_min+component.amount_max)/2))
							end
						end
						if ingres=="results" and component.type == "fluid" and generatorFluidRecipes[component.name] then
							generatorfluid=component.name
						end
					end
				end
			end
		end
		for _,dif in pairs({"normal","expensive"}) do
			for _,ingres in pairs({ing,res}) do
				for _,component in pairs(ingres[dif]) do
					component.amount=math.min(component.amount/gcd[dif],65535) --set max cap
				end
			end
		end
		if recipe.subgroup or recipe.normal.subgroup then
			if recipe.subgroup then
				recipe.normal.subgroup =recipe.subgroup
				recipe.expensive.subgroup =recipe.subgroup
			else
				subgr.normal = recipe.normal.subgroup
				subgr.expensive = recipe.expensive.subgroup
			end
		else
			subgr.normal = subgr.regular
			subgr.expensive = subgr.regular
		end

		local check = {{seperate_fluid_solid(ing.normal),seperate_fluid_solid(res.normal)},{seperate_fluid_solid(ing.expensive),seperate_fluid_solid(res.expensive)}}
		if compressed_ingredients_exist(check[1][1].solid,check[1][2].solid) and compressed_ingredients_exist(check[2][1].solid,check[2][2].solid) then
			local new_val_norm = get_recipe_values(ing.normal,res.normal)
			local new_val_exp = get_recipe_values(ing.expensive,res.expensive)
			local mult = {}
			if check[1][1].solid[1] then
				mult = {normal=new_val_norm.ingredients[1].amount/check[1][1].solid[1].amount*omni.lib.find_stacksize(check[1][1].solid[1].name),
				expensive=new_val_exp.ingredients[1].amount/check[2][1].solid[1].amount*omni.lib.find_stacksize(check[2][1].solid[1].name)}
			else
				mult = {normal=new_val_norm.results[1].amount/check[1][2].solid[1].amount*omni.lib.find_stacksize(check[1][2].solid[1].name),
				expensive = new_val_exp.results[1].amount/check[2][2].solid[1].amount*omni.lib.find_stacksize(check[2][2].solid[1].name)}
			end
			local tid = {}
			if recipe.normal and recipe.normal.energy_required then
				tid = {normal = recipe.normal.energy_required*mult.normal,expensive = recipe.expensive.energy_required*mult.expensive}
			else
				tid = {normal = mult.normal,expensive = mult.expensive}
			end
			tid.normal = tid.normal/gcd.normal
			tid.expensive = tid.expensive/gcd.expensive
			local icons = get_icons_rec(recipe)

			if recipe.normal.category and not data.raw["recipe-category"][recipe.normal.category.."-compressed"] then
				data:extend({{type = "recipe-category",name = recipe.normal.category.."-compressed"}})
			elseif not data.raw["recipe-category"]["general-compressed"] then
				data:extend({{type = "recipe-category",name = "general-compressed"}})
			end

			local new_cat = "crafting-compressed"
			if recipe.normal.category then new_cat = recipe.normal.category.."-compressed" end

			local loc = {"recipe-name."..recipe.name}
			local r = {
				type = "recipe",
				icons = icons,
				icon_size = recipe.icon_size or 32,
				name = recipe.name.."-compression",
				enabled = false,
				hidden = recipe.hidden,
				normal = {
					ingredients = new_val_norm.ingredients,
					results = new_val_norm.results,
					energy_required = tid.normal,
					subgroup = subgr.normal
				},
				expensive = {
					ingredients = new_val_exp.ingredients,
					results = new_val_exp.results,
					energy_required = tid.expensive,
					subgroup = subgr.expensive
				},
				category = new_cat,
				subgroup = subgr.regular,
				order = recipe.order,
			}
			if settings.startup["omnicompression_normalize_stacked_buildings"].value then
				for _,dif in pairs({"normal","expensive"}) do
					if #r[dif].results == 1 and omni.lib.find_entity_prototype(string.sub(r[dif].results[1].name,string.len("compressed-")+1,string.len(r[dif].results[1].name))) then
						for _,ing in pairs(r[dif].ingredients) do
							ing.amount = omni.lib.round_up(ing.amount/r[dif].results[1].amount)
						end
						r[dif].energy_required = r[dif].energy_required/r[dif].results[1].amount
						r[dif].results[1].amount=1
					end
				end
			end
			--if not r.subgroup then
			if recipe.localised_name then
				loc = recipe.localised_name
			end
			r.localised_name = {"recipe-name.compressed-recipe",loc}
			if true or settings.startup["omnicompression_one_list"].value then
				r.subgroup = "compressor-".."items"
				r.normal.subgroup = "compressor-".."items"
				r.expensive.subgroup = "compressor-".."items"
			end

			r.normal.hidden = recipe.normal.hidden
			r.normal.enabled = false
			r.normal.category= new_cat
			if r.main_product and r.main_product ~= "" then
				r.main_product = recipe.main_product
				if not data.raw.fluid[r.main_product] then r.main_product="compressed-"..r.main_product end
			end
			if #r.normal.results==1 then r.normal.main_product = r.normal.results[1].name end
			if #r.expensive.results==1 then r.expensive.main_product = r.expensive.results[1].name end
			r.expensive.enabled = false
			r.expensive.hidden = recipe.expensive.hidden
			r.expensive.category = new_cat
			if r.main_product == "compressed-" or (r.normal and r.normal.main_product == "compressed-") or (r.expensive and r.expensive.main_product == "compressed-") then
				if r.normal then r.normal.main_product = nil end
				if r.expensive then r.expensive.main_product = nil end
				r.main_product = nil
			end
			for _, module in pairs(data.raw.module) do
				if module.limitation then
					for _,lim in pairs(module.limitation) do
						if lim==recipe.name then
							table.insert(module.limitation, r.name)
							break
						end
					end
				end
			end
			r.main_product = nil
			r.normal.main_product = nil
			r.expensive.main_product = nil
			omni.marathon.standardise(r)
			if generatorfluid then
				table.insert(generatorFluidRecipes[generatorfluid].recipes,adjustOutput(r))
			end
			return adjustOutput(r)
		end
	elseif (recipe.icon_size or 0)%32 == 0 and math.log(recipe.icon_size or 32)/math.log(2) > 4 and recipe.normal.results and #recipe.normal.results > 0 and not_random(recipe) and not omni.lib.is_in_table(recipe.name,excluded_recipes) and (more_than_one(recipe) or omni.lib.is_in_table(recipe.name,include_recipes)) and not string.find(recipe.name,"creative") then
		local new_cat = "crafting-compressed"
		if recipe.normal.category then new_cat = recipe.normal.category.."-compressed" end
		if recipe.normal.category and not data.raw["recipe-category"][recipe.normal.category.."-compressed"] then
			data:extend({{type = "recipe-category",name = recipe.normal.category.."-compressed"}})
		elseif not data.raw["recipe-category"]["general-compressed"] then
			data:extend({{type = "recipe-category",name = "general-compressed"}})
		end
		local r = table.deepcopy(recipe)
		r.enabled=false
		r.name = r.name.."-compression"
		if r.icon or r.icons then
			local icons = {{icon = "__omnimatter_compression__/graphics/compress-32.png",icon_size=32}}
			if r.icons then
				for _ , icon in pairs(r.icons) do
					local shrink = icon
					icons[#icons+1] = shrink
				end
			else
				icons[#icons+1] = {icon = r.icon}
			end
			r.icon = nil
			r.icons = icons
		end
		if true or settings.startup["omnicompression_one_list"].value then
			r.subgroup = "compressor-".."items"
			r.normal.subgroup = "compressor-".."items"
			r.expensive.subgroup = "compressor-".."items"
		end
		for _, dif in pairs({"normal","expensive"}) do
			r[dif].category=new_cat
			r[dif].energy_required = concentrationRatio*r[dif].energy_required
			for _,ingres in pairs({"ingredients","results"}) do
				for i,item in pairs(r[dif][ingres]) do
					r[dif][ingres][i].name="concentrated-"..r[dif][ingres][i].name
				end
			end
		end
		return r
	end
	return nil
end

local create_void = function(recipe)
	local continue = false
	for _, dif in pairs({"normal","expensive"}) do
		if #recipe[dif].results == 1 and recipe[dif].results[1].type=="item" and #recipe[dif].ingredients == 1 and recipe[dif].ingredients[1].type=="item" and recipe[dif].results[1].probability and recipe[dif].results[1].probability == 0 then continue = true end
	end
	if continue==true then
		local icons = get_icons_rec(recipe)
		local new_cat = "crafting-compressed"
		if recipe.normal.category then new_cat = recipe.normal.category.."-compressed" end
		if recipe.normal.category and not data.raw["recipe-category"][recipe.normal.category.."-compressed"] then
			data:extend({{type = "recipe-category",name = recipe.normal.category.."-compressed"}})
		elseif not data.raw["recipe-category"]["general-compressed"] then
			data:extend({{type = "recipe-category",name = "general-compressed"}})
		end
		local new_rc = table.deepcopy(recipe)
		new_rc.name = recipe.name.."-compression"
		new_rc.category = new_cat
		new_rc.normal.ingredients[1].name="compressed-"..new_rc.normal.ingredients[1].name
		new_rc.expensive.ingredients[1].name="compressed-"..new_rc.expensive.ingredients[1].name

		return table.deepcopy(new_rc)
	end
	return nil
end


--log("Tok you bastard")

for _,recipe in pairs(data.raw.recipe) do
	--Start with the ingredients
	--log("calc compressed recipe of "..recipe.name)
	if not mods["omnimatter_marathon"] then omni.marathon.standardise(recipe) end
	if recipe.subgroup ~= "y_personal_equip" and (recipe.icon_size or 0)%32 == 0 and math.log(recipe.icon_size or 32)/math.log(2) > 4 then
		local rc = create_compression_recipe(recipe)
		if not rc and string.find(recipe.name,"void") then rc=create_void(recipe) end
		if rc then
			compress_based_recipe[#compress_based_recipe+1] = table.deepcopy(rc)
		else
			if not not_random(recipe) then random_recipes[#random_recipes+1]=recipe.name end
		end
	end
end

--log("Finished compressing recipes")

local multiplier = settings.startup["omnicompression_multiplier"].value


for name,fluid in pairs(generatorFluidRecipes) do
	--log("working on fluid "..name)
	for _,rec in pairs(fluid.recipes) do
		for i = 1, settings.startup["omnicompression_building_levels"].value do
			local new = table.deepcopy(rec)
			new.name = new.name.."-grade-"..i
			local newFluid={}
			for _,dif in pairs({"normal","expensive"}) do
				for j,res in pairs(new[dif].results) do
					if res.name == name then
						new[dif].results[j].amount = new[dif].results[j].amount/ math.pow(multiplier,i)
						newFluid=table.deepcopy(data.raw.fluid[res.name])
						new[dif].results[j].name = res.name.."-concentrated-grade-"..i
					elseif string.sub(res.name,string.len("concentrated-")+1,-1)==name then
						new[dif].results[j].amount = new[dif].results[j].amount/ math.pow(multiplier,i)*60
						newFluid=table.deepcopy(data.raw.fluid[string.sub(res.name,string.len("concentrated-")+1,-1)])
						new[dif].results[j].name = string.sub(res.name,string.len("concentrated-")+1,-1).."-concentrated-grade-"..i
					end
				end
			end

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
			new.icons = table.deepcopy(newFluid.icons)
			compress_recipes[#compress_recipes+1]=new
			compress_recipes[#compress_recipes+1]=newFluid
		end
	end
end
--log("damn it zom!")
--log("ep")
data:extend(compress_recipes)
--log("meep")
data:extend(uncompress_recipes)
--log("deep")
data:extend(compress_based_recipe)
--log("seep")
--error("derp")
