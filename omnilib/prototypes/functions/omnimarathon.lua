if not omni then omni={} end    
if not omni.marathon then omni.marathon={} end

marathon_recipes = {}
marathon_items = {}

function omni.marathon.exclude_recipe(recipe)
    if recipe then marathon_recipes[recipe]={recipe=recipe} end
end
function omni.marathon.inverse_recipes(recipe1,recipe2)
    if not marathon_recipes[recipe1] then
        marathon_recipes[recipe1]={recipe=recipe1,inverse=recipe2}
    else
        marathon_recipes[recipe1].inverse=recipe2
    end
    if not marathon_recipes[recipe2] then
        marathon_recipes[recipe2]={recipe=recipe2,inverse=recipe1}
    else
        marathon_recipes[recipe2].inverse=recipe1
    end
end
function omni.marathon.exclude_item(item)
    omni.marathon.exclude_item_ingredient(item)
    omni.marathon.exclude_item_result(item)
end
function omni.marathon.normalize(recipe)
    if not marathon_recipes[recipe] then
        marathon_recipes[recipe]={normalize=true}    
    else
        marathon_recipes[recipe].normalize=true
    end
end
function omni.marathon.exclude_item_ingredient(item)
    marathon_items[item]={ingredients=true}
end
function omni.marathon.exclude_item_result(item)
    marathon_items[item]={results=true}
end
function omni.marathon.equalize(item,res)
    if not marathon_items[item] then
        marathon_items[item]={equal={res}}
    else
        marathon_items[item].equal[#marathon_items[item].equal+1]=res
    end
end
function omni.marathon.item_constant(item,c)
    marathon_items[item]=c
end
function omni.marathon.exclude_item_in_recipe(recipe,item)
    omni.marathon.multiply_recipe_item(recipe,item,0)
end
function omni.marathon.multiply_recipe_item(recipe,it,constant)
    if not marathon_recipes[recipe] then
        marathon_recipes[recipe]={recipe=recipe,item={}}
        marathon_recipes[recipe].item[it]={mult = constant}
    else
        if not marathon_recipes[recipe].item then marathon_recipes[recipe].item={} end
        if not marathon_recipes[recipe].item[it] then marathon_recipes[recipe].item[it] = {} end
        marathon_recipes[recipe].item[it].mult=constant
    end
end

function omni.marathon.addition_recipe_item(recipe,it,constant)
    if not marathon_recipes[recipe] then
        marathon_recipes[recipe]={recipe=recipe,item={}}
        marathon_recipes[recipe].item[it]={add = constant}
    else
        if not marathon_recipes[recipe].item then marathon_recipes[recipe].item={} end
        if not marathon_recipes[recipe].item[it] then marathon_recipes[recipe].item[it] = {} end
        marathon_recipes[recipe].item[it].add=constant
    end
end

function omni.marathon.multiply_recipe_results(recipe,constant)
    for _,res in pairs(data.raw.recipe[recipe].normal.results) do
        omni.marathon.multiply_recipe_item(recipe,res.name,constant)
    end
end

function omni.marathon.multiply_recipe_ingredients(recipe,constant)
    --log(recipe)
    for _,res in pairs(data.raw.recipe[recipe].normal.ingredients) do
        omni.marathon.multiply_recipe_item(recipe,res.name,constant)
    end
end

function omni.marathon.addition_recipe_results(recipe,constant)
    for _,res in pairs(data.raw.recipe[recipe].normal.results) do
        omni.marathon.addition_recipe_item(recipe,res.name,constant)
    end
end

function omni.marathon.addition_recipe_ingredients(recipe,constant)
    for _,res in pairs(data.raw.recipe[recipe].normal.ingredients) do
        omni.marathon.addition_recipe_item(recipe,res.name,constant)
    end
end