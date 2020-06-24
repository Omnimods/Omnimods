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
-----------------------------------------------------------------------------
-- ICON FUNCTIONS --
-----------------------------------------------------------------------------
--If our prototype doesn't have an icon, we need to find one that does
local find_icon = function(item)
  for _, p in pairs({"item","mining-tool","gun","ammo","armor","repair-tool","capsule","module","tool","rail-planner","item-with-entity-data","fluid"}) do
    if data.raw[p][item] then
      if data.raw[p][item].icons or data.raw[p][item].icon then
        return data.raw[p][item]
      end
    end
  end
end
--really dig deep for the icon set
local function find_result_icon(raw_item)
  if raw_item then
    if type(raw_item) ~= "table" then
      raw_item = find_icon(raw_item) --Find a matching prototype if possible
      return find_result_icon(raw_item)
    elseif raw_item.icons then
      local icons = table.deepcopy(raw_item.icons)
      for i, icon in pairs(icons) do-- Apply inherited attributes as explicit for each layer
        icon.icon_size = icon.icon_size or raw_item.icon_size
        icon.icon_mipmaps = icon.icon_mipmaps or raw_item.icon_mipmaps
      end
      return icons
    elseif raw_item.icon then
      return {{
        icon = raw_item.icon,
        icon_size = raw_item.icon_size
      }}
    else
      local result = (-- recipe.result, first entry in recipe.results or either of the previous two within normal and expensive recipe blocks
        (raw_item.result) or
        (raw_item.results and raw_item.results[1].name) or
        (raw_item.normal and (raw_item.normal.result or raw_item.normal.results[1].name)) or
        (raw_item.expensive and (raw_item.expensive.result or raw_item.expensive.results[1].name)) 
      )
      return find_result_icon(result)
    end
  else
    return {{
      icon = "__core__/graphics/too-far.png",--ERROR
      icon_size = 32,
    }}
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

  local overlay = {}
  if overlay_type == "building" and level ~= nil then
    overlay.icon = "__omnimatter_compression__/graphics/compress-"..level.."-32.png"
  elseif overlay_type == "compress" then
    overlay.icon = "__omnimatter_compression__/graphics/compress-32.png"
  elseif overlay_type == "uncompress" then
    overlay.icon = "__omnimatter_compression__/graphics/compress-out-arrow-32.png"
  end
  
  local icons = find_result_icon(it)
  if icons then --ensure it exists first
    -- Do we require an overlay? This will be placed at the end of the list and thus on top
    if overlay.icon then
      overlay.icon_size = 32
      icons = util.combine_icons(icons, {overlay}, {})
    end
    -- This is the first table entry on which the others are built
    local base_icon = {{
      icon = "__omnilib__/graphics/icons/blank.png",
      icon_size = 32 --set initial icon to set the size for auto-scaling purposes
    }}
    return util.combine_icons(base_icon, icons, {})--add overlay at the end
  end
end
