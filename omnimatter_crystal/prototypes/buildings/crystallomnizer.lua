local plant = {}

local parts = {"gear","circuit","plate", "pipe"}

local component={}

local quant={}
quant["gear"]={5,8}
quant["plate"]={10,20}
quant["pipe"]=5
quant["circuit"]=15

component["gear"]={"omnicium-gear-wheel","omnicium-iron-gear-box"}
component["circuit"]={"electronic-circuit","basic-crystallonic","basic-oscillo-crystallonic"}

if mods["bobores"] then
	--component["circuit"][#component["circuit"]+1]=omni.crystal.find_crystallonic({"omnine","iron","copper"}, 1)
	--component["circuit"][#component["circuit"]+1]=omni.crystal.find_crystallonic({"copper","lead","tin"}, 1)
	--component["circuit"][#component["circuit"]+1]=omni.crystal.find_crystallonic({"bauxite","lead","zinc","copper"}, 2)
else
	component["circuit"][#component["circuit"]+1]=nil
	--component["circuit"][#component["circuit"]+1]=omni.crystal.find_crystallonic({"omnine","iron","copper"}, 1)
end
component["plate"] = {"omnicium-plate","omnicium-steel-alloy"}
component["pipe"] = {"pipe"}

if bobmods and bobmods.plates then
component["gear"][#component["gear"]+1] = "omnicium-steel-gear-box"
component["gear"][#component["gear"]+1] = "omnicium-brass-gear-box"
component["gear"][#component["gear"]+1] = "omnicium-titanium-gear-box"
component["gear"][#component["gear"]+1] = "omnicium-tungsten-gear-box"
component["gear"][#component["gear"]+1] = "omnicium-nitinol-gear-box"
quant["gear"]={5,8,11,13,18,25}

component["plate"][#component["plate"]+1]="omnicium-aluminium-alloy"
component["plate"][#component["plate"]+1] ="omnicium-tungsten-alloy"
quant["plate"]={10,15,30,45}
end

if mods["boblogistics"] then
	component["pipe"][#component["pipe"]+1]="steel-pipe"
	component["pipe"][#component["pipe"]+1]="plastic-pipe"
end

local get_cost = function(tier)
	local ing = {}
	--ing[#ing+1]={type="item",name="omnicium-plate",amount=20+10*tier}
	--ing[#ing+1]={type="item",name="omnicium-gear-wheel",amount=10+5*tier}
	for _,part in pairs(parts) do
		local amount = quant[part]
		if type(quant[part])=="table" then amount=quant[part][tier] end
		for i=tier,1,-1 do
			if component[part][i] then
				ing[#ing+1]={type="item",name=component[part][i],amount=amount}
				break
			else
				amount = 4*amount
			end
		end
	end
	if tier > 1 then
		ing[#ing+1]={type="item",name="omni-plant-"..tier-1,amount=1}
	end
	return ing
end

for i = 1,4 do
	local icons={{icon = "__omnimatter_crystal__/graphics/icons/crystallomnizer.png"},{icon = "__omnimatter__/graphics/icons/extraction-"..i..".png"}}
	plant[#plant+1]={
    type = "item",
    name = "crystallomnizer-"..i,
    icons = icons,
	localised_name = {"item-name.crystallomnizer", "mk"..i},
	flags = {"goes-to-quickbar"},
    subgroup = "crystallization",
    order = "a[burner-omnitractor]",
    place_result = "crystallomnizer-"..i,
    icon_size = 32,
    stack_size = 20,
    }
		
	local cost = get_cost(i)
	plant[#plant+1]={
    type = "recipe",
    icons = icons,
    icon_size = 32,
    name = "crystallomnizer-"..i,
    energy_required = 25,
	enabled = false,
    ingredients = cost,
    result= "crystallomnizer-"..i,
    subgroup = "omniplant",
	order = "z"
    }
	
	
	plant[#plant+1]=	{
    type = "assembling-machine",
    name = "crystallomnizer-"..i,
	localised_name = {"item-name.crystallomnizer", "mk"..i},
    icons = icons,
	flags = {"placeable-neutral","player-creation"},
    minable = {mining_time = 1, result = "crystallomnizer-"..i},
	fast_replaceable_group = "crystallomnizer",
    max_health = 300,
    icon_size = 32,
	ingredient_count = 7,
	corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
	fluid_boxes =
    {
      {
        production_type = "input",
        --pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {2, 0} }}
      },
	  {
        production_type = "output",
        --pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 2,
        pipe_connections = {{type="output", position = {0, -2} }}
      },
    },
	module_specification =
    {
      module_slots = i
    },
    allowed_effects = {"consumption", "speed", "pollution", "productivity"},
    crafting_categories = {"crystallomnizer"},
    crafting_speed = 0.5+i/2,
	source_inventory_size = 3,
	energy_source =
    {
	  type = "electric",
	  usage_priority = "secondary-input",
	  emissions = 0.04 / 3.5
	},
    energy_usage = "250kW",
    ingredient_count = 4,
    animation ={
	layers={
	{
        filename = "__omnimatter_crystal__/graphics/buildings/crystallomnizer.png",
		priority = "extra-high",
        width = 164,
        height = 162,
        frame_count = 36,
		line_length = 6,
        shift = {0.00, -0.8},
		scale = 0.8,
		animation_speed = 0.3
	},
	}
	},
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound = { filename = "__base__/sound/oil-refinery.ogg" },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 2.5,
    },
}

end

data:extend(plant)

