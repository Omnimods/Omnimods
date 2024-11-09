if settings.startup["omnicompression_item_compression"].value and settings.startup["omnicompression_recipe_compression"].value then
    -------------------------------------------------------------------------------
    --[[Initialisation and Config Variables]]--
    -------------------------------------------------------------------------------
    local compress_recipes = {}
    local concentrationRatio = omni.compression.sluid_contain_fluid
    --compressed_item_names = {}  --global?
    random_recipes = {} --global?
    local compress_based_recipe = {}
    local new_cat={}
    -------------------------------------------------------------------------------
    --[[Set-up the functions for compressed recipes]]--
    -------------------------------------------------------------------------------
    --stack size of more than 1 function
    local function more_than_one(recipe)
        -- Multi-result
        local results = recipe.results
        -- Sanity checks, huzzah
        if not results then
            return false
        end
        -- Multi result
        if #results > 1 then
            return true
        end
        local product = omni.lib.get_main_product(recipe)
        -- ???
        if not product then
            return false
        end
        -- Valid but we're returning nothing
        if product.amount == 0 or (product.probability or 1) == 0 then
            return false
        end
        product = omni.lib.locale.find(product.name, product.type, true)
        -- Main product is >1, this covers cases of .result as well
        if product and omni.lib.find_stacksize(product) > 1 then
            return true
        end
        return false
    end
    --category set
    local function set_category(recipe)
        if recipe.category then
            if not data.raw["recipe-category"][recipe.category.."-compressed"] then
                if not omni.lib.is_in_table(recipe.category.."-compressed", new_cat) then
                    new_cat[#new_cat+1] = {type = "recipe-category", name = recipe.category.."-compressed"}
                end
            end
            return recipe.category.."-compressed"
        elseif not data.raw["recipe-category"]["general-compressed"] then
            if not omni.lib.is_in_table("general-compressed",new_cat) then
                new_cat[#new_cat+1] = {type = "recipe-category", name = "general-compressed"}
            end
            return "general-compressed"
        end
    end

    --fluids check, returns true if anything except fluids is present
    local function not_only_fluids(recipe)
        local all_ing = recipe.ingredients
        local all_res = recipe.results
        if type(all_ing)=="table" then
            for _,ing in pairs(all_ing) do
                if ing[1] or (ing.type ~= "fluid") then return true end
            end
        elseif type(all_ing)=="string" then
            return true
        end
        if type(all_res)=="table" then
            for _,ing in pairs(all_res) do
                if ing[1] or (ing.type ~= "fluid") then return true end
            end
        else
            if type(all_res) == "string" or all_res[1] or all_res.type~="fluid" then
                return true
            end
        end
        return false
    end

    --checks results for probabilistic returns (probability, amount min, amount max etc)
    local function not_random(recipe)
        if recipe.results and next(recipe.results) then
            for _,r in pairs(recipe.results) do
                if r.amount_min or (r.probability and r.probability > 0) or r.amount_max then
                    return false
                end
            end
        end
        return true
    end

    --splits fluids and solids per "table"
    local function seperate_fluid_solid(collection)
        local fluid = {}
        local solid = {}
        if type(collection) == "table" then
            for _, thing in pairs(collection) do
                local amount = type(thing) == "table" and tonumber(thing.amount or thing[2])
                if not amount or (amount and amount > 0) then
                    if thing.type and thing.type == "fluid" then
                        fluid[#fluid+1]=thing
                    else
                        if type(thing)=="table" then
                            if thing.type then
                                solid[#solid+1] = thing
                            elseif thing[1] then
                                solid[#solid+1] = {type="item",name=thing[1],amount=thing[2]}
                            elseif thing.name then
                                solid[#solid+1] = {type="item",name=thing.name,amount=thing.amount}
                            end
                        else
                            solid[#solid+1] = {type="item",name=thing[1],amount=1}
                        end
                    end
                else
                    log("Invalid recipe with a 0 requirement/result!\n" .. serpent.block(collection))
                end
            end
        else
            solid[#solid+1] = {type="item",name=collection,amount=1}
        end
        return {fluid = fluid,solid = solid}
    end

    --sort and clean up groups of ingredients and results for type processing
    local function get_recipe_values(ingredients, results)
        local parts={}
        local all_ing = seperate_fluid_solid(ingredients)
        local all_res = seperate_fluid_solid(results)

        for _,comp in pairs({all_ing.solid,all_res.solid}) do
            for _,  resing in pairs(comp) do
                parts[#parts+1]={name=resing.name,amount=resing.amount}
            end
        end
        local lcm_rec = 1
        local gcd_rec = 0
        local mult_rec = 1
        local lcm_stack = 1
        local gcd_stack = 0
        local mult_stack = 1
        --calculate lcm of the parts and stacks
        for _, p in pairs(parts) do
            if gcd_rec == 0 then
                gcd_rec = p.amount
            else
                gcd_rec = omni.lib.gcd(gcd_rec, p.amount)
            end
            lcm_rec = omni.lib.lcm(lcm_rec,p.amount)
            mult_rec = mult_rec*p.amount

            local stacksize = omni.lib.find_stacksize(p.name)
            if gcd_stack == 0 then
                gcd_stack=stacksize
            else
                gcd_stack = omni.lib.gcd(gcd_stack,stacksize)
            end
            lcm_stack = omni.lib.lcm(lcm_stack,stacksize)
            mult_stack = mult_stack*stacksize
        end
        --lcm_rec = mult_rec/gcd_rec
        --lcm_stack = mult_stack/gcd_stack
        local new_parts = {}
        local new_stacks = {}
        for i, p in pairs(parts) do
            new_parts[i]={name = p.name, amount = lcm_rec/p.amount}
            local stacksize = omni.lib.find_stacksize(p.name)
            new_stacks[i]={name = p.name, amount = lcm_stack/stacksize}
        end
        local new_gcd = 0
        local new_lcm = lcm_rec*lcm_stack--rec_max*stack_max/omni.lib.gcd(rec_max,stack_max)
        local new = {}
        for i, _ in pairs(new_parts) do
            new[i]=new_lcm*new_stacks[i].amount/new_parts[i].amount
            new[i]=math.max(math.floor(new[i]+0.5),1) --round and assume at least 1
            if new_gcd == 0 then
                new_gcd = new[i]
            else
                new_gcd=omni.lib.gcd(new_gcd,new[i])
            end
        end
        for i,p in pairs(new_parts) do
            new[i]=math.min(new[i] / new_gcd, 65535)
        end
        local total_mult = new[1]*omni.lib.find_stacksize(parts[1].name)/parts[1].amount

        local newing = {}
        for i, s in pairs(all_ing.solid) do
            newing[#newing + 1] = {
        type = "item",
        name = "compressed-" .. parts[i].name,
        amount = new[i]
        }
        end
        for _,f in pairs(all_ing.fluid) do
            newing[#newing + 1] = {
                type = "fluid",
                name = "concentrated-" .. f.name,
                amount = f.amount * total_mult / concentrationRatio,
                minimum_temperature = f.minimum_temperature,
                maximum_temperature = f.maximum_temperature
            }
        end
        local newres = {}
        for i, s in pairs(all_res.solid) do
            newres[#newres + 1] = {
                type = "item",
                name = "compressed-" .. parts[#all_ing.solid + i].name,
                amount = new[#all_ing.solid + i]
            }
        end
        for _,f in pairs(all_res.fluid) do
            newres[#newres + 1] = {
                type = "fluid",
                name = "concentrated-" .. f.name,
                amount = f.amount * total_mult / concentrationRatio,
                temperature = f.temperature
            }
        end
        return {ingredients = newing, results = newres}
    end


    --output(results) adjustments
    local function adjustOutput(recipe)
        local silos = {} -- For later reference
        local supremumTime = settings.startup["omnicompression_too_long_time"].value
        -- Rocket case
        local rocket_mult = 1
        -- Case: Rocket Parts
        for _, proto in pairs(data.raw["rocket-silo"]) do
            -- If our recipe matches or our category is applicable
            if (
            (proto.fixed_recipe and proto.fixed_recipe == recipe.name) or 
            (proto.crafting_categories and recipe.category and omni.lib.is_in_table(recipe.category, proto.crafting_categories)
            )) and recipe.name:find("-compression$")
            then
                local old_recipe = omni.lib.locale.find(recipe.name:gsub("-compression$", ""), "recipe")
                local old_item = omni.lib.locale.find(omni.lib.get_main_product(old_recipe).name, "item")
                local product = (proto.rocket_parts_required / old_item.stack_size)
                local old_req = proto.rocket_parts_required
                silos[#silos+1] = proto -- For later reference
                if product%1 == 1 then -- Whole number, no mult needed to be set
                    proto.rocket_parts_required = product
                else
                    rocket_mult = old_item.stack_size / omni.lib.gcd(old_req, old_item.stack_size) -- Smallest whole multiple
                    proto.rocket_parts_required = (old_req / omni.lib.gcd(old_req, old_item.stack_size))
                end
            end
        end
        local gcd = 0
        local tooMuchIng = nil
        for _, ing in pairs(recipe.ingredients) do
            if ing.type ~= "fluid" then
                if gcd == 0 then
                    gcd = ing.amount
                else
                    gcd = omni.lib.gcd(gcd,ing.amount)
                end
                if ing.amount > 65535 then
                    if not tooMuchIng then
                        tooMuchIng = ing.amount
                    else
                        tooMuchIng = math.max(ing.amount,tooMuchIng)
                    end
                end
            end
        end
        --adjust div to account for results too
        for _, res in pairs(recipe.results) do
            if res.type ~= "fluid" then
                if gcd == 0 then --highly unlikely after dealing with the ingredients
                    gcd = res.amount
                else
                    gcd = omni.lib.gcd(gcd,res.amount)
                end
            end
        end
        --now we play with GCD > 0
        if gcd > 0 then
            local divisors = omni.lib.divisors(gcd)
            local div = nil
            if recipe.energy_required > supremumTime or tooMuchIng then
                for i=1,#divisors do
                    if recipe.energy_required/divisors[i]<supremumTime and (tooMuchIng == nil or tooMuchIng/divisors[i] < 65535) then
                        if div and div > divisors[i] then
                            div=divisors[i]
                        elseif not div then
                            div=divisors[i]
                        end
                    end
                end
            end
            for resIndex=1, #recipe.results do
                local res = recipe.results[resIndex]
                if div then
                    res.amount = res.amount / div
                end
                res.amount = res.amount * rocket_mult -- Rockets
                if res.type == "item" then
                    -- Case: satellite
                    if omni.lib.get_main_product(recipe) then
                        -- Satellite
                        local launch_item = omni.lib.locale.find(res.name, "item")
                        local product_table = launch_item.rocket_launch_product and {launch_item.rocket_launch_product}
                        or launch_item.rocket_launch_products or {}
                        for _, product in pairs(product_table) do           
                            -- Scale
                            if product.name and product.amount then
                                local product_proto = product.name:find("compressed") and omni.lib.locale.find(product.name:gsub("compressed%-", ""), "item") or omni.lib.locale.find(product.name, "item")
                                product.amount = math.max(1, (res.amount * product.amount) / product_proto.stack_size)
                                for _, silo_prototype in pairs(silos) do -- Update according to stack size
                                    silo_prototype.rocket_parts_required = math.min(silo_prototype.rocket_parts_required * product.amount, 2^32-1)
                                end
                                silos = {}-- Remove since we don't want to accidentally compound the values
                            end
                        end
                        -- Aaaand insert
                        if #product_table > 0 then
                            launch_item.rocket_launch_products = product_table
                            launch_item.rocket_launch_product = nil
                            res.amount = (launch_item.stack_size == 1) and 1 or res.amount -- Revert amount if necessary
                        end
                    end
                    if res.amount >= 2^16 then
                        -- Split output into res/65535 + remainder different results to bypass limit
                        local newres = table.deepcopy(res)
                        newres.amount = 65535
                        for n=1, math.floor(res.amount / 65535) do
                            recipe.results[#recipe.results+1] = newres
                        end
                        res.amount = res.amount % 65535
                    end
                end
            end
            if div then
                for _, ing in pairs(recipe.ingredients) do
                    ing.amount = (ing.amount/div) * rocket_mult -- More rockets
                end
                recipe.energy_required = (recipe.energy_required / div) * rocket_mult -- Rockets
            end
        end
        return recipe
    end

    -----------------------------------------------------------------
    -- IS VOID? check for the word void in recipe name or products --
    -----------------------------------------------------------------
    local is_void = function(recipe)
        if recipe.name:find("void") or 
            recipe.name:find("flaring") or 
            recipe.name:find("incineration")
        then
            return true
        end
        local product = omni.lib.get_main_product(recipe) 
        if product and (product.name:find("void") or product.amount == 0) then
            return true
        end
        return false
    end

    ----------------------------------
    -- GENERATOR FLUID: duplicates? --
    ----------------------------------
    local generatorFluidRecipes = {}
    --generator styled recipes
    for _, gen in pairs(data.raw.generator) do
        if not string.find(gen.name,"creative") then
            if not gen.burns_fluid and gen.fluid_box and gen.fluid_box.filter then
                if not generatorFluidRecipes[gen.fluid_box.filter] then
                    generatorFluidRecipes[gen.fluid_box.filter]={name=gen.fluid_box.filter,temperature={},recipes = {}}
                    generatorFluidRecipes[gen.fluid_box.filter].temperature[1]={min = gen.fluid_box.minimum_temperature, max=gen.maximum_temperature}
                else
                    table.insert(generatorFluidRecipes[gen.fluid_box.filter].temperature,{min = gen.fluid_box.minimum_temperature, max=gen.maximum_temperature})
                end
            end
        end
    end

    -------------------------------------------------------------------------------
    --[[Create Compressed Versions of Each Recipe]]--
    -------------------------------------------------------------------------------
    function omni.compression.create_compression_recipe(recipe)
        if not omni.lib.is_in_table(recipe.name, omni.compression.excluded_recipes) then --not excluded
            if not string.find(recipe.name,"creative") then --not creative mod or void
                if (recipe.results and #recipe.results > 0) then --ingredients.results and 1+
                    if (more_than_one(recipe) or omni.lib.is_in_table(recipe.name, omni.compression.include_recipes)) then
                        local comrec={} --set basis to zero
                        local new_cat = set_category(recipe) or "crafting-compressed" --fallback should not be needed
                        local icons = omni.lib.add_overlay(recipe,"compress")

                        if not_random(recipe) then
                            --log(serpent.block(recipe.name .. " not_random"))
                            -------------------------------------------------------------------------------
                            --first conditional-- 
                            --contains solids and results with no probability--
                            -------------------------------------------------------------------------------
                            if not_only_fluids(recipe) then
                                --log(serpent.block(recipe.name .. " not_only_fluids"))
                                ------------------------------------
                                -- **Set-up required parameters** --
                                ------------------------------------
                                local parts = {}
                                local res = {}
                                local ing = {}
                                local gcd = 0
                                local generatorfluid = nil
                                local missing_solids = false
                                local single_stack = not more_than_one(recipe)
                                -----------------------------------
                                -- **Find GCD from base recipe** --
                                -----------------------------------
                                --set ingredient and result tables from recipe
                                ing=table.deepcopy(recipe.ingredients)
                                res=table.deepcopy(recipe.results)
                                --log(serpent.block(ing))
                                --log(serpent.block(res))
                                --GCD checks for each recipe
                                --iterates through each ingredient to find the 2 gcd variables {gcd[norm],gcd[exp]} these are calculated across both ingredients and results
                                parts.solid = parts.solid or {}
                                parts.fluid = parts.fluid or {}
                                for b, io_type in pairs({"ingredients","results"}) do
                                    parts.solid[b] = parts.solid[b] or {}
                                    parts.fluid[b] = parts.fluid[b] or {}
                                    for _, component in pairs(recipe[io_type]) do
                                        --temp fix for non-standard stuff sneaking through
                                        component = (io_type == "results" and omni.lib.parse_result(component) or omni.lib.parse_ingredient(component))
                                        if component.type ~= "fluid" then
                                            if not single_stack then -- No math on single bois
                                                local amount = math.min(math.max(math.floor(component.amount+0.5),1),65535)  --ensure no decimals on items
                                                if gcd == 0 then
                                                    gcd = amount
                                                else
                                                    gcd = omni.lib.gcd(gcd, amount)
                                                end
                                            end
                                            parts.solid[b][#parts.solid[b]+1] = component
                                            if not omni.lib.locale.find("compressed-"..component.name, component.type, true) then
                                                --log("["..component.type.."]".."[compressed-"..component.name.."]")       
                                                missing_solids = true
                                            end
                                        else
                                            parts.fluid[b][#parts.fluid[b]+1] = component
                                        end
                                        if io_type == "results" and component.type == "fluid" and generatorFluidRecipes[component.name] then
                                            generatorfluid = component.name
                                        end
                                    end
                                end
                                
                                -- finish finding gcd before applying calculation to parts
                                for b, io_type in pairs({"ingredients","results"}) do
                                    for _, item_type in pairs{"solid", "fluid"} do
                                        for _, component in pairs(parts[item_type][b]) do
                                            --set max cap (in case something slips through)
                                            component.amount = single_stack and component.amount or math.min(component.amount/gcd,65535)
                                        end
                                    end
                                end
                                --log(serpent.block(check))
                                -- Scope
                                if not missing_solids then
                                    local new_val = get_recipe_values(ing, res)
                                    local mult
                                    if parts.solid[1][1] then
                                        mult = new_val.ingredients[1].amount / parts.solid[1][1].amount * omni.lib.find_stacksize(parts.solid[1][1].name)
                                    else
                                        mult = new_val.results[1].amount / parts.solid[2][1].amount*omni.lib.find_stacksize(parts.solid[2][1].name)
                                    end
                                    --new crafting time calculations
                                    local tid = {}
                                    if recipe.energy_required then
                                        tid = recipe.energy_required * mult
                                    else
                                        tid = mult
                                    end
                                    if not single_stack then
                                        tid = tid / gcd
                                    end
                                    --------------------------------------
                                    -- **set up basics for new recipe** --
                                    --------------------------------------
                                    local r = {
                                    type = "recipe",
                                    icons = icons,
                                    name = recipe.name.."-compression",
                                    localised_name = omni.lib.locale.custom_name(recipe, 'compressed-recipe'),
                                    enabled = false,
                                    hidden = recipe.hidden,
                                    ingredients = new_val.ingredients,
                                    results = new_val.results,
                                    energy_required = math.max(0.0011, tid),
                                    subgroup = recipe.subgroup,
                                    hide_from_player_crafting = recipe.hide_from_player_crafting or omni.compression.hide_handcraft,
                                    category = new_cat,
                                    order = recipe.order,
                                    surface_conditions = recipe.surface_conditions
                                    }
                                    -------------------------------------------
                                    -- **Normalised stack building setting** --
                                    -------------------------------------------
                                    if settings.startup["omnicompression_normalize_stacked_buildings"].value then
                                        if #r.results == 1 and omni.lib.find_entity_prototype(string.sub(r.results[1].name,string.len("compressed-")+1,string.len(r.results[1].name))) then
                                            for _,ing in pairs(r.ingredients) do
                                                ing.amount = math.ceil(ing.amount/r.results[1].amount)
                                            end
                                            r.energy_required = math.max(0.0011, r.energy_required/r.results[1].amount)
                                            r.results[1].amount=1
                                        end
                                    end
                                    --------------------------------------------------
                                    -- **set up other properties from base recipe** --
                                    --------------------------------------------------
                                    if r.main_product and r.main_product ~= "" then
                                        if not data.raw.fluid[r.main_product] then
                                            r.main_product="compressed-"..r.main_product --set correct name for solid
                                        else
                                            r.main_product="concentrated-"..r.main_product --set correct name for fluid
                                        end
                                    end
                                    if #r.results==1 then r.main_product = r.results[1].name end
                                    if generatorfluid then
                                        table.insert(generatorFluidRecipes[generatorfluid].recipes,adjustOutput(r))
                                    end
                                    comrec=adjustOutput(r)
                                else
                                    --log(serpent.block(no ingredients or results found in compressed form))
                                end
                                -------------------------------------------------------------------------------
                                --second conditional-- 
                                --contains only fluids and results with no probability--
                                -------------------------------------------------------------------------------
                            else --not not_only_fluids(recipe)
                                --log(serpent.block(recipe.name .. " only_fluids"))
                                --------------------------------------------------
                                -- **Copy base recipe** --
                                    -- no stack size shenanigans required for fluids
                                --------------------------------------------------
                                local r = table.deepcopy(recipe)

                                r.name = r.name.."-compression"
                                r.localised_name = omni.lib.locale.custom_name(recipe, 'compressed-recipe')
                                r.icons = icons
                                r.icon = nil
                                r.category=new_cat
                                r.subgroup = recipe.subgroup
                                r.energy_required = concentrationRatio*r.energy_required
                                r.hide_from_player_crafting = r.hide_from_player_crafting or omni.compression.hide_handcraft
                                for _,ingres in pairs({"ingredients","results"}) do
                                    for i,item in pairs(r[ingres]) do
                                        r[ingres][i].name="concentrated-"..r[ingres][i].name
                                    end
                                end
                                comrec = r
                            end
                            -------------------------------------------------------------------------------
                            --final adjustments--
                            --tags, categories, grouping
                            -------------------------------------------------------------------------------
                            if comrec and comrec.name and comrec.type == "recipe" then
                                if settings.startup["omnicompression_one_list"].value then
                                    local subgroup = (
                                    comrec.subgroup and 
                                    data.raw["item-subgroup"][comrec.subgroup]
                                    )
                                    subgroup =  subgroup and subgroup.group and data.raw["item-group"][subgroup.group]
                                    subgroup = subgroup and subgroup.order
                                    subgroup = "compressed-" .. (subgroup or "crafting") .. "-" .. (comrec.subgroup or "general")
                                    if not data.raw["item-subgroup"][subgroup] then
                                        local item_cat = {
                                            type = "item-subgroup",
                                            name = subgroup,
                                            group = "compressor-compress",
                                            order = "a["..subgroup.."]" --maintain some semblance of order
                                        }
                                        data:extend({item_cat}) --create it if it didn't already exist
                                    end
                                    comrec.subgroup = subgroup
                                end
                                comrec.hidden = recipe.hidden
                                comrec.enabled = false
                                comrec.main_product = nil
                                comrec.category=new_cat
                                comrec.hide_from_player_crafting = comrec.hide_from_player_crafting or omni.compression.hide_handcraft
                                return comrec
                            else
                                return nil --should not
                            end
                        else
                            --log(serpent.block(recipe.name .. " random still"))
                        end
                    else
                        --log(serpent.block(recipe.name .. " stack_size = 1"))
                    end
                else
                    --log(serpent.block(recipe.name .. " results < 1"))
                end
            else
                --log(serpent.block(recipe.name .. " has creative or void"))
            end
        else
            --log(serpent.block(recipe.name .. " excluded"))
        end
    end

    -------------------------------------------------------------------------------
    --[[VOID CREATION RECIPE]]--
    -------------------------------------------------------------------------------
    local function create_void(recipe)
        local continue = false
        local prefix = "compressed-"
        local product = omni.lib.get_main_product(recipe)
        local ingredient = omni.lib.get_main_product(recipe)
        if not omni.lib.is_in_table(recipe.name, omni.compression.excluded_recipes) then --not excluded
            if not more_than_one(recipe) then -- Verify products
                if ingredient then
                    if not product or (product.count == 0) or (product.probability == 0) or product.name:find("void") then
                        if ingredient.type == "fluid" then
                            prefix = "concentrated-"
                        end
                        if data.raw[ingredient.type][ingredient.name] then-- Don't make recipes for items that don't exist
                            continue = true
                        end
                    end
                end
            end
            if continue == true then
                local icons = omni.lib.add_overlay(recipe, "compress")
                local new_cat = "crafting-compressed"
                if recipe.category then
                    new_cat = recipe.category.."-compressed"
                    if not data.raw["recipe-category"][new_cat] then
                        data:extend({{
                            type = "recipe-category",
                            name = new_cat
                        }})
                    end
                end
                if not data.raw["recipe-category"]["general-compressed"] then
                    data:extend({{
                    type = "recipe-category",
                    name = "general-compressed"
                    }})
                end
                local new_rc = table.deepcopy(recipe)
                new_rc.name = recipe.name.."-compression"
                new_rc.localised_name = omni.lib.locale.custom_name(new_rc, 'recipe-name.compressed-recipe')
                new_rc.icons = icons
                new_rc.category = new_cat
                new_rc.ingredients[1].name = prefix .. ingredient.name
                --new_rc.results[1].probability = 0 --set to never actually give
                if string.find(recipe.name,"%-car$") then
                    log(serpent.block(new_rc))
                end
                return table.deepcopy(new_rc)
            end
            return nil
        end
    end

    -------------------------------------------------------------------------------
    --[[CALL FUNCTION FOR GENERAL RECIPES]]--
    -------------------------------------------------------------------------------
    log("Start recipe compression")

    --call the recipe creation script, splitting off the randomised recipes and void recipes for further processing
    for _,recipe in pairs(data.raw.recipe) do
        --if not already compressed
        if not recipe.category or not (recipe.category == "compression" or string.find(recipe.category,"%-concentration$") or string.find(recipe.category,"%-condensation$") or string.find(recipe.category,"%-compressed$")) then
            if recipe.subgroup ~= "y_personal_equip" then --exclude yuoki's personal equipment subgroup
                --check for void and swap it to the void system in place of compression_recipe
                local rc = omni.compression.create_compression_recipe(recipe) --call create recipe
                -- the main exclusions are added in that function since it is also called with the random recipes
                if not rc and is_void(recipe) then
                    --should create void recipes in place of non-void
                    rc = create_void(recipe)
                end
                if rc then
                    compress_based_recipe[#compress_based_recipe+1] = table.deepcopy(rc)
                elseif not not_random(recipe) then
                    random_recipes[#random_recipes+1] = recipe.name
                end
            end
        end
    end

    -------------------------------------------------------------------------------
    --[[DEAL WITH GENERATOR FLUIDS]]-- needed for omnifluid
    -------------------------------------------------------------------------------
    local multiplier = settings.startup["omnicompression_multiplier"].value

    for name,fluid in pairs(generatorFluidRecipes) do
        if string.find(name,"-concentrated-") == nil then --skip if already concentrated, no need to add a tier 2 superconcentrate
            --log("working on fluid "..name)
            for _,rec in pairs(fluid.recipes) do
                for i = 1, settings.startup["omnicompression_building_levels"].value do
                    local new = table.deepcopy(rec)
                    new.name = new.name.."-grade-"..i
                    local newFluid={}
                    for j,res in pairs(new.results) do
                        if res.name == name then
                            new.results[j].amount = new.results[j].amount/ math.pow(multiplier,i)
                            newFluid=table.deepcopy(data.raw.fluid[res.name])
                            new.results[j].name = res.name.."-concentrated-grade-"..i
                        elseif string.sub(res.name,string.len("concentrated-")+1,-1) == name then
                            new.results[j].amount = new.results[j].amount/ math.pow(multiplier,i)*60
                            newFluid=table.deepcopy(data.raw.fluid[string.sub(res.name,string.len("concentrated-")+1,-1)])
                            new.results[j].name = string.sub(res.name,string.len("concentrated-")+1,-1).."-concentrated-grade-"..i
                        end
                    end

                    newFluid.name = newFluid.name.."-concentrated-grade-"..i
                    newFluid.localised_name = omni.lib.locale.custom_name(data.raw.fluid[name], "compressed-fluid", tostring(i))

                    if not newFluid.heat_capacity then
                        newFluid.heat_capacity = "1kJ"
                    end

                    newFluid.heat_capacity = tonumber(string.sub(newFluid.heat_capacity,1,string.len(newFluid.heat_capacity)-2))*math.pow(multiplier,i)..
                    string.sub(newFluid.heat_capacity,string.len(newFluid.heat_capacity)-1,string.len(newFluid.heat_capacity))

                    if newFluid.fuel_value then
                        newFluid.fuel_value = tonumber(string.sub(newFluid.fuel_value,1,string.len(newFluid.fuel_value)-2))*math.pow(multiplier,i)..
                        string.sub(newFluid.fuel_value,string.len(newFluid.fuel_value)-2,string.len(newFluid.fuel_value))
                    end

                    newFluid.icons = omni.lib.add_overlay(newFluid, "compress-fluid", i)
                    newFluid.icon = nil
                    compress_recipes[#compress_recipes+1] = new
                    compress_recipes[#compress_recipes+1] = newFluid
                end
            end
        end
    end

    -------------------------------------------------------------------------------
    --[[Extend tables]]--
    -------------------------------------------------------------------------------
    -- Final check
    if not data.raw["recipe-category"]["general-compressed"] then
        data:extend({{
            type = "recipe-category",
            name = "general-compressed"
        }})
    end
    -- Extend
    data:extend(new_cat)

    if #compress_recipes > 0 then
        data:extend(compress_recipes) --for generator fluid recipes
    end
    if #compress_based_recipe > 0 then
        data:extend(compress_based_recipe)
    end

    -------------------------------------------------------------------------------
    --[[Fix fixed_recipes]]--
    -------------------------------------------------------------------------------

    local assemblers = {"assembling-machine", "rocket-silo"}

    for _, type in pairs(assemblers) do
        for _, ent in pairs(data.raw[type]) do
            if ent.fixed_recipe and string.find(ent.name, "-compressed") and string.find(ent.crafting_categories[1],"-compressed") and not string.find(ent.fixed_recipe, "-compressed") then
                if data.raw.recipe[ent.fixed_recipe.."-compression"] then
                    ent.fixed_recipe = ent.fixed_recipe.."-compression"
                end
            end
        end
    end

    log("Recipe compression finished: "..(#compress_recipes or 0).. " recipes")
end