for _, sol in pairs(data.raw["solar-panel"]) do
	if sol.minable then
		local recipe = omni.lib.find_recipe(sol.minable.result)
		omni.lib.remove_recipe_all_techs(recipe.name)
	end
end

local sol = {
	{ 
		type = "item",
		name = "zolar-panel",
		icon = "__omnimatter_energy__/graphics/icons/zolar-panel.png",
		flags = {},
		subgroup = "omnitractor",
		order = "zolar-panel",
		icon_size = 32,
		stack_size = 50,
	},
	{
		type = "recipe",
		name = "zolar-panel",
		subgroup = "omnienergy-solar",
		category="omniphlog",
		energy_required = 2,
		ingredients = {{"iron-ore-crystal",2},{"copper-ore-crystal",3},{"basic-crystallonic",3}},
		enabled=false,
		results=
		{
		  {type="item", name="zolar-panel", amount=1},
		},
		order = "a[angelsore1-crushed-hand]",
	}
}

local parts={"plate","crystal","circuit"}

local quant={}
quant["crystal"]=5
quant["plate"]=5
quant["circuit"]=5

local component={}
component["circuit"]={"basic-crystallonic","basic-oscillo-crystallonic"}
component["plate"]= {"steel-plate"}
component["crystal"]={"iron-ore-crystal"}

