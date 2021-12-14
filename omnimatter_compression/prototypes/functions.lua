omni.compression.excluded_recipes = {}
omni.compression.include_recipes = {}
omni.compression.compress_entity = {}

function omni.compression.exclude_recipe(recipe)
    if not omni.lib.is_in_table(recipe,omni.compression.excluded_recipes) then
        omni.compression.excluded_recipes[#omni.compression.excluded_recipes+1]=recipe
    end
end

function omni.compression.include_recipe(recipe)
    if not omni.lib.is_in_table(recipe,omni.compression.include_recipes) then
        omni.compression.include_recipes[#omni.compression.include_recipes+1]=recipe
    end
end

function omni.compression.exclude_entity(entity)
    if not (omni.compression.compress_entity[entity] and omni.compression.compress_entity[entity].exclude == nil) then
        omni.compression.compress_entity[entity]={exclude=true}
    end
end

function omni.compression.include_entity(entity)
    if not (omni.compression.compress_entity[entity] and omni.compression.compress_entity[entity].include == nil)then
        omni.compression.compress_entity[entity]={include=true}
    end
end

function omni.compression.CleanName(name)
    if type(name) == "table" then return name end
    local str = "" --clear each time
    --find and replace all '-' with %20 (space)
    --capitalise first letter of first word
    str = string.gsub(name,"%-"," ")
    str = str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
    return str
end

--finds if the object is hidden by flag
function omni.compression.is_hidden(obj)
    local hidden = false
    for _, flag in ipairs(obj.flags or {}) do
        if flag == "hidden" then
            hidden = true
        end
    end
    return hidden
end

--finds if the object is stackable by flag
function omni.compression.is_stackable(obj)
    local stackable = true
    for _, flag in ipairs(obj.flags or {}) do
        if flag == "not-stackable" then
            stackable = false
        end
    end
    return stackable
end