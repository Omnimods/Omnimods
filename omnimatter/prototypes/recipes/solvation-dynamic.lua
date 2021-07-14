local omniFluidCat = "chemistry"
if mods["omnimatter_crystal"] then omniFluidCat = "omniplant" end


--------------------
-----Omniston-----
--------------------
local get_omniston_req = function(lvl)
    local req = {}
    req[#req+1]="omnitech-omnic-acid-hydrolyzation-"..lvl
    if (lvl-1)%omni.fluid_levels_per_tier ~= 0 and lvl > 1 then
        req[#req+1]="omnitech-solvation-omniston-"..(lvl-1)
    end
    return req
end

local get_solvation_tech_packs = function(grade)
    local c = {}
    local size = 1+((grade-1)-(grade-1)%omni.fluid_levels_per_tier)/omni.fluid_levels_per_tier
    local length = math.min(size,#omni.sciencepacks)
    for l=1,length do
        local q = 0
        if omni.linear_science then
            q = 1+omni.science_constant*(size-l)
        else
            q=omni.lib.round(math.pow(omni.science_constant,size-l))
        end
        c[#c+1] = {omni.sciencepacks[l],q}
    end
    return c
end

local quant = 24
local cost = OmniGen:create():
        setYield("omniston"):
        setIngredients("omnite"):
        setWaste():
        yieldQuant(function(levels,grade) return omni.omniston_ratio*(120+(grade-1)*120/(levels-1)) end ):
        wasteQuant(function(levels,grade) return math.max(12-extraction_value(levels,grade),0) end)
local omniston = RecChain:create("omnimatter","omniston"):
        setIngredients({{name="pulverized-omnite", amount = quant/3},{name="omnic-acid",type="fluid", amount = 240}}):
        setLocName("fluid-name.omniston"):
        setCategory(omniFluidCat):
        setResults(cost:results()):
        setSubgroup("omni-fluids"):
        setLevel(omni.fluid_levels):
        setEnergy(function(levels,grade) return 5 end):
        setTechPrefix("solvation"):
        setTechIcons("omniston-tech","omnimatter"):
        setTechCost(function(levels,grade) return 50*omni.matter.get_tier_mult(levels,grade,1) end):
        setTechPacks(function(levels,grade) return get_solvation_tech_packs(grade) end):
        setTechPrereq(function(levels,grade) return get_omniston_req(grade)  end):
        setTechTime(15):
        setTechLocName("omnitech-omniston_solvation"):
        extend()


--------------------
-----Omnisludge-----
--------------------
if mods["omnimatter_crystal"] then
    local get_sludge_req = function(lvl)
        local req = {}
        req[#req+1]="omnitech-omnic-acid-hydrolyzation-"..lvl

        if (lvl-1)%omni.fluid_levels_per_tier ~= 0 and lvl > 1 then
            req[#req+1]="omnitech-omnisolvent-omnisludge-"..(lvl-1)
        end

        return req
    end

    local cost = OmniGen:create():
            setYield("omnisludge"):
            setIngredients("omnite"):
            setWaste():
            yieldQuant(function(levels,grade) return 26/15*(120+(grade-1)*120/(omni.fluid_levels-1)) end ):
            wasteQuant(function(levels,grade) return math.max(12-extraction_value(levels,grade),0) end)

    local omnisludge = RecChain:create("omnimatter","omnisludge"):
            setLocName("recipe-name.omnisludge"):
            setIngredients({
            {name = "pulverized-stone", amount = quant/2},
            {type="fluid", name="omnic-acid", amount=240}
            }):
            setCategory(omniFluidCat):
            setSubgroup("omni-fluids"):
            setResults(cost:results()):
            setLevel(omni.fluid_levels):
            setEnergy(function(levels,grade) return 3 end):
            setTechPrefix("omnisolvent"):
            setTechIcons("omni-sludge","omnimatter"):
            setTechCost(function(levels,grade) return 25*omni.matter.get_tier_mult(levels,grade,1) end):
            setTechPacks(function(levels,grade) return get_acid_tech_cost(grade) end):
            setTechPrereq(function(levels,grade) return get_sludge_req(grade)  end):
            setTechLocName("omnitech-omnisludge"):
            setTechTime(15):
            extend()
end
-----------------------------------------
-----Dynamic Distillation generation-----
-----------------------------------------
local get_distillation_req = function(tier,item, level)
    local req = {}
    -- prereq omniston if that still exists on this tier
    if omni.fluid_levels >= (tier-1)*omni.fluid_levels_per_tier + level then
        req[#req+1]="omnitech-solvation-omniston-"..(tier-1)*omni.fluid_levels_per_tier + level
    end
    --Prereq omnitractor if its the firs tech of a new tier and if there is no omniston prereq
    if #req == 0 and (level-1)%omni.fluid_levels_per_tier == 0 and ((level-1) / omni.fluid_levels_per_tier + tier) <= omni.max_tier then
        req[#req+1]="omnitech-omnitractor-electric-"..((level-1) / omni.fluid_levels_per_tier + tier)
    --Prereq last lvl if on the same tier
    elseif level > 1 and  (level-1)%omni.fluid_levels_per_tier ~= 0 then
        req[#req+1]="omnitech-distillation-"..item.."-"..(level-1)
    end
    return req
end

--Dynamically calc tech packs dependant on tier and grade
local get_distillation_tech_packs = function(grade,tier)
    local packs = {}
    local pack_tier = math.min(math.ceil(grade/omni.fluid_levels_per_tier) + tier-1, #omni.sciencepacks)
    for i=1,pack_tier do
        packs[#packs+1] = {omni.sciencepacks[i],1}
    end
    return packs
end

local function generate_distillation_icon(fluid)
    local fluid_icon = table.deepcopy(omni.lib.icon.of(fluid.name, "fluid"))
    local tint = table.deepcopy(data.raw.fluid[fluid.name].base_color)
    if tint.r then
        tint.a = 0.75
    else
        tint[4] = 0.75
    end
    for _, layer in pairs(fluid_icon) do
        layer.shift = {
            -48 - (0.5 * (64 / layer.icon_size)),
            48 + (0.5 * (64 / layer.icon_size))
        }
    end
    return omni.lib.add_overlay(
        {{
            icon = "__omnimatter__/graphics/technology/fluid-generic.png",
            icon_size = 128,
            tint = tint
        }},
        fluid_icon
    )
end

for _,tier in pairs(omni.matter.omnifluid) do
    for _, fluid in pairs(tier) do
        local cost = OmniGen:create():
            setYield(fluid.name):
            setIngredients("omnite"):
            setWaste("omnic-waste"):
            yieldQuant(function(levels,grade) return fluid.ratio*(120+120*(grade-1)/(levels-1)) end ):
            wasteQuant(function(levels,grade) return 240-fluid.ratio*(120+120*(grade-1)/(levels-1)) end)
        local thingy = RecChain:create("omnimatter","distillation-"..fluid.name):
            setLocName("fluid-name."..fluid.name):
            setIngredients({
            {type="fluid", name="omniston", amount=240}
            }):
            setCategory(omniFluidCat):
            setSubgroup("omni-fluids"):
            setLevel(omni.fluid_levels):
            setIcons(fluid.name):
            setResults(cost:results()):
            setEnergy(function(levels,grade) return 5 end):
            setTechIcons(generate_distillation_icon(fluid)):
            setTechCost(function(levels,grade) return 25*omni.matter.get_tier_mult(levels,grade,1) end):
            setTechPacks(function(levels,grade) return get_distillation_tech_packs(grade, fluid.tier) end):
            setTechPrereq(function(levels,grade) return get_distillation_req(fluid.tier,fluid.name, grade)  end):
            setTechLocName("omnitech-omnistillation",{"fluid-name."..fluid.name}):
            setTechTime(15):
            extend()
    end
end

--Set omnitractor extraction prereqs
local function get_tractor_req(i)
    local r = {}
    for j, tier in pairs(omni.matter.omnifluid) do
        local tier_int = tonumber(j)
        if tier_int < i and tier_int >= i-3 then
            for _,fluid in pairs(tier) do
                r[#r+1] = "omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels_per_tier * (i-fluid.tier-1) + omni.fluid_levels_per_tier
            end
        end
    end
    return r
end

for i=1, omni.max_tier, 1 do
    omni.lib.add_prerequisite("omnitech-omnitractor-electric-"..i, get_tractor_req(i))
end