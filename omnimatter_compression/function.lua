added_list = {}
excluded_recipes = {}
include_recipes = {}

compress_entity = {}

if not omni then omni={} end
if not omni.compression then omni.compression={} end

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
  local str="" --clear each time
  --find and replace all '-' with %20 (space)
  --capitalise first letter of first word
  str = string.gsub(name,"%-"," ")
  str = str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
  return str
end