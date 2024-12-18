local hierarchy = require('locale-hierarchy')

local lib = { -- We'll return this as omni.locale
    partial = {}
} 

-- All of the below is sourced from the code and methods of TheRustyKnife's locale resolver.
-- Many thanks to the hours he spent screaming so I don't have to
-- Comments added to explain steps as they happen
-- Most of this is untouched beyond some housekeeping, it comes readable as-is

function lib.resolver(resolvers)
-- Make an empty table that calls a function from `resolvers` with the same name to resolve non-existent keys.
    return setmetatable({}, {
        __index = function(self, key) -- Called when we index a nonexistent key
            local f = resolvers[key] -- Do we have a resolver for this type?
            if f then
                self[key] = f(self) -- Set for next time this key is indexed
                return self[key] -- Return the resolved value
            end
            return nil -- no resolver, what are you doing
        end,
    })
end

local function is_known(prototype_type) -- Are we the heir or parent?
    return hierarchy.top_down[prototype_type] or hierarchy.bottom_up[prototype_type]
end

function lib.descendants(prototype_type)-- Get the tree of descendants, rooted at the given type, or nil if the type doesn't exist.
    if prototype_type == nil then
        return hierarchy.bottom_up
    end
    if not is_known(prototype_type) then 
        log(("lib.descendants: Checking descendants of unknown type `%s`!"):format(prototype_type))
    end
    return lib.descendants(hierarchy.top_down[prototype_type])[prototype_type]
end

function lib.inherits(prototype_type, bases)
    -- Check if type is a descendant either a single base prototype or any of several prototypes provided as a table {string: boolean}.
    -- This returns the type that matched, or nil of none did.
    if prototype_type == nil then
        return nil
    elseif type(bases) ~= 'table' then -- Fixup input formats if needed
        return lib.inherits(prototype_type, {
            [bases] = true -- Make sure our initial input is accounted for in the next check
        })
    elseif bases[prototype_type] then
        return prototype_type -- We found our parent!
    end
    if not is_known(prototype_type) then -- If our table doesn't have this we should be a bit concerned.
        log(("lib.inherits: Checking inheritance of unknown type `%s`!"):format(prototype_type))
    end
    return lib.inherits(hierarchy.top_down[prototype_type], bases) -- One step further down in the table
end

