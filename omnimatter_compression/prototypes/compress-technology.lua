-------------------------------------------------------------------------------
--[[Local Declarations]]--
-------------------------------------------------------------------------------
local lab_inputs = {}
local compressed_techs={}
local pack_sizes={}
local tiered_tech = {}
local alwaysSP = omni.lib.split(settings.startup["omnicompression_always_compress_sp"].value,",")
local min_compress = settings.startup["omnicompression_compressed_tech_min"].value
-------------------------------------------------------------------------------
--[[Locally defined functions]]--
-------------------------------------------------------------------------------
-- lab input checks
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
--contains at least one of the packs
local containsOne = function(t,d)
	for _,p in pairs(t) do
		for _,q in pairs(d) do
      if p[1]==q then
        return true
      elseif p.name==q then
        return true
      end
		end
	end
	return false
end
-------------------------------------------------------------------------------
--[[Set-up loops]]--
-------------------------------------------------------------------------------
log("start tech compression checks")
--add compressed packs to labs
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
end
--find lowest level in tiered techs that gets compressed to ensure chains are all compressed passed the first one
for _,tech in pairs(data.raw.technology) do --run always
local lvl = string.match(tech.name,".*%-(%d*)") 
local name = string.match(tech.name,"(.*)%-%d*")
  if lvl ~="" and lvl ~=nil and containsOne(tech.unit.ingredients,alwaysSP) then
    if not tiered_tech[name] then
      tiered_tech[name] = tonumber(lvl)
    elseif tiered_tech[name] > tonumber(lvl) then --in case techs are added out of order, always add the lowest
      tiered_tech[name] = tonumber(lvl)
    end
  end
end
--log(serpent.block(tiered_tech))
--compare tech to the list created (tiered_tech) to include techs missing packs previously in the chain
local include_techs = function(t)
  --extract name and level
  local lvl = string.match(t.name,".*%-(%d*)")
  if lvl ~="" and lvl ~=nil then
    local name = string.match(t.name,"(.*)%-%d*")
    --check if in table and lvl > min lvl
    if tiered_tech[name] then
      if tonumber(lvl) >= tiered_tech[name] then
        return true
      end
    end
  end
  return false
end
-------------------------------------------------------------------------------
--[[Compressed Tech creation]]--
-------------------------------------------------------------------------------
log("start tech compression")
for _,tech in pairs(data.raw.technology) do
  if tech.unit and ((tech.unit.count and type(tech.unit.count)=="number" and tech.unit.count > min_compress) or not tech.unit.count or containsOne(tech.unit.ingredients,alwaysSP) or include_techs(tech)) then
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
    
    --lowest common multiple for the packs
		local lcm = 1
    for _, ings in pairs(t.unit.ingredients) do
      local st_s=pack_sizes[ings.name or ings[1]]
      --local item = data.raw.tool[ings[1]]
			lcm=omni.lib.lcm(lcm,(ings.amount or ings[2])*st_s)
    end
    local wrong = false
    --set compressed ingredients and amounts
    for num,ing in pairs(t.unit.ingredients) do
      local nme="" --get name string prepped
      local amt="" --get amount sorted out
      if ing.type then
        nme=ing.name
        amt=ing.amount
      else
        nme=ing[1]
        amt=ing[2]
      end
      local st_s=pack_sizes[nme]
      --check if compressed tool exists (it had bloody better)
      if data.raw.tool["compressed-"..nme] then
        ing={} --reset ing for this next step
        ing[1] = "compressed-"..nme
        ing[2] = lcm/(amt*st_s)
      else
        log("compressed tool missing?"..nme)
        log(serpent.block(ing)) --tell log what is wrong
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

data:extend(compressed_techs)
log("end tech compression")