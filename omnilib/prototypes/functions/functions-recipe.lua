function omni.lib.parse_result(product)
    --Get the given product in the {name = ..., type = ..., amount=..., ..} format.
    if not product or type(product) == "table" and not next(product) then return end

    if type(product) == "string" then -- Single product
        return {
            name = product,
            amount = 1,
            type = "item"
        }
    end

    local prod = table.deepcopy(product)
    --Check if prod.type is defined
    if not prod.type then
        prod.type = "item"
    end
    --Check for nametags
    if not prod.name then
        prod.name = prod[1]
    end
    if not prod.amount then
        prod.amount = prod[2] or 1
    end
    --No longer necessary
    prod[1] = nil
    prod[2] = nil
    return prod
end

function omni.lib.parse_results(products)
    local res = {}
    for _, product in pairs(products) do
        res[#res+1] = omni.lib.parse_result(product)
    end
    return res
end

function omni.lib.parse_ingredient(ingredient)
    return omni.lib.parse_result(ingredient)
end

function omni.lib.parse_ingredients(ingredients)
    return omni.lib.parse_results(ingredients)
end

-- Get the full product definition for a product with the given name from the given recipe part.
function omni.lib.find_product(recipe, name)
    if recipe.results then
        for _, product in pairs(recipe.results) do
            local parsed_product = omni.lib.parse_result(product) -- Format and standardise, return if applicable
            if parsed_product.name == name then
                return parsed_product
            end
        end
    end
    return nil
end

-- Get the full ingredient definition for a ingredient with the given name from the given recipe part.
function omni.lib.find_ingredient(recipe, name)
    if recipe.ingredients then
        for _, ingredient in pairs(recipe.ingredients) do
            local parsed_ingredient = omni.lib.parse_ingredient(ingredient)
            if parsed_ingredient.name == name then
                return parsed_ingredient
            end
        end
    end
    return nil
end

-- Get the main product of the given recipe.
function omni.lib.get_main_product(recipe)
    --Empty main product string - nil
    if recipe.main_product == "" then
        return nil
    --Main product is defined
    elseif recipe.main_product ~= nil then
        return omni.lib.find_product(recipe, recipe.main_product)
    --No main product defined - Check if the recipe has only 1 result
    elseif recipe.results and #recipe.results == 1 then
        return omni.lib.parse_result(recipe.results[1])
    end
    return nil
end

function omni.lib.set_recipe_ingredients(recipename,...)
    local rec = data.raw.recipe[recipename]
    if rec then
        local arg = {...}
        local ing = {}
        for _,v in pairs(arg) do
            local tmp = {}
            ing = omni.lib.union(ing, omni.lib.parse_ingredient(tmp))
        end
        rec.ingredients = ing
    end
end

function omni.lib.set_recipe_results(recipename, ...)
    local rec = data.raw.recipe[recipename]
    if rec then
        local arg = {...}
        local res = {}
        for _, v in pairs(arg) do
            local tmp = {}
            res = omni.lib.union(res, omni.lib.parse_result(tmp))
        end
        rec.results = res
    end
end

function omni.lib.add_recipe_ingredient(recipename, ingredient)
    local rec = data.raw.recipe[recipename]
    if rec then
        local newing = omni.lib.parse_ingredient(ingredient)
        local found = false
        if rec.ingredients then
            found = false
            for _, ing in pairs(rec.ingredients) do
                --check if nametags exist (only check ing[i] when no name tags exist)
                if ing.name then
                    if ing.name == newing.name then
                        found= true
                        ing.amount = ing.amount + newing.amount
                        break
                    end
                elseif ing[1] and ing[1] == newing.name then
                    found= true
                    ing[2] = ing[2] + newing.amount
                    break
                end
            end
            if  not found then
                table.insert(rec.ingredients, newing)
            end
        end
    else
        --log(recipe.." does not exist.")
    end
end

function omni.lib.add_recipe_result(recipename, result)
    local rec = data.raw.recipe[recipename]
    if rec then
        local newres = omni.lib.parse_result(result)
        local found = false
        --rec .results
        if rec.results then
            found = false
            for _,res in pairs(rec.results) do
                --check if nametags exist (only check res[i] when no name tags exist)
                if res.name then
                    if res.name == newres.name then
                        found= true
                        res.amount = res.amount + newres.amount
                        break
                    end
                elseif res[1] and res[1] == newres.name then
                    res[2] = res[2] + newres.amount
                    break
                end
            end
            if  not found then
                table.insert(rec.results, newres)
            end
        end
    else
        --log(recipe.." does not exist.")
    end
end

function omni.lib.remove_recipe_ingredient(recipename, ingredient)
    local rec = data.raw.recipe[recipename]
    if rec then
        if rec.ingredients then
            for i,ing in pairs(rec.ingredients) do
                if ing.name == ingredient or ing[1] == ingredient then
                    table.remove(rec.ingredients,i)
                end
            end
        end
    else
        log("Can not remove ingredient "..ingredient..". Recipe "..recipename.." not found.")
    end
end

function omni.lib.remove_recipe_result(recipename, result)
    local rec = data.raw.recipe[recipename]
    if rec.results then
        for i,res in pairs(rec.results) do
            if res.name == result then
                table.remove(rec.results,i)
                if rec.main_product and rec.main_product == result then
                    rec.main_product = nil
                end
                break
            end
        end
    end
end

function omni.lib.replace_recipe_result(recipename, result, replacement)
    local rec = data.raw.recipe[recipename]
    if rec and rec.results and result and replacement then
        local res = omni.lib.parse_results(rec.results)
        replacement = omni.lib.parse_result(replacement)
        local found = false

        --check if the replacement is already an result, add up the current amount
        for _, r in pairs(res) do
            if r.name == replacement.name then
                found = true
                if replacement.amount_min or replacement.amount_max then
                    r.amount_min = (r.amount_min or 0) + replacement.amount_min
                    r.amount_max = (r.amount_max or 0) + replacement.amount_max
                else
                    r.amount = r.amount + replacement.amount
                end
                break
            end
        end

        --Check all results to find the one that has to be replaced
        for num, r in pairs(res) do
            if r.name == result then
                --if the replacement was found above, set the calculated amount and nil this result, otherwise replace the result
                if found then
                    res[num] = nil
                else
                    r.name = replacement.name
                    r.type = replacement.type
                    if r.amount_min or r.amount_max then
                        r.amount_min = replacement.amount_min
                        r.amount_max = replacement.amount_max
                    else
                        r.amount = replacement.amount
                    end
                end
                break
            end
        end
        rec.results = res
        --Check if the main product was replaced
        if rec.main_product and rec.main_product == result then
            rec.main_product = replacement.name
        end
    end
end

function omni.lib.replace_recipe_ingredient(recipename, ingredient, replacement)
    local rec = data.raw.recipe[recipename]
    if rec and rec.ingredients and ingredient and replacement then
        local ing = omni.lib.parse_ingredients(rec.ingredients)
        replacement = omni.lib.parse_ingredient(replacement)
        local found = false

        --check if the replacement is already an ingredient, add up the current amount
        for _, i in pairs(ing) do
            if i.name == replacement.name then
                found = true
                i.amount = i.amount + replacement.amount
                break
            end
        end

        --Check all ingredients to find the one that has to be replaced
        for num, i in pairs(ing) do
            if i.name == ingredient then
                --if the replacement was found above, set the calculated amount and nil this result, otherwise replace the ingredient
                if found then
                    ing[num] = nil
                else
                    i.name = replacement.name
                    i.type = replacement.type
                    i.amount = replacement.amount
                end
                break
            end
        end
        rec.ingredients = ing
    end
end

function omni.lib.multiply_recipe_ingredient(recipename, ingredient, mult)
    local rec = data.raw.recipe[recipename]
    if rec then
        --rec.ingredients
        if rec.ingredients then
            for _,ing in pairs(rec.ingredients) do
                --check if nametags exist (only check ing[i] when no name tags exist)
                if ing.name then
                    if ing.name == ingredient then
                        ing.amount = omni.lib.round(ing.amount * mult)
                        break
                    end
                elseif ing[1] and ing[1] == ingredient then
                    ing[2] = omni.lib.round(ing[2] * mult)
                    break
                end
            end
        end
    end
end

function omni.lib.multiply_recipe_result(recipename, result, mult)
    local rec = data.raw.recipe[recipename]
    --rec.results
    if rec.results then
        for _,res in pairs(rec.results) do
            --check if nametags exist (only check res[i] when no name tags exist)
            if res.name then
                if res.name == result then
                    res.amount = omni.lib.round(res.amount * mult)
                    break
                end
            elseif res[1] and res[1] == result then
                res[2] = omni.lib.round(res[2] * mult)
                break
            end
        end
    end
end

function omni.lib.replace_all_ingredient(ingredient, replacement)
    for _,recipe in pairs(data.raw.recipe) do
        omni.lib.replace_recipe_ingredient(recipe.name, ingredient, replacement)
    end
end

function omni.lib.replace_all_result(result, replacement)
    for _,recipe in pairs(data.raw.recipe) do
        omni.lib.replace_recipe_result(recipe.name, result, replacement)
    end
end

function omni.lib.change_recipe_category(recipe, category)
    data.raw.recipe[recipe].category=category
end

--Checks if a recipe contains a specific material as ingredient
function omni.lib.recipe_ingredient_contains(recipename, itemname)
    local rec = data.raw.recipe[recipename]
    if rec then
        --rec.ingredients
        if rec.ingredients then
            for i,ing in pairs(rec.ingredients) do
                if omni.lib.is_in_table(itemname, ing) then return true end
            end
        end
        return nil
    end
end

--Checks if a recipe contains a specific material as result
function omni.lib.recipe_result_contains(recipename, itemname)
    local rec = data.raw.recipe[recipename]
    if rec then
        --rec.results
        if rec.results then
            for i,res in pairs(rec.results) do
                if omni.lib.is_in_table(itemname, res) then return true end
            end
        end
        return nil
    end
end

--Checks if a recipe contains an item that contains the specified string in its name
function omni.lib.recipe_result_contains_string(recipename, string)
    local items_to_check = {}
    --find all items that contain the specified string
    for _, it in pairs(data.raw.item) do
        if string.find(it.name, string) then
            items_to_check[#items_to_check+1] = it.name
        end
    end
    --check if the given recipe contains one of the items in our list
    for _, it in pairs(items_to_check) do
        if omni.lib.recipe_result_contains(recipename, it) then
            return true
        end
    end
    return nil
end

function omni.lib.get_tech_name(recipename)
    for _,tech in pairs(data.raw.technology) do
        if tech.effects then
            for _,eff in pairs(tech.effects) do
                if eff.type == "unlock-recipe" and eff.recipe ==recipename then
                    return tech.name
                end
            end
        end
    end
    return nil
end

function omni.lib.remove_recipe_all_techs(recipename)
    for _,tech in pairs(data.raw.technology) do
        if tech.effects then
            for i,eff in pairs(tech.effects) do
                if eff.type == "unlock-recipe" and eff.recipe == recipename then
                    table.remove(data.raw.technology[tech.name].effects,i)
                end
            end
        end
    end
end

function omni.lib.replace_recipe_all_techs(recipename,replacement)
    for _,tech in pairs(data.raw.technology) do
        if tech.effects then
            for i,eff in pairs(tech.effects) do
                if eff.type == "unlock-recipe" and eff.recipe == recipename then
                    eff.recipe=replacement
                end
            end
        end
    end
end

--Checks if the recipe is enabled
function omni.lib.recipe_is_enabled(recipename)
    local rec = data.raw.recipe[recipename]
    if rec then
        --Check rec.enabled which has prio
        if rec.enabled ~= nil then
            if rec.enabled == true then
                return true
            else
                return false
            end
        --nothing is set --> recipe is enabled by default
        else
            return true
        end
    end
    return nil
end

--Checks if the recipe is hidden
function omni.lib.recipe_is_hidden(recipename)
    local rec = data.raw.recipe[recipename]
    if rec then
        --Check rec.hidden which has prio
        if rec.hidden ~= nil then
            if rec.hidden == true then
                return true
            else
                return false
            end
        --nothing is set --> recipe is not hidden
        else
            return false
        end
    end
    return nil
end