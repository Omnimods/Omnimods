    --Loop through all of the items in the category
	
local ord={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r"}

function extraction_value(levels,grade)
	return (8*levels+5*grade-13)*(3*levels+grade-4)/(4*math.pow(levels-1,2))
end

local get_item_icons = function(item,tier)
    --Build the icons table
    local icons = {}
    if item.icons then
        for _ , icon in pairs(item.icons) do
            icons[#icons+1] = icon
        end
    else
        icons[#icons+1] = {icon = item.icon}
    end
    return icons
end
local get_tech_icons = function(item)
    --Build the icons table
    local icon = ""
    if not item.mod then
		icon = "__omnimatter__"
	else
		icon = "__"..item.mod.."__"
	end
	icon=icon.."/graphics/extraction/"..item.ore.name..".png"
    return icon
end

local reqpure = function(tier,level,item)
	local req = {}
	if level%omni.pure_levels_per_tier==1 or omni.pure_levels_per_tier==1 then
		req[#req+1]="omnitractor-electric-"..(level-1)/omni.pure_levels_per_tier+tier
		if level > 1 and omni.pure_dependency < omni.pure_levels_per_tier then
			req[#req+1]="omnitech-extraction-"..item.."-"..(level-1)
		end
	elseif level > 1 then
		req[#req+1]="omnitech-extraction-"..item.."-"..(level-1)
	end
	if omni.impure_dependency<omni.impure_levels_per_tier and level==1 then
		req[#req+1]="omnitech-focused-extraction-"..item.."-"..omni.impure_levels_per_tier
	end
	return req
end

local techcost = function(levels, grade,tier)
	local c = {}
	local size = tier+((lvl-1)-(grade-1)%(levels/pure_levels_per_tier))/omni.pure_levels_per_tier
	local length = math.min(size,#omni.sciencepacks)
	for l=1,length do
		local q = 0
		if omni.linear_science then
			q = 1+omni.science_constant*(size-l)
		else
			q=round(math.pow(omni.science_constant,size-l))
		end
		c[#c+1] = {omni.sciencepacks[l],q}
	end
	return c
end

local function tech_cost(levels,grade,tier)
	return omni.lib.round(25*math.pow(omni.pure_tech_tier_increase,tier)*get_tier_mult(levels,grade,1))
end


local impure_icons =function(t,kind)
    local icons = {}
	if kind then
		
		icons[#icons+1] = {icon = kind.icon}
		icons[#icons+1] = {icon = "__omnimatter__/graphics/icons/specialized-impure-extraction.png"}
		--icons[#icons+1] = {icon = "__omnimatter__/graphics/icons/extraction-"..t..".png"}
	else
		icons[#icons+1] = {icon = "__omnimatter__/graphics/icons/omnite.png"}
		icons[#icons+1] = {icon = "__omnimatter__/graphics/icons/extraction-"..t..".png"}
	end
    return icons
end

local get_impurities = function(ore,tier)
	local tierores = {}
	for _,o in pairs(omnisource) do
		if o.tier == tier and o.ore.name ~= ore then
			tierores[#tierores+1]=o.ore.name
		end
	end
	local pickedores = {ore}
	local c=math.random(12)
	if ore then c=string.byte(ore,math.random(string.len(ore)))%12 end
	math.randomseed(c+omni.impure_levels_per_tier*omni.impure_dependency-omni.pure_levels_per_tier+tier*#tierores)
	while #tierores>0 and #pickedores<4 do
		local pick = math.random(1,#tierores)
		pickedores[#pickedores+1]=tierores[pick]
		table.remove(tierores,pick)
		----log("in loop tier count: "..#tierores)
	end
	return pickedores
end
local proper_result = function(tier, level,focus)
	local res = {}
	local impurities = get_impurities(focus,tier)
	if #impurities ~=1 then
		if level == 0 then
			local avg = 2
			for _,imp in pairs(impurities) do
				local p = avg/#impurities 
				res[#res+1] = {type = "item", name = imp, amount_min = avg-1, amount_max = avg+1, probability = p}
			end
		else
			local count = #impurities+level
			local avg = level +2
			res[#res+1] = {type = "item", name = focus, amount_min = avg-1, amount_max = avg+1, probability = (level+1)/count*4/avg}
			for _,imp in pairs(impurities) do
				if imp ~= focus then
					res[#res+1] = {type = "item", name = imp, amount_min = level, amount_max = level+2, probability = 4/(count*(level+1))}
				end
			end
		end
	else
		local p = (2+2*level/omni.impure_levels_per_tier)/4
		res[#res+1] = {type = "item", name = impurities[1], amount_min = 3, amount_max = 5, probability = p}
	end
	res[#res+1]={type = "item", name = "stone-crushed", amount=6}
	return res
end

local get_omnimatter_split = function(tier,focus,level)
	local source = table.deepcopy(omnisource[tostring(tier)])
	-- How many ores we try to assign per group
	local prime_splits={4,3,5}
	if not level then prime_splits[#prime_splits+1]=6 end
	local aligned_ores = {}
	local source_count = 0
	for _,i in pairs(source) do
		-- Counts all ores if doing basic omnitraction, or all ores without the focus one if focused omnitraction
		-- Change: Not handling the focused here
		--if not level or (level and i.name ~= focus) then
			source_count = source_count+1
			aligned_ores[#aligned_ores+1] = i.name
		--end
	end
	-- If very little ores per tier, break out early
	if source_count == 0 or (source_count == 1 and not focus) then
		return {{
			result_round({name="stone-crushed",amount = 10-4/(omni.impure_levels_per_tier-(level or 0)+1),type="item"}),
			result_round({name=focus or aligned_ores[1],amount = 4/(omni.impure_levels_per_tier-(level or 0)+1),type="item"})}}
	end
	local d = 1
	local div = 0
	-- Checking which split among the prime_splits gives us the smallest number of extra ores
	for _,p in pairs(prime_splits) do
		if (source_count%p)/p < d then
			div = p
			d=source_count/p-math.floor(source_count/p)
		end
	end
	local count = source_count
	local splits = {}
	-- If we end up with extra ores, we put them to the last group
	while count ~= 0 do
		if count >= div then
			splits[#splits+1]=div
		else
			splits[#splits+1]=count
		end
		count = count-splits[#splits]
	end	
	if source_count%div < math.floor(source_count/div/2) and source_count%div ~= 0 then
		count = splits[#splits]
		local sum = 0
		splits[#splits]=nil
		while count > sum do
			sum=sum+1
			splits[sum%#splits]=splits[sum%#splits]+1
		end
	end
	local ores = {}
	local rel_count = source_count+(level or 0)
		
	-- splits is a table of integers that shows how ores are divided, e.g. {5,5} or {3,3,4}
	if source_count == 10 then
		splits = {3,3,4}
	end
	for _,s in pairs(splits) do
		local n_ore = {}
		local t_quant = 0
		if focus then
			-- Not changing the focus amount here
			--n_ore = {{name=focus,amount=level+1,type="item"}}
			t_quant=level
		end
		for i=1,s do
			--math.randomseed(#omnisource+omni.pure_levels_per_tier*omni.fluid_levels_per_tier)
			--local pick_ore = math.random(1,#aligned_ores)
			local pick_ore = 1
			t_quant=t_quant+1
			n_ore[#n_ore+1]={name=aligned_ores[pick_ore],amount=1,type="item"}
			table.remove(aligned_ores,pick_ore)
		end
		local const = rel_count/t_quant
		for _,n in pairs(n_ore) do
			n.amount = 4/t_quant*n.amount
		end
		n_ore[#n_ore+1]={name="stone-crushed",amount = 6,type="item"}
		for q, no in pairs(n_ore) do
			n_ore[q] = table.deepcopy(result_round(no))
		end
		ores[#ores+1]=table.deepcopy(n_ore)
	end
	if focus then
		-- If focused, find the group with the focused ore, change the amount to +1, make it first in the group, and return only this group
		local focus_ores = {}
		for _,ore_mix in pairs(ores) do
			for i,ore in pairs(ore_mix) do
				if ore["name"] == focus then
					-- ToDo: Need to fix the amount so the total is 10 units! Same problem with pure extractions...
					ore["amount"] = (level+1)*ore["amount"]
					table.insert(focus_ores, ore)
					for j = 1,#ore_mix do
						if j ~= i then
							table.insert(focus_ores, ore_mix[j])
						end
					end
					return {focus_ores}
				end
			end
		end
	end
	return ores
end
	--omni.pure_dependency > omni.pure_levels_per_tier
	--omni.max_tier
	
--Pure extraction
for i, tier in pairs(omnisource) do
	for ore_name, ore in pairs(tier) do
		--Check for hidden flag to skip later
		
		local item = ore.name
		local tier_int = tonumber(i)
			
		
		--local icons = get_item_icons(item,tier)
		
		--Automated subcategories
		local cost = OmniGen:create():
		setInputAmount(12):
		setYield(item):
		setIngredients("omnite"):
		setWaste("stone-crushed"):
		yieldQuant(extraction_value):
		wasteQuant(function(levels,grade) return math.max(12-extraction_value(levels,grade),0) end)
			
		local pure_ore = RecChain:create("omnimatter","extraction-"..item):
		setLocName("recipe-name.pure-omnitraction",{"item-name."..item}):
		setIngredients("omnite"):
		setIcons(item):
		setIngredients(cost:ingredients()):
		setResults(cost:results()):
		setEnabled(false):
		setCategory("omnite-extraction"):
		setSubgroup("omni-pure"):
		setMain(item):
		setLevel(3*omni.pure_levels_per_tier):
		setEnergy(function(levels,grade) return 5*(math.floor((grade-1+(tier_int-1)/2)/levels)+1) end):
		setTechIcon(ore.mod or "omnimatter","extraction-"..item):
		setTechCost(function(levels,grade) return tech_cost(levels,grade,tier_int) end):
		setTechPrereq(function(levels,grade) return reqpure(tier_int,grade,item)  end):
		setTechPacks(function(levels,grade) return math.floor((grade-1)*3/levels)+tier_int end):
		setTechLocName("pure-omnitraction",{"item-name."..item}):
		extend()
		
	end
end


--Impure recipies
for _,ore_tiers in pairs(omnisource) do
	--Base mix
	local t = 1
	for _, garbage in pairs(ore_tiers) do
		t=garbage.tier
		break
	end
	local base_split = get_omnimatter_split(t,nil,nil)
	for i,split in pairs(base_split) do
		local tc = 25*t*t
		if t==1 then tc=tc*omni.beginning_tech_help end
		local base_impure_ore = RecGen:create("omnimatter","omnirec-base-"..i.."-extraction-"..t):
		setLocName("base-impure",{t}):
		setIngredients({name="omnite",type="item",amount=10}):
		setSubgroup("omni-impure-basic"):
		setEnergy(5*(math.floor(t/2+0.5))):
		setTechUpgrade(t>1):
		setTechCost(tc):
		setEnabled(false):
		setTechPacks(math.max(1,t-1)):
		setTechIcon("omnimatter","omnimatter"):
		setIcons("omnite"):
		addIcon({icon="__omnilib__/graphics/num_"..i..".png",
			scale = 0.4375,
			shift = {-10, -10}})
		
		if t==1 then
			base_impure_ore:setCategory("omnite-extraction-both"):
			setTechPrereq(nil):
			setTechName("base-impure-extraction"):
			setTechLocName("base-omnitraction")
		else
			base_impure_ore:setCategory("omnite-extraction"):
			setTechName("omnitractor-electric-"..(t-1))
		end
		base_impure_ore:setResults(split):marathon()
		base_impure_ore:extend()
	end
	for _,ore in pairs(ore_tiers) do
		local level_splits = {}
		for l=1,omni.impure_levels_per_tier do
			level_splits[l]=get_omnimatter_split(t,ore.name,l)
		end
		for i, sp in pairs(level_splits) do
			for j,r in pairs(sp) do
				local focused_ore = RecGen:create("omnimatter","omnirec-focus-"..j.."-"..ore.name.."-"..ord[i]):
				setLocName("impure-omnitraction",{"item-name."..ore.name}):
				setIngredients({name="omnite",type="item",amount=10}):
				setSubgroup("omni-impure"):
				setEnergy(5*(math.floor(t/2+0.5))):
				setIcons("omnite"):
				setEnabled(false):
				addIcon({icon=ore.name,
				scale = 0.4375,
				shift = {10, 10}}):
				addBlankIcon():
				setTechName("omnitech-focused-extraction-"..ore.name.."-"..i):
				setTechCost(25*i*t):
				setTechLocName("impure-omnitraction","item-name."..ore.name,i):
				setTechPacks(math.max(1,t)):
				setTechIcon(ore.mod or "omnimatter","impure_"..ore.name):
				marathon()
				
				if #sp > 1 then
					focused_ore:addIcon({icon="__omnilib__/graphics/num_"..j..".png",
					scale = 0.6,
					shift = {-10, -10}})
				end
				
				if t==1 then
					focused_ore:setCategory("omnite-extraction-both")
				else
					focused_ore:setCategory("omnite-extraction")
				end
				if i==1 and t==1 then
					focused_ore:setTechPrereq("base-impure-extraction")
				elseif i == 1 then
					focused_ore:setTechPrereq("omnitractor-electric-"..t-1)
				else
					focused_ore:setTechPrereq("omnitech-focused-extraction-"..ore.name.."-"..(i-1))
				end
				focused_ore:setResults(r)
				focused_ore:extend()
			end
		end
	end	
	--local icons = impure_icons(t)	
	--impure_extraction_recipes[#impure_extraction_recipes+1] = extraction
end

	--  {type = "item", name = "angels-ore1", amount_min = 6, amount_max = 10, probability = 0.75},
	--  {type = "item", name = "stone-crushed", amount_min = 4, amount_max = 8, probability = 1.00},
	
	