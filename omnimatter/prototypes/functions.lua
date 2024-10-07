omni.matter.omnitial = {}
omni.matter.omnisource = {}
omni.matter.omnifluid = {}
omni.matter.res_to_keep = {
    "omnite",
    "infinite-omnite"
}
-- returns resource_name, fluid_to_mine
local function get_resource(name, fluid)
    -- Yeah sometimes.. only sometimes do we have a resource but not an item and the names don't match, and we somehow end up here. Welcome to hell :)
    local minable = data.raw.resource[name] and data.raw.resource[name].minable
    if minable then
        -- Check for fluid, fluid=false skips, fluid=anything overrides
        if fluid == nil and minable.required_fluid and minable.fluid_amount then
            fluid = {
                name = minable.required_fluid,
                amount = minable.fluid_amount
            }
        end
        -- Find the minable result if we can.
        -- Edge case: item and resource with same name. Resource yields different thing than the item with the resource's name
        -- If we hit this, we'll take the minable result
        if minable.result then
            name = minable.result 
        elseif minable.results then -- This is more complex, we'll search the results for something matching r_name
            local matched_result = false     -- If we don't find a match, we'll defer to the first result
            for _, result in pairs(minable.results) do
                local result_name = result[1] or result.name
                if result_name == name then
                    matched_result = true
                    break
                end
            end
            if not matched_result then            
                name = minable.results[1][1] or minable.results[1].name
            end
        end
    end
    return name, fluid
end

--------------------------
---Extraction functions---
--------------------------
--Manipulation of the extraction tables
--Open for modders to use to add compatibility

--Adds an initial resource to omnimatter (resource name, result ore amount, input omnite amount, fluid required to mine)
--Initial resources are those that are required to be available at game start witout any tech
--If no mining fluid is specified, it will use the one specified in the resource
--If fluid_to_mine = false, no fluid is required even if the resource prototype specified one
function omni.matter.add_initial(ore_name, ore_amount, omnite_amount, fluid_to_mine)
    ore_name, fluid_to_mine = get_resource(ore_name, fluid_to_mine)

    omni.matter.omnitial[ore_name] = {
        ingredients ={{name = "omnite", amount = omnite_amount, type = "item"}},
        results = {{name = ore_name, amount = ore_amount, type = "item"}, {name = "stone-crushed", amount = (omnite_amount-ore_amount) or 6, type = "item"}}
    }

    if fluid_to_mine and fluid_to_mine.name and settings.startup["omnimatter-fluid-processing"].value then
        omni.matter.omnitial[ore_name].fluid = {name = fluid_to_mine.name, amount = fluid_to_mine.amount or 1, type = "fluid"}
        omni.matter.omnitial[ore_name].results[1].name = "crude-"..omni.matter.omnitial[ore_name].results[1].name
    end
end

--Adds a resource to omnimatter (resource name, tier, fluid required to mine)
--If no mining fluid is specified, it will use the one specified in the resource
--If fluid_to_mine = false, no fluid is required even if the resource prototype specified one
function omni.matter.add_resource(r_name, tier, fluid_to_mine)
    if not tonumber(tier) then
        error("omni.matter.add_resource(): Invalid tier specified for "..r_name)
    end

    if not omni.matter.omnisource[tostring(tier)] then
        omni.matter.omnisource[tostring(tier)] = {}
    end

    r_name, fluid_to_mine = get_resource(r_name, fluid_to_mine)

    omni.matter.omnisource[tostring(tier)][r_name] = {tier = tier, name = r_name}
    if fluid_to_mine and fluid_to_mine.name and settings.startup["omnimatter-fluid-processing"].value then
        omni.matter.omnisource[tostring(tier)][r_name]["fluid"] = {name = fluid_to_mine.name, amount = fluid_to_mine.amount or 1, type = "fluid"}
    end
end

function omni.matter.add_fluid(f_name , tier, ratio, f_temperature)
    if not tonumber(tier) then
        error("omni.matter.add_fluid(): Invalid tier specified for "..f_name)
    end

    if not omni.matter.omnifluid[tostring(tier)] then omni.matter.omnifluid[tostring(tier)] = {} end
    omni.matter.omnifluid[tostring(tier)][f_name] = {tier = tier, ratio=ratio, name = f_name, temperature = f_temperature}
end

function omni.matter.remove_resource(r_name)
    for t, tiers in pairs(omni.matter.omnisource) do
        if omni.matter.omnisource[t][r_name] then
            omni.matter.omnisource[t][r_name] = nil
            return true
        end
    end
    return nil
end

function omni.matter.remove_fluid(f_name)
    for t, tiers in pairs(omni.matter.omnifluid) do
        if omni.matter.omnifluid[t][f_name] then
            omni.matter.omnifluid[t][f_name] = nil
            return true
        end
    end
    return nil
end

