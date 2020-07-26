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

local find_result_icon = omni.lib.find_result_icon

omni.compression.add_overlay = function(it,overlay_type,level) 
  -- `it` is the item/recipe table, not the name (can search for it if wrong)
  -- overlay_type is a string for type or an iconspecification table:
    -- "compress" for compressed item/recipe
    -- "uncompress" for decompression recipe
    -- "building" for compressed buildings
    -- "compress-fluid" is for tiered compressed fluids
    -- "technology" for compressed techs
    -- level is required for building type and compress-fluid and should be a number, optional for others
  --check if it is correct, if not fix it
  if type(it) == "string" then --parsed whole table not the name...
    it = omni.lib.find_prototype(it)
  end

  local overlay = {}
  if type(overlay_type) == "string" then
    if overlay_type == "building" and level ~= nil then
      overlay.icon = "__omnimatter_compression__/graphics/compress-"..level.."-32.png"
    elseif overlay_type == "compress" then
      overlay = {
        icon = "__omnimatter_compression__/graphics/compress-32.png",
        tint = {1,0,0,1},
        scale = 1.5,
        shift = {-8, 8}
      }
    elseif overlay_type == "uncompress" then
      overlay.icon = "__omnimatter_compression__/graphics/compress-out-arrow-32.png"
    elseif overlay_type == "compress-fluid" and level ~= nil then
      overlay.icon = "__omnilib__/graphics/icons/small/lvl"..level..".png"
    elseif overlay_type == "technology" then
      overlay = {
        icon = "__omnimatter_compression__/graphics/compress-tech-128.png",
        icon_size = 128,
        scale=0.5,
        shift={-16,16},
        tint={r=1,g=1,b=1,a=0.75}
      }
    end
  else
    overlay = overlay_type
  end
  
  local icons = find_result_icon(it)
  if icons then --ensure it exists first
    -- Do we require an overlay? This will be placed at the end of the list and thus on top
    if overlay.icon then
      overlay.icon_size = overlay.icon_size or 32
      icons = util.combine_icons(icons, {overlay}, {})
    end
    -- This is the first table entry on which the others are built
    --[[
    local base_icon = {{
      icon = "__omnilib__/graphics/icons/blank.png",
      icon_size = 32 --set initial icon to set the size for auto-scaling purposes
    }}
    return util.combine_icons(base_icon, icons, {})]]
    return icons
  end
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