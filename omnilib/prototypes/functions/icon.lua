local icon = { -- We'll return this as omni.icon
    partial = {}
} 

-- Icons
function icon.of_generic(prototype, silent)
    --- Get icons for the given prototype, assuming it's in the generic format.
    if prototype.icons then
        local icons = {}
        for i, icon in pairs(prototype.icons) do
            if icon.icon and icon.icon_size then icons[i] = icon
            else
                local icon_size = icon.icon_size or prototype.icon_size
                if not icon_size or not icon.icon then
                    if silent then
                        return nil
                    end
                    error(("%s/%s doesn't specify icons correctly"):format(prototype.type, prototype.name))
                end                
                local new = {}
                for k, v in pairs(icon) do
                    new[k] = v
                end
                new.icon_size = icon_size
                icons[i] = new
            end
        end
        return icons
    end
    if not prototype.icon or not prototype.icon_size then
        if silent then
            return nil
        end
        error(("%s/%s doesn't specify icons correctly"):format(prototype.type, prototype.name))
    end
    return {{
        icon = prototype.icon,
        icon_size = prototype.icon_size
    }}
end

function icon.of_recipe(prototype, silent)
    --- Get icons for the given recipe prototype.
    local icons = icon.of_generic(prototype, true)
    if icons then return icons; end

    local product
    if prototype.normal ~= nil then product = omni.lib.locale.partial.get_main_product(prototype.normal)
    else product = omni.lib.locale.partial.get_main_product(prototype); end

    if not product then
        if silent then
            return nil
        end
        log(serpent.block(prototype))
        error(("%s/%s doesn't specify icons correctly"):format(prototype.type, prototype.name))
    end

    return product and icon.of(product.name, product.type, silent)
end


function icon.of(prototype, ptype, silent)
    --- Get the icons of the given prototype.
    if type(ptype) == 'string' then
        prototype = omni.lib.locale.find(prototype, ptype, silent)
    elseif prototype == nil then
        if silent then
            return nil 
        end
        error("Can't get icons of nil prototype")
    elseif type(ptype) == 'boolean' then -- wrong arg order
        silent = ptype 
    end
    -- We got handed a .icons
    if type(prototype) == "table" and prototype[1] and prototype[1].icon then
        return prototype
    end
    if omni.lib.locale.inherits(prototype.type, 'recipe') then
        return icon.of_recipe(prototype, silent)
    else
        return icon.of_generic(prototype, silent)
    end
end

omni.lib.icon = icon