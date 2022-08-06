-------------------------------------------------------------------------------
--[[Local Declarations]]--
-------------------------------------------------------------------------------
local lab_inputs = {}
local compressed_techs={}
local tiered_tech = {}
local alwaysSP = omni.lib.split(settings.startup["omnicompression_always_compress_sp"].value,",")
local min_compress = settings.startup["omnicompression_compressed_tech_min"].value
-------------------------------------------------------------------------------
--[[Locally defined functions]]--
-------------------------------------------------------------------------------
-- lab input checks
local function has_input(tab)
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
local function containsOne(t,d)
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

local function splitTech(tech)
    local match = select(3, tech:find("()%-%d+$"))
    if match then
        local level = tech:sub(match+1)
        local name = tech:sub(1, match-1)
        return name, level
    else
        return tech
    end
end

local pack_sizes = {}
setmetatable(pack_sizes, {
    __index = function(self, key, value)
        local proto = data.raw.tool[key]
        if not proto or not proto.stack_size then
            log("We expect " .. key .. " to be a tool, but it isn't")
            proto = data.raw.item[key]
        end
        self[key] = proto.stack_size
        return rawget(self, key)
    end
})
-------------------------------------------------------------------------------
--[[Set-up loops]]--
-------------------------------------------------------------------------------
log("start tech compression checks")

--add compressed packs to labs
for _, lab in pairs(data.raw.lab) do
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
end
--find lowest level in tiered techs that gets compressed to ensure chains are all compressed passed the first one
for _,tech in pairs(data.raw.technology) do --run always
    local name, lvl = splitTech(tech.name)
    local unit = tech.unit or tech.normal.unit
    if lvl == "" or lvl == nil then --tweak to allow techs that start with no number
        lvl = 1
        name = tech.name
    end
    --protect against pack removal
    if containsOne(unit and unit.ingredients, alwaysSP) then
        if not tiered_tech[name] then
            tiered_tech[name] = tonumber(lvl)
        elseif tiered_tech[name] > tonumber(lvl) then --in case techs are added out of order, always add the lowest
            tiered_tech[name] = tonumber(lvl)
        end
    end
    --protect against cost drops
    if tech.unit and ((unit.count and type(unit.count)=="number" and unit.count > min_compress)) then
        if not tiered_tech[name] then
            tiered_tech[name] = tonumber(lvl)
        elseif tiered_tech[name] > tonumber(lvl) then --in case techs are added out of order, always add the lowest
            tiered_tech[name] = tonumber(lvl)
        end
    end
end
--log(serpent.block(tiered_tech))
--compare tech to the list created (tiered_tech) to include techs missing packs previously in the chain
local function include_techs(t)
    --extract name and level
    local name, lvl = splitTech(t.name)
    if lvl == "" or lvl == nil then --tweak to allow techs that start with no number
        lvl = 1
        name = t.name
    end
    if tiered_tech[name] then
        if tonumber(lvl) >= tiered_tech[name] then
        return true
        end
    end
    return false
end
-------------------------------------------------------------------------------
--[[Compressed Tech creation]]--
-------------------------------------------------------------------------------
log("Start technology compression")
for _,tech in pairs(data.raw.technology) do
    if not omni.compression.is_hidden(tech) and tech.unit and tech.unit.ingredients and #tech.unit.ingredients > 0 and
    ((tech.unit.count and type(tech.unit.count)=="number" and tech.unit.count > min_compress) or include_techs(tech) or containsOne(tech.unit.ingredients,alwaysSP) or not tech.unit.count) then
        --fetch original
        local t = table.deepcopy(tech)
        t.name = "omnipressed-"..t.name
        local class, tier = splitTech(tech.name)
        local locale = omni.lib.locale.of(tech).name
        if tier and tonumber(locale[#locale]) == nil and tech.level == tech.max_level then-- If the last key is a number, or there's multiple levels, it's already tiered.
            t.localised_name = omni.lib.locale.custom_name(tech, "compressed-tiered", tier)
            t.localised_description = {"technology-description.compressed-tiered", locale, tier}
        else
            t.localised_name = omni.lib.locale.custom_name(tech, "compressed")
            t.localised_description = {"technology-description.compressed", locale}
        end
        --Handle icons
        t.icons = omni.lib.add_overlay(t, "technology")
        t.icon = nil
        --if we req more than a (compressed) stack, we increment this counter
        local divisor = 1
        local lcm = {1}
        local gcd = {}
        -- Stage 1: Standardize and find our LCM of the various stack sizes
        for _, ings in pairs(t.unit.ingredients) do
            if ings[1] then
                ings.name = ings[1]
                ings.amount = ings[2]
                ings[1] = nil
                ings[2] = nil
            end
            -- Remove unit_count from our equation for now
            ings.amount = ings.amount * (t.unit.count or 1)
            lcm[#lcm+1] = pack_sizes[ings.name]
            -- Amount of packs needed (in stacks)
            gcd[#gcd+1] = ings.amount / pack_sizes[ings.name]
        end
        lcm = omni.lib.lcm(table.unpack(lcm))
        gcd = omni.lib.pgcd(table.unpack(gcd))

        -- Stage 2: Determine our amounts and divisor (if we use count_formula)
        for _, ings in pairs(t.unit.ingredients) do
            -- Divisor will always be the largest stack size of the packs used in this tech
            divisor = math.max(divisor, pack_sizes[ings.name])
            -- Divide out our pack size and GCD, the latter will become our unit count
            ings.amount = (ings.amount / pack_sizes[ings.name]) / gcd
            -- Minimum 1, Maximum 65535, round otherwise
            ings.amount = math.min(math.max(omni.lib.round(ings.amount), 1), 65535)
            ings.name = "compressed-"..ings.name
        end

        --if valid remove effects from compressed version
        if t.effects then
            for i, eff in pairs(t.effects) do
                if eff.type ~= "unlock-recipe" then t.effects[i] = nil end
            end
        end
        
        -- Divide our time and unit count to account for our changes
        if t.unit.count then
            -- new time is total time divided by our new unit count
            t.unit.time = omni.lib.round((t.unit.time * t.unit.count) / math.max(gcd, 1))
            -- and clamped
            t.unit.time = math.min(math.max(t.unit.time, 1), 2^64-1)
            -- new unit count is our gcd, rounded
            t.unit.count = omni.lib.round(gcd)
            -- and clamped
            t.unit.count = math.min(math.max(t.unit.count, 1), 2^64-1)

        else
            t.unit.time = math.max(1, t.unit.time / gcd)
            t.unit.count_formula = "(" .. t.unit.count_formula..")*".. string.format("%f", 1 / divisor)
        end

        compressed_techs[#compressed_techs+1]=table.deepcopy(t)
    end
end

if #compressed_techs > 0 then --in case no tech is compressed
    data:extend(compressed_techs)
end

log("Migrating compressed tech prerequisites")
-- Once we've added them to data, we'll fix the prereqs
for _, template in pairs(compressed_techs) do
    local tech = data.raw.technology[template.name]
    --migrate prereqs to compressed versions
    if tech.prerequisites then
        for i, v in pairs(tech.prerequisites) do
            local variant = "omnipressed-" .. v
            if data.raw.technology[variant] then
                tech.prerequisites[i] = variant
            end
        end
    end
end

log("Technology compression finished: "..(#compressed_techs or 0).. " techs")