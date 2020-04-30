local nr_reactors = settings.startup["omnilogistics-nr-reactors"].value
local nr_slots = settings.startup["omnilogistics-nr-slots"].value
local reactor = {}

local costs = {slots={circuit={},mechanical={},plate={},engine={}},efficiency={circuit={},mechanical={},plate={},engine={}}}
if not mods["bobpower"] then
	costs.efficiency.engine[#costs.efficiency.engine+1] = {name = "steel-furnace", quant={2,2,3,6,7,8}}
	costs.slots.engine[#costs.slots.engine+1] = {name = "steam-engine", quant={1,1,2,2,3,3}}
else
	costs.efficiency.engine[#costs.efficiency.engine+1] = {name = "steel-furnace", quant={2,2}}
	
	if mods["omnimatter_fluid"] then
		costs.efficiency.engine[#costs.efficiency.engine+1] = {name = "boiler-2-converter", quant={1,2}}
		costs.efficiency.engine[#costs.efficiency.engine+1] = {name = "boiler-3-converter", quant={1,2}}
	else
		costs.efficiency.engine[#costs.efficiency.engine+1] = {name = "boiler-2", quant={1,2}}
		costs.efficiency.engine[#costs.efficiency.engine+1] = {name = "boiler-3", quant={1,2}}
	end
	
	costs.slots.engine[#costs.slots.engine+1] = {name = "steam-engine", quant={2,2}}
	costs.slots.engine[#costs.slots.engine+1] = {name = "steam-engine-2", quant={2,2}}
	costs.slots.engine[#costs.slots.engine+1] = {name = "steam-engine-3", quant={2,2}}
	--costs.circuit[#costs.circuit+1] = {name = "basic-circuit-board", quant={15,29,54}}steam-engine
	--costs.circuit[#costs.circuit+1] = {name = "electronic-circuit", quant={10,26}}
end
if not mods["bobelectronics"] then
	costs.efficiency.circuit[#costs.efficiency.circuit+1] = {name = "electronic-circuit", quant={5,6,7,8,9,10}}
else
	costs.efficiency.circuit[#costs.efficiency.circuit+1] = {name = "basic-circuit-board", quant={3,7,9}}
	costs.efficiency.circuit[#costs.efficiency.circuit+1] = {name = "electronic-circuit", quant={4,8,12}}
end
if not mods["aai-industry"] then
	--costs.mechanical[#costs.mechanical+1]={name = "iron-gear-wheel", quant={40,70,115,183,285}}
else
	--costs.mechanical[#costs.mechanical+1]={name = "motor", quant={10,18,30}}
	--costs.mechanical[#costs.mechanical+1]={name = "electric-motor", quant={7,14}}
end
if not mods["omnimatter_crystal"] then
	costs.efficiency.plate[#costs.efficiency.plate+1]={name = "steel-plate", quant={5,5,10,15,20,25}}
	costs.slots.plate[#costs.slots.plate+1]={name = "copper-plate", quant={20,10,17,24,41,100}}
else
	costs.efficiency.plate[#costs.efficiency.plate+1]={name = "steel-plate", quant={5,5,10}}
	costs.efficiency.plate[#costs.efficiency.plate+1]={name = "iron-ore-crystal", quant={5,5,10}}
	
	costs.slots.plate[#costs.slots.plate+1]={name = "bronze-alloy", quant={5,5,10}}
	costs.slots.plate[#costs.slots.plate+1]={name = "invar-alloy", quant={5,5,10}}
end

for efficiency=1,nr_reactors do
	for slots=1,nr_slots do
		--sizing calculations
		local width=1 --set defaults each time
		local height=1
		width=math.floor(math.sqrt(slots))
		height=math.ceil(slots/width)
		reactor[#reactor+1]={
			type = "item",
			name = "omni-generator-eff-"..efficiency.."-slot-"..slots,
			localised_name={"equipment-name.omni-generator",{"eff-slot-lookup.eff-"..efficiency},{"eff-slot-lookup.slot-"..slots}},
			icons={
				{icon = "__omnimatter_logistics__/graphics/icons/reactor/"..(efficiency-1).."-"..(slots-1)..".png", icon_size=32},
			},
			placed_as_equipment_result = "omni-generator-eff-"..efficiency.."-slot-"..slots,
			flags = {},
			order = "a[omni-burner-generator-vequip]",
			stack_size = 10,
			default_request_amount = 10,
			icon_size = 32,
		  }
		  
		reactor[#reactor+1]={
		type = "generator-equipment",
		name = "omni-generator-eff-"..efficiency.."-slot-"..slots,
		localised_name={"equipment-name.omni-generator",{"eff-slot-lookup.eff-"..efficiency},{"eff-slot-lookup.slot-"..slots}},
		sprite =
		{
		  filename = "__omnimatter_logistics__/graphics/equipment//reactor/"..(efficiency-1).."-"..(slots-1)..".png",
		  width = 64,
		  height = 96,
		  priority = "medium"
		},
		shape =
		{
		  width = width,
		  height = height,
		  type = "full"
		},
		energy_source =
		{
		  type = "burner",
		  usage_priority = "primary-output"
		},
		burner =
		{
		  fuel_category = "chemical",
		  effectivity = efficiency/nr_reactors,
		  fuel_inventory_size = slots,
		  burnt_inventory_size = 0
		},
		power = 1750+250*efficiency.."kW",
		categories = {"omni-armour"}
	  }
	local c = {}
	local val = {efficiency = efficiency, slots = slots}
	for _, eff in pairs({"efficiency","slots"}) do
		for _,kind in pairs(costs[eff]) do
			if #kind>0 then
				local left = val[eff]
				local level = 1
				while kind[level].quant[left] == nil do
					left=left-#kind[level].quant
					level=level+1
				end
				local f = false
				for _,ing in pairs(c) do
					if ing.name == kind[level].name then
						f = true
						ing.amount = ing.amount+kind[level].quant[left]
						break
					end
				end
				if not f then
					c[#c+1]={type="item",name=kind[level].name,amount=kind[level].quant[left]}
				end
			end
		end
	end
	if slots > 1 then c[#c+1]={type="item",name="omni-generator-eff-"..efficiency.."-slot-"..(slots-1),amount=1} end
	if efficiency > 1 then c[#c+1]={type="item",name="omni-generator-eff-"..(efficiency-1).."-slot-"..slots,amount=1} end
	reactor[#reactor+1]={
		type = "recipe",
		name = "omni-generator-eff-"..efficiency.."-slot-"..slots,
		localised_name={"equipment-name.omni-generator",{"eff-slot-lookup.eff-"..efficiency},{"eff-slot-lookup.slot-"..slots}},
		icon = "__omnimatter_logistics__/graphics/icons/reactor/"..(efficiency-1).."-"..(slots-1)..".png",
		icon_size = 32,
		subgroup = "omni-generator",
		order = "g[hydromnic-acid]",
		energy_required = 10,
		enabled = false,
		ingredients = c,
		results =
		{
		  {type = "item", name = "omni-generator-eff-"..efficiency.."-slot-"..slots, amount = 1},
		},
	}
	if efficiency > 1 then omni.marathon.equalize("omni-generator-eff-"..(efficiency-1).."-slot-"..slots,"omni-generator-eff-"..efficiency.."-slot-"..slots) end
	if slots > 1 then omni.marathon.equalize("omni-generator-eff-"..efficiency.."-slot-"..(slots-1),"omni-generator-eff-"..efficiency.."-slot-"..slots) end
	end
end
for efficiency=1,nr_reactors do
	local req = {}
	if efficiency == 1 then req[#req+1]="omniquipment-basic" else req[#req+1]="omnireactor-effiency-"..efficiency-1 end
	reactor[#reactor+1]={ 
    type = "technology",
	name = "omnireactor-effiency-"..efficiency,
	localised_name={"technology-name.omnireactor-efficiency",efficiency},
    icon = "__omnimatter_logistics__/graphics/technology/generator-effiency.png",
	icon_size = 128,
	prerequisites = req,
    effects =
    {
    },
    unit =
    {
      count = 250+100*(math.pow(2,efficiency-1)-1),
      ingredients = {
	  {"automation-science-pack", 1},
	  {"logistic-science-pack", 1},
	  },
      time = 60
    },
    order = "c-a"
    }
end
for slots=1,nr_slots do
	local req = {}
	if slots == 1 then req[#req+1]="omniquipment-basic" else req[#req+1]="omnireactor-slots-"..slots-1 end
	reactor[#reactor+1]={ 
    type = "technology",
	name = "omnireactor-slots-"..slots,
	localised_name={"technology-name.omnireactor-slots",slots},
    icon = "__omnimatter_logistics__/graphics/technology/generator-slots.png",
	icon_size = 128,
	prerequisites = req,
    effects =
    {
    },
    unit =
    {
      count = 250+100*(math.pow(2,slots-1)-1),
      ingredients = {
	  {"automation-science-pack", 1},
	  {"logistic-science-pack", 1},
	  },
      time = 60
    },
    order = "c-a"
    }
end
data:extend(reactor)