function lib.find(input_name, input_type, silent)
-- Find the prototype with the given name, whose type inherits from the given type, or nil if it doesn't exist.
    if input_type == nil then
        error("lib.find needs a type - use find_by_name to search by name only instead.")
    end

    if input_name == nil then
        if silent then
            return nil -- Silent is basically continue_on_error
        else
            error("lib.find: bad input, prototypes can't have a nil name")
        end
    end
    
    for type_name, prototypes in pairs(data.raw) do -- Go through our parent categories
        local prototype = prototypes[input_name] -- This is the prototype of input_name, maybe
        if prototype and lib.inherits(type_name, input_type) then 
            return prototype -- We have a valid prototype *and* it inherits from the correct type
        end
    end

    -- Our princess is in another castle (or more likely, doesn't exist)
    if silent then
        return nil
    end

    -- If we haven't been told not to error, we will now proceed to error.
    -- You could have stopped this
    local existing_types = {}
    for prototype_type, _ in pairs(lib.find_by_name(input_name)) do -- Find valid types with matching names
        table.insert(existing_types, prototype_type)
    end
    -- Log with our types and input arguments
    error(
        string.format(
            "No prototype called `%s` found for type `%s`, these prototypes with the name exist: %s",
            input_name,
            input_type,
            serpent.line(existing_types)
        )
    )
end

function lib.find_by_name(name)
-- Find all prototypes with the given name. Returns a table of {type: prototype}.
    local results = {}
    for prototype_type, prototypes in pairs(data.raw) do-- Just going one deep for a match here, we don't care about inheritance
        results[prototype_type] = prototypes[name]
    end
    return results
end

local function remove_trailing_level(prototype_name)
    -- locale key for levelled technologies is the technology name with the level removed
    return prototype_name:gsub("-%d+$", "")
end

local function key_of(prototype, key_type, locale_type)
-- Get the default locale key for the given prototype and key type (name or description).
    if not locale_type then 
        locale_type = lib.inherits(prototype.type, lib.localised_types) -- If we don't have our type overridden, find one
    end
    local prototype_name = prototype.name
    if locale_type == 'technology' then -- Make sure multilevel techs aren't returned wrong
        prototype_name = remove_trailing_level(prototype_name)
    end 
    return {-- category-thing.key, as table because localised string
        string.format('%s-%s.%s', locale_type, key_type, prototype_name)
    }
end

-- These are the base types that support locale
lib.localised_types = {}
for prototype_type in pairs(lib.descendants('prototype-base')) do -- Working downwards through the tree
    lib.localised_types[prototype_type] = true
end

function lib.of_generic(prototype, locale_type)
-- Get the locale of the given prototype, assuming it's one of the types that use the generic format.
    return lib.resolver({ -- By passing to the resolver, it will call the appropriate resolution function for our type
        name = function() 
            return prototype.localised_name
            or key_of(prototype, 'name', locale_type)
        end,
        description = function()
            return prototype.localised_description
            or key_of(prototype, 'description', locale_type)
        end
    })
end

function lib.of_item(prototype)
-- Get the locale of the given item.
    return lib.resolver({ -- it's just locale.of but item themed
        place_result = function()
            return ( -- our place_result proto or false
                prototype.place_result and 
                prototype.place_result ~= '' and
                lib.of_generic(
                    lib.find(
                        prototype.place_result,
                        'entity'
                    ),
                    'entity'
                )
                or false
            )
        end,
        place_as_equipment_result = function()
            return (
                prototype.place_as_equipment_result and
                lib.of_generic( -- Find the type and locale of our equipment result
                    lib.find(
                        prototype.place_as_equipment_result,
                        'equipment'
                    ),
                    'equipment'
                )
                or false
            )
        end,
        name = function(self) -- Our most basic hierarchy: set name, place result, equipment, item in that order
            return prototype.localised_name
            or self.place_result and self.place_result.name
            or self.place_as_equipment_result and self.place_as_equipment_result.name
            or key_of(prototype, 'name', 'item')
        end,
        description = function(self)
            return prototype.localised_description
            or key_of(prototype, 'description', 'item')
        end
    })
end

function lib.of_recipe(prototype)
-- Get the locale of the given recipe.
    return lib.resolver { -- Throw to the appropriate function
        main_product = function()
            local product = omni.lib.get_main_product(prototype)
            return product and lib.of(
                lib.find(product.name, product.type)
            ) or {}
        end,        
        name = function(self)-- Set name, product name, or recipe name
            return prototype.localised_name
            or self.main_product.name
            or key_of(prototype, 'name', 'recipe')
        end,
        description = function(self)
            return prototype.localised_description
            or key_of(prototype, 'description', 'recipe')
        end,
    }
end

local custom_resolvers = {
    ['recipe'] = lib.of_recipe,
    ['item'] = lib.of_item,
} -- This way we can direct anything thrown at .of to the correct function

function lib.of(prototype, prototype_type)
--- Get the locale of the given prototype.
    if prototype_type ~= nil then
        prototype = lib.find(prototype, prototype_type)
    end
    local locale_type = lib.inherits(prototype.type, lib.localised_types)
    assert( -- If we don't have a return, we assert.
        locale_type,
        string.format(
            "%s doesn't support localization",
            prototype.type
        )
    )
    local resolver = custom_resolvers[locale_type] or lib.of_generic-- Either pass to our resolver, or use the generic function
    return resolver(prototype, locale_type)
end

lib.custom_name = function(prototype, name_key, ...)
    if not name_key:find("%.") then
        name_key = lib.inherits(prototype.type, lib.localised_types).."-name."..name_key
    end
    return {
        name_key,
        lib.of(prototype).name,
        ...
    }
end

lib.custom_description = function(prototype, desc_key, ...)
    if not desc_key:find("%.") then
        desc_key = lib.inherits(prototype.type, lib.localised_types).."-description."..desc_key
    end
    return {
        desc_key,
        lib.of(prototype).description,
        ...
    }
end
omni.lib.locale = lib