if mods["bobores"] then
	component["crystal"][#component["crystal"]+1] = "lead-ore-crystal"
end

local nr_tiers = settings.startup["omnielectricity-solar-tiers"].value
local max_size = settings.startup["omnielectricity-solar-size"].value

local get_cost = function(tier, size)
	local ing = {}
	ing[#ing+1]={type="item",name="omnicium-plate",amount=10+tier+size}
	--ing[#ing+1]={type="item",name="omnicium-gear-wheel",amount=7+3*tier}
	for _,part in pairs(parts) do
		local amount = quant[part]
		for i=tier,1,-1 do
			if component[part] and component[part][i] then
				ing[#ing+1]={type="item",name=component[part][i],amount=amount}
				break
			else
				amount = amount+2
			end
		end
	end
	if size > 1 then
		if size > 2 then
			ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-"..size-1,amount=1}
			ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-1",amount=math.pow(size,2)-math.pow(size-1,2)}
		elseif size==2 then
			ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-"..size-1,amount=3}
		end
		ing[#ing+1]={type="item",name="electrocrystal",amount=math.pow(size-1,2)-math.pow(size-2,2)}
	else
		ing[#ing+1]={type="item",name="zolar-panel",amount=7}
	end
	if tier > 1 and size == 1 then
		ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..(tier-1).."-size-1",amount=1}
	end
	return ing
end

local get_req = function(tier, size, msize)
	local req = {}
	if tier == 1 and size == 1 then
		req = {"automation"}
	elseif size == 1 then
		req = {"crystal-solar-panel-tier-"..(tier-1).."-size-"..msize}
	else 
		req = {"crystal-solar-panel-tier-"..tier.."-size-"..size-1}
	end
	return req
end

local get_scienceing = function(tier)
	local techtier= {
		[1]={{"automation-science-pack", 1},},
		[2]={{"automation-science-pack", 1},{"logistic-science-pack", 1},},
		[3]={{"automation-science-pack", 1},{"logistic-science-pack", 1},{"chemical-science-pack", 1},},
		[4]={{"automation-science-pack", 1},{"logistic-science-pack", 1},{"chemical-science-pack", 1},{"production-science-pack", 1},},
		[5]={{"automation-science-pack", 1},{"logistic-science-pack", 1},{"chemical-science-pack", 1},{"production-science-pack", 1},{"utility-science-pack", 1},},
	}
	if tier <= #techtier then
		return techtier[tier]
	else
		return techtierh[#techtier]
	end
end

local get_icon = function(size)
	local icons={{icon="__omnimatter_energy__/graphics/icons/empty.png"}}
	for k=size,1,-1 do
		for l=1, size do
			icons[#icons+1]={
				icon="__omnimatter_energy__/graphics/icons/zolar-panel.png",
				scale = 1/size,
			--	shift={((max_size-i)/(max_size-1)+k-2)*32/i,((max_size-i)/(max_size-1)+l-2)*32/i}
			--	shift={((max_size-i)/(max_size-1)+k-2)*32/i+2-i*2,((max_size-i)/(max_size-1)+l-2)*32/i+2-i*2}
				shift={((max_size-size)/(max_size-1)+k-2)*32/size-(size-1)*2,((max_size-size)/(max_size-1)+l-2)*32/size-(size-1)*2}
			}
		end
	end
	for k=1,size-1 do
		for l=1, size-1 do
			icons[#icons+1]={
				icon="__omnimatter_energy__/graphics/icons/zolar-panel.png",
				scale = 1/size,
			--	shift={((max_size-i)/(max_size-1)+k-2)*32/i,((max_size-i)/(max_size-1)+l-2)*32/i}
			--	shift={((max_size-i)/(max_size-1)+k-2)*32/i+2-i*2,((max_size-i)/(max_size-1)+l-2)*32/i+2-i*2}
				shift={((max_size-size)/(max_size-1)+k-2)*32/size-(size-1)*2,((max_size-size)/(max_size-1)+l-2)*32/size-(size-1)*2}
			}
		end
	end
	return icons
end

--log("solar shite")
for j=1,nr_tiers do

	sol[#sol+1]={ 
		type = "item-subgroup",
		name = "omnienergy-solar-tier-"..j,
		group = "omnienergy",
		order = data.raw["item-subgroup"]["omnienergy-solar"].order..j,
	  	}

	for i=1,max_size do
	
		local pic = {}
		for k=i,1,-1 do
			for l=1, i do
				pic[#pic+1]={
				  filename = "__omnimatter_energy__/graphics/entity/buildings/zolar-panel.png",
				  priority = "high",
				  width = 192,
				  height = 192,
				  scale=0.5,
				  shift = {k-i/2-0.5,l-i/2-0.4},
				}
			end
		end
		for k=1,i-1 do
			for l=1, i-1 do
				pic[#pic+1]={
				  filename = "__omnimatter_energy__/graphics/entity/buildings/zolar-crystal.png",
				  priority = "high",
				  width = 192,
				  height = 192,
				  scale=0.5,
				  shift = {k-i/2,l-i/2},
				}
			end
		end
		--icons[#icons+1]={icon="__omnimatter_energy__/graphics/icons/zolar-panel.png"}
		
		sol[#sol+1]={ 
		type = "item",
		name = "crystal-solar-panel-tier-"..j.."-size-"..i,
		localised_name = {"item-name.crystal-solar-panel", j, i},
		icons = get_icon(i,32),
		flags = {},
		subgroup = "omnitractor",
		order = "zolar-panel",
		place_result = "crystal-solar-panel-tier-"..j.."-size-"..i,
		icon_size = 32,
		stack_size = 10+max_size*10-10*i,
		}
		sol[#sol+1]={ 
		type = "solar-panel",
		name = "crystal-solar-panel-tier-"..j.."-size-"..i,
		localised_name = {"entity-name.crystal-solar-panel", j, i},
		icon = "__base__/graphics/icons/solar-panel.png",
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
		--[[overlay =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/solar-panel/solar-panel-shadow-overlay.png",
			  priority = "high",
			  width = 108,
			  height = 90,
			  shift = util.by_pixel(11, 6),
			  hr_version = {
				filename = "__base__/graphics/entity/solar-panel/hr-solar-panel-shadow-overlay.png",
				priority = "high",
				width = 214,
				height = 180,
				shift = util.by_pixel(10.5, 6),
				scale = 0.5
			  }
			}
		  }
		},]]
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		production = math.floor(5*math.pow(i,2)*math.pow(1.2,i-1)*math.pow(1.5,j-1)).."kW"
		}

	  	sol[#sol+1]={
		type = "recipe",
		name = "crystal-solar-panel-tier-"..j.."-size-"..i,
		localised_name = {"recipe-name.crystal-solar-panel", j, i},
		icons = get_icon(i),
		icon_size = 32,
		subgroup = "omnienergy-solar-tier-"..j,
		category="omniphlog",
		energy_required = 1,
		enabled=false,
		ingredients = get_cost(j,i),
		results=
		{
		  {type="item", name="crystal-solar-panel-tier-"..j.."-size-"..i, amount=1},
		},
		energy_required = 6.0,
		order = "a[angelsore1-crushed-hand]",
		}
		
		sol[#sol+1]={ 
		type = "technology",
		name = "crystal-solar-panel-tier-"..j.."-size-"..i,
		localised_name = {"technology-name.crystal-solar-panel", j, i},
		--icon = "__omnimatter_energy__/graphics/technology/zolar-panel.png",
		icons = get_icon(i),
		icon_size = 32,
		prerequisites = get_req(j,i,max_size),
		effects =
		{
			{type = "unlock-recipe", recipe = "crystal-solar-panel-tier-"..j.."-size-"..i}
		},
		unit =
		{
			count = 30+i*30+j*10,
			ingredients = get_scienceing(j),
			time = 30
		},
			order = "c-a",
		}
	end
end
data:extend(sol)
omni.lib.add_unlock_recipe("crystal-solar-panel-tier-1-size-1", "zolar-panel")
