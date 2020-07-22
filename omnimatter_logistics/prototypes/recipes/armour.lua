local armour = {}
local nr_armour = settings.startup["omnilogistics-nr-armour"].value

local costs= {circuit={},plate={}}

if not mods["bobelectronics"] then
	costs.circuit[#costs.circuit+1] = {name = "electronic-circuit", quant={16,27,43,65,96,139,200,285,404,571}}
else
	costs.circuit[#costs.circuit+1] = {name = "basic-circuit-board", quant={24,40,64,100,154}}
	costs.circuit[#costs.circuit+1] = {name = "electronic-circuit", quant={10,17,27,41,60}}
end
if not mods["bobplates"] then
	costs.plate[#costs.plate+1]={name = "iron-plate", quant={20,29,40,53,69}}
	costs.plate[#costs.plate+1]={name = "steel-plate", quant={20,29,41,56,76}}
else
	costs.plate[#costs.plate+1]={name = "iron-plate", quant={20,29,40}}
	costs.plate[#costs.plate+1]={name = "bronze-alloy", quant={12,24,41,64}}
	costs.plate[#costs.plate+1]={name = "steel-plate", quant={25,34,43}}
end

--group and categories
armour[#armour+1]= {
  type = "item-group",
  name = "omnilogistics",
  order = "z",
  inventory_order = "z",
  icon = "__omnimatter_logistics__/graphics/omnilogistics.png",
  icon_size = 128,
}
armour[#armour+1] = {
  type = "item-subgroup",
  name = "early-armours",
  group = "omnilogistics",
  order = "aa",
}
--armour tier1
armour[#armour+1]= {
  type = "recipe",
  name = "primitive-armour",
  icon = "__omnimatter_logistics__/graphics/icons/primitive-armor.png",
  icon_size = 32,
  subgroup = "early-armours",
  order = "g[hydromnic-acid]",
  energy_required = 5,
  enabled = false,
  ingredients =
  {
    {type = "item", name = "iron-plate", amount = 10},
    {type = "item", name = "electronic-circuit", amount = 15},
    {type = "item", name = "heavy-armor", amount = 1},
  },
  results =
  {
    {type = "item", name = "primitive-armour", amount = 1},
  },
}
-- armour counts dynamic  
for i=1,nr_armour do
	armour[#armour+1] = {
    type = "armor",
    name = "omni-armour-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-armour-1.png",
    icon_size = 32,
	  localised_name = {"item-name.omni-armour", i},
    flags = {},
    resistances =
    {
    },
    durability = 1000,
    subgroup = "armor",
    order = "c[modular-armor]",
    stack_size = 1,
    equipment_grid = "omniquipment-grid-"..i,
    inventory_size_bonus = 5*i
  }
  --ingredient indexing
	local req = {}
	for _,kind in pairs(costs) do
		local left = i
		local level = 1
		while kind[level].quant[left] == nil do
			left=left-#kind[level].quant
			level=level+1
		end
		req[#req+1]={type="item",name=kind[level].name,amount=kind[level].quant[left]}
  end
  if i==1 then req[#req+1]={type="item", name="primitive-armour",amount=1} else req[#req+1]={type="item", name="omni-armour-"..i-1,amount=1} end
  --recipe generating using above indexation
	armour[#armour+1] = {
    type = "recipe",
    name = "omni-armour-"..i,
    icon = "__omnimatter_logistics__/graphics/icons/omni-armour-1.png",
    icon_size = 32,
    subgroup = "early-armours",
    order = "g[hydromnic-acid]",
	  energy_required = 5,
    enabled = false,
    ingredients =req,
    results =
    {
      {type = "item", name = "omni-armour-"..i, amount = 1},
    },
  }
  --technology unlocks
	req = {}
	if i==1 then req[#req+1]="omniquipment-basic" else req[#req+1]="omni-armour-"..i-1 end
	armour[#armour+1] = { 
    type = "technology",
    name = "omni-armour-"..i,
    icon = "__omnimatter_logistics__/graphics/technology/omni-armour.png",
	  icon_size = 128,
	  prerequisites = req,
    effects =
    {
	  {
        type = "unlock-recipe",
        recipe = "omni-armour-"..i
      },
    },
    unit =
    {
      count = 500+75*(math.pow(2,i-1)-1),
      ingredients = {
	      {"automation-science-pack", 1},
	      {"logistic-science-pack", 1},
	    },
      time = 60
    },
    order = "c-a"
    }
end
data:extend(armour)
