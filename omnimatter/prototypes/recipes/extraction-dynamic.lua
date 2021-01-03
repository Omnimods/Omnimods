--Loop through all of the items in the category

local ord = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r"}

function extraction_value(levels, grade)
    return (8 * levels + 5 * grade - 13) * (3 * levels + grade - 4) / (4 * math.pow(levels - 1, 2))
end

local reqpure = function(tier,level,item)
    local req = {}
    if level%omni.pure_levels_per_tier==1 or omni.pure_levels_per_tier==1 then
        req[#req+1]="omnitech-omnitractor-electric-"..math.min((level-1)/omni.pure_levels_per_tier+tier, omni.max_tier)
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

-- local techcost = function(levels, grade,tier)
--     local c = {}
--     local size = tier+((lvl-1)-(grade-1)%(levels/pure_levels_per_tier))/omni.pure_levels_per_tier
--     local length = math.min(size,#omni.sciencepacks)
--     for l=1,length do
--         local q = 0
--         if omni.linear_science then
--             q = 1+omni.science_constant*(size-l)
--         else
--             q=round(math.pow(omni.science_constant,size-l))
--         end
--         c[#c+1] = {omni.sciencepacks[l],q}
--     end
--     return c
-- end

local function tech_cost(levels,grade,tier)
    return omni.lib.round(20*math.pow(omni.pure_tech_tier_increase,tier)*get_tier_mult(levels,grade,1))
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
    for _,o in pairs(omni.omnisource) do
        if o.tier == tier and o.ore.name ~= ore then
            tierores[#tierores+1]=o.ore.name
        end
    end
    local pickedores = {ore}
    local c = math.random(12)
    if ore then
        c = string.byte(ore, math.random(string.len(ore))) % 12
    end
    math.randomseed(
        c + omni.impure_levels_per_tier * omni.impure_dependency - omni.pure_levels_per_tier + tier * #tierores
    )
    while #tierores > 0 and #pickedores < 4 do
        local pick = math.random(1, #tierores)
        pickedores[#pickedores + 1] = tierores[pick]
        table.remove(tierores, pick)
        --log("in loop tier count: " .. #tierores)
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
    local source = table.deepcopy(omni.omnisource[tostring(tier)])
    level = level or 0
    local aligned_ores = {}
    local source_count = table_size(source)
    for a, i in pairs(source) do
        -- Build a table of our ore names
        aligned_ores[i.name] = true
    end
    -- splits is a table of integers that shows how ores are divided between recipes, e.g. {5,5} or {3,3,4}
    local splits = {}
    local divisor = math.min(math.ceil(source_count / 3), 5)
    local quotient = source_count / divisor
    local remainder = source_count % divisor
    for index = 1, divisor do
        if index <= remainder then
            splits[#splits + 1] = math.ceil(quotient)
        else
            splits[#splits + 1] = math.floor(quotient)
        end
    end
    local ores = {}
    -- Add the proper number of products to our extraction recipe
    for _, rec_index in pairs(splits) do
        local split_ores = {}
        local total_quantity = level + (focus and 1 or 0)
        if focus and aligned_ores[focus] then
            split_ores[#split_ores + 1] = {
                name = focus,
                amount = 1,
                type = "item"
            }
            aligned_ores[focus] = nil
        end
        for current in pairs(aligned_ores) do
            if rec_index > #split_ores then 
                total_quantity = total_quantity + 1
                split_ores[#split_ores + 1] = {
                    name = current,
                    amount = 1,
                    type = "item"
                }
                aligned_ores[current] = nil
            else
                break
            end
        end
        -- Adjust by total count + level
        local stone_amount = 10
        for I = 1, #split_ores do
            local ore = split_ores[I]
            -- Handle "focus"
            if focus and ore.name == focus then
                ore.amount = 2+level/omni.impure_levels_per_tier
                -- Make the focus first in the list
                if I ~= 1 then
                    split_ores[1], split_ores[I] = ore, split_ores[1]
                end
                split_ores[1] = table.deepcopy(result_round(ore))
            else
                ore.amount = focus and (2-level/omni.impure_levels_per_tier) or 4 / math.max(2, total_quantity * ore.amount)
                split_ores[I] = table.deepcopy(result_round(ore))
            end
            stone_amount = stone_amount - ore.amount
        end
        -- Add our stone post-adjustment
        split_ores[#split_ores + 1] =
            result_round(
            {
                name = "stone-crushed",
                amount = stone_amount,
                type = "item"
            }
        )
        -- Focused?
        if focus then
            return {split_ores}
        else
            -- Enter into our table
            ores[#ores + 1] = split_ores
        end
    end
    return ores
end

local function generate_impure_icon(ore)
    local ore_icon = table.deepcopy(omni.icon.of(ore.name, "item"))
    for _, layer in pairs(ore_icon) do
        layer.shift = {
            5 * (64 / layer.icon_size),
            (layer.icon_size * 0.5 + 5) * (64 / layer.icon_size)
        }
    end
    return omni.lib.add_overlay(
        {{
            icon = "__omnimatter__/graphics/technology/omnimatter.png",
            icon_size = 128
        }},
        ore_icon
    )
end

local function generate_pure_icon(ore)
    local ore_icon = table.deepcopy(omni.icon.of(ore.name, "item"))
    for _, layer in pairs(ore_icon) do
        layer.shift = {
            0,
            layer.icon_size * 0.5 * (64 / layer.icon_size)
        }
    end
    return omni.lib.add_overlay(
        {{
            icon = "__omnimatter__/graphics/technology/extraction-generic.png",
            icon_size = 128
        }},
        ore_icon
    )
end

--Initial omnitraction
for n, ore in pairs(omni.omnitial) do
	RecGen:create("omnimatter","initial-omnitraction-" .. n):
		setCategory("omnite-extraction-burner"):
		setEnergy(5):
		setEnabled(true):
		noItem():
		setSubgroup("omni-basic"):
		setIngredients(ore.ingredients):
		setResults(ore.results):
		setIcons(n):
		marathon():
		setLocName("recipe-name.initial-omni","item-name."..n):
		addSmallIcon("stone-crushed", 3):
		extend()
end

--Pure extraction
for i, tier in pairs(omni.omnisource) do
    for ore_name, ore in pairs(tier) do
        --Check for hidden flag to skip later
        
        local item = ore.name
        local tier_int = tonumber(i)
        
        --Automated subcategories
        local cost = (
            OmniGen:create():
            setInputAmount(12):
            setYield(item):
            setIngredients("omnite"):
            setWaste("stone-crushed"):
            yieldQuant(extraction_value):
            wasteQuant(
                function(levels, grade)
                    return math.max(12 - extraction_value(levels, grade), 0)
                end
            )
        )
        local function get_desc(levels,grade)
            local desc = ""
            local costres =cost:results()
            local res =costres(levels, grade)
            for j, part in pairs(res) do
                desc = desc.."[img=item."..part.name.."] x "..string.format("%.2f",part.amount * (part.probability or 1))
                if j<#res then desc = desc.."\n" end
            end
            return desc
        end

        local pure_ore = (
            RecChain:create("omnimatter", "extraction-" .. item):
            setLocName("recipe-name.pure-omnitraction", {"item-name." .. item}):
            setLocDesc(function(levels, grade) return get_desc(levels,grade) end):
            setIngredients("omnite"):
            setIcons(item):
            setIngredients(cost:ingredients()):
            setResults(cost:results()):
            setEnabled(false):
            setCategory("omnite-extraction"):
            setSubgroup("omni-pure"):
            setMain(item):
            setLevel(3 * omni.pure_levels_per_tier):
            setEnergy(
                function(levels, grade)
                    return 5 * (math.floor((grade - 1 + (tier_int - 1) / 2) / levels) + 1)
                end):
            setTechIcons(generate_pure_icon(ore)):
            setTechCost(
                function(levels, grade)
                    return tech_cost(levels, grade, tier_int)
                end):
            setTechPrereq(
                function(levels, grade)
                    return reqpure(tier_int, grade, item)
                end):
            setTechPacks(
                function(levels, grade)
                    return math.floor((grade - 1) * 3 / levels) + tier_int
                end):
            setTechLocName("omnitech-pure-omnitraction", {"item-name." .. item}):extend()
        )
    end
end

--Impure recipes
for _,ore_tiers in pairs(omni.omnisource) do
    --Base mix
    local t = select(2, next(ore_tiers)).tier
    local base_split = get_omnimatter_split(t, nil, nil)
    for i, split in pairs(base_split) do
        local tc = 25 * t * t
        if t == 1 then
            tc = tc * omni.beginning_tech_help
        end
        local result_names = " "
        local desc = ""
        local icons = omni.icon.of("omnite", "item")
        icons[1].tint = {1,1,1,0.8}-- Just a canvas but we want the right size
        local item_count = #split-1
        for I=1, #split do
            --Add crushed stone to the recipe description and jump the rest
            desc = desc.."[img=item." .. split[I].name .. "] x "..string.format("%.2f",split[I].amount * (split[I].probability or 1))
            if I < #split then desc = desc.."\n" end
            if I == #split then goto continue end

            result_names = result_names .. "[img=item." .. split[I].name .. "]/"
            local deg = (I / item_count * 360)+90 -- Offset a bit
            deg = math.rad(deg % 360)
            icons = util.combine_icons(
                icons,
                omni.icon.of(split[I].name, "item"),
                {
                    scale = 0.5,
                    shift = {
                        math.cos(deg) * icons[1].icon_size * 0.33,
                        math.sin(deg) * icons[1].icon_size * 0.33
                    }
                }
            )
            ::continue::
        end
        result_names = result_names:sub(1, -2)
        local base_impure_ore = (
            RecGen:create("omnimatter", "omnirec-base-" .. i .. "-extraction-" .. t):
            setLocName("recipe-name.base-impure", {"", result_names}):
            setLocDesc(desc):
            setIngredients(
                {name = "omnite", type = "item", amount = 10}
            ):
            setSubgroup("omni-impure-basic"):
            setEnergy(5 * (math.floor(t / 2 + 0.5))):
            setTechUpgrade(t > 1):
            setTechCost(tc):
            setEnabled(false):
            setTechPacks(math.max(1, t - 1)):
            setTechIcons("omnimatter", "omnimatter"):
            setIcons(icons)--[[:addIcon(
                {
                    icon = "__omnilib__/graphics/icons/small/num_" .. i .. ".png",
                    scale = 0.4375,
                    shift = {-10, -10}
                }
            )]]
        )
        if t == 1 then
            base_impure_ore:setCategory("omnite-extraction-both"):
            setTechPrereq(nil):
            setTechName("omnitech-base-impure-extraction"):
            setTechLocName("omnitech-base-omnitraction")
        else
            base_impure_ore:setCategory("omnite-extraction"):
            setTechName("omnitech-omnitractor-electric-" .. (t - 1))
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
            for j, r in pairs(sp) do
                local desc = ""
                for j, part in pairs(r) do
                    desc = desc.."[img=item."..part.name.."] x "..string.format("%.2f",part.amount * (part.probability or 1))
                    if j<#r then desc = desc.."\n" end
                end
                local focused_ore =
                (
                    RecGen:create("omnimatter", "omnirec-focus-" .. j .. "-" .. ore.name .. "-" .. ord[i]):
                    setLocName("recipe-name.impure-omnitraction", {"item-name." .. ore.name}):
                    setLocDesc(desc):
                    setIngredients({name = "omnite", type = "item", amount = 10}):
                    setSubgroup("omni-impure"):
                    setEnergy(5 * (math.floor(t / 2 + 0.5))):
                    setIcons("omnite"):
                    setEnabled(false):
                    addIcon(
                    {
                        icon = ore.name,
                        scale = 0.4375,
                        shift = {10, 10}
                    }):
                    addBlankIcon():
                    setTechName("omnitech-focused-extraction-" .. ore.name .. "-" .. i):
                    setTechCost(25 * i * t):
                    setTechLocName(
                        "omnitech-impure-omnitraction",
                        "item-name." .. ore.name,
                        i
                    ):
                    setTechPacks(math.max(1, t)):
                    setTechIcons(generate_impure_icon(ore)):
                    marathon()
                )
                if #sp > 1 then
                    focused_ore:addIcon({icon="__omnilib__/graphics/icons/small/num_"..j..".png",
                    scale = 0.6,
                    shift = {-10, -10}})
                end
                if t == 1 then
                    focused_ore:setCategory("omnite-extraction-both")
                else
                    focused_ore:setCategory("omnite-extraction")
                end
                if i==1 and t==1 then
                    focused_ore:setTechPrereq("omnitech-base-impure-extraction")
                elseif i == 1 then
                    focused_ore:setTechPrereq("omnitech-omnitractor-electric-"..t-1)
                else
                    focused_ore:setTechPrereq("omnitech-focused-extraction-"..ore.name.."-"..(i-1))
                end
                focused_ore:setResults(r)
                focused_ore:extend()
            end
        end
    end
end

--Set omnitractor extraction prereqs
local function get_tractor_req(i)
	local r = {}
	for j,tier in pairs(omni.omnisource) do
		if tonumber(j) < i and tonumber(j) >= i-3 then
			for _,ore in pairs(tier) do
				r[#r+1]="omnitech-extraction-"..ore.name.."-"..omni.pure_levels_per_tier*(i-ore.tier-1)+omni.pure_dependency
			end
		end
		if tonumber(j) == i then
			for _,ore in pairs(tier) do
				r[#r+1]="omnitech-focused-extraction-"..ore.name.."-"..omni.impure_dependency
			end
		end
	end
	if i>1 and i*omni.fluid_levels_per_tier < omni.fluid_levels then
		--r[#r+1]="omnitech-solvation-omniston-"..(i-2)*omni.fluid_levels_per_tier+omni.fluid_dependency
		--r[#r+1]="omnitech-omnic-acid-hydrolyzation-"..(i-2)*omni.fluid_levels_per_tier+omni.fluid_dependency
		--r[#r+1]="omnitech-omnisolvent-omnisludge-"..(i-2)*omni.fluid_levels_per_tier+omni.fluid_dependency
	end
	if i == 2 then
		if data.raw.technology["omnitech-omnisolvent-omnisludge-"..(i-2)] then
			r[#r+1]="omnitech-omnisolvent-omnisludge-"..(i-2)*omni.fluid_levels_per_tier+omni.fluid_dependency
		end
	end
	for j,tier in pairs(omni.omnifluid) do
		if tonumber(j) < i and tonumber(j) >= i-3 then
			for _,fluid in pairs(tier) do
				if omni.fluid_levels_per_tier*(i-fluid.tier-1)+omni.fluid_dependency <= omni.fluid_levels then
					r[#r+1]="omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels_per_tier*(i-fluid.tier-1)+omni.fluid_dependency
				elseif omni.fluid_levels_per_tier*(i-fluid.tier-1)+omni.fluid_dependency > omni.fluid_levels then
					r[#r+1]="omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels
				end
			end
		end
	end
	return r
end

for i=1,omni.max_tier,1 do
    omni.lib.add_prerequisite("omnitech-omnitractor-electric-"..i, get_tractor_req(i))
end