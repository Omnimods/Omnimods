local exclusion_list = {"void","flaring","incineration"}
local check_recipes = random_recipes

log("start probability style compression")

for _, recipe in pairs(check_recipes) do
    if not omni.lib.is_in_table(recipe,exclusion_list) and not string.find(recipe,"creative") then
        --local store = data.raw.recipe[recipe]
        local new_recipe = table.deepcopy(data.raw.recipe[recipe])
        --grab localisation before standardisation
        local loc = omni.lib.locale.custom_name(data.raw.recipe[recipe], "compressed-recipe")
        --standardise
        if not mods["omnimatter_marathon"] then omni.lib.standardise(new_recipe) end
        --double check shenanigans are not happening
        new_recipe.ingredients=nil
        new_recipe.ingredient=nil
        new_recipe.result=nil
        new_recipe.results=nil
        local stored_probabilities = {normal={},expensive={}}
        --prob table should include more details than just the number, the order of items seems to get changed in create_compression_recipes
        for _, difficulty in pairs({"normal","expensive"}) do
            for _, result in pairs(new_recipe[difficulty].results) do
                --check item not already in table
                local result_name = result.name
                if stored_probabilities[difficulty][result_name] then
                    --already exists, give new one a fresh tag
                    result_name=result.name .."-p"
                end
                --begin property setting, bring name into the key
                stored_probabilities[difficulty][result_name]={style="normal"}
                if result.amount_min and result.amount_max and result.amount_max <= result.amount_min then
                    result.amount = result.amount_min
                    result.amount_min = nil
                    result.amount_max = nil
                end
                local result_amount = result.amount --set default value
                --amount min system
                -- "min-max" parses mininum, sets mm_prob as max/min
                -- "min-chance" parses minimum, sets mp_prob as min*prob
                -- "zero-max" parses maximum only
                -- "chance" parses average yield, sets prob as prob
                if result.amount_min and result.amount_min > 0 then
                    result_amount = result.amount_min
                    if result.amount_max then
                        stored_probabilities[difficulty][result_name].style = "min-max"
                        stored_probabilities[difficulty][result_name].mm_prob = result.amount_max/result_amount
                    elseif result.probability then --don't know why you would use this, but sure...
                        stored_probabilities[difficulty][result_name].style = "min-chance"
                        stored_probabilities[difficulty][result_name].mp_prob = result.probability
                    end
                elseif result.amount_min and result.amount_min == 0 then
                    if result.amount_max then
                        result_amount = result.amount_max
                        stored_probabilities[difficulty][result_name].style = "zero-max"
                    else
                        log("what are you doing with".. new_recipe.name .. "?")
                    end
                elseif result.amount and result.probability then --normal style, priority over previous step
                    stored_probabilities[difficulty][result_name].style = "chance"
                    stored_probabilities[difficulty][result_name].prob = result.probability
                    result_amount = math.max(result_amount,1) --stop it giving 0?
                end
                --set rec
                result.amount = result_amount
                --prevent shenanigans
                result.amount_min = nil
                result.amount_max = nil
                result.probability = nil
            end
        end
        --parse to compression
        local new_rec = omni.compression.create_compression_recipe(new_recipe)
        --add in manipulation to return the form
        if new_rec then
            local secondary = {}
            for _, difficulty in pairs({"normal","expensive"}) do
                for _, result in pairs(new_rec[difficulty].results) do
                    local result_name = string.sub(result.name,12)
                    if result.type == "fluid" then
                        result_name = string.sub(result.name,14)
                    end
                    --instigate secondary
                    if secondary[result_name]==true then
                        result_name=result_name .."-p"
                    end
                    local probability = stored_probabilities[difficulty][result_name]
                    if probability then                  
                        --get style
                        if probability.style == "min-max" then
                            if result.amount and math.floor(result.amount*probability.mm_prob) > result.amount then --check it actually gets a range
                                result.amount_min = result.amount
                                result.amount_max = math.floor(result.amount*probability.mm_prob) --always round down
                                result.amount = nil --remove standard if min and max exist
                            end
                        elseif probability.style == "zero-max" then
                            result.amount_min = 0
                            result.amount_max = result.amount
                            result.amount = nil
                        elseif probability.style == "min-chance" then
                            result.amount_min = result.amount
                            result.probability = probability.mp_prob
                            result.amount = nil
                        elseif probability.style == "chance" then
                            result.probability = probability.prob
                        end
                    end
                    --check for double entries after primary
                    if stored_probabilities[difficulty][result_name .."-p"] then
                        secondary[result_name]=true
                    end
                end
            end
            new_rec.localised_name = new_rec.localised_name or loc
            data:extend({new_rec})
        -- elseif not string.find(recipe,"void") then --ignore void recipes
        --         log("you fucked up big time with this recipe: "..rec.name)
        --     end
        end
    end
end
log("end probability style compression")