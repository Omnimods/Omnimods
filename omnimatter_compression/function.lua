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
-----------------------------------------------------------------------------
-- ICON FUNCTIONS --
-----------------------------------------------------------------------------
--Find base icon
local find_icon = function(item)
	for _, p in pairs({"item","mining-tool","gun","ammo","armor","repair-tool","capsule","module","tool","rail-planner","item-with-entity-data","fluid"}) do
		if data.raw[p][item] then
			if data.raw[p][item].icons then
				return data.raw[p][item].icons
			else
				return {{icon = data.raw[p][item].icon, icon_size = data.raw[p][item].icon_size or 32}}
			end
		end
	end
end
--really dig deep for the icon set
local find_result_icon = function(it)
  if type(it) == "table" then
    if it then --search for the icon in its various hiding places
      if it.icons then
        icons=table.deepcopy(it.icons)
        if it.icon_size and not it.icons[1].icon_size then
          icons[1].icon_size=it.icon_size or 32
        end
        return icons
      else
        if it.icon then
          return  {{icon = it.icon, icon_size = it.icon_size or 32}}
        else
          local process = {}
          if it.result or (it.normal and it.normal.result) then
            if it.result then
              process = find_icon(it.result)
            else
              process = find_icon(it.normal.result)
            end
          else
            if it.results then
              process = find_icon(it.results[1].name)
            else
              process = find_icon(it.normal.results[1].name)
            end
          end
          if process ~= nil then
            if process[1] and process[1].icon then
              if it.icon_size and not process[1].icon_size then
                process[1].icon_size=it.icon_size or 32
              end
            end
            return process
          else
            return {{icon = "__omnimatter_compression__/graphics/compress-out-arrow-32.png", icon_size = 32}} --should be using blank, but for testing...
          end
        end
      end
    else
      return {{icon = "__omnimatter_compression__/graphics/compress-out-arrow-32.png", icon_size = 32}} --should be using blank, but for testing...
    end
  end
end

omni.compression.add_overlay = function(it,overlay_type,level) 
  -- `it` is the item/recipe table, not the name (can search for it if wrong)
  -- overlay_type is a string for type:
    -- "compress" for compressed item/recipe
    -- "uncompress" for decompression recipe
    -- "building" for compressed buildings
    -- level is required for building type and should be a number, optional for others
  --check if it is correct, if not fix it
  if type(it) == "string" then --parsed whole table not the name...
    it = omni.lib.find_prototype(it)
  end
  --set overlay icon
  if overlay_type == "building" and level ~= nil then
    overlay = {icon = "__omnimatter_compression__/graphics/compress-"..level.."-32.png", icon_size = 32, scale=1}
    if it.icons then
      it_icons=it.icons
    else
      it_icons={{icon = it.icon, icon_size = it.icon_size or 32}}
    end
  elseif overlay_type == "compress" then
    overlay = {icon = "__omnimatter_compression__/graphics/compress-32.png", icon_size = 32}
  elseif overlay_type == "uncompress" then
    overlay = {icon = "__omnimatter_compression__/graphics/compress-out-arrow-32.png", icon_size = 32}
  end
  --set icons table
  it_icons = find_result_icon(it)
  --set up loop where we add a blank on the base and overlay on the top.
  if it_icons then --ensure it exists first
    icons = {{icon = "__omnilib__/graphics/blank.png", icon_size = 32}} --set initial icon to set the size for auto-scaling purposes
    for i,icon in pairs(it_icons) do
      icons[#icons+1] = icon --add each icon to the list
    end
    --add overlay at the end
    icons[#icons+1] = overlay
  else
    icons = {{icon = "__omnimatter_compression__/graphics/compress-out-arrow-32.png", icon_size = 32}} --error
  end
  return icons
end

