--Loop through all of the items in the category

function extraction_value(levels, grade)
    return (8 * levels + 5 * grade - 13) * (3 * levels + grade - 4) / (4 * math.pow(levels - 1, 2))
end

local reqpure = function(tier,level,item)
    local req = {}
    if (level%omni.pure_levels_per_tier == 1 or omni.pure_levels_per_tier == 1) and ((level-1)/omni.pure_levels_per_tier + tier - 1) <= omni.max_tier then
        req[#req+1]="omnitech-omnitractor-electric-"..(level-1)/omni.pure_levels_per_tier + tier - 1
    elseif level > 1 then
        req[#req+1]="omnitech-extraction-"..item.."-"..(level-1)
    end
    return req
end

local function tech_cost(levels,grade,tier)
    return omni.lib.round(20*math.pow(omni.pure_tech_tier_increase,tier)*omni.matter.get_tier_mult(levels,grade,1))
end

local get_omnimatter_split = function(tier,focus,level)
    local source = table.deepcopy(omni.matter.omnisource[tostring(tier)])
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
                ore.amount = 2+level/omni.impure_levels
                -- Make the focus first in the list
                if I ~= 1 then
                    split_ores[1], split_ores[I] = ore, split_ores[1]
                end
                split_ores[1] = table.deepcopy(result_round(ore))
            else
                ore.amount = focus and (2-level/omni.impure_levels) or 4 / math.max(2, total_quantity * ore.amount)
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
    local ore_icon = table.deepcopy(omni.lib.icon.of(ore.name, "item"))
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
    local ore_icon = table.deepcopy(omni.lib.icon.of(ore.name, "item"))
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
for n, ore in pairs(omni.matter.omnitial) do
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
for i, tier in pairs(omni.matter.omnisource) do
    for ore_name, ore in pairs(tier) do
        --Check for hidden flag to skip later
        
        local item = ore.name
        local tier_int = tonumber(i) + 1
        
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
for _,ore_tiers in pairs(omni.matter.omnisource) do
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
        local icons = omni.lib.icon.of("omnite", "item")
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
                omni.lib.icon.of(split[I].name, "item"),
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
        for l=1,omni.impure_levels do
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
                    RecGen:create("omnimatter", "omnirec-focus-" .. j .. "-" .. ore.name .. "-" .. omni.lib.alpha(i)):
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
	for j, tier in pairs(omni.matter.omnisource) do
        local tier_int = tonumber(j)
		if tier_int < i and tier_int >= i-3 then
			for _,ore in pairs(tier) do
				r[#r+1] = "omnitech-extraction-"..ore.name.."-"..omni.pure_levels_per_tier * (i-ore.tier-1) + omni.pure_levels_per_tier
			end
		end
		if tier_int == i then
			for _,ore in pairs(tier) do
				r[#r+1] = "omnitech-focused-extraction-"..ore.name.."-"..omni.impure_levels
			end
		end
	end
	return r
end

for i=1, omni.max_tier, 1 do
    omni.lib.add_prerequisite("omnitech-omnitractor-electric-"..i, get_tractor_req(i))
end