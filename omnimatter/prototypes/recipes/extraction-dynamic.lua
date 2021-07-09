function extraction_value(levels, grade)
    return (8 * levels + 5 * grade - 13) * (3 * levels + grade - 4) / (4 * math.pow(levels - 1, 2))
end

local reqpure = function(tier,level,item)
    local req = {}
    if (level%omni.pure_levels_per_tier == 1 or omni.pure_levels_per_tier == 1) and ((level-1)/omni.pure_levels_per_tier + tier - 1) <= omni.max_tier then
        req[#req+1]="omnitech-omnitractor-electric-"..(level-1) / omni.pure_levels_per_tier + tier
    elseif level > 1 then
        req[#req+1]="omnitech-extraction-"..item.."-"..(level-1)
    end
    return req
end

local function tech_cost(levels,grade,tier)
    return omni.lib.round(20*math.pow(omni.pure_tech_tier_increase,tier)*omni.matter.get_tier_mult(levels,grade,1))
end

local function generate_impure_icon(ore_name)
    local ore_icon = table.deepcopy(omni.lib.icon.of(ore_name, "item"))
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

local function generate_pure_icon(orename)
    local ore_icon = table.deepcopy(omni.lib.icon.of(orename, "item"))
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

--Crates a table containing splits of the given tier with their corresponding ore names
local function split_omnisource_tier(tier)
    local source = omni.matter.omnisource[tostring(tier)]
    local source_count = table_size(source)
    -- Put all ore names of source in a table
    local ore_names = {}
    for name, content in pairs(source) do
        ore_names[#ore_names+1] = content.name
    end
    
    -- "splits" is a table of integers that shows how ores are divided between recipes, e.g. {5,5} or {3,3,4}
    local splits = {}
    local split_size = math.min(math.ceil(source_count / 3), 5)--4
    local total_splits = source_count / split_size --2.5
    local remainder = source_count % split_size --2

    for index = 1, split_size do
        if index <= remainder then
            splits[#splits + 1] = math.ceil(total_splits) --3,3,2,2
        else
            splits[#splits + 1] = math.floor(total_splits)
        end
    end

    --Sort the ores of the current tier into a table according to the defined split size
    local splitted_ores = {}
    local num_ore = 1
    for splitnum = 1, #splits do --1-4
        for splitamount = 1, splits[splitnum] do --3,3,2,2
            if not splitted_ores[splitnum] then splitted_ores[splitnum] = {} end
            splitted_ores[splitnum][#splitted_ores[splitnum]+1] = ore_names[num_ore]
            num_ore = num_ore + 1
        end
    end
    return splitted_ores
end

local function build_result_table(tier, split, focused_ore_name, level)
    -- Add the proper number of products to our extraction recipe
    local split_ores = {}
    local aligned_ores = table.deepcopy(split)
    local total_quantity = level or 0 + (focused_ore_name and 1 or 0)
    --Add focused ore to the result table if it is specified
    if focused_ore_name and aligned_ores[focused_ore_name] then
        split_ores[#split_ores + 1] = {
            name = focused_ore_name,
            amount = 1,
            type = "item"
        }
        aligned_ores[focused_ore_name] = nil
    end

    --Add all other ore sto the result table
    for _,current in pairs(aligned_ores) do
        if #split > #split_ores then 
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
        -- Handle "focused_ore_name"
        if focused_ore_name and ore.name == focused_ore_name then
            ore.amount = 2+level/omni.impure_levels
            -- Make the focused_ore_name first in the list
            if I ~= 1 then
                split_ores[1], split_ores[I] = ore, split_ores[1]
            end
            split_ores[1] = table.deepcopy(result_round(ore))
        else
            ore.amount = focused_ore_name and (2-level/omni.impure_levels) or 4 / math.max(2, total_quantity * ore.amount)
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
    return split_ores       
end

local function create_base_extraction(tier, split, split_num)
    local split_results = build_result_table(tier, split, nil, nil)

    local tc = 25 * tier * tier
    if tier == 1 then
        tc = tc * omni.beginning_tech_help
    end
    local result_names = " "
    local desc = ""
    local icons = omni.lib.icon.of("omnite", "item")
    icons[1].tint = {1,1,1,0.8}-- Just a canvas but we want the right size
    local item_count = #split_results-1

    for I=1, #split_results do
        --Add crushed stone to the recipe description and jump the rest
        desc = desc.."[img=item." .. split_results[I].name .. "] x "..string.format("%.2f",split_results[I].amount * (split_results[I].probability or 1))
        if I < #split_results then desc = desc.."\n" end
        if I == #split_results then goto continue end

        result_names = result_names .. "[img=item." .. split_results[I].name .. "]/"
        local deg = (I / item_count * 360)+90 -- Offset a bit
        deg = math.rad(deg % 360)
        icons = util.combine_icons(
            icons,
            omni.lib.icon.of(split_results[I].name, "item"),
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
        RecGen:create("omnimatter", "omnirec-base-" .. split_num .. "-extraction-" .. tier):
        setLocName("recipe-name.base-impure", {"", result_names}):
        setLocDesc(desc):
        setIngredients(
            {name = "omnite", type = "item", amount = 10}
        ):
        setSubgroup("omni-impure-basic"):
        setEnergy(5 * (math.floor(tier / 2 + 0.5))):
        setTechUpgrade(tier > 1):
        setTechCost(tc):
        setEnabled(false):
        setTechPacks(math.max(1, tier - 1)):
        setTechIcons("omnimatter", "omnimatter"):
        setIcons(icons)
    )
    if tier == 1 then
        base_impure_ore:setCategory("omnite-extraction-both"):
        setTechPrereq(nil):
        setTechName("omnitech-base-impure-extraction"):
        setTechLocName("omnitech-base-omnitraction")
    else
        base_impure_ore:setCategory("omnite-extraction"):
        setTechName("omnitech-omnitractor-electric-" .. (tier - 1))
    end
    base_impure_ore:setResults(split_results):
        marathon():
        extend()     
end

local function create_impure_extraction(tier, split, ore_name)
    local level_split_results = {}
    for l=1,omni.impure_levels do
        level_split_results[l] = build_result_table(tier, split, ore_name, l)
    end
    for i, res in pairs(level_split_results) do
        local num = 1 --legacy reasons, its in all names, removing it will result in bad migration dreams
        local desc = ""
        for j, part in pairs(res) do
            desc = desc.."[img=item."..part.name.."] x "..string.format("%.2f",part.amount * (part.probability or 1))
            if j<#res then desc = desc.."\n" end
        end
        local focused_ore =
        (
            RecGen:create("omnimatter", "omnirec-focus-" .. num .. "-" .. ore_name .. "-" .. omni.lib.alpha(i)):
            setLocName("recipe-name.impure-omnitraction", {"item-name." .. ore_name}):
            setLocDesc(desc):
            setIngredients({name = "omnite", type = "item", amount = 10}):
            setSubgroup("omni-impure"):
            setEnergy(5 * (math.floor(tier / 2 + 0.5))):
            setIcons("omnite"):
            setEnabled(false):
            addIcon(
            {
                icon = ore_name,
                scale = 0.4375,
                shift = {10, 10}
            }):
            addBlankIcon():
            setTechName("omnitech-focused-extraction-" .. ore_name .. "-" .. i):
            setTechCost(25 * i * tier):
            setTechLocName(
                "omnitech-impure-omnitraction",
                "item-name." .. ore_name,
                i
            ):
            setTechPacks(math.max(1, tier)):
            setTechIcons(generate_impure_icon(ore_name)):
            marathon()
        )
        if tier == 1 then
            focused_ore:setCategory("omnite-extraction-both")
        else
            focused_ore:setCategory("omnite-extraction")
        end
        if i==1 and tier==1 then
            focused_ore:setTechPrereq("omnitech-base-impure-extraction")
        elseif i == 1 then
            focused_ore:setTechPrereq("omnitech-omnitractor-electric-"..tier-1)
        else
            focused_ore:setTechPrereq("omnitech-focused-extraction-"..ore_name.."-"..(i-1))
        end
        focused_ore:setResults(r)
        focused_ore:extend()
    end      
end

local function create_pure_extraction(tier, ore_name)
    local cost = (
        OmniGen:create():
            setInputAmount(12):
            setYield(ore_name):
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
        RecChain:create("omnimatter", "extraction-" .. ore_name):
        setLocName("recipe-name.pure-omnitraction", {"item-name." .. ore_name}):
        setLocDesc(function(levels, grade) return get_desc(levels,grade) end):
        setIngredients("omnite"):
        setIcons(ore_name):
        setIngredients(cost:ingredients()):
        setResults(cost:results()):
        setEnabled(false):
        setCategory("omnite-extraction"):
        setSubgroup("omni-pure"):
        setMain(ore_name):
        setLevel(3 * omni.pure_levels_per_tier):
        setEnergy(
            function(levels, grade)
                return 5 * (math.floor((grade - 1 + (tier - 1) / 2) / levels) + 1)
            end):
        setTechIcons(generate_pure_icon(ore_name)):
        setTechCost(
            function(levels, grade)
               return tech_cost(levels, grade, tier)
            end):
        setTechPrereq(
            function(levels, grade)
                return reqpure(tier, grade, ore_name)
            end):
        setTechPacks(
            function(levels, grade)
                return math.floor((grade - 1) * 3 / levels) + tier
            end):
        setTechLocName("omnitech-pure-omnitraction", {"item-name." .. ore_name}):extend()
    )
end

--Initial omnitraction recipe creation
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

--Get highest tier number
local max_omnisource_tier = 0
for k, v in pairs(omni.matter.omnisource) do
    max_omnisource_tier  = math.max(tonumber(k), max_omnisource_tier)
end

--Recipe Creation
--Go up tier by tier to make sure we start with the lowest tier
for tier = 1, max_omnisource_tier do
    --Split the current tier
    local splits = split_omnisource_tier(tier)

    --Go throug each split
    for i, split in pairs(splits) do
        --Create Basic extractions
        create_base_extraction(tier, split, i)

        --Go through each ore
        for j, ore in pairs(split) do

            --Create pure extraction recipes
            create_pure_extraction(tier, ore)
            --Create impure extraction recipes
            create_impure_extraction(tier, split, ore)
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