function omni.matter.get_ore_tier(r_name)
    for _, tiers in pairs(omni.matter.omnisource) do
        for _,ores in pairs(tiers) do
            if ores.name == r_name then
                return ores.tier
            end
        end
    end
    return nil
end

function omni.matter.set_ore_tier(r_name, tier)
    if not tonumber(tier) then
        error("omni.matter.set_ore_tier(): Invalid tier specified for "..r_name)
    end
    local t = omni.matter.get_ore_tier(r_name)
    if t then
        local res = table.deepcopy(omni.matter.omnisource[tostring(t)][r_name])
        omni.matter.omnisource[tostring(t)][r_name] = nil
        if not omni.matter.omnisource[tostring(tier)] then omni.matter.omnisource[tostring(tier)] = {} end
        omni.matter.omnisource[tostring(tier)][r_name] = res
        return true
    else
        return nil
    end
end

function omni.matter.add_omnium_alloy(name,plate,ingot)
    local reg = {}

    ItemGen:create("omnimatter","omnium-"..name.."-alloy"):
            setSubgroup("omnium"):
            setStacksize(400):
            setIcons("omnium-plate"):
            addSmallIcon(plate,3):
            extend()

    if mods["angelssmelting"] then
        local r = RecGen:create("omnimatter","molten-omnium-"..name.."-alloy")
            r:fluid():
            setBothColour({r = 1, g = 0, b = 1}):
            setMaxTemp(900):
            setIngredients(
                {type="item", name="ingot-omnium", amount=18},
                {type="item", name=ingot, amount=12}
            ):
            setResults({type="fluid", name="molten-omnium-"..name.."-alloy", amount=300}):
            setIcons("liquid-molten-omnium"):
            addSmallIcon(ingot,3):
            setCategory("induction-smelting"):
            setSubgroup("omnium-alloy-casting"):
            setOrder("a[molten-omnium-"..name.."-alloy]"):
            setEnergy(4):
            setTechName("omnitech-angels-omnium-"..name.."-alloy-smelting"):
            setTechIcons("smelting-omnium-"..name):
            setTechPacks("angels-"..name.."-smelting-1"):
            setTechCost(50):
            setTechTime(30):
            setTechPrereq(
                "omnitech-angels-omnium-smelting-1",
                "angels-"..name.."-smelting-1"):
            extend()

        RecGen:create("omnimatter","angels-plate-omnium-"..name.."-alloy"):
            setIngredients({type="fluid", name="molten-omnium-"..name.."-alloy", amount=40}):
            setResults({type="item", name="omnium-"..name.."-alloy", amount=4}):
            addProductivity():
            setCategory("casting"):
            setEnergy(4):
            setSubgroup("omnium-alloy-casting"):
            setOrder("b[molten-omnium-"..name.."-alloy]"):
            setTechName("omnitech-angels-omnium-"..name.."-alloy-smelting"):
            extend()
    else
        local metal_q = math.random(2,6)
        local omni_q = math.random(1,metal_q)
        reg[#reg+1]={
            type = "recipe",
            name = "omnium-"..name.."-alloy-furnace",
            category = "omnifurnace",
            icon_size = 32,
            energy_required = 5,
            enabled = false,
            ingredients = {
                {type="item", name="omnium-plate",amount=omni_q},
                {type="item", name=plate,amount=metal_q},
            },
            results = {{type="item", name="omnium-"..name.."-alloy",amount=omni.lib.round(math.sqrt(omni_q+metal_q))}}
        }
        local found = false
        for _, tech in pairs(data.raw.technology) do
            if tech.effects then
                for _, eff in pairs(tech.effects) do
                    if eff.type == "unlock-recipe" and eff.recipe == plate then
                        omni.lib.add_unlock_recipe(tech.name, "omnium-"..name.."-alloy-furnace", true)
                        found = true
                        break
                    end
                end
            end
        end
        if not found then
            omni.lib.add_unlock_recipe("omnitech-omnium-processing", "omnium-"..name.."-alloy-furnace", true)
        end
    end
    if #reg > 0 then data:extend(reg) end
end

function omni.matter.get_tier_mult(levels,r,c)
    local peak = math.floor(levels/2)+1.5 --1
    if r==1 and c==1 then
        return 1
    elseif r==c and r<=peak then
        return omni.pure_tech_level_increase
    elseif r>peak and c==2*peak-r+levels%2 then
        return -omni.pure_tech_level_increase
    else
        local val = omni.matter.get_tier_mult(levels,r-1,c)+omni.matter.get_tier_mult(levels,r,c+1)
        return val
    end
end

