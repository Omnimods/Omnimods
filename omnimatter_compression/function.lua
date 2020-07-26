added_list = {}
excluded_recipes = {}
include_recipes = {}

compress_entity = {}

function omni.compression.exclude_recipe(recipe)
  if not omni.lib.is_in_table(recipe,excluded_recipes) then
    excluded_recipes[#excluded_recipes+1]=recipe
  end
end

function omni.compression.include_recipe(recipe)
  if not omni.lib.is_in_table(recipe,include_recipes) then
    include_recipes[#include_recipes+1]=recipe
  end
end

function omni.compression.exclude_entity(entity)
  if not (compress_entity[entity] and compress_entity[entity].exclude == nil) then
    compress_entity[entity]={exclude=true}
  end
end

function omni.compression.include_entity(entity)
  if not (compress_entity[entity] and compress_entity[entity].include == nil)then
    compress_entity[entity]={include=true}
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

local locale = omni.locale
omni.compression.set_localisation = function(old_prototype, new_prototype, name_key, description_key)--class_override format: "type-%s.prototype.name"
  if name_key then
    new_prototype.localised_name = {
      new_prototype.type.."-name."..name_key,
      old_prototype.localised_name or locale.of(old_prototype).name--locale.of(old_prototype).name
    }
  end
  if description_key then
    new_prototype.localised_description = {
      new_prototype.type.."-description."..description_key,
      old_prototype.localised_description or locale.of(old_prototype).description
    }
  end
end