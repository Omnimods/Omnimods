local nr_tiers = settings.startup["omnielectricity-solar-tiers"].value
local max_size = settings.startup["omnielectricity-solar-size"].value

--Disable all Solar Panels
for _, sol in pairs(data.raw["solar-panel"]) do
	if sol.minable then
		local recipe = omni.lib.find_recipe(sol.minable.result)
		omni.lib.remove_recipe_all_techs(recipe.name)
	end
end

local parts={"plate","crystal","circuit"}

local quant={}
quant["plate"]=5
quant["crystal"]=5
quant["circuit"]=5

local component={}
component["plate"]= {"steel-plate"}
component["crystal"]={"iron-ore-crystal"}
component["circuit"]={"basic-crystallonic","basic-oscillo-crystallonic"}
if data.raw.item["lead-ore-crystal"] then component["crystal"][#component["crystal"]+1] = "lead-ore-crystal" end
if data.raw.item["quartz-crystal"] then component["crystal"][#component["crystal"]+1] = "quartz-crystal" end
if data.raw.item["cobalt-ore-crystal"] then component["crystal"][#component["crystal"]+1] = "cobalt-ore-crystal" end
if data.raw.item["silver-ore-crystal"] then component["crystal"][#component["crystal"]+1] = "silver-ore-crystal" end

local crystallonics = {"crystal-rod","oscillocrystal","electrocrystal"}

local get_cost = function(tier, size)
	local ing = {}

	ing[#ing+1]={type="item",name="omnicium-plate", amount = 6 + (size-1)*(size-1) + (tier-1)*4}

	--Add components to each crystal panel recipe
	for _,part in pairs(parts) do
		local amount = quant[part]
		for i=tier, 1, -1 do
			if component[part] and component[part][i] then
				ing[#ing+1]={type="item",name=component[part][i],amount=amount}
				break
			else
				amount = amount + 2
			end
		end
	end

	--Add crystallonics to each crystal panel with size > 1
	for i=tier, 1, -1 do
		if size > 1 and crystallonics[i] then
			ing[#ing+1]={type="item",name=crystallonics[i],amount=math.pow(size-1,2)-math.pow(size-2,2)}
			break
		end
	end

	if size > 1 then
		if size > 2 then
			ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-"..size-1,amount=1}
			ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-1",amount=math.pow(size,2)-math.pow(size-1,2)}
		elseif size==2 then
			ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-"..size-1,amount=4}
		end
	else
		ing[#ing+1]={type="item",name="crystal-panel",amount=7}
	end

	if tier > 1 and size == 1 then
		ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..(tier-1).."-size-1",amount=1}
	end

	return ing
end

local get_req = function(tier, size)
	local req = {}
	if tier == 1 and size == 1 then
		req = {"solar-energy", "crystallonics-1"}
	elseif size == 1 then
		if tier <= 5 then
			req = {"crystal-solar-panel-tier-"..(tier-1).."-size-"..max_size, "crystallonics-"..tier}
		else
			req = {"crystal-solar-panel-tier-"..(tier-1).."-size-"..max_size}
		end
	else
		req = {"crystal-solar-panel-tier-"..tier.."-size-"..size-1}
	end
	return req
end

local get_scienceing = function(tier)
	local packs = {}
	for i=1,math.min(tier+1,5) do
		packs[#packs+1] = {omni.sciencepacks[i],1}
	end
	return packs
end

local sol = {}
for j=1,nr_tiers do
	--subgroup
	sol[#sol+1]={
		type = "item-subgroup",
		name = "omnienergy-solar-tier-"..j,
		group = "omnienergy",
		order = data.raw["item-subgroup"]["omnienergy-solar"].order..j,
	}

	for i=1,max_size do
		--panel pictures
		local pic = {}
		local icons={{icon="__omnimatter_energy__/graphics/icons/empty.png"}}
		for k=i,1,-1 do
			for l=1, i do
				--entity pictures
				pic[#pic+1]={
					filename = "__omnimatter_energy__/graphics/entity/buildings/zolar-panel.png",
					priority = "high",
					width = 192,
					height = 192,
					scale=0.5,
					shift = {k-i/2-0.5,l-i/2-0.4},
				}
				--icons
				icons[#icons+1]={
					icon="__omnimatter_energy__/graphics/icons/zolar-panel.png",
					icon_size= 32,
					scale = 1/i,
					shift={(k-i/2-0.5)*32/i,(l-i/2-0.5)*32/i}
				}
			end
		end
		--crystal links
		for k=1,i-1 do
			for l=1, i-1 do
				--entity pictures
				pic[#pic+1]={
					filename = "__omnimatter_energy__/graphics/entity/buildings/zolar-crystal.png",
					priority = "high",
					width = 192,
					height = 192,
					scale=0.5,
					shift = {k-i/2,l-i/2},
				}
				--icons
				icons[#icons+1]={
					icon="__omnimatter_energy__/graphics/entity/buildings/zolar-crystal.png",
					icon_size=192,
					scale = 1/i*72/192,
					shift={(k-i/2)*32/i,(l-i/2)*32/i}
				}
			end
		end
		--add tier icon
		icons[#icons+1]={icon="__omnilib__/graphics/icons/small/lvl"..j..".png",icon_size=32} --handles 0-8

		--solar panel array item
		sol[#sol+1]={
			type = "item",
			name = "crystal-solar-panel-tier-"..j.."-size-"..i,
			localised_name = {"item-name.crystal-solar-panel", j, i},
			icons = icons,
			flags = {},
			subgroup = "omnienergy-solar-tier-"..j,
			order = "a[crystal-solar-panel-tier-"..j.."-size-"..i.."]",
			place_result = "crystal-solar-panel-tier-"..j.."-size-"..i,
			icon_size = 32,
			stack_size = 10+max_size*10-10*i,
		}

		--solar panel array entity
		sol[#sol+1]={
			type = "solar-panel",
			name = "crystal-solar-panel-tier-"..j.."-size-"..i,
			localised_name = {"entity-name.crystal-solar-panel", j, i},
			icons = icons,
			icon_size = 32,
			flags = {"placeable-neutral", "player-creation"},
			minable = {hardness = 0.2, mining_time = 0.5, result = "crystal-solar-panel-tier-"..j.."-size-"..i},
			max_health = 200,
			corpse = "big-remnants",
			collision_box = {{-i*0.5+0.1, -i*0.5+0.1}, {i*0.5-0.1, i*0.5-0.1}},
			selection_box = {{-i*0.5, -i*0.5}, {i*0.5, i*0.5}},
			energy_source =
			{
				type = "electric",
				usage_priority = "solar"
			},
			picture =
			{
				layers =pic,
			},
			vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
			production = math.floor(5*math.pow(i,2)*math.pow(1.2,i-1)*math.pow(1.5,j-1)).."kW"
		}

		--solar panel array recipe
		sol[#sol+1]={
			type = "recipe",
			name = "crystal-solar-panel-tier-"..j.."-size-"..i,
			localised_name = {"recipe-name.crystal-solar-panel", j, i},
			icons = icons,
			icon_size = 32,
			subgroup = "omnienergy-solar-tier-"..j,
			category ="crafting",
			energy_required = 1,
			enabled = false,
			ingredients = get_cost(j,i),
			results=
			{
				{type="item", name="crystal-solar-panel-tier-"..j.."-size-"..i, amount=1},
			},
			energy_required = 6.0,
			order = "a[crystal-solar-panel-tier-"..j.."-size-"..i.."]",
		}

		--solar panel array tech unlocks sets
		sol[#sol+1]={
			type = "technology",
			name = "crystal-solar-panel-tier-"..j.."-size-"..i,
			localised_name = {"technology-name.crystal-solar-panel", j, i},
			icons = icons,
			icon_size = 32,
			prerequisites = get_req(j,i,max_size),
			effects =
			{
				{type = "unlock-recipe", recipe = "crystal-solar-panel-tier-"..j.."-size-"..i}
			},
			unit =
			{
				count = 150+((j-1)*max_size+i)*75+j*100,	--base_cost+...*cost_between_techs+...*addidional_cost_between_tiers
				ingredients = get_scienceing(j),
				time = 30
			},
			order = "c-a",
		}
	end
end

data:extend(sol)

--Add an upgrade recipe from previous tier max size to this tier size 1
for j=1,nr_tiers do
	for i=1,max_size do
		
		if i == 1 and j > 1 then
			data:extend({
			{
				type = "recipe",
				name = "crystal-solar-panel-tier-"..j.."-size-"..i.."-upgrade",
				localised_name = {"recipe-name.crystal-solar-panel", j, i},
				icons = icons,
				icon_size = 32,
				subgroup = "omnienergy-solar-tier-"..j,
				category ="crafting",
				energy_required = 1,
				enabled = false,
				ingredients = get_cost(j,i),
				results=
				{
					{type="item", name="crystal-solar-panel-tier-"..j.."-size-"..i, amount=max_size*max_size},
				},
				energy_required = 6.0,
				order = "a[crystal-solar-panel-tier-"..j.."-size-"..i.."]z"
			}})

			omni.lib.remove_recipe_ingredient("crystal-solar-panel-tier-"..j.."-size-"..i.."-upgrade", "crystal-solar-panel-tier-"..(j-1).."-size-"..i)
			for _,ing in pairs(data.raw.recipe["crystal-solar-panel-tier-"..j.."-size-"..i.."-upgrade"].ingredients) do
				omni.lib.multiply_recipe_ingredient("crystal-solar-panel-tier-"..j.."-size-"..i.."-upgrade", ing.name, max_size*max_size)
			end
			omni.lib.add_recipe_ingredient("crystal-solar-panel-tier-"..j.."-size-"..i.."-upgrade", "crystal-solar-panel-tier-"..(j-1).."-size-"..max_size)
			omni.lib.add_unlock_recipe("crystal-solar-panel-tier-"..j.."-size-"..i, "crystal-solar-panel-tier-"..j.."-size-"..i.."-upgrade")
		end
	end
end

omni.lib.replace_all_ingredient("solar-panel","crystal-panel")