function omni.matter.add_omniwater_extraction(mod, element, lvls, tier, gain, starter_recipe)

    local function get_prereq(grade, e, t)
        local req = {}
        --local tractor_lvl = math.floor((grade-1) / omni.fluid_levels_per_tier) * tier
        local tractor_lvl = math.floor((grade-1) / omni.fluid_levels_per_tier) + t - 1

        -- Add basic omnitraction as prereq if grade and tier == 1
        if grade == 1 and t == 1 then
            req[#req+1]="omnitech-base-impure-extraction"
        end
        --Add previous tech as prereq if its in the same tier
        if grade > 1 and grade%omni.fluid_levels_per_tier ~= 1 then
            req[#req+1]="omnitech-"..e.."-omnitraction-"..(grade-1)
        end
        --Add an electric omnitractor tech as prereq if this is the first tech of a new tier
        if grade%omni.fluid_levels_per_tier == 1 and (tractor_lvl <=omni.max_tier) and (tractor_lvl >= 1) then
            req[#req+1]="omnitech-omnitractor-electric-"..tractor_lvl
        --Add the last tech of a tier as prereq for the next omnitractor
        elseif grade > 0 and grade%omni.fluid_levels_per_tier == 0 and (tractor_lvl+1 <=omni.max_tier) then
            omni.lib.add_prerequisite("omnitech-omnitractor-electric-"..tractor_lvl+1, "omnitech-"..element.."-omnitraction-"..(grade), true)    
        end
        --Add the last tier as prereq for the rocket silo if its the highest tier
        if omni.rocket_locked and tractor_lvl >= omni.max_tier and grade == lvls then
            omni.lib.add_prerequisite("rocket-silo", "omnitech-"..e.."-omnitraction-"..grade,true)
        end
        return req
    end

    local function get_tech_packs(grade, t)
        local packs = {}
        local pack_tier = math.ceil(grade/omni.fluid_levels_per_tier) + t - 1
        for i=1, math.min(pack_tier, #omni.sciencepacks) do
            packs[#packs+1] = {omni.sciencepacks[i],1}
        end
        return packs
    end

    local function get_tech_cost(levels,grade,t,start,constant)
        local lvl = grade + (t-1) * omni.fluid_levels_per_tier
        return  start*lvl + constant*lvl*omni.matter.get_tier_mult(levels,grade,1)
    end

    --Starter recipe
    if starter_recipe == true then
        RecGen:create(mod,"basic-"..element.."-omnitraction"):
            setIcons(element):
            addSmallIcon("__omnilib__/graphics/icons/small/num_1.png", 2):
            setIngredients({type="fluid",name="omnic-water",amount=720}):
            setResults({
                {type = "fluid", name = element, amount = gain*0.5},
                {type = "fluid", name = "omnic-waste", amount = gain*1.5}}):
            setSubgroup("omni-fluid-basic"):
            setOrder("b[basic-"..element.."-omnitraction]"):
            setCategory("omnite-extraction-both"):
            setLocName("recipe-name.basic-omnic-water-omnitraction",{"fluid-name."..element}):
            setEnergy(5):
            setEnabled(true):
            extend()
    end

    --Chained recipes
    local cost = OmniGen:create():
        setYield(element):
        setIngredients({type="fluid",name="omnic-water",amount=720}):
        setWaste("omnic-waste"):
        yieldQuant(function(levels,grade) return gain+(grade-1)*gain/(levels-1) end):
        wasteQuant(function(levels,grade) return gain-(grade-1)*gain/(levels-1) end)
    local omniston = RecChain:create(mod, element.."-omnitraction"):
        setLocName("recipe-name.omnic-water-omnitraction",{"fluid-name."..element}):
        setIngredients(cost:ingredients()):
        setCategory("omnite-extraction-both"):
        setIcons(element):
        setResults(cost:results()):
        setSubgroup("omni-fluid-extraction"):
        setOrder("b["..element.."-omnitraction]"):
        setLevel(lvls):
        setEnergy(function(levels,grade) return 0.5 end):
        setEnabled(false):
        setTechIcons(element.."-omnitraction",mod):
        setTechPrereq(function(levels,grade) return get_prereq(grade,element,tier) end):
        setTechPacks(function(levels,grade) return get_tech_packs(grade,tier) end):
        setTechCost(function(levels,grade) return get_tech_cost(levels,grade,tier,18,0.8) end):
        setTechTime(15):
        setTechLocName("omnitech-omniwater-omnitraction",{"fluid-name."..element}):
        extend()
end

--------------------------
---Other functions---
--------------------------

--Add a resource to our whitelist. Whitelisted resources will not be removed from autoplace control
function omni.matter.add_ignore_resource(name)
    if not omni.lib.is_in_table(name, omni.matter.res_to_keep) then
        omni.matter.res_to_keep[#omni.matter.res_to_keep+1] = name
    end
end

--Remove a resource from our whitelist.
function omni.matter.remove_ignore_resource(name)
    if omni.lib.is_in_table(name, omni.matter.res_to_keep) then
        omni.lib.remove_from_table(name, omni.matter.res_to_keep)
    end
end