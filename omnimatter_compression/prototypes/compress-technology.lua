
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

local pack_sizes={}
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
    if proto and not pack_sizes[ing] then --only add it if it does not already exist (should save a few microns)
      if data.raw.tool[ing].stack_size then
        pack_sizes[ing]=data.raw.tool[ing].stack_size
      elseif data.raw.item[ing].stack_size then
        pack_sizes[ing]=data.raw.item[ing].stack_size
      end
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

local tiered_tech = {}
--find lowest level that gets compressed
for _,tech in pairs(data.raw.technology) do --run always
local lvl = string.match(tech.name,".*%-(%d*)") 
local name = string.match(tech.name,"(.*)%-%d*")
  if lvl ~="" and lvl ~=nil and containsOne(tech.unit.ingredients,alwaysSP) then
    if not omni.lib.is_in_table(name,tiered_tech) then
      tiered_tech[name] = lvl
    elseif tiered_tech[name].value < lvl then --in case techs are added out of order, always add the lowest
      tiered_tech[name] = lvl
    end
  end
end
--fix odd bob tech behaviour, may need to automate a check for previous tech level ingredients
--local included_techs={"bob-laser-turrets-3","bob-plasma-turrets-3","bob-turrets-4"}
local include_techs = function(t)
  --extract name and level
  local lvl = string.match(t.name,".*%-(%d*)") 
  local name = string.match(t.name,"(.*)%-%d*")
  --check if in table and lvl > min lvl
  if omni.lib.is_in_table(name,tiered_tech) then
    if lvl > tiered_tech[name].value then
      return true
    end
  end
  return false
end

for _,tech in pairs(data.raw.technology) do
  if tech.unit and ((tech.unit.count and type(tech.unit.count)=="number" and tech.unit.count > settings.startup["omnicompression_compressed_tech_min"].value) or not tech.unit.count or containsOne(tech.unit.ingredients,alwaysSP) or include_techs(tech)) then
    --fetch original
    local t = table.deepcopy(tech)
    t.name="omnipressed-"..t.name
    local loc_key = tech.localised_name --or {"technology-name.compressed", omni.compression.CleanName(tech.name)}
    --clean up localisation issues, or use name string
    if not loc_key then
      local name=""
      if t.max_level then --tiered techs
        name = string.match(tech.name,"(.*)%-%d*")
      else
        name = tech.name
      end
      loc_key = {"technology-name.compressed",omni.compression.CleanName(name)}
    end
    t.localised_name = loc_key
    log(serpent.block(loc_key))
    --lowest common multiple for the packs
		local lcm = 1
    for _, ings in pairs(t.unit.ingredients) do
      local st_s=pack_sizes[ings[1] or ings.name]
      --local item = data.raw.tool[ings[1]]
			lcm=omni.lib.lcm(lcm,(ings[2] or ings.amount)*st_s)
    end
    local wrong = false
    --set compressed ingredients and amounts
    for num,ing in pairs(t.unit.ingredients) do
      local nme="" --get name string prepped
      if ing.name then
        mne=ing.name
      else
        nme=ing[1]
      end
      local st_s=pack_sizes[nme]
      local amt={} --get amount sorted out
      if ing.amount then
        amt=ing.amount
      else 
        amt=ing[2]
      end 
      --check if compressed tool exists (it had bloody better)
      if data.raw.tool["compressed-"..nme] then
        ing={} --reset ing for this next step
        ing[1] = "compressed-"..nme
        ing[2] = lcm/(amt*st_s)
      else
        log("compressed tool missing?"..nme)
        wrong=true
        break
      end
      t.unit.ingredients[num]=ing
    end
    --if valid remove effects from compressed and update cost curve
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
