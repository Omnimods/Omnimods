
local lab_inputs = {}
--log("begin tech compression")
local has_input  = function(tab)
	local  found = false
	for _, li in pairs(lab_inputs) do
		local has_all = true
		for _,e in pairs(tab) do
			if not omni.lib.is_in_table(e,li) then
				has_all=false
				break
			end
		end
		if has_all then
			found = true
			break
		end
	end
	return found
end
local compressed_techs={}

for _, lab in pairs(data.raw.lab) do
	local l = table.deepcopy(lab)
	if not has_input(lab.inputs) then
		lab_inputs[#lab_inputs+1]=lab.inputs
	end
	for _, ing in pairs(lab.inputs) do
		local hidden = false
		local proto = omni.lib.find_prototype(ing)
		if proto then
			for _, flag in ipairs(proto.flags or {}) do
				if flag == "hidden" then hidden = true end
			end
		end
		if proto and data.raw.tool["compressed-"..ing] and not omni.lib.start_with(ing,"compressed") and not omni.lib.is_in_table("compressed-"..ing,lab.inputs) and not hidden then
			table.insert(lab.inputs,"compressed-"..ing)
		end
	end
	--compressed_techs[#compressed_techs+1]=l
end

local alwaysSP = omni.lib.split(settings.startup["omnicompression_always_compress_sp"].value,",")

local containsOne = function(t,d)
	for _,p in pairs(t) do
		for _,q in pairs(d) do
			if p[1]==q then return true end
		end
	end
	return false
end

for _,tech in pairs(data.raw.technology) do
	if tech.unit and ((tech.unit.count and type(tech.unit.count)=="number" and tech.unit.count > settings.startup["omnicompression_compressed_tech_min"].value) or not tech.unit.count or containsOne(tech.unit.ingredients,alwaysSP)) then
		local t = table.deepcopy(tech)
		t.name=t.name.."-omnipressed"
		t.localised_name = t.localised_name or {"technology-name.compressed", omni.compression.CleanName(tech.name)}
		local lcm = 1
		for _, ing in pairs(t.unit.ingredients) do
			local item = data.raw.tool[ing[1]]
			lcm=omni.lib.lcm(lcm,ing[2]*item.stack_size)
		end
		local wrong = false
		for _, ing in pairs(t.unit.ingredients) do
			if data.raw.tool["compressed-"..ing[1]] then
				local item = data.raw.tool[ing[1]]
				ing[2]=lcm/(ing[2]*item.stack_size)
				ing[1]="compressed-"..ing[1]
			else
				wrong=true
				break
			end
		end
		if not wrong then
			if t.effects then
				for i, eff in pairs(t.effects) do
					if eff.type ~= "unlock-recipe" then t.effects[i] = nil end
				end
			end
			if t.unit.count then
				t.unit.count = math.floor(t.unit.count/lcm)+1
			else
				t.unit.count_formula = t.unit.count_formula.."*"..(math.floor(10000/lcm)/1000).."+1"
			end
			t.unit.time = t.unit.time*lcm
			compressed_techs[#compressed_techs+1]=table.deepcopy(t)
		end
	end
end
--log("end tech compression")
data:extend(compressed_techs)
