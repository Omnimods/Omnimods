if not omni then omni={} end
if not omni.fluid then omni.fluid={} end

forbidden_boilers={}
forbidden_assembler={}
forbidden_recipe={}

function omni.fluid.excempt_boiler(boiler)
	forbidden_boilers[boiler]=true
end

function omni.fluid.excempt_assembler(boiler)
	forbidden_assembler[boiler]=true
end

function omni.fluid.excempt_recipe(boiler)
	forbidden_recipe[boiler]=true
end
local fluid_solid = {}

function omni.fluid.SetRoundFluidValues()
	local top_value = 500000
	local roundFluidValues = {}
	local b,c,d = math.log(5),math.log(3),math.log(2)
	for i=0,math.floor(math.log(top_value)/b) do
		local pow5 = math.pow(5,i)
		for j=0,math.floor(math.log(top_value/pow5)/c) do
			local pow3=math.pow(3,j)
			for k=0,math.floor(math.log(top_value/pow5/pow3)/d) do
				roundFluidValues[#roundFluidValues+1] = pow5*pow3*math.pow(2,k)
			end
		end
	end
	table.sort(roundFluidValues)
	return(roundFluidValues)
end

function omni.fluid.round_fluid1(nr)
	local t = omni.lib.round(nr)
	local mod={30,20,15, 12, 10,6}
	local pick = 1
	local dif = 1
	for j,m in pairs(mod) do
		local ch = t%m
		if math.min(ch,m-ch)/m < dif then
			pick = m
			dif = math.min(ch,m-ch)/m
		end
	end
	local val = 0
	local ch = t%pick
	if pick-ch < ch then val = t+pick-ch else val = t-ch end
	local newval = val
	for p,inner in pairs(primeRound) do
		local prime = tonumber(p)
		if val%prime == 0 then
			local cval= newval/prime
			if cval * inner.above-newval < newval-cval * inner.below then
				newval = newval / prime * inner.above
			else
				newval = newval / prime * inner.above
			end
		end
	end
	return math.max(newval,60)
end

function omni.fluid.round_fluid(nr,round)
	roundFluidValues=omni.fluid.SetRoundFluidValues()
	local t = omni.lib.round(nr)
	local newval = t
	for i=1,#roundFluidValues-1 do
		if roundFluidValues[i]< t and roundFluidValues[i+1]>t then
			if t-roundFluidValues[i] < roundFluidValues[i+1]-t then
				local c = 0
				if roundFluidValues[i] ~= t and round == 1 then c=1 end
				newval = roundFluidValues[i+c]
			else
				local c = 0
				if roundFluidValues[i+1] ~= t and round == -1 then c=-1 end
				newval = roundFluidValues[i+1+c]
			end
		end
	end
	return math.max(newval,10)
end

function omni.fluid.convert_mj(value)
	local unit = string.sub(value,string.len(value)-1,string.len(value)-1)
	local val = tonumber(string.sub(value,1,string.len(value)-2))
	if unit == "K" or unit == "k" then
		return val/1000
	elseif unit == "M" then
		return val
	elseif unit=="G" then
		return val*1000
	elseif tonumber(unit) ~= nil then
		return tonumber(string.sub(value,1,string.len(value)-1))
	end
end
function omni.fluid.get_icons(item)
	--Build the icons table
	local icons={}
	if item.icons then
		icons=item.icons
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
		icons[1] = {icon = item.icon, icon_size = item.icon_size or 32}
	end
	return icons
end
function omni.fluid.has_fluid(recipe)
	for _,ingres in pairs({"ingredients","results"}) do
		for _,component in pairs(recipe.normal[ingres]) do
			if component.type == "fluid" then return true end
		end
	end
	return false
end
