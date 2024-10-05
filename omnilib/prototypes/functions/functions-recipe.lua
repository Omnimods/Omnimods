function omni.lib.set_recipe_ingredients(recipename,...)
    local rec = data.raw.recipe[recipename]
    if rec then
        local arg = {...}
        local ing = {}
        for _,v in pairs(arg) do
            local tmp = {}
            if type(v)=="string" then
                tmp = {{name = v, type = "item", amount = 1}}
            elseif type(v) == "table" then
                if type(v[1]) == "string" then
                    tmp = {{name = v[1], type = "item", amount = v[2]}}
                elseif v.name then
                    tmp = {{name = v.name, type = v.type or "item", amount = v.amount, probability = v.probability, amount_min = v.amount_min, amount_max = v.amount_max}}
                end
            end
            ing = omni.lib.union(ing,tmp)
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
            if type(v)=="string" then
                tmp = {{name = v, type = "item", amount = 1}}
            elseif type(v)=="table" then
                if type(v[1]) == "string" then
                    tmp = {{name = v[1], type="item", amount = v[2]}}
                elseif v.name then
                    tmp = {{name = v.name, type = v.type or "item", amount = v.amount, probability = v.probability, amount_min = v.amount_min, amount_max = v.amount_max}}
                end
            end
            res = omni.lib.union(res,tmp)
        end
        rec.results = res
    end
end

function omni.lib.add_recipe_ingredient(recipename, ingredient)
    local rec = data.raw.recipe[recipename]
    if rec then
        local newing = {}
        if not ingredient.name then
            if type(ingredient) == "string" then
                newing = {type="item",name=ingredient,amount=1}
            elseif ingredient[1].name then
                newing = ingredient[1]
            elseif type(ingredient[1])=="string" then
                newing = {type="item", name=ingredient[1],amount=ingredient[2]}
            end
        else
            newing = table.deepcopy(ingredient)
        end

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
        local newres = {}
        if not result.name then
            if type(result) == "string" then
                newres = {type = "item", name = result, amount = 1}
            elseif result[1].name then
                newres = result[1]
            elseif type(result[1])=="string" then
                newres = {type = "item", name = result[1], amount = result[2]}
            end
        else
            newres = table.deepcopy(result)
        end

        local found = false
        --rec.normal.results
        if rec.normal.results then
            found = false
            for _,res in pairs(rec.normal.results) do
                --check if nametags exist (only check res[i] when no name tags exist)
                if res.name then
                    if res.name == newres.name then
                        found= true
                        res.amount = res.amount + newres.amount
                        break
                    end
                elseif res[1] and res[1] == newres.name then
                    found= true
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
    if rec then
        local resname = result.name or result[1]
        --Add replacement
        omni.lib.add_recipe_result(recipename, replacement)
        --Check if the main product will be replaced
        if rec.main_product and rec.main_product == resname then
            rec.main_product = replacement.name or replacement[1]
        end
        --remove replacement
        omni.lib.remove_recipe_result(recipename, result)
    end
end

function omni.lib.replace_recipe_ingredient(recipename, ingredient, replacement)
    local rec = data.raw.recipe[recipename]
    if rec then
        --Add replacement
        omni.lib.add_recipe_ingredient(recipename, replacement)
        --remove replacement
        omni.lib.remove_recipe_ingredient(recipename, ingredient)
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
        elseif (rec.normal and rec.normal.hidden ~= nil) or (rec.expensive and rec.expensive.hidden~= nil) then
            if (rec.normal and rec.normal.hidden == true) or (rec.expensive and rec.expensive.hidden == true) then
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