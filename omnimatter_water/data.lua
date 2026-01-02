local water_levels = settings.startup["water-levels"].value

--Calc dynamic prereqs
local get_omniwater_prereq = function(grade,element,tier)
    local req = {}
    --local tractor_lvl = math.floor((grade-1) / omni.fluid_levels_per_tier) * tier
    local tractor_lvl = math.floor((grade-1) / omni.fluid_levels_per_tier) + tier - 1

    -- Add basic omnitraction as prereq if grade and tier == 1
    if grade == 1 and tier == 1 then
        req[#req+1]="omnitech-base-impure-extraction"
    end
    --Add previous tech as prereq if its in the same tier
    if grade > 1 and grade%omni.fluid_levels_per_tier ~= 1 then
        req[#req+1]="omnitech-"..element.."-omnitraction-"..(grade-1)
    end
    --Add an electric omnitractor tech as prereq if this is the first tech of a new tier
    if grade%omni.fluid_levels_per_tier == 1 and (tractor_lvl <=omni.max_tier) and (tractor_lvl >= 1) then
        req[#req+1]="omnitech-omnitractor-electric-"..tractor_lvl
    --Add the last tech of a tier as prereq for the next omnitractor
    elseif grade > 0 and grade%omni.fluid_levels_per_tier == 0 and (tractor_lvl+1 <=omni.max_tier) then
        omni.lib.add_prerequisite("omnitech-omnitractor-electric-"..tractor_lvl+1, "omnitech-"..element.."-omnitraction-"..(grade), true)    
    end
    --Add the last tier as prereq for the rocket silo if its the highest tier
    if omni.rocket_locked and tractor_lvl >= omni.max_tier and grade == water_levels then
        omni.lib.add_prerequisite("rocket-silo", "omnitech-"..element.."-omnitraction-"..grade,true)
    end
    return req
end

--Calc dynamic tech packs
local get_omniwater_tech_packs = function(grade,tier)
    local packs = {}
    local pack_tier = math.ceil(grade/omni.fluid_levels_per_tier) + tier-1
    for i=1, math.min(pack_tier, #omni.sciencepacks) do
        packs[#packs+1] = {omni.sciencepacks[i],1}
    end
    return packs
end

local c = 1
if mods["omnimatter_compression"] then c = 1/3 end
local cost = OmniGen:create():
    setInputAmount(12*c):
    setYield("omnic-water"):
    setIngredients("omnite"):
    setWaste("omnic-waste"):
    yieldQuant(function(levels,grade) return 3500+(grade-1)*3500/(levels-1) end):
    wasteQuant(function(levels,grade) return 3500-(grade-1)*3500/(levels-1) end)

RecChain:create("omnimatter_water","omnic-water-omnitraction"):
    setLocName("recipe-name.omnic-water-omnitraction",{"fluid-name.".."omnic-water"}):
    setIngredients("omnite"):
    setIcons({"omnic-water", 32},"omnimatter"):
    setIngredients(cost:ingredients()):
    setResults(cost:results()):
    setEnabled(false):
    setCategory("omnite-extraction-both"):
    setSubgroup("omni-fluid-basic"):
    setOrder("a[omnic-water-omnitraction"):
    setLevel(water_levels):
    setEnergy(5*c):
    setTechIcons("omnic-water-omnitraction","omnimatter_water"):
    setTechPrereq(function(levels,grade) return get_omniwater_prereq(grade,"omnic-water",1) end):
    setTechPacks(function(levels,grade) return get_omniwater_tech_packs(grade,1) end):
    setTechCost(function(levels,grade) return 18*omni.matter.get_tier_mult(levels,grade,1) end):
    setTechTime(15):
    setTechLocName("omnitech-omniwater-omnitraction",{"fluid-name.omnic-water"}):
    extend()

--Add the last tier as prereq for the rocket silo
omni.lib.add_prerequisite("rocket-silo", "omnitech-omnic-water-omnitraction-"..water_levels)

--Add starter recipe with lower yield
RecGen:create("omnimatter_water","basic-omnic-water-omnitraction"):
    setLocName("recipe-name.basic-omnic-water-omnitraction",{"fluid-name.omnic-water"}):
    setIcons({"omnic-water", 32},"omnimatter"):
    addSmallIcon({{icon = "__omnilib__/graphics/icons/small/num_1.png", icon_size = 32}}, 2):
    setIngredients({type = "item", name = "omnite", amount = 12}):
    setResults({
        {type = "fluid", name = "omnic-water", amount = 1800},
        {type = "fluid", name = "omnic-waste", amount = 5200}}):
    setSubgroup("omni-fluid-basic"):
    setOrder("a[basic-omnic-water-omnitraction]"):
    setCategory("omnite-extraction-both"):
    setEnergy(5):
    setEnabled(true):
    extend()

if mods["angelsrefining"] and settings.startup["enable-waste-water"].value == true then
    omni.matter.add_omniwater_extraction("omnimatter_water", "angels-water-viscous-mud", water_levels, 2, 90, false)
    for _,fluid in pairs(data.raw.fluid) do
        if omni.lib.start_with(fluid.name,"water") and omni.lib.end_with(fluid.name,"waste") then
            omni.matter.add_omniwater_extraction("omnimatter_water", fluid.name, water_levels, 2, 30, false)
        end
    end
end