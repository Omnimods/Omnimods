RecGen = {}
RecGen.__index = RecGen

ItemGen = {}
ItemGen.__index = ItemGen

FluidGen = {}

RecChain = {}
RecChain.__index = RecChain

BotGen = {}
BotGen.__index = BotGen

InsGen = {}
InsGen.__index = InsGen

TechGen = {}
TechGen.__index = TechGen


BuildGen = {}
BuildGen.__index = BuildGen

InsertGen = {}
InsertGen.__index = InsertGen

OmniGen = {}
OmniGen.__index = OmniGen

Omni = {
    Gen = {Rec = {},Item={},Bot={},Ins={},Tech={},Build={}},
    Chain={Rec = {},Bot={},Ins={},Build={}}
}

setmetatable(RecGen, {
    __index = ItemGen, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:create(...)
        return self
    end,
})

setmetatable(InsertGen, {
    __index = BuildGen, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:create(...)
        return self
    end,
})

setmetatable(RecChain, {
    __index = RecGen, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:create(...)
        return self
    end,
})

setmetatable(BuildGen, {
    __index = RecGen, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:create(...)
        return self
    end,
})

setmetatable(BotGen, {
    __index = RecGen, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:create(...)
        return self
    end,
})

setmetatable(InsGen, {
    __index = BuildGen, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:create(...)
        return self
    end,
})

local parents  = {BuildGen,RecChain}
local rawset   = rawset
local cache_mt = {}
function cache_mt:__index(key)
    for i = 1, #parents do
        local parent = parents[i]
        local value = parent[key]
        if value ~= nil then
            rawset(self, key, value)
            return value
        end
    end
end

local function search (k, plist)
    for i=1, table_size(plist) do
        local v = plist[i][k]     -- try `i'-th superclass
        if v then return v end
    end
end

function createClass (...)
    local c = {}        -- new class

    -- class will search for each method in the list of its
    -- parents (`arg' is the list of parents)
    setmetatable(c, {__index = function (t, k)
        return search(k, arg)
    end})

    -- prepare `c' to be the metatable of its instances
    c.__index = c

    -- define a new constructor for this new class
    function c:new (o)
        o = o or {}
        setmetatable(o, c)
        return o
    end

    -- return new class
    return c
end

function cache_mt:__call(cls, ...)
    local self = setmetatable({}, cls)
    self:create(...)
    return self
end

local cache = setmetatable({}, cache_mt)


BuildChain = createClass(RecChain,BuildGen)
--BuildChain.__index = BuildChain

setmetatable(BuildChain, {
  __index = cache,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:create(...)
    return self
    end
})

--[[
    Takes an input and checks if is of the a table and then
    if the input is a table, checks if it has a subtable
    that is of the type or have variable name of those
    added in, if so it spits out the subtable, otherwise the entire table.

    This is to prevent endless subtabling of main tables
    as the inheritance goes on.
]]
local argTable = function(arg, ...)
    local check = {...}
    local bool = type(arg[1])=="table"
    for _, c in pairs(check) do
        bool = bool and not (arg[1][c] or type(arg[1][1])==c)
    end
    if bool then return arg[1] end
    return arg
end

local replaceIngres = function(tabIngres,arg)
    for i, ingres in pairs(tabIngres) do
        for _,r in pairs(arg) do
            if (type(r[1])=="string" and ingres.name == r[1]) or (type(r[1])=="number" and i==r[1]) then
                if type(r[2])=="string" then
                    tabIngres[i].name=r[2]
                else
                    tabIngres[i]=table.deepcopy(r[2])
                end
                break
            end
        end
    end
    return tabIngres
end
local multiplyIngres = function(tabIngres,name,mult)
    if not mult then mult = name;name=nil end
    for i, ingres in pairs(tabIngres) do
        if ingres.name == name or name==nil then
            if tabIngres[i].type=="item" then
                tabIngres[i].amount=omni.lib.round(ingres.amount*mult)
            else
                tabIngres[i].amount=ingres.amount*mult
            end
        end
    end
    return tabIngres
end

function OmniGen:create()
    return setmetatable({
        type = "chain",
        shift = {},
        input = {
            items = {
            },
            sum=function(levels,grade) return 12 end
        },
        output = {
            yield={
                items = {
                },
                quant = function(levels,grade) return linear_gen(6,12,levels,grade) end
            },
            waste = {
                items = {
                    "omnic-waste",
                    "stone-crushed"
                },
                quant = function(levels,grade) return 12 - linear_gen(6,12,levels,grade) end
            }
        }
    },OmniGen)
end
function OmniGen:linearOutput(total,start,finish)
    self.output.yield.quant = function(levels,grade) return linear_gen(start,finish or total,levels,grade) end
    self.output.waste.quant = function(levels,grade) return total-linear_gen(start,finish or total,levels,grade) end
    return self
end
function OmniGen:linearPercentOutput(total,start,finish)
    self.output.yield.quant = function(levels,grade) return linear_gen(start*total,(finish or 1)*total,levels,grade) end
    self.output.waste.quant = function(levels,grade) return total-linear_gen(start*total,(finish or 1)*total,levels,grade) end
    return self
end
function OmniGen:wasteQuant(operation)
    self.output.waste.quant=operation
    return self
end
function OmniGen:yieldQuant(operation)
    self.output.yield.quant=operation
    return self
end
function OmniGen:setInputAmount(array)
    if type(array)=="function"  then
        self.input.sum = array
    elseif type(array)=="number" then
        self.input.sum = function(levels,grade) return array end
    end
    return self
end
function OmniGen:setIngredients(array,...)
    local arg = {...}
    if #arg > 0 then
        if array.name then
            array = {array}
        elseif type(array[1]) == "string" then
            array={{name=array[1], amount=array[2] or 0, type="item"}}
        end
        for i,v in pairs(arg) do
            local c = v
            if type(v[1])=="string" then c = {name=v[1],amount=v[2],type="item"} end
            array = omni.lib.union(array,{c})
        end
    end
    if type(array)=="table" then
        if array.name then
            self.input.items = {array}
        else
            self.input.items = array
        end
    else
        self.input.items = {{name=array}}
    end
    return self
end
function OmniGen:addIngredients(...)
    for _,ing in pairs({...}) do
        local addIng = ing
        if type(ing[1])=="string" and type(ing[2])=="number" then
            addIng={name=ing[1],amount=ing[2] or 0, type="item"}
        end
        table.insert(self.input.items,addIng)
    end
    return self
end
function OmniGen:ifAddIngredients(bool,...)
    if bool then
        return self:addIngredients(...)
    end
    return self
end
function OmniGen:setYield(array)
    if type(array)=="table" then
        self.output.yield.items = {array}
    else
        self.output.yield.items = {{name = array}}
    end
    return self
end
function OmniGen:addYield(item)
    local t = item
    if type(item)=="string" then t={name=item} end
    table.insert(self.output.yield.items,t)
end
function OmniGen:setWaste(array,...)
    local arg = {...}
    if #arg > 0 then
        if array.name then
            array = {array}
        elseif type(array[1]) == "string" then
            array={name=array[1]}
        elseif type(array)=="string" then
            array={{name=array}}
        end
        for i,v in pairs(arg) do
            local c = v
            --if type(v[1])=="string" then c = {name=v[1],amount=v[2],type="item"} end
            if type(v)=="string" then
                c={name=v}
            elseif type(v)=="table" then
            end
            array = omni.lib.union(array,{c})
        end
    end
    if type(array)=="table" then
        if type(array[1])=="table" then
            self.output.waste.items = array
        else
            self.output.waste.items = {array}
        end
    elseif type(array)=="string" then
        self.output.waste.items = {{name = array}}
    else
        self.output.waste.items = nil
    end
    return self
end
function OmniGen:addWaste(item)
    table.insert(self.output.waste.items,item)
end
function OmniGen:ingredients()
    if self.type=="chain" then
        return self:chainIngredients()
    elseif self.type=="building" then
        return self:buildingCost()
    end
end
function OmniGen:results()
    if self.type=="chain" then
        return self:wasteYieldResults()
    elseif false then
        return self:buildingCost()
    end
end
function OmniGen:roundResults()
    self.roundResult = true
    return self
end


result_round = function(array)
    if array.amount_min then array.amount = (array.amount_max+array.amount_max) end
    if math.floor(array.amount)~=array.amount then
        local nm = math.floor(array.amount)+1
        return {type=array.type,name=array.name,amount = nm,probability = array.amount/nm}
    else
        return array
    end
end

function OmniGen:chainIngredients()
    local f = function(levels,grade,dif)

        local usable = self.input.items
        local sum = clone_function(self.input.sum)(levels,grade)
        local total = 0

        local ingredients = {}
        for j,ing in pairs(usable) do
            local t = "item"
            if data.raw.fluid[ing.name] or ing.type == "fluid" then t = "fluid" end
            local amount = 0
            if ing.amount then
                amount = ing.amount
            else
                local ingname = ing.name or ing[1] or ing or ""
                math.randomseed(#usable*string.len(ingname)*j)
                if j ~= #usable then
                    local expected = (sum-total)/(#usable-j)
                    amount = math.random(omni.lib.round(expected*4/5),omni.lib.round(expected*6/5))
                else
                    amount = sum-total
                end
            end
            total = total+amount
            ingredients[#ingredients+1]={type=t,name = ing.name,amount = amount}
        end
        return ingredients
    end
    return clone_function(f)
end

function OmniGen:wasteYieldResults()
    local f = function(levels,grade,dif)
        local max_yield = clone_function(self.output.yield.quant)(levels,grade)
        local yieldItems = table.deepcopy(self.output.yield.items)
        local wasteItems = table.deepcopy(self.output.waste.items)
        local yield_count = 0
        local total = 0
        local results = {}
        for j,yield in pairs(yieldItems) do
            local amount = 0
            yield_count = yield_count+1
            local t = "item"
            if data.raw.fluid[yield.name] then t = "fluid" end
            if not yield.portion then
                if j < #yieldItems then
                    math.randomseed(#yieldItems*string.len(yield)+j)
                    local expected = (max_yield-total)/(#yieldItems-j+1)
                    amount = (0.1*math.random()+0.95)*expected
                else
                    amount = max_yield-total
                end
            else
                amount = max_yield*yield.portion
            end
            total = total+amount
            if amount > 0 then
                if self.roundResult or t == "fluid" then
                    results[#results+1]={type=t,name = yield.name,amount = omni.lib.round(amount)}
                else
                    results[#results+1]=result_round({type=t,name = yield.name,amount = amount})
                end
            end
        end
        total = 0
        if wasteItems then
            local max_waste = clone_function(self.output.waste.quant)(levels,grade)
            for j,waste in pairs(wasteItems) do
                local amount = 0
                local t = "item"
                if data.raw.fluid[waste.name] then t = "fluid" end
                if j < #wasteItems then
                    math.randomseed(#wasteItems*string.len(waste.name)+j)
                    local expected = (max_waste-total)/(#wasteItems-j+1)
                    amount = (0.1*math.random()+0.95)*expected
                else
                    amount = max_waste-total
                end
                total = total+amount
                if amount > 0 then
                    if self.roundResult or t == "fluid" then
                        results[#results+1]={type=t,name = waste.name,amount = omni.lib.round(amount)}
                    else
                        results[#results+1]=result_round({type=t,name = waste.name,amount = amount})
                    end
                end
            end
        end
        return table.deepcopy(results)
    end
    return clone_function(f)
end

function linear_gen(start, final, levels, grade)
    return start + (final-start)*(grade-1)/(levels-1)
end
function standard_linear(levels,grade)
    return linear_gen(6,12,levels,grade)
end

function ItemGen:create(mod_name, item_name)
    local new_name = item_name
    if type(new_name) ~= "string" then
        new_name = "omni" 
    end
    local t = {
        mod = mod_name,
        name = item_name,
        loc_name = function(levels,grade) return nil end,
        loc_desc =  function(levels,grade) return nil end,
        icons = function(levels,grade) return nil end,
        flags = nil,
        order = function(levels,grade) return "y["..new_name.."]" end,
        stack_size = 100,
        subgroup = function(levels,grade) return "raw-resource" end,
        fuel_value = nil,
        fuel_category = nil,
        place_result = function(levels,grade) return nil end,
        rtn = {},
        requiredMods = function(levels,grade) return true end,
        max_temperature = function(levels,grade) return nil end,
        type="item",
        force = false,
    }
    if mod_name then
        mod_name = "__" .. mod_name .. "__"
        t.icons = function(levels,grade)
            return {{
                icon = mod_name.."/graphics/icons/"..item_name..".png",
                icon_size = 32
            }}
        end
    end
    return setmetatable(t,ItemGen)
end

function FluidGen:create(mod,name)
    return ItemGen:create(mod,name):fluid()
end

function ItemGen:import(item)
    local proto = omni.lib.find_prototype(item)
    if proto then
        local it = ItemGen:create():
        setName(proto.name):
        setStacksize(proto.stack_size):
        setFlags(proto.flags):
        setPlace(proto.place_result):
        setSubgroup(proto.subgroup):
        setFuelCategory(proto.fuel_category):
        setIcons(proto.icons or proto.icon or omni.lib.icon.of(proto, true)):
        setItemPictures(proto.pictures):
        setFuelValue(proto.fuel_value):
        setOrder(proto.order)
        if proto.type == "fluid" then
            it:fluid():
            setFlowColour(proto.flow_color):
            setBaseColour(proto.base_color)
        elseif proto.type == "tool" then
            it:tool():
            setDurability(proto.durability):
            setDurabilityDesc(proto.durability_description_key)
        end
        if proto.place_as_tile then
            it:tile()
        end
        return table.deepcopy(it)
    elseif item then
        error("Could not find "..item.." to import it.")
    else
        error("You input nothing to import, terminating.")
    end
end
function ItemGen:find(name)
    if Omni.Gen.Item[name] then
        return Omni.Gen.Item[name]:setForce()
    else
        return ItemGen:importIf(name)
    end
end
function ItemGen:setForce(meep)
    self.force = meep or meep == nil
    return self
end

function ItemGen:importIf(item)
    local possible = {"item","fluid","tool"}
    for _,k in pairs(possible) do
        if data.raw[k][item] then
            return ItemGen:import(item):setForce()
        end
    end
    return ItemGen:create(item):setGenerationCondition(false)
end

function ItemGen:setIcons(icons,mod)
    if not icons then error("No icons specified for "..(self.name or "No Name")) end
    local proto = nil
    if type(icons)=="string" then
        proto = omni.lib.find_prototype(icons)
    end
    --Case "mod" given : expect just a name for the icon(s) without a path
    if type(icons)~= "function" and mod and (type(icons)~= "string" or not string.match(icons, "%_%_(.-)%_%_")) then
        if type(icons) == "table" then
            local ic = {}
            local ic_scale
            local ic_sz = 32
            for _, c in pairs(icons) do
                if c.icon_size then	ic_sz=c.icon_size end
                if c.scale then ic_scale = c.scale*32/ic_sz end
                if type(c)=="table" then
                    ic[#ic+1] = {icon = "__"..mod.."__/graphics/icons/"..(c.name or c.icon)..".png",
                        icon_size = ic_sz,
                        --optional
                        scale = ic_scale,
                        shift = c.shift}
                else
                    ic[#ic+1]={icon = "__"..mod.."__/graphics/icons/"..c..".png",icon_size=c.icon_size}
                end
            end
            self.icons = function(levels,grade) return ic end
        else
            local ic_size=32
            local check = {}
            if data.raw.item[icons] then
                check=data.raw.item[icons]
                if check.icon_size then ic_size=check.icon_size end
            end
            self.icons = function(levels,grade) return {{icon = "__"..(mod or self.mod).."__/graphics/icons/"..icons..".png",icon_size=ic_size}} end
        end
    elseif type(icons)~= "function" then
        --find icon_size
        local ic_sz = 32
        if type(icons)=="table" and type(icons[1].icon)=="string" then   
            if icons[1].icon_size then
                ic_sz=icons[1].icon_size
            elseif type(icons[1].icon)=="string" then --try to find item name by extracting icon name
                local name=string.match(icons[1].icon,".*%/(.-).png")
                --check if a HR icon, if so, update icon_size default
                if string.match(name,"-HR") then
                    name=string.sub(name,1,-4)
                end
                for _,cat in pairs({"item-with-entity-data","recipe","tool","fluid","item"}) do
                    if data.raw[cat][name] then
                        if data.raw[cat][name].icon_size then
                            ic_sz=data.raw[cat][name].icon_size
                        elseif data.raw[cat][name].icons and data.raw[cat][name].icons[1].icon_size then
                            ic_sz=data.raw[cat][name].icons[1].icon_size
                        else
                        end
                    end
                end
                icons[1].icon_size=ic_sz
            end
        end
        if type(icons)=="string" and string.match(icons, "%_%_(.-)%_%_") then
            local name=string.match(icons,".*%/(.-).png")
            local setup = {}
            proto = omni.lib.find_prototype(name)
            if proto then
                setup={{icon=proto.icon,icon_size=proto.icon_size,mipmaps=proto.mipmaps or nil}}
            else
                setup={{icon = icons, icon_size=ic_sz}}
            end
            self.icons = function(levels,grade)	return setup end
        elseif type(icons) == "string" and not proto and (mod or self.mod) then
            self.icons = function(levels,grade) return {{icon = "__"..(mod or self.mod).."__/graphics/icons/"..icons..".png",icon_size=ic_sz}} end
        elseif proto then
            if proto.icons then
                self.icons=function(levels,grade) return proto.icons end
            else
                self.icons=function(levels,grade) return {{icon=proto.icon,icon_size=proto.icon_size,mipmaps=proto.mipmaps or nil}} end
            end
        else
            self.icons = function(levels,grade) return icons end
        end
    else
        self.icons = icons
    end
    self.set_icon = true
    return self
end

function ItemGen:addIcon(icon)
    local a = nil
    if type(icon) == "table" and icon.icon then
        local f = string.match(icon.icon, "%_%_(.-)%_%_")
        --Full Path is there
        if f then
            a = function(levels,grade) return {icon} end
        --Just a name given
        else
            local proto = omni.lib.find_prototype(icon.icon)
            local ic_sz=32
            --Find icon size
            if proto then
                if proto.icon_size then
                    ic_sz = proto.icon_size
                elseif proto.icons and proto.icons[1].icon_size then
                    ic_sz = proto.icons[1].icon_size
                end
            end
            --Proto with .icon
            if proto and proto.icon then
                a = function(levels,grade) return {{icon=proto.icon,icon_size=ic_sz,scale=icon.scale*32/ic_sz,shift=icon.shift}} end
            --Proto with .icons
            elseif proto and proto.icons then
                local ic = {}
                for _, c in pairs(proto.icons) do
                    local int_sz = c.icon_size or ic_sz
                    ic[#ic+1] = {
                        icon=c.icon,
                        icon_scale=int_sz,
                        scale = (c.scale or (32/int_sz))*(icon.scale or (32/int_sz)),
                        shift = {(c.shift or {0,0})[1]+(icon.shift or {0,0})[1],(c.shift or {0,0})[2]+(icon.shift or {0,0})[2]}
                    }
                end
                a = function(levels,grade) return ic end
            --No proto found, convert name into full path
            elseif icon.icon then
                icon.icon = "__"..self.mod.."__/graphics/icons/"..icon.icon..".png"
                a = function(levels,grade) return {icon} end
            end
        end
    elseif type(icon)=="table" then
        a = function(levels,grade) return {{icon=icon[1]}} end
    else
        a = function(levels,grade)	return {{icon=icon}} end
    end
    local f = clone_function(self.icons)
    self.icons = function(levels,grade) return omni.lib.union(f(levels,grade),a(levels,grade)) end
    self.set_icon = true
    return self
end
function ItemGen:addMask(...)
    local arg=argTable({...})
    if not arg.r then arg = {r=arg[1],g=arg[2],b=arg[3]} end
    local icons = self.icons(0,0)
    self:addIcon({
        icon = string.sub(icons[#icons].icon,1,-5).."-mask.png",
        tint=table.deepcopy(arg),
        icon_size = icons[#icons].icon.icon_size or 32
    })
    return self
end
function ItemGen:addIconLevel(lvl)
    self:addIcon({icon = "__omnilib__/graphics/icons/small/lvl"..lvl..".png",icon_size=32})
    return self
end
function ItemGen:setName(lvl,mod)
    self.name = lvl
    if mod then self.mod = mod end
    return self
end
function ItemGen:addBurnerIcon()
    self:addIcon({icon = "__omnilib__/graphics/icons/small/burner.png",
    icon_size=32,
        scale = 0.4375,
        shift = {-10, 10}})
    return self
end
function ItemGen:addElectricIcon()
    self:addIcon({icon = "__omnilib__/graphics/icons/small/electric.png",
    icon_size=32,
        scale = 0.4375,
        shift = {-10, 10}})
    return self
end
function ItemGen:addSteamIcon()
    -- CC BY-NC 4.0 Licensed from http://getdrawings.com/get-icon#steam-icon-51.png
    self:addIcon({icon = "__omnilib__/graphics/icons/small/steam-icon-51-32x32.png",
    icon_size=32,
        scale = 0.4375,
        shift = {-10, 10}})
    return self
end
function ItemGen:addSmallIcon(icon, nr)
    local quad = {{10, -10},{-10, -10},{-10, 10},{10, 10}}
    local icons
    local ic_sz=32
    if type(icon) == "table" and icon[1] and icon[1].icon then
        icons = icon 
    else
        icons = omni.lib.icon.of(icon, true)
    end
    if icons then
        ic_sz = icons.icon_size or ic_sz
        for _, ic in pairs(icons) do
            if ic.icon_size then
                ic_sz = ic.icon_size
            end
            self:addIcon({icon = ic.icon,
            icon_size=ic_sz,
                scale = 0.4375*(ic.scale or (32/ic_sz)),
                shift = quad[nr or 1], --currently "centres" the icon if it was already offset, may need to math that out
                tint = ic.tint or nil})
        end
    else
        local ic = icon
        self:addIcon({
            icon = icon,
            icon_size = icon.icon_size or ic_sz,
            scale = 0.4375,
            shift = quad[nr or 1]}) --currently "centres" the icon if it was already offset, may need to math that out
    end
    return self
end
function ItemGen:addBlankIcon()
    self:addIcon({icon = "__omnilib__/graphics/icons/blank.png", icon_size = 32})
    return self
end
function ItemGen:nullIcon()
    self:setIcons({icon = "__omnilib__/graphics/icons/blank.png", icon_size = 32})
    return self
end

function ItemGen:setItemPictures(e)
    self.item_pictures = e
    return self
end

function ItemGen:setSubgroup(subgroup)
    if type(subgroup)~= "function" then
        self.subgroup = function(levels,grade) return subgroup end
    else
        self.subgroup = subgroup
    end
    return self
end
function ItemGen:setStacksize(size)
    self.stack_size = size
    return self
end
function ItemGen:setFuelValue(fv)
    if type(fv)=="number" then
        self.fuel_value = fv.."MJ"
    elseif fv and string.find(fv,"J") then
        self.fuel_value=fv
    else
        self.fuel_value = fv
    end
    if fv and self.fuel_value and not self.fuel_category then self:setFuelCategory() end
    return self
end
function ItemGen:setFuelCategory(fv)
    self.fuel_category = fv or "chemical"
    return self
end
function ItemGen:fluid()
    self.default_temperature = 25
    self.heat_capacity = "0.7KJ"
    self.base_color = {r = 1, g = 0, b = 1}
    self.flow_color = {r = 1, g = 0, b = 1}
    self.type="fluid"
    self.stack_size = nil
    return self
end
function ItemGen:tool()
    self.type="tool"
    self.durability=1
    self.durability_description_key="description.science-pack-remaining-amount-key"
    self.durability_description_value="description.science-pack-remaining-amount-value"
    return self
end
function ItemGen:tile(tog)
    if type(tog)=="boolean" then
        self.isTile= tog
    else
        self.isTile = tog==nil
    end
    return self
end
function ItemGen:setDurability(tmp)
    if self.type=="tool" then
        self.durability=tmp
    end
    return self
end
function ItemGen:setDurabilityDesc(tmp)
    if self.type=="tool" then
        local name = tmp
        if string.find(tmp,"-key") then
            tmp = string.gsub(tmp,"-key","")
        end
        self.durability_description_key=tmp.."-key"
        self.durability_description_value=tmp.."-value"
    end
    return self
end
function ItemGen:setMaxTemp(tmp)
    if type(tmp) == "number" then
        self.max_temperature=function(levels,grade) return tmp end
    elseif type(tmp)=="function" then
        self.max_temperature = tmp
    end
    return self
end
function ItemGen:setCapacity(c)
    if self.type=="fluid" then
        if type(c)=="number" then
            self.heat_capacity=c.."KJ"
        else
            self.heat_capacity=c
        end
    end
    return self
end
function ItemGen:setFlags(flags)
    if type(flags)=="table" then
        self.flags = flags
    else
        self.flags = {flags}
    end
    return self
end
function ItemGen:setBaseColour(r,g,b)
    if self.type=="fluid" then
        if g and b then
            self.base_color={r = r, g = g, b = b}
        elseif type(r)=="table" then
            self.base_color=table.deepcopy(r)
        end
    end
    return self
end
function ItemGen:setFlowColour(r,g,b)
    if self.type=="fluid" then
        if g and b then
            self.flow_color={r = r, g = g, b = b}
        elseif type(r)=="table" then
            self.flow_color=table.deepcopy(r)
        end
    end
    return self
end
function ItemGen:setBothColour(r,g,b)
    if self.type=="fluid" then
        if g and b then
            self:setBaseColour({r = r, g = g, b = b})
            self:setFlowColour({r = r, g = g, b = b})
        elseif type(r)=="table" then
            self:setBaseColour(r)
            self:setFlowColour(r)
        end
    end
    return self
end
function ItemGen:setOrder(order)
    if type(order)=="function" then
        self.order = order
    else
        self.order = function(levels,grade) return order end
    end
    return self
end
function ItemGen:setPlace(place)
    if type(place)== "function" then
        self.place_result = place
    else
        self.place_result = function(levels,grade) return place end
    end

    return self
end
function ItemGen:setLocName(inname,...)
    local arg = {...}
    self.unique_loc_name = inname ~= nil
    local rtn = {}
    if not inname then return self end
    if type(inname) == "function" and type(inname(0,0)) == "string" then
        rtn[1] = inname
    elseif type(inname) == "function" and type(inname(0,0)) == "table" then
        rtn = inname(0,0)
    elseif type(inname)=="table" and inname["grade-1"] then
        rtn[1] = function(levels,grade) return inname["grade-"..grade] end
    elseif type(inname)=="table" and #arg == 0 then
        for _, part in pairs(inname) do
            if type(part) == "function" then
                rtn[#rtn+1] = part
            elseif type(part)=="table" and not #part == 1 then
                rtn[#rtn+1] = function(levels,grade) return part[grade] end
            --elseif type(part)=="string" and string.find(part,".") and (string.find(part,"name") or string.find(part,"description")) and  then
                --rtn[#rtn+1] = function(levels,grade) return {part} end
                --rtn[#rtn+1] = function(levels,grade) return {part} end
            else
                rtn[#rtn+1]=function(levels,grade) return part end
            end
        end
    else
        rtn[1]=function(levels,grade) return inname end
    end
    for _,part in pairs(arg) do
        if type(part) == "function" then
            rtn[#rtn+1] = part
        elseif type(part)=="table" and not #part == 1 then
            rtn[#rtn+1] = function(levels,grade) return inname[grade] end
        elseif type(part)=="string" and string.find(part,".") and (string.find(part,"name") or string.find(part,"description")) then
            rtn[#rtn+1] = function(levels,grade) return {part} end
        else
            rtn[#rtn+1]=function(levels,grade) return part end
        end
    end
    self.loc_name = function(levels,grade)
        local out = {}
        for _, o in pairs(rtn) do
            out[#out+1]=o(levels,grade)
        end
        return out
    end
    return self
end
function ItemGen:addLocName(key)
    local a = clone_function(self.loc_name)
    local b = function(levels,grade) return {key} end
    if type(key) == "function" then
        b = key
    elseif type(key)=="table" and not #key == 1 then
        b = function(levels,grade) return key[grade] end
    elseif type(key)=="string" and string.find(key,".") and (string.find(key,"name") or string.find(key,"description")) then
        b = function(levels,grade) return {key} end
    else
        b=function(levels,grade) return key end
    end
    self.loc_name = clone_function(function(levels,grade) return omni.lib.union(a(levels,grade),{b(levels,grade)}) end)
    return self
end
function ItemGen:setLocDesc(inname,keys)
    if type(inname) == "function" then
        self.loc_desc = inname
    elseif type(inname)=="table" then
        self.loc_desc = function(levels,grade) return inname[grade] end
    else
        self.loc_desc=function(levels,grade) return inname end
    end
    if type(keys) == "function" then
        self.loc_desc_keys = keys
    elseif type(keys)=="table" then
        self.loc_desc_keys = function(levels,grade) return keys end
    else
        self.loc_desc_keys=function(levels,grade) return {keys} end
    end
    return self
end
function ItemGen:addLocDescKey(key)
    local a = clone_function(self.loc_desc_keys)
    local k = key
    if type(key)=="table" then
        k=function(levels,grade) return key end
    elseif type(key)=="string" or type(key)=="number" then
        k=function(levels,grade) return {key} end
    end
    self.loc_desc_keys = function(levels,grade) return omni.lib.union(a(levels,grade),k(levels,grade)) end
    return self
end
function ItemGen:setNameLocType(kind)
    if self.loc_name(0,0) then
        local r =self.loc_name(0,0)
        if r[1] == string then
            r[1]=kind.."-name."..r[1]
        elseif r[1][1] then
            r[1]=kind.."-name."..r[1][1]
        end
        return r
    else
        return nil
    end
end
function ItemGen:setGenerationCondition(...)
    local arg = argTable({...})
    if type(arg[1])=="function" then
        self.requiredMods = function(levels,grade) return arg[1](levels,grade) end
    elseif type(arg[1])=="boolean" then
        self.requiredMods = function(levels,grade) return arg[1] end
    elseif type(arg[1])=="string" then
        local bool = mods[arg[1]] ~= nil
        for i=2,#arg do
            bool=bool and mods[arg[i]] ~= nil
        end
        self:setGenerationCondition(bool)
    end
    return self
end
function ItemGen:notCondition()
    local a=clone_function(self.requiredMods)
    self.requiredMods=function(levels,grade) return not a(levels,grade) end
    return self
end
function ItemGen:setReqAllMods(...)
    local arg = argTable({...})
    local val = true
    for _,v in pairs(arg) do
        val=mods[v]~= nil and val
    end
    self:setGenerationCondition(val)
    return self
end
function ItemGen:setReqAnyMods(...)
    local args = argTable({...})
    local val = false
    for _,v in pairs(arg) do
        val=v or val
    end
    self:setGenerationCondition(val)
    return self
end
function ItemGen:setReqNoneMods(...)
    local arg = argTable({...})
    local val = false
    for _,v in pairs(arg) do
        val=v or val
    end
    self:setGenerationCondition(val):notCondition()
    return self
end
function ItemGen:setDescLocType(kind)
    if self.loc_desc(0,0) then
        local r ={kind.."-name."..self.loc_desc(0,0)}
        if self.loc_desc_keys(0,0) and #self.loc_desc_keys(0,0) > 0 then r[2]=self.loc_desc_keys(0,0) end
        return r
    else
        return nil
    end
end
function ItemGen:generate_item()
    local lname = self.loc_name(0,0)
    if not self.unique_loc_name then
        lname = {"item-name."..self.name}
        if self.type == "fluid" then lname = {"fluid-name."..self.name} end
        if self.place_result(0,0) then
            local entity = omni.lib.find_entity_prototype(self.place_result(0,0)) or self.proto
            if entity and entity.localised_name then
                lname=entity.localised_name
            else
                lname={"entity-name."..self.place_result(0,0)}
            end
        end
    end
    if self.fuel_category and not data.raw["fuel-category"][self.fuel_category] then
        data:extend({{
            type = "fuel-category",
            name = self.fuel_category
        }})
    end
    local t = self.max_temperature(0,0)
    if self.type == "fluid" and not t then t = 100 end
    self.rtn[#self.rtn+1] = {
        localised_name = lname,
        --localised_description = "item-description."..self.name,
        type = self.type,
        name = self.name,
        icons = self.icons(0,0),
        pictures = self.item_pictures,
        flags = self.flags,
        fuel_value = self.fuel_value,
        fuel_category = self.fuel_category,
        subgroup = self.subgroup(0,0),
        order = self.order(0,0),
        icon_size = self.icon_size or 32,
        stack_size = self.stack_size,
        default_temperature = self.default_temperature,
        heat_capacity=self.heat_capacity,
        base_color=self.base_color,
        flow_color=self.flow_color,
        max_temperature=t,
        durability=self.durability,
        durability_description_key=self.durability_description_key,
        durability_description_value=self.durability_description_value
    }
    if  self.isTile then
        self.rtn[#self.rtn].place_as_tile={
        result = self.place_result(0,0),
        condition_size = 1,
        condition = { "water-tile" }
        }
    else
        self.rtn[#self.rtn].place_result = self.place_result(0,0)
    end
    return self
end

function ItemGen:return_array()
    self:generate_item()
    return self.rtn
end
function ItemGen:extend()
    if self.requiredMods(0,0) and self.name then
        Omni.Gen.Item[self.name] = self
        data:extend(self:return_array())
    end
end

function RecGen:create(mod,name,efficency)
    local r = ItemGen:create(mod,name)
    r.ingredients = function(levels,grade,dif) return nil end
    r.results = function(levels,grade,dif) return {{type="item",name=name,amount=1}} end
    r.enabled=function(levels,grade) return false end
    r.efficency = efficency
    r.energy_required = function(levels,grade) return 1 end
    r.category = function(levels,grade) return nil end
    r.main_product=function(levels,grade) return nil end
    r.add_prod = false
    r.hidden = function(levels,grade) return nil end
    r.tech = {
        noTech = false,
        cost = function(levels,grade) return 50 end,
        packs = function(levels,grade) return 1 end,
        time=function(levels,grade) return 20 end,
        upgrade = function(levels,grade) return false end,
        name = function(levels,grade) return self.name end,
        loc_name = function(levels,grade) return nil end,
        loc_desc = function(levels,grade) return nil end,
        icons = function(levels,grade) return nil end,
        prerequisites = function(level,grade) return nil end,
        effects = {}}
    return setmetatable(r,RecGen)
end
--Must occure after setting ingredients and results
function RecGen:addSmallIngIcon(nr,place)
    local ing = self.ingredients(0,0,0)
    self:addSmallIcon(ing[nr].name,place)
    return self
end
function RecGen:addSmallResIcon(nr,place)
    local res = self.results(0,0,0)
    self:addSmallIcon(res[nr].name,place)
    return self
end

function RecGen:import(rec)
    local recipe = data.raw.recipe[rec]
    if recipe then
        omni.lib.standardise(recipe)
        local r = RecGen:create()
        if #recipe.normal.results==1 or recipe.main_product and recipe.main_produc ~= "" then
            local proto = omni.lib.find_prototype(recipe.main_product or recipe.normal.results[1].name)
            if proto then
                r:setStacksize(proto.stack_size):
                setFlags(proto.flags):
                setPlace(proto.place_result):
                setSubgroup(proto.subgroup):
                setOrder(proto.order):
                setFuelCategory(proto.fuel_category):
                setIcons(proto.icons or proto.icon or omni.lib.icon.of(proto, true)):
                setFuelValue(proto.fuel_value)
                if proto.place_as_tile then r:tile():setPlace(proto.place_as_tile.result) end
                if proto.type == "fluid" then
                    r:fluid():
                    setFlowColour(proto.flow_color):
                    setBaseColour(proto.base_color)
                elseif proto.type == "tool" then
                    r:tool():
                    setDurability(proto.durability):
                    setDurabilityDesc(proto.durability_description_key)
                end
            end
        end
        r:setName(recipe.name):
        setResults({normal = table.deepcopy(recipe.normal.results),expensive=table.deepcopy(recipe.expensive.results)}):
        setIngredients({normal = table.deepcopy(recipe.normal.ingredients),expensive=table.deepcopy(recipe.expensive.ingredients)}):
        setMain(recipe.main_product):
        setEnabled(recipe.enabled or recipe.normal.enabled or false):
        setEnergy(recipe.energy_required or recipe.normal.energy_required):
        setCategory(recipe.category):
        setSubgroup(recipe.subgroup or r.subgroup(0,0)):
        setOrder(recipe.order or r.order(0,0)):
        setIcons(recipe.icons or recipe.icon or r.icons(0,0) or omni.lib.icon.of(recipe, true)):
        setHidden(recipe.hidden or false)

        for _, module in pairs(data.raw.module) do
            if module.effect.productivity and module.limitation then
                for _,lim in pairs(module.limitation) do
                    if lim==recipe.name then
                        r:addProductivity(module.name)
                    end
                end
            end
        end

        if recipe.enabled==nil and recipe.normal.enabled==nil then r:setEnabled(true) end

        if not recipe.enabled then
            local tech = nil
            local found = false
            for _,t in pairs(data.raw.technology) do
                if t.effects then
                    for _,eff in pairs(t.effects) do
                        if eff.type=="unlock-recipe" and eff.recipe == recipe.name then
                            tech = t
                            found = true
                            break
                        end
                    end
                    if found then break end
                end
            end
            if tech then
                r:setTechName(tech.name):
                setTechCost(tech.unit.count):
                setTechIcons(tech.icons  or {{icon=tech.icon, icon_size=tech.icon_size or 128, icon_mipmaps = tech.icon_mipmaps or nil}}):
                setTechLocName(tech.localised_name):
                setTechLocDesc(tech.localised_description):
                setTechPacks(tech.unit.ingredients):
                setTechPrereq(tech.prerequisites):
                setTechTime(tech.unit.time):
                setTechUpgrade(tech.upgrade)
            end
        end
        return table.deepcopy(r)
    elseif rec then
        error("Could not find "..rec.." to import it.")
    else
        error("You input nothing to import, terminating.")
    end
end
function RecGen:importIf(rec)
    if data.raw.recipe[rec] then
        return RecGen:import(rec):setForce()
    else
        return RecGen:create():setGenerationCondition(false)
    end
end
function RecGen:importResult(result)
    if data.raw.recipe[result] then
        return RecGen:import(result)
    else
        for _,rec in pairs(data.raw.recipe) do
            omni.lib.standardise(rec)
            for _,res in pairs(rec.normal.results) do
                if res.name==result then
                    return RecGen:import(rec.name)
                end
            end
        end
    end
end
function RecGen:find(name)
    if Omni.Gen.Rec[name] then
        return Omni.Gen.Rec[name]:setForce()
    else
        return RecGen:importIf(name)
    end
end
--[[
r.ingredients = function(levels,grade,dif) return nil end
    r.results = function(levels,grade,dif) return {{type="item",name=name,amount=1}} end
    r.enabled=function(levels,grade) return false end
    r.efficency = efficency
    r.energy_required = function(levels,grade) return 1 end
    r.category = function(levels,grade) return nil end
    r.main_product=function(levels,grade) return nil end
    r.tech = {
        cost = function(levels,grade) return 50 end,
        packs = function(levels,grade) return 1 end,
        time=function(levels,grade) return 20 end,
        upgrade = function(levels,grade) return false end,
        name = function(levels,grade) return self.name end,
        loc_name = function(levels,grade) return nil end,
        loc_desc = function(levels,grade) return nil end,
        icon = function(levels,grade) return nil end,
        prerequisites = function(level,grade) return nil end}
]]


function RecGen:addProductivity(mod)
    if type(mod)=="nil" then
        self.add_prod = true
    elseif type(mod)=="string" then
        if type(self.add_prod)~= "table" then self.add_prod = {} end
        self.add_prod[#self.add_prod+1]=mod
    end
    return self
end
function RecChain:create(mod,name)
    local r = RecGen:create(mod,name,0.5)
    r.tech.cost = function(levels,grade) return 50+50*grade end
    r.tech.packs = function(levels,grade) return math.floor(grade/levels*5+1) end
    r.tech.upgrade = function(levels,grade) return false end
    --r.ingredients=function(levels,grade) return chainIngredients(r,levels,grade) end
    --r.results=function(levels,grade) return wasteYieldResults(r,levels,grade) end
    return setmetatable(r,RecChain)
end
function RecChain:find(name)
    if Omni.Chain.Rec[name] then
        return Omni.Chain.Rec[name]:setForce()
    else
        return RecChain:create(name):setGenerationCondition(false)
    end
end
function RecGen:setEnabled(en)
    if type(en)=="function" then
        self.enabled = en
    else
        self.enabled = function(levels,grade) return en==true or en=="true" or en==nil end
    end
    return self
end
function RecGen:setHidden(en)
    if type(en)=="function" then
        self.hidden = en
    else
        self.hidden = function(levels,grade) return en or en==nil end
    end
    return self
end
function RecGen:noItem()
    self.noItem=true
    return self
end
function RecGen:noTech(b)
    self.tech.noTech = (b == nil) or b
    return self
end
function RecGen:setItemName(en)
    self.item_name = en or self.name
    return self
end

function RecGen:resetItemName()
    self.item_name = self.name
    return self
end
function RecGen:multiplyItem(item,c)
    local a = clone_function(self.ingredients)
    local b = clone_function(self.results)
    self.ingredients=function(levels,grade,dif) return multiplyIngres(a(levels,grade,dif),item,c) end
    self.results=function(levels,grade,dif) return multiplyIngres(b(levels,grade,dif),item,c) end
    return self
end
function RecGen:multiplyIngredients(c)
    local a = clone_function(self.ingredients)
    self.ingredients=function(levels,grade,dif) return multiplyIngres(a(levels,grade,dif),c) end
    return self
end
function RecGen:multiplyResults(c)
    local a = clone_function(self.results)
    self.results=function(levels,grade,dif) return multiplyIngres(a(levels,grade,dif),c) end
    return self
end
function RecGen:multiplyIfIngredients(bool,c)
    if bool then
        local a = clone_function(self.ingredients)
        self.ingredients=function(levels,grade,dif) return multiplyIngres(a(levels,grade,dif),c) end
    end
    return self
end
function RecGen:multiplyIfResults(bool,c)
    if bool then
        local a = clone_function(self.results)
        self.results=function(levels,grade,dif) return multiplyIngres(a(levels,grade,dif),c) end
    end
    return self
end
function RecGen:multiplyIfModsIngredients(c,...)
    local arg = {...}
    local bool = true
    for _,m in pairs(arg) do
        bool=bool and mods[m]
    end
    return self:multiplyIfIngredients(bool,c)
end
function RecGen:multiplyIfResults(c,...)
    local arg = {...}
    local bool = true
    for _,m in pairs(arg) do
        bool=bool and mods[m]
    end
    return self:multiplyIfResults(bool,c)
end

function RecGen:setIngredients(array,...)
    local arg = {...}
    if #arg > 0 then
        if array.name then
            array = {array}
        elseif type(array[1]) == "string" then
            array={{name=array[1], amount=array[2] or 1, type="item"}}
        elseif type(array)=="string" then
            array={{name=array, amount=1, type="item"}}
        end
        for i,v in pairs(arg) do
            local c = v
            if type(v[1])=="string" then
                c = {name=v[1],amount=v[2] or 1,type="item"}
            elseif type(v)=="string" then
                c={name=v,amount=1,type="item"}
            end
            array = omni.lib.union(array,{c})
        end
    end
    if type(array)=="table" then
        if array.normal then
            for _,dif in pairs({"normal","expensive"}) do
                for i,ing in pairs(array[dif]) do
                    if type(ing[1])=="string" then
                        if ing[2] then
                            array[dif][i]={type="item",name=ing[1],amount=ing[2]}
                        else
                            array[dif][i]={type="item",name=ing[1],amount=1}
                        end
                    end
                end
            end
            self.ingredients = function(levels,grade, dif) if dif == 0 then return table.deepcopy(array.normal) else return table.deepcopy(array.expensive) end end
        elseif array[1] then
            if type(array[1]) == "string" and type(array[2]) == "number" then
                self.ingredients = function(levels,grade, dif) return {{name=array[1],amount=array[2],type="item"}} end
            elseif type(array[1])=="string" and array[2]==nil then
                self.ingredients = function(levels,grade, dif) return {{name=array[1],amount=1,type="item"}} end
            else
                for i,ing in pairs(array) do
                    if type(ing)=="string" then
                        array[i]={type="item",amount=1,name=ing}
                    elseif type(ing)=="table" and type(ing[1])=="string" and not ing[2] then
                        array[i]={type="item",amount=1,name=ing[1]}
                    elseif type(ing)=="table" and type(ing[1])=="string" and type(ing[2])=="number" then
                        array[i]={type="item",amount=ing[2],name=ing[1]}
                    end
                end
                self.ingredients = function(levels,grade, dif) return array end
            end
        elseif array.name and not array.amount then
            self.ingredients = function(levels,grade, dif) return {{name=array,amount=1,type="item"}} end
        elseif array.name then
            self.ingredients = function(levels,grade, dif) return {array} end
        end
    elseif type(array)=="function" then
        self.ingredients = array
    elseif type(array)=="string" then
        self.ingredients = function(levels,grade, dif) return {{name=array,amount=1}} end
    end
    return self
end
function RecGen:nullIngredients()
    self.ingredients = function(levels,grade) return {} end
    return self
end
function RecGen:setNormalIngredients(...)
    local arg = argTable({...},"string","name")
    local tmp = RecGen:create("mah","blah"):
        setIngredients(arg)
    local a = clone_function(self.ingredients)
    local b = clone_function(tmp.ingredients)
    self.ingredients = function(levels,grade,dif) if dif == 0 then return b(levels,grade,dif) else return a(levels,grade,dif) end end
    return self
end
function RecGen:setExpensiveIngredients(...)
    local arg = argTable({...},"string","name")
    local tmp = RecGen:create("mah","blah"):
        setIngredients(arg)
    local a = clone_function(self.ingredients)
    local b = clone_function(tmp.ingredients)
    self.ingredients = function(levels,grade,dif) if dif == 1 then return b(levels,grade,dif) else return a(levels,grade,dif) end end
    return self
end
function RecGen:addIngredients(...)
    local tmp = RecGen:create("mah","blah"):
        setIngredients(argTable({...},"string","name"))
    local a = clone_function(self.ingredients)
    local b = clone_function(tmp.ingredients)
    self.ingredients = function(levels,grade,dif) return omni.lib.union(a(levels,grade,dif),b(levels,grade,dif)) end
    return self
end
function RecGen:addNormalIngredients(...)
    local arg = argTable({...},"string","name")
    local tmp = RecGen:create("mah","blah"):
        setIngredients(arg)
    local a = clone_function(self.ingredients)
    local b = function(levels,grade,dif) if dif == 0 then return tmp.ingredients(levels,grade,dif) else return {} end end
    self.ingredients = function(levels,grade,dif) return omni.lib.union(a(levels,grade,dif),b(levels,grade,dif)) end
    return self
end
function RecGen:addExpensiveIngredients(...)
    local arg = argTable({...},"string","name")
    local tmp = RecGen:create("mah","blah"):
        setIngredients(arg)
    local a = clone_function(self.ingredients)
    local b = function(levels,grade,dif) if dif == 1 then return tmp.ingredients(levels,grade,dif) else return {} end end
    self.ingredients = function(levels,grade,dif) return omni.lib.union(a(levels,grade,dif),b(levels,grade,dif)) end
    return self
end
function RecGen:replaceIngredients(...)
    local arg = argTable({...})
    if #arg == 2 and (type(arg[1])=="string" or type(arg[1])=="number") then
        arg={{arg[1],arg[2]}}
    end
    for _,a in pairs(arg) do
        if type(a[2])=="table" and not a[2].name then
            a[2]={type="item",name=a[2][1],amount=a[2][2] or 1}
        end
    end
    local ingredients = clone_function(self.ingredients)
    self.ingredients=function(levels,grade,dif) return replaceIngres(ingredients(levels,grade,dif),arg) end
    return self
end
function RecGen:ifReplaceIngredients(bool,...)
    if bool then
        self:replaceIngredients({...})
    end
    return self
end
function RecGen:ifModsReplaceIngredients(modis,...)
    if type(modis)=="string" then modis = {modis} end
    local bool = true
    for _,m in pairs(modis) do
        bool = bool and mods[m]
    end
    self:ifReplaceIngredients(bool,argTable({...}))
    return self
end
function RecGen:ifAddIngredients(bool,...)
    if bool then
        self:addIngredients(argTable({...},"string"))
    end
    return self
end
function RecGen:ifModsAddIngredients(modis,...)
    if type(modis)=="string" then modis = {modis} end
    local bool = true
    for _,m in pairs(modis) do
        bool = bool and mods[m]
    end
    self:ifAddIngredients(bool,argTable({...},"string","name"))
    return self
end
function RecGen:ifSetIngredients(bool,...)
    local arg = argTable({...},"string","name")
    if (type(bool)=="boolean" and bool) or mods[bool]  then
        self:setIngredients(argTable({...},"string","name"))
    end
    return self
end
function RecGen:removeIngredients(...)
    local args = {...}
    local ingredients = clone_function(self.ingredients)
    self.ingredients=function(levels,grade,dif)
        local ings = ingredients(levels,grade,dif)
        local finalIngs = {}
        for c,i in pairs(ings) do
            if not omni.lib.is_in_table(i.name, args) and not omni.lib.is_in_table(c, args) then
                finalIngs[#finalIngs+1]=table.deepcopy(i)
            end
        end
        return finalIngs
    end
    return self
end
function RecGen:ifRemoveIngredients(bool,...)
    if bool then
        return self:removeIngredients(...)
    else
        return self
    end
end
function RecGen:ifModsRemoveIngredients(mods,...)
    local args=mods
    if type(args)~="table" then args={args} end
    local bool = true
    for _,m in pairs(args) do
        bool = bool and mods[m]
    end
    return self:ifRemoveIngredients(bool,...)
end
function RecGen:removeResults(...)
    local args = {...}
    local results = clone_function(self.results)
    self.results=function(levels,grade,dif)
        local ings = results(levels,grade,dif)
        local finalIngs = {}
        for c,i in pairs(ings) do
            if not omni.lib.is_in_table(i.name, args) and not omni.lib.is_in_table(c, args) then
                finalIngs[#finalIngs+1]=table.deepcopy(i)
            end
        end
        return finalIngs
    end
    return self
end
function RecGen:ifRemoveResults(bool,...)
    if bool then
        return self:removeResults(...)
    else
        return self
    end
end
function RecGen:ifModsRemoveResults(mods,...)
    local args=mods
    if type(args)~="table" then args={args} end
    local bool = true
    for _,m in pairs(args) do
        bool = bool and mods[m]
    end
    return self:ifRemoveResults(bool,...)
end
function RecGen:setResults(array,...)
    local arg = {...}
    if #arg > 0 then
        if array.name then
            array = {array}
        elseif type(array[1]) == "string" then
            array={{name=array[1], amount=array[2] or 1, type="item"}}
        end
        for i,v in pairs(arg) do
            local c = v
            if type(v[1])=="string" then c = {name=v[1],amount=v[2],type="item"} end
            array = omni.lib.union(array,{c})
        end
    end
    if type(array)=="table" then
        if array.normal then
            for _,dif in pairs({"normal","expensive"}) do
                for i,res in pairs(array[dif]) do
                    if type(res[1])=="string" then
                        if res[2] then
                            array[dif][i]={type="item",name=res[1],amount=res[2]}
                        else
                            array[dif][i]={type="item",name=res[1],amount=1}
                        end
                    end
                end
            end
            self.results = function(levels,grade, dif) if dif == 0 then return array.normal else return array.expensive end end
        elseif array[1] then
            if type(array[1]) == "string" and type(array[2]) == "number" then
                self.results = function(levels,grade, dif) return {{name=array[1],amount=array[2],type="item"}} end
            elseif type(array[1])=="string" and array[2]==nil then
                self.results = function(levels,grade, dif) return {{name=array[1],amount=1,type="item"}} end
            elseif type(array[1][1])=="table" or array[1].name then
                self.results = function(levels,grade, dif) return array end
            end
        elseif array.name then
            self.results = function(levels,grade, dif) return {
            {name=array.name,amount=array.amount,type=array.type or "item",amount_min=array.amount_min,amount_max=array.amount_max,probability=array.probability,temperature=array.temperature}
            } end
        end
    elseif type(array)=="function" then
        self.results = array
    elseif type(array)=="string" then
        self.results = function(levels,grade, dif) return {{name=array,amount=1,type="item"}} end
    end
    return self
end
function RecGen:setNormalResults(...)
    local arg = argTable({...},"string","name")
    local tmp = RecGen:create("mah","blah"):
        setResults(arg)
    local a = clone_function(self.results)
    local b = clone_function(tmp.results)
    self.results = function(levels,grade,dif) if dif == 0 then return b(levels,grade,dif) else return a(levels,grade,dif) end end
    return self
end
function RecGen:setExpensiveResults(...)
    local arg = argTable({...},"string","name")
    local tmp = RecGen:create("mah","blah"):
        setResults(arg)
    local a = clone_function(self.results)
    local b = clone_function(tmp.results)
    self.results = function(levels,grade,dif) if dif == 1 then return b(levels,grade,dif) else return a(levels,grade,dif) end end
    return self
end
function RecGen:addResults(...)
    local arg = argTable({...})
    local tmp = RecGen:create("mah","blah"):
        setResults(arg)
    local a = clone_function(tmp.results)
    local b = clone_function(self.results)
    self.results = function(levels,grade,dif) return omni.lib.union(a(levels,grade,dif),b(levels,grade,dif)) end
    return self
end
function RecGen:addNormalResults(...)
    local arg = argTable({...},"string","name")
    local tmp = RecGen:create("mah","blah"):
        setIngredients(arg)
    local a = clone_function(self.results)
    local b = function(levels,grade,dif) if dif == 0 then return arg else return nil end end
    self.results = function(levels,grade,dif) return omni.table.union(a(levels,grade,dif),b(levels,grade,dif)) end
    return self
end
function RecGen:addExpensiveResults(...)
    local arg = argTable({...},"string","name")
    local tmp = RecGen:create("mah","blah"):
        setIngredients(arg)
    local a = clone_function(self.results)
    local b = function(levels,grade,dif) if dif == 1 then return arg else return nil end end
    self.results = function(levels,grade,dif) return omni.table.union(a(levels,grade,dif),b(levels,grade,dif)) end
    return self
end
function RecGen:replaceResults(...)
    local arg = argTable({...})
    if #arg == 2 and type(arg[1])=="string" then
        arg={{arg[1],arg[2]}}
    end
    for _,a in pairs(arg) do
        if type(a[2])=="table" and not a[2].name then
            a[2]={type="item",name=a[1],amount=a[2] or 1}
        end
    end
    local results = clone_function(self.results)
    self.results=function(levels,grade,dif) return replaceIngres(results(levels,grade,dif),arg) end
    return self
end
function RecGen:ifReplaceResults(bool,...)
    if bool then
        self:replaceResults({...})
    end
    return self
end
function RecGen:ifModsReplaceResults(modis,...)
    if type(modis)=="string" then modis = {modis} end
    local bool = true
    for _,m in pairs(modis) do
        bool = bool and mods[m]
    end
    self:ifReplaceResults(bool,argTable({...}))
    return self
end
function RecGen:ifAddResults(bool,...)
    if bool then
        self:addResults(argTable({...},"string","name"))
    end
    return self
end
function RecGen:ifModsAddResults(modis,...)
    if type(modis)=="string" then modis = {modis} end
    local bool = true
    for _,m in pairs(modis) do
        bool = bool and mods[m]
    end
    self:ifAddResults(bool,argTable({...},"string","name"))
    return self
end
function RecGen:ifSetResults(bool,...)
    if (type(bool)=="boolean" and bool)  then
        self:setResults(argTable({...},"string","name"))
    end
    return self
end
function RecGen:ifModsResults(modis,...)
    if type(modis)~= "table" then modis={modis} end
    local bool = true
    for _,m in pairs(modis) do
        bool=bool and mods[m]
    end
    self:ifSetResults(bool,argTable({...},"string","name"))
    return self
end
function RecGen:setEnergy(tid)
    if type(tid)~= "function" then
        self.energy_required=function(levels,grade) return tid end
    else
        self.energy_required=tid
    end
    return self
end
function RecGen:setCategory(cat)
    if type(cat)~= "function" then
        self.category=function(levels,grade) return cat end
    else
        self.category=cat
    end
    return self
end
function RecGen:ifCategory(bool,cat)
    if bool or mods[bool] then
        self:setCategory(cat)
    end
    return self
end
function RecGen:setMain(main)
    if type(main)~= "function" then
        self.main_product = function(levels,grade) return main end
    else
        self.main_product = main
    end

    return self
end
function ItemGen:setBuildProto(proto)
    self.proto = proto
    return self
end
function RecGen:generate_recipe()
    local res = self.results(0,0,0) or {{name=self.name,amount=1,type="item"}}
    if res and #res == 1 and not self.set_icon then
        self.main_product=function(levels,grade) return res[1].name end
    end
    if ((
    (res and #res == 1 and omni.lib.find_prototype(res[1].name)==nil) or 
    (self.main_product(0,0) and omni.lib.find_prototype(self.main_product(0,0))==nil) or
    (self.item_name and omni.lib.find_prototype(self.item_name)==nil)) and (self.noItem ~= false and self.noItem ~= nil)) or self.force then
        local it = ItemGen:create(self.mod,self.item_name or self.main_product(0,0) or res[1].name):
        setIcons(self.icons(0,0)):
        setSubgroup(self.subgroup(0,0)):
        setOrder(self.order(0,0)):
        setStacksize(self.stack_size):
        setFuelValue(self.fuel_value):		
        setPlace(self.place_result(0,0)):
        setFlags(self.flags):
        setLocName(self.loc_name(0,0)):
        setLocDesc(self.loc_desc(0,0)):
        setBuildProto(self.proto):
        setMaxTemp(self.max_temperature(0,0))
        if self.fuel_category then it:setFuelCategory(self.fuel_category) end
        if self.isTile then it:tile() end
        if self.type == "fluid" then
            it:fluid():
            setCapacity(self.heat_capacity):
            setBaseColour(self.base_color):
            setFlowColour(self.flow_color)
        elseif self.type=="tool" then
            it:tool():
            setDurability(self.durability):
            setDurabilityDesc(self.durability_description_key)
        end
        it:extend()
    end

    local lname = self.loc_name(0,0)
    if not self.unique_loc_name then
        if not lname and ((res and #res == 1) or self.main_product(0,0)) then
            local it = omni.lib.find_prototype(self.main_product(0,0) or res[1].name)
            if not it then error("The item/fluid "..(self.main_product(0,0) or res[1].name).." does not seem to exist.") end
            if it.place_result then
                local entity = omni.lib.find_entity_prototype(it.place_result) or self.proto
                if entity and entity.localised_name then
                    lname=entity.localised_name
                else
                    lname={"entity-name."..it.place_result}
                end
            else
                if it.type == "fluid" then
                    lname={"fluid-name."..it.name}
                else
                    lname={"item-name."..it.name}
                end
            end
        elseif not lname then
            lname={"recipe-name."..self.name}
        elseif lname then
            if type(lname)=="table" and not string.find(lname[1],"name") then
                lname[1]="recipe-name."..lname[1]
            elseif type(lname)=="string" then
                if not string.find(lname,".") and not string.find(lname,"name") then
                    lname={"recipe-name."..lname}
                else
                    lname={lname}
                end
            end
        end
    end

    if self.main_product then
        if data.raw.item[self.main_product(0,0)] then
            local item = data.raw.item[self.main_product(0,0)]
            if item.icons then
                self.icons = function(levels,grade) return item.icons end
            elseif item.icon then
                self.icons = function(levels,grade) return {{icon = item.icon, icon_size = item.icon_size or 32}} end
            end
        elseif data.raw.fluid[self.main_product(0,0)] then
            local fluid = data.raw.fluid[self.main_product(0,0)]
            if fluid.icons then
                self.icons = function(levels,grade) return fluid.icons end
            elseif fluid.icon then
                self.icons = function(levels,grade) return {{icon = fluid.icon, icon_size = fluid.icon_size or 32}} end
            end
        end
    end
    if self.tech.name(0,0) ~= nil and not self.enabled(0,0) and self.tech.noTech ~= true then
        local tname = self.tech.name(0,0)
        --Add way to make this optional
        --omni.lib.remove_recipe_all_techs(tname)
        if string.find(tname,"omnitech") == nil then
            if tonumber(string.sub(tname,string.len(tname),string.len(tname))) and data.raw.technology["omnitech-"..tname] then
                tname = "omnitech-"..tname
            elseif data.raw.technology["omnitech-"..tname.."-1"] then
                tname = "omnitech-"..tname.."-1"
            end
        end
        if not data.raw.technology[tname] and self.tech.icons(0,0)~= nil then
            --omni.lib.remove_unlock_recipe(self.tech.name(0,0),self.name)
            self.rtn[#self.rtn+1]=TechGen:create(self.mod,self.tech.name(0,0)):
            setCost(self.tech.cost(0,0)):
            setPacks(self.tech.packs(0,0)):
            setTime(self.tech.time(0,0)):
            setIcons(self.tech.icons(0,0)):
            setUpgrade(self.tech.upgrade(0,0) or false):
            addUnlocks(omni.lib.union(self.tech.effects,{self.name})):
            setPrereq(self.tech.prerequisites(0,0)):
            setLocDesc(self.tech.loc_desc(0,0)):
            setLocName(self.tech.loc_name(0,0)):
            return_array()[1]
        else
            --Force recipe unlock since the recipe is not generated yet
            omni.lib.add_unlock_recipe(tname, self.name, true)
        end
    end
    if self.category(0,0) and not data.raw["recipe-category"][self.category(0,0)] then
        data:extend({
            {
                type = "recipe-category",
                name = self.category(0,0),
            }
        })
    end
    if self.add_prod then
        for _, module in pairs(data.raw.module) do
            if module.effect.productivity and module.limitation and ((type(self.add_prod)=="boolean" and self.add_prod) or (type(self.add_prod)=="table" and omni.lib.is_in_table(module.name, self.add_prod))) then
                table.insert(module.limitation, self.name)
            end
        end
    end
    self.rtn[#self.rtn+1] ={
        type = "recipe",
        name = self.name,
        localised_name = lname,
        localised_description = self.loc_desc(0,0), --self:setDescLocType("recipe"),
        category = self.category(0,0),
        subgroup = self.subgroup(0,0),
        order = self.order(0,0),
        hidden = self.hidden(0,0),
        normal = {
            ingredients=table.deepcopy(self.ingredients(0,0,0)) or {},
            results=table.deepcopy(self.results(0,0,0) or res) or {},
            enabled = self.enabled(0,0),
            main_product = self.main_product(0,0),
            energy_required = self.energy_required(0,0) or 0.5,
        },
        expensive = {
            ingredients=table.deepcopy(self.ingredients(0,0,1)) or {},
            results=table.deepcopy(self.results(0,0,1) or res) or {},
            enabled = self.enabled(0,0),
            main_product = self.main_product(0,0),
            energy_required = self.energy_required(0,0) or 0.5,
        },
        icons = self.icons(0,0),
        icon_size = 32,
    }
    return self
end
function RecGen:marathon()
    omni.marathon.exclude_recipe(self.name)
    return self
end
function RecGen:exemptMarathon()
    omni.marathon.exclude_recipe(self.name)
    return self
end
function RecGen:equalize(item,res)
    local results = self:results(0,0,0)
    local ingredients = self:ingredients(0,0,0)
    if #results == 1 then
        omni.marathon.equalize(item,results[1].name)
    elseif #results > 1 and #ingredients == 1 then
        omni.marathon.equalize(ingredients[1].name,item)
    elseif item and res then
        omni.marathon.equalize(item,res)
    end
    return self
end
function RecGen:equalizeMarathon(equalize)
    return self:equalize(equalize)
end
function RecGen:exemptCompression()
--to be fixed
    omni.marathon.exclude_recipe(self.name)
    return self
end
function RecGen:return_array()
    self:generate_recipe()
    return self.rtn
end
function RecGen:extend()
    if self.requiredMods(0,0) and self.name then
        Omni.Gen.Rec[self.name] = self
        data:extend(self:return_array())
    end
end

function RecChain:setLevel(lvl)
    self.levels=lvl
    return self
end

function RecGen:setTechName(name)
    if type(name)=="function" then
        self.tech.name = name
    elseif type(name)=="string" then
        self.tech.name=function(levels,grade) return name end
    else
        self.tech.name=function(levels,grade) return self.name end
    end
    return self
end

function RecGen:setTechEffects(...)
    local name = {...}
    if type(name[1])=="function" then
        self.tech.effects = name[1]
    else
        self.tech.effects=function(levels,grade) return name end
    end
    return self
end

function RecGen:setTechLocName(inname,...)
    local arg = {...}
    local rtn = {}
    if type(inname) == "function" then
        rtn[1] = inname
    elseif type(inname)=="table" and inname["grade-1"] then
        rtn[1] = function(levels,grade) return inname["grade-"..grade] end
    elseif type(inname)=="table" and #arg == 0 then
        if #inname ==1 then
            rtn[#rtn+1]=function(levels,grade) return inname[1] end
        else
            for _, part in pairs(inname) do
                if type(part) == "function" then
                    rtn[#rtn+1] = part
                elseif type(part)=="table" and not #part == 1 then
                    rtn[#rtn+1] = function(levels,grade) return inname[grade] end
                elseif type(part)=="string" and string.find(part,".") and (string.find(part,"name") or string.find(part,"description")) then
                    rtn[#rtn+1] = function(levels,grade) return {part} end
                else
                    rtn[#rtn+1]=function(levels,grade) return part end
                end
            end
        end
    else
        rtn[1]=function(levels,grade) return inname end
    end
    for _,part in pairs(arg) do
        if type(part) == "function" then
            rtn[#rtn+1] = part
        elseif type(part)=="table" and not #part == 1 then
            rtn[#rtn+1] = function(levels,grade) return inname[grade] end
        elseif type(part)=="string" and string.find(part,".") and (string.find(part,"name") or string.find(part,"description")) then
            rtn[#rtn+1] = function(levels,grade) return {part} end
        else
            rtn[#rtn+1]=function(levels,grade) return part end
        end
    end
    self.tech.loc_name = function(levels,grade)
        local out = {}
        for _, o in pairs(rtn) do
            out[#out+1]=o(levels,grade)
        end
        return out
    end
    return self
end

function RecGen:addTechLocName(key)
    local a = clone_function(self.tech.loc_name)
    local b = function(levels,grade) return {key} end
    if type(key) == "function" then
        b = key
    elseif type(key)=="table" and not #key == 1 then
        b = function(levels,grade) return key[grade] end
    elseif type(key)=="string" and string.find(key,".") and (string.find(key,"name") or string.find(key,"description")) then
        b = function(levels,grade) return {key} end
    else
        b=function(levels,grade) return key end
    end
    self.tech.loc_name = clone_function(function(levels,grade) return omni.lib.union(a(levels,grade),{b(levels,grade)}) end)
    return self
end
function RecGen:setTechLocDesc(inname,keys)
        if type(inname) == "function" then
        self.tech.loc_desc = inname
    elseif type(inname)=="table" then
        self.tech.loc_desc = function(levels,grade) return inname[grade] end
    else
        self.tech.loc_desc=function(levels,grade) return inname end
    end
    if type(keys) == "function" then
        self.tech.loc_desc_keys = keys
    elseif type(keys)=="table" then
        self.tech.loc_desc_keys = function(levels,grade) return keys end
    else
        self.tech.loc_desc_keys=function(levels,grade) return {keys} end
    end
    return self
end
function RecGen:setTechUpgrade(value)
    if type(value)~= "function" then
        self.tech.upgrade = function(levels,graede) return value == nil or value end
    else
        self.tech.upgrade = value
    end
    return self
end
function RecGen:setTechCost(cost)
    if type(cost)=="number" then
        self.tech.cost = function(levels,grade) return cost end
    elseif type(cost)=="function" then
        self.tech.cost = cost
    end
    return self
end
--setTechIcons() can be called with either:
    --icon name (mod=nil, mod from RecGen() call is used as dir path)
    --icon name + modname
    --(icon name, icon_size) if mod is defined in the RecGen call
    --the full path to the icon (mod=nil)
    --with an icons table where icon and icon_size are specified (mod=nil)
    --with an (icons) table consisting of {{namestring, icon_size}} or {{namestring, icon_size=XXX}} (+ modname if not already defined)
function RecGen:setTechIcons(icons,mod)
    if type(icons)~= "function" then
        local ic = {}
        local ic_sz = 128
        --if not mod and not self.mod then log("RecGen:setTechIcons() mod not defined") return nil end
        if type(icons)=="string" then
            if string.match(icons, "%_%_(.-)%_%_") then
                ic[#ic+1]={icon=icons, icon_size=ic_sz}
            elseif type(mod) == "number" and self.mod then
                ic[#ic+1]={icon = "__"..self.mod.."__/graphics/technology/"..icons..".png", icon_size=mod}
            else
                ic[#ic+1]={icon = "__"..(mod or self.mod).."__/graphics/technology/"..icons..".png", icon_size=ic_sz}
            end
        elseif type(icons)=="table" then
            for _, c in pairs(icons) do
                -- .icon is just a namestring
                if c.icon and not string.match(c.icon, "%_%_(.-)%_%_") then
                    ic[#ic+1]={icon = "__"..(mod or self.mod).."__/graphics/technology/"..c.icon..".png", icon_size=c.icon_size or ic_sz}
                --table consists of {namestring,icon_size} or {namestring, icon_size=XXX}
                elseif not c.icon and c[1] and type(c[1])=="string" then
                    ic[#ic+1]={icon = "__"..(mod or self.mod).."__/graphics/technology/"..c[1]..".png", icon_size=c[2] or c.icon_size or ic_sz}
                -- table should be fine
                else
                    ic[#ic+1] = c
                end
            end
        end
        self.tech.icons = function(levels,grade) return ic end
    else
        self.tech.icons = icons
    end	
    return self
end
function RecGen:setTechPacks(cost)
    if type(cost)=="number" or type(cost)=="string" then
        self.tech.packs = function(levels,grade) return cost end
    elseif type(cost)=="table" then
        self.tech.packs = function(levels,grade) return cost end
    elseif type(cost)=="function" then
        self.tech.packs = cost
    end
    return self
end
function RecGen:setTechTime(t)
    if type(t)=="number" then
        self.tech.time = function(levels,grade) return t end
    elseif type(t)=="function" then
        self.tech.time = t
    end
    return self
end
function RecGen:setTechPrereq(...)
    local arg={...}
    if #arg==1 and type(arg[1])~="string" then
        local prereq = arg[1]
        if type(prereq)=="table" then
            if type(prereq[1])=="table" then
                self.tech.prerequisites = function(level,grade)
                    for j=grade,1,-1 do
                        if prereq[j]~= nil then return prereq[j] end
                    end
                end
            else
                self.tech.prerequisites = function(level,grade) return prereq end
            end
        elseif type(prereq)=="function" then
            self.tech.prerequisites = prereq
        end
    elseif #arg == 1 and type(arg[1])~="table" then
        self.tech.prerequisites= clone_function(function(levels,grade) return arg end)
    else
        self.tech.prerequisites= clone_function(function(levels,grade) return arg end)
    end
    return self
end
--Fix these
function RecGen:ifAddTechPrereq(bool, ...)
    if bool then
        self:addTechPrereq(argTable({...},"table"))
    end
    return self
end
function RecGen:ifModsAddTechPrereq(modis, ...)
    if type(modis)=="string" then modis = {modis} end
    local bool = true
    for _,m in pairs(modis) do
        bool = bool and mods[m]
    end
    self:ifAddTechPrereq(bool,argTable({...},"table"))
    return self
end
function RecGen:addTechPrereq(...)
    local arg = argTable({...},"table")
    if type(arg[1])=="table" or type(arg[1])=="function" then arg=arg[1] end
    local tmp = RecGen:create("mah","blah"):
        setTechPrereq(arg)
    local a = clone_function(tmp.tech.prerequisites)
    local b = clone_function(self.tech.prerequisites)
    self.tech.prerequisites = function(levels,grade) return omni.lib.union(a(levels,grade),b(levels,grade)) end
    return self
end
function RecGen:addCondPrereq(cond,...)
    local arg = {...}
    if type(arg[1])=="table" and not (arg[2] and type(arg[2])=="table") then arg=arg[1] end
    local argif = {}
    local argelse = {}
    local argtype = argif
    if not (arg[2] and type(arg[2])=="table") then
        for i=1,#arg do
            if arg[i]==":" then
                argtype=argelse
            else
                argtype[#argtype+1]=arg[i]
            end
        end
    else
        argif=arg[1]
        argelse=arg[2]
    end
    local tmpif = RecGen:create("mah","blah"):
        setTechPrereq(argif)
    local tmpelse = RecGen:create("mah","blah"):
        setTechPrereq(argelse)
    local b = clone_function(self.tech.prerequisites)
    if type(cond)=="string" then
        if mods[cond] then
            local a = clone_function(tmpif.tech.prerequisites)
            self.tech.prerequisites = function(levels,grade) return omni.lib.union(a(levels,grade),b(levels,grade)) end
        else
            local a = clone_function(tmpelse.tech.prerequisites)
            self.tech.prerequisites = function(levels,grade) return omni.lib.union(a(levels,grade),b(levels,grade)) end
        end
    elseif type(cond)=="boolean" then
        if cond then
            local a = clone_function(tmpif.tech.prerequisites)
            self.tech.prerequisites = function(levels,grade) return omni.lib.union(a(levels,grade),b(levels,grade)) end
        else
            local a = clone_function(tmpelse.tech.prerequisites)
            self.tech.prerequisites = function(levels,grade) return omni.lib.union(a(levels,grade),b(levels,grade)) end
        end
    end
    return self
end

function RecChain:setTechSuffix(suffix)
    self.tech.suffix = suffix
    return self
end
function RecChain:setTechPrefix(prefix)
    self.tech.prefix = prefix
    return self
end

function RecChain:setTechCircumfix(prefix,suffix)
    self.chain.tech.suffix = suffix
    self.chain.tech.prefix = prefix
    return self
end

function RecChain:generate_chain()
    local array = {}
    local m = self.levels
    local res = self.results(self.levels,1)
    for _,r in pairs(res) do
        if r.name == self.name then
            self:setMain(r.name)
            break
        end
    end
    if ((#res == 1 and omni.lib.find_prototype(res[1].name)==nil) or (self.main_product(0,0) and omni.lib.find_prototype(self.main_product(0,0))==nil) or
        (self.item_name and omni.lib.find_prototype(self.item_name)==nil)) and (self.noItem ~= false and self.noItem ~= nil) then
        local it = ItemGen:create(self.mod,self.item_name or self.main_product(0,0) or res[1].name):
        setIcons(self.icons(0,0)):
        setSubgroup(self.subgroup(0,0)):
        setStacksize(self.stack_size):
        setFuelValue(self.fuel_value):
        setOrder(self.order(0,0)):
        setPlace(self.place_result(0,0)):
        setFlags(self.flags):
        setLocName(self.loc_name(0,0)):
        setLocDesc(self.loc_desc(0,0)):
        setGenerationCondition(self.requiredMods(0,0))
        if self.fuel_category then it:setFuelCategory(self.fuel_category) end
        if self.type == "fluid" then
            it:fluid():
            setMaxTemp(self.max_temperature):
            setCapacity(self.heat_capacity):
            setBaseColour(self.base_color):
            setFlowColour(self.flow_color)
        elseif self.type=="tool" then
            it:tool():
            setDurability(self.durability):
            setDurabilityDesc(self.durability_description_key)
        end
        it:extend()
    end
    for i = 1, self.levels do
        local techname = self.tech.name(m,i) or self.name
        if self.tech.prefix ~= "" and self.tech.prefix ~= nil then techname=self.tech.prefix.."-"..techname end
        if self.tech.suffix ~= "" and self.tech.suffix ~= nil then techname=techname.."-"..self.tech.suffix end

        local techDifEnabled = 1

        while self.enabled(m,techDifEnabled) do
            techDifEnabled=techDifEnabled+1
        end
        techDifEnabled=techDifEnabled-1
        local actualTier = i - techDifEnabled
        local lname = omni.lib.union(self.loc_name(m,actualTier),{})
        if self.loc_name(m,actualTier) == nil then
            local prefixType = "item"
            if self.type=="fluid" then prefixType = "fluid" end
            lname = {self.name,actualTier}
        end
        --if self.loc_desc(m,i) == nil and self.main_product then lname=nil end
        local r = RecGen:create(self.mod,"omnirec-"..self.name.."-"..omni.lib.alpha(i)):
        setCategory(self.category):
        setSubgroup(self.subgroup(self.levels,i)):
        setLocName(lname):
        setLocDesc(self.loc_desc(m,actualTier)):
        setIcons(self.icons(m,i)):
        setEnabled(self.enabled(m,i)):
        setSubgroup(self.subgroup(0,0)):
        setOrder(self.order(0,0)):
        setEnergy(self.energy_required(self.levels,i)):
        noTech(self.tech.noTech):
        setTechCost(omni.lib.round(self.tech.cost(self.levels,i))):
        setTechTime(omni.lib.round(self.tech.time(self.levels,i))):
        setTechPacks(self.tech.packs(self.levels,i)):
        setTechUpgrade(i>1):
        setTechIcons(self.tech.icons(self.levels,i)):
        setTechLocName(self.tech.loc_name(self.levels,i)):
        setTechLocDesc(self.tech.loc_desc,self.tech.loc_desc_keys):
        --setTechName("omnitech-"..techname.."-"..i-techDifEnabled):
        setGenerationCondition(self.requiredMods(self.levels,i))

        if string.find(techname, "omnitech-") then
            r:setTechName(techname.."-"..i-techDifEnabled)
        else
            r:setTechName("omnitech-"..techname.."-"..i-techDifEnabled)
        end


        if self.tech.icons(levels,i) then
            r:setTechIcons(self.tech.icons(levels,i))
        else
            r:setTechIcons(self.tech.name,self.mod)
        end
        if self.add_prod then
            r:addProductivity()
        end
        if self.isTile then r:tile() end
        if self.loc_name(m,actualTier)~= nil then r:addLocName(actualTier) end
        if self.tech.loc_name(levels,i) ~= nil then r:addTechLocName(actualTier) end

        local prq = self.tech.prerequisites(m,i)
        if (not prq or #prq == 0) and i-techDifEnabled > 1 then
            prq={"omnitech-"..techname.."-"..i-1-techDifEnabled}
        elseif i>1 and prq and #prq >= 2 and omni.lib.is_in_table("omnitech-"..techname.."-"..i-1,prq) then
            for i,req in pairs(prq) do
                if req == "omnitech-"..techname.."-"..i-1 then
                    --table.remove(prq,i)
                end
            end
        elseif i-techDifEnabled>1 and self.tech.prerequisites(m,i-1)==self.tech.prerequisites(m,i) then
            prq={"omnitech-"..techname.."-"..i-1-techDifEnabled}
        end
        r:setTechPrereq(prq)
        if self.main_product(0,0) then
            if not self.set_icon then
                self:setIcons(self.main_product(0,0))
            end
        end
        --r:setIcons(self.icons(m,i))

        if mods["omnimatter_marathon"] then omni.marathon.exclude_recipe(r.name) end
        r:setIngredients(self.ingredients(self.levels,i))
        r:setResults(self.results(self.levels,i))
        --if #self.chain.output.yield.items == 1 then self:setMain(self.chain.output.yield.items[1]) end
        r:return_array()
        array = table.deepcopy(omni.lib.union(array,r.rtn))

        --Tech generation
        --[[
        local techname = self.tech.name
        if self.tech.prefix then techname=self.tech.prefix..techname end
        if self.tech.suffix then techname=techname..self.tech.suffix end
        local t = TechGen:create(self.mod,"omnirec-"..techname.."-"..omni.lib.alpha(i)):
        set_packs(self.tech.packs(self.levels,i)):
        set_cost(self.tech.cost(self.levels,i))]]
    end
    self.rtn = array
    return self
end
function RecChain:return_array()
    self:generate_chain()
    return self.rtn
end
function RecChain:extend()
    if self.requiredMods(0,0) then
    Omni.Chain.Rec[self.name]=self
        self:return_array()
        data:extend(self.rtn)
    end
end

function TechGen:create(mod,name)
    local t = {
        mod = mod,
        name=name or mod,
        rtn = {},
        cost = 50,
        packs = 1,
        unlock={},
        upgrade = false,
        prereq={},
        time = 20,
        type="technology",
        allowed = true

    }
    if mod then
        local m = "__omnimatter_"..mod.."__"
        t.icon = m.."/graphics/technology/"..name..".png"
    end
    return setmetatable(t,TechGen)
end

function TechGen:import(name)
    local tech = data.raw.technology[name]
    if tech then
        local t = TechGen:create():
        setName(name):
        setIcons(omni.lib.icon.of(tech)):
        setPacks(tech.unit.ingredients):
        setCost(tech.unit.count):
        setTime(tech.unit.time):
        setPrereq(tech.prerequisites):
        setUpgrade(tech.upgrade):
        setEnabled(tech.enabled)

        local uns = {}
        for _,unlock in pairs(tech.effects) do
            if unlock.type=="unlock-recipe" then
                uns[#uns+1]=unlock.recipe
            end
        end

        t:addUnlocks(uns)
        return t
    else
        error("The technology "..name.." does not exist to be imported.")
    end
end
function TechGen:importIf(name)
    local tech = data.raw.technology[name]
    if tech then
        return TechGen:import(name)
    else
        return TechGen:create():setAllow(false)
    end
end
function TechGen:setName(name)
    self.name = name
    return self
end
function TechGen:setEnabled(name)
    self.enabled = name or name==nil or name=="true"
    return self
end
function TechGen:setIcon(m)
    self.icons = {{icon = m, icon_size = 128}}
    return self
end
function TechGen:setIcons(m)
    self.icons = m
    return self
end
function TechGen:setAllow(m)
    self.allowed = m or m==nil
    return self
end
function TechGen:setLocName(n)
    if type(n) == "table" then
        self.loc_name = n
    else
        self.loc_name = {n}
    end
    if self.loc_name[1] and not string.find(self.loc_name[1],"name.") then
        self.loc_name[1]="technology-name."..self.loc_name[1]
    end
    return self
end
function TechGen:setLocDesc(n)
    if type(n) == "table" then
        self.loc_desc = n
    else
        self.loc_desc = {n}
    end
    if self.loc_desc[1] and not string.find(self.loc_desc[1],"name.") then
        self.loc_desc[1]="technology-description."..self.loc_desc[1]
    end
    return self
end
function TechGen:setPacks(p)
    self.packs = p
    return self
end
function TechGen:setCost(c)
    self.cost = c
    return self
end
function TechGen:setTime(t)
    self.time = t
    return self
end
function TechGen:setPrereq(...)
    local arg = argTable({...})
    self.prereq = arg
    return self
end
function TechGen:addPrereq(...)
    local arg = argTable({...})
    self.prereq = omni.lib.union(self.prereq,arg)
    return self
end
function TechGen:addPrereqIf(bool,...)
    if bool or mods[bool] then
        local arg = argTable({...})
        self:addPrereq(arg)
    end
    return self
end
function TechGen:replacePrereq(source,target)
    local newPrereq = {}
    for i,pre in pairs(self.prereq) do
        if pre==source then
            newPrereq[#newPrereq+1]=target
        else
            newPrereq[#newPrereq+1]=pre
        end
    end
    self.prereq=newPrereq
    return self
end
function TechGen:replacePrereqIf(bool,source,target)
    if bool or mods[bool] then
        self:replacePrereq(source,target)
    end
    return self
end
function TechGen:removePrereq(...)
    local arg = argTable({...})
    local newPrereq = {}
    for i,pre in pairs(self.prereq) do
        if not omni.lib.is_in_table(pre,arg) then
            newPrereq[#newPrereq+1]=pre
        end
    end
    self.prereq=newPrereq
    return self
end
function TechGen:setUpgrade(value)
    self.upgrade = value == nil or value
    return self
end
function TechGen:nullUnlocks()
    self.unlock={}
    return self
end
function TechGen:addUnlocks(...)
    local unlock = argTable({...})
    self.unlock=omni.lib.union(self.unlock,unlock)
    return self
end
function TechGen:addUnlocksExists(...)
    local unlock = argTable({...})
    local new = {}
    for _,rec in pairs(unlock) do
        if data.raw.recipe[rec] then
            new[#new+1]=rec
        end
    end
    self:addUnlocks(new)
    return self
end
function TechGen:removeUnlocks(...)
    local unlock = argTable({...})
    self.unlock=omni.lib.dif(self.unlock,unlock)
    return self
end

function TechGen:sethidden(hidden)
    self.hidden = hidden or true
    return self
end

function TechGen:generate_tech()
    local c = {}
    local add_cost = 1
    if type(self.packs)=="number" then
        for i=1,self.packs do
            if omni.sciencepacks[i] then
                table.insert(c,{omni.sciencepacks[i],1})
            else
                add_cost = add_cost *2
            end
        end
    elseif type(self.packs) == "table" then
        c=table.deepcopy(self.packs)
    elseif type(self.packs)=="string" then
        c=table.deepcopy(data.raw.technology[self.packs].unit.ingredients)
    else
        error("Tech ingredient costs must be a number, table or function that gives the former two.")
    end
    local u = {}
    for _, rec in pairs(self.unlock) do
        u[#u+1]={
            type = "unlock-recipe",
            recipe = rec
        }
        if data.raw.recipe[rec] then data.raw.recipe[rec].enabled=false end
    end
    local tech = {
    name = self.name,
    type = "technology",
    icons = self.icons,
    upgrade = self.upgrade,
    --icon_size = 128,
    prerequisites = self.prereq,
    enabled = self.enabled,
    hidden = self.hidden,
    effects =u,
    unit  =
    {
      count = omni.lib.round(self.cost*add_cost),
      ingredients = c,
      time = self.time
    },
    order = "c-a"
    }
    --if type(tech.icon) == "table" and tech.icon[1] then
    --	tech.icons = self.icon
    --	tech.icon = nil
    --	tech.icon_size = nil
    --end
    if self.loc_name and next(self.loc_name) then
        tech.localised_name = self.loc_name
    end
    if self.loc_desc and next(self.loc_desc) then
        tech.localised_description = self.loc_desc
    end
    self.rtn[#self.rtn+1] = tech
end
function TechGen:return_array()
    self:generate_tech()
    return self.rtn
end
function TechGen:extend()
    if self.allowed then
    Omni.Gen.Tech[self.name]=self
        data:extend(self:return_array())
    end
end

function setBuildingParameters(b,subpart)
    b.type = "assembling-machine"
    b.fast_replaceable_group=function(levels,grade) return "assembling-machine" end
    b.max_health = function(levels,grade) return 300 end
    b.size = function(levels,grade) return 1.5 end
    b.mining_time = function(levels,grade) return 1 end
    b.module =
    {
        slots = function(levels,grade) return 3 end,
        effects = function(levels,grade) return {"consumption", "speed", "pollution"} end
    }
    b.crafting_speed = function(levels,grade) return 1 end
    b.energy_source =
    {
        type = "electric",
        usage_priority = "secondary-input",
        emissions_per_minute = 1
    }
    b.energy_usage = function(levels,grade) return "150kW" end
    b.animation = function(levels,grade) return {} end
    b.animations = function(levels,grade) return nil end
    b.pictures = function(levels,grade) return nil end
    b.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
    b.working_sound = function(levels,grade) return {
        sound = {
            {
            filename = "__base__/sound/assembling-machine-t1-1.ogg",
            volume = 0.8
            },
            {
            filename = "__base__/sound/assembling-machine-t1-2.ogg",
            volume = 0.8
            },
        },
        idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
        apparent_volume = 2,
        }
    end
    b.fluid_boxes = function(levels,grade) return nil end
    b.input_fluid_box = function(levels,grade) return nil end
    b.flags = {"placeable-neutral", "player-creation"}
    b.corpse = "big-remnants"
    b.mining_speed = function(levels,grade) return 0.5 end
    b.mining_power = function(levels,grade) return 3 end
    b.overlay={}
    b.place_result = function(levels,grade) return b.name end
    b.next_upgrade = function(levels,grade) return nil end
    b.vector_to_place_result = function(levels,grade) return {0, -1.85} end
    b.crafting_categories = function(levels,grade) return nil end
    b.working_visualisations = function(levels,grade) return nil end
    b.effectivity = function(levels,grade) return 1 end
    b.fluid_usage_per_tick = function(levels,grade) return 1 end
    b.burns_fluid = function(levels,grade) return false end
    b.vertical_animation = function(levels,grade) return nil end
    b.horizontal_animation = function(levels,grade) return nil end
    b.max_temperature = function(levels,grade) return nil end
    b.maximum_wire_distance = function(levels,grade) return nil end
    b.area = function(levels,grade) return nil end
    b.connection_points = function(levels,grade) return nil end
    b.radius_visualisation_picture = function(levels,grade) return nil end
    b.sound = function(levels,grade) return nil end
    b.light = function(levels,grade) return nil end
    b.resource_searching_radius = function(levels,grade) return nil end
    b.resource_categories = function(levels,grade) return nil end
    b.inputs = function(levels,grade) return nil end
    b.off_animation = function(levels,grade) return nil end
    b.on_animation = function(levels,grade) return nil end
    b.hd = false
    return b
end

function BuildGen:create(mod,name)
    local b = RecGen:create(mod,name)
    return setmetatable(setBuildingParameters(b),BuildGen)
end

function BuildGen:import(name)
    local build = omni.lib.find_entity_prototype(name)
    if not build then return nil end

    local b = BuildGen:create():
        setName(build.name):
        setEffectivity(build.effectivity):
        setFluidConsumption(build.fluid_usage_per_tick):
        setFluidBurn(build.burns_fluid):
        setReplace(build.fast_replaceable_group):
        setHealth(build.health):
        setSize(omni.lib.round(build.selection_box[2][1]-build.selection_box[1][1]),omni.lib.round(build.selection_box[2][2]-build.selection_box[1][2])):
        setModEffects(build.allowed_effects):
        setSpeed(build.crafting_speed):
        setEnergySource(build.energy_source):
        setOrder(build.order):
        setNextUpgrade(build.next_upgrade):
        setUsage(build.energy_usage):
        setAnimation(build.animation):
        setAnimations(build.animations):
        setWorkVis(build.working_visualisations):
        setDirectionAnimation(build.horizontal_animation,build.vertical_animation):
        setRadVisPic(build.radius_visualisation_picture):
        setLight(build.light):
        setSoundWorking(build.working_sound):
        setSoundImpact(build.vehicle_impact_sound):
        setFluidBox(build.fluid_boxes or build.fluid_box):
        setFluidInput(build.input_fluid_box):
        setCorpse(build.corpse):
        setMiningSpeed(build.mining_speed):
        setMiningPower(build.mining_power):
        setWireDistance(build.maximum_wire_distance):
        setArea(build.supply_area_distance): --Add beacon effect
        setConnectionPoints(build.connection_points):
        setPlaceShift(build.vector_to_place_result):
        setMiningTime(build.minable.mining_time):
        setCrafting(build.crafting_categories):
        setSearchRadius(build.resource_searching_radius):
        setResourceCategory(build.resource_categories):
        setInputs(build.inputs):
        setInventory(build.ingredient_count or build.source_inventory_size):
        setResultInventory(build.result_count or build.result_inventory_size):
        setOffAnimation(build.off_animation):
        setOnAnimation(build.on_animation)

        --if build.resource_searching_radius then b:setMiningRadius(build.resource_searching_radius*2+0.02) end
        -- if build.working_sound then
        --     b:setSoundWorking(build.working_sound)
        -- end
        if build.module_specification then
            b:setModSlots(build.module_specification.module_slots)
        else
            b:setModSlots(0)
        end
        if build.localised_name then
            b:setLocName(build.localised_name)
        end
        if build.localised_description then
            b:setLocDesc(build.localised_description)
        end

        if build.energy_source and (build.energy_source.fuel_categories or build.energy_source.fuel_category) then
            b:setFuelCategories(build.energy_source.fuel_categories or build.energy_source.fuel_category)
            --Make sure that we nil fuel_category after we set fuel_categories
            build.energy_source.fuel_category = nil
        end

    local r = RecGen:import(name)
    for name,data in pairs(r) do
        b[name]=table.deepcopy(data)
    end

    --if build.energy_source.type=="burner" then b:setBurner(self.energy_source.effectivity,self.energy_source.fuel_inventory_size) end
    return b:setType(build.type):setFlags(build.flags):setIcons(build.icons or build.icon or omni.lib.icon.of(build, true))
end
function BuildGen:importIf(name)
    local build = omni.lib.find_entity_prototype(name)
    if build then
        return BuildGen:import(name):setForce()
    end
    return BuildGen:create(name):setGenerationCondition(false)
end
function BuildGen:find(name)
    if Omni.Gen.Build[name] then
        return Omni.Gen.Build[name]:setForce()
    else
        return BuildGen:importIf(name)
    end
end
function BuildGen:allowProductivity(func)
    local tmp = clone_function(self.module.effects)
    self.module.effects = function(levels,grade) return omni.lib.union(tmp(levels,grade),{"productivity"}) end
    return self
end
function BuildGen:setSearchRadius(func)
    if type(func)=="function" then
        self.resource_searching_radius = func
    else
        self.resource_searching_radius = function(levels,grade) return func end
    end
    return self
end
function BuildGen:setResourceCategory(func)
    if type(func)=="function" then
        self.resource_categories = func
    elseif type(func)=="table" then
        self.resource_categories = function(levels,grade) return func end
    elseif type(func)=="string" then
        self.resource_categories = function(levels,grade) return {func} end
    end
    return self
end
function BuildGen:setInputs(...)
    local eff = {...}
    if #eff==1 and type(eff[1])=="function" then
        self.inputs = eff[1]
    elseif #eff==1 and type(eff[1])=="table" then
        self.inputs = function(levels,grade) return eff[1] end
    elseif #eff == 1 and type(eff[1])=="string" then
        local build = omni.lib.find_entity_prototype(eff[1])
        if not build or not build.inputs then
            self.inputs = function(levels,grade) return {eff[1]} end
        else
            self.inputs = function(levels,grade) return build.inputs end
        end
    else
        self.inputs = function(levels,grade) return eff end
    end
    return self
end
function BuildGen:setEffects(eff)
    if type(eff)=="function" then
        self.module.effects = eff
    elseif type(eff)=="table" then
        self.module.effects = function(levels,grade) return eff end
    end
    return self
end
function BuildGen:setDrill()
    self.type = "mining-drill"
    return self
end
function BuildGen:setFurnace()
    self.type = "furnace"
    return self
end
function BuildGen:setAssembler()
    self.type = "assembling-machine"
    return self
end
function BuildGen:setGenerator()
    self.type = "generator"
    return self
end
function BuildGen:setElectricPole()
    self.type = "electric-pole"
    self:setArea(2.5)
    self:setWireDistance(7.5)
    return self
end
function BuildGen:setType(t)
    self.type = t
    return self
end
function BuildGen:setNextUpgrade(t)
    if type(t)=="function" then
        self.next_upgrade = t
    else
        self.next_upgrade = function(levels,grade) return t end
    end
    return self
end
function BuildGen:setLight(t)
    if type(t)=="function" then
        self.light = t
    else
        self.light = function(levels,grade) return t end
    end
    return self
end
function BuildGen:setConnectionPoints(t)
    if type(t)=="function" then
        self.connection_points = t
    else
        self.connection_points = function(levels,grade) return t end
    end
    return self
end
function BuildGen:setRadVisPic(t)
    if type(t)=="function" then
        self.radius_visualisation_picture = t
    else
        self.radius_visualisation_picture = function(levels,grade) return t end
    end
    return self
end
function BuildGen:setWireDistance(t)
    if type(t)=="function" then
        self.maximum_wire_distance = t
    else
        self.maximum_wire_distance = function(levels,grade) return t end
    end
    return self
end
function BuildGen:setArea(t)
    if type(t)=="function" then
        self.area = t
    else
        self.area = function(levels,grade) return t end
    end
    return self
end
function BuildGen:setEffectivity(eff)
    if type(eff)=="function" then
        self.effectivity = eff
    elseif type(eff)=="number" then
        self.effectivity = function(levels,grade) return eff end
    end
    return self
end
function BuildGen:setFluidConsumption(eff)
    if type(eff)=="function" then
        self.fluid_usage_per_tick = eff
    elseif type(eff)=="table" then
        self.fluid_usage_per_tick = function(levels,grade) return eff end
    end
    return self
end
function BuildGen:setFluidBurn(eff)
    if type(eff)=="function" then
        self.burns_fluid = eff
    elseif type(eff)=="boolean" then
        self.burns_fluid = function(levels,grade) return eff end
    elseif eff==nil then
        self.burns_fluid = function(levels,grade) return true end
    end
    return self
end
function BuildGen:setReplace(group)
    if type(group) == "function" then
        self.fast_replaceable_group = group
    else
        self.fast_replaceable_group = function(levels,grade) return group end
    end
    return self
end
function BuildGen:setHealth(h)
    if type(h) == "function" then
        self.health = h
    else
        self.health = function(levels,grade) return h end
    end
    return self
end
function BuildGen:setSize(h,prop)
    if type(h) == "function" then
        self.size = h
    elseif type(h)=="number" then
        self.size = function(levels,grade) return {width = h/2, height = (prop or h)/2} end
    elseif type(h)=="table" then
        self.size = function(levels,grade) return {height = h[2] or h.height, width = h[1] or h.height or h[1] or h.width} end
    end
    return self
end
function BuildGen:setModSlots(h)
    if type(h) == "function" then
        self.module.slots = h
    else
        self.module.slots = function(levels,grade) return math.floor(h) end
    end
    return self
end
function BuildGen:setModEffects(h)
    if type(h)=="string" then
        self.module.effects = function(levels,grade) return {h} end
    elseif type(h) == "table" then
        self.module.effects = function(levels,grade) return h end
    else
        self.module.effects = function(levels,grade) return h end
    end
    return self
end
function BuildGen:setSpeed(h)
    if type(h) == "function" then
        self.crafting_speed = h
    else
        self.crafting_speed = function(levels,grade) return h end
    end
    return self
end
function BuildGen:setInventory(h)
    self.source_inventory_size = h
    self.ingredient_count = h
    return self
end
function BuildGen:setResultInventory(h)
    self.result_inventory_size = h
    self.result_count = h
    return self
end
function BuildGen:setBurner(efficiency,size)
    self.energy_source = {
        type = "burner",
        effectivity = efficiency or 0.5,
        fuel_inventory_size = size or 1,
        emissions_per_minute = 1.0,
        smoke =
        {
            {
            name = "smoke",
            deviation = {0.1, 0.1},
            frequency = 5,
            position = {1.0, -0.8},
            starting_vertical_speed = 0.08,
            starting_frame_deviation = 60
            }
        }}
    self:addBurnerIcon()
    self:setModSlots(0)
    return self
end
function BuildGen:setSteam(efficiency,size)
    -- Taken from Bob's steam assembling machine, might be a prereq...
    self.energy_source =
    {
        type = "fluid",
        effectivity = 1,
        emissions_per_minute = 10, --fairly sure this scales, so it would be 2 at level 1 speed.
        fluid_box =
        {
            base_area = 1,
            height = 2,
            base_level = -1,
            pipe_connections =
            {
                {type = "input-output", position = { 2, 0}},
                {type = "input-output", position = {-2, 0}}
            },
            pipe_covers = pipecoverspictures(),
            pipe_picture = assembler2pipepictures(),
            production_type = "input-output",
            filter = "steam"
        },
        burns_fluid = false,
        scale_fluid_usage = false,
        fluid_usage_per_tick = (2/60),
        maximum_temperature = 765,
        smoke =
        {
            {
                name = "light-smoke",
                frequency = 10 / 32,
                starting_vertical_speed = 0.08,
                slow_down_factor = 1,
                starting_frame_deviation = 60
            }
        }
    }
    self:addSteamIcon()
    return self
end
function BuildGen:setFuelCategories(cat)
    if type(cat)== "table" then
        self.fuel_categories = cat
    else
        self.fuel_categories = {cat or "chemical"}
    end
    return self
end
function BuildGen:setEnergySupply()
    self.energy_source = {
        type = "electric",
        usage_priority = "secondary-output"
    }
    return self
end

function BuildGen:setEmissions(em)
    self.energy_source.emissions_per_minute = em
    return self
end

function BuildGen:setEnergySource(eff)
    self.energy_source = table.deepcopy(eff)
    return self
end

function BuildGen:setBurnEfficiency(eff)
    if type(eff) == "function" then
        self.energy_source.effectivity = eff
    else
        self.energy_source.effectivity = function(levels,grade) return eff end
    end
    return self
end
function BuildGen:setBurnSlots(slots)
    if type(slots) == "function" then
        self.energy_source.fuel_inventory_size = slots
    else
        self.energy_source.fuel_inventory_size = function(levels,grade) return slots end
    end
    return self
end
function BuildGen:addSmoke()
    self.smoke =
      {
        {
          name = "smoke",
          deviation = {0.1, 0.1},
          frequency = 5,
          position = {1.0, -0.8},
          starting_vertical_speed = 0.08,
          starting_frame_deviation = 60
        }
      }
    return self
end

function BuildGen:setUsage(operation)
    if type(operation)=="function" then
        self.energy_usage = operation
    elseif type(operation)=="string" then
        self.energy_usage = function(levels,grade) return operation end
    elseif type(operation)=="number" then
        self.energy_usage = function(levels,grade) return operation.."kW" end
    end
    return self
end

function BuildGen:setAnimation(e)
    if type(e)=="function" then
        self.animation = e
    else
        self.animation = function(levels,grade) return e end
    end
    return self
end
function BuildGen:setOffAnimation(e)
    if type(e)=="function" then
        self.off_animation = e
    else
        self.off_animation = function(levels,grade) return e end
    end
    return self
end
function BuildGen:setOnAnimation(e)
    if type(e)=="function" then
        self.on_animation = e
    else
        self.on_animation = function(levels,grade) return e end
    end
    return self
end
function BuildGen:setAnimations(e)
    if type(e)=="function" then
        self.animations = e
    else
        self.animations = function(levels,grade) return e end
    end
    return self
end
function BuildGen:setPictures(e)
    if type(e)=="function" then
        self.pictures = e
    else
        self.pictures = function(levels,grade) return e end
    end
    return self
end
function BuildGen:setDirectionAnimation(a,b)
    if type(a)=="function" then
        self.horizontal_animation = a
    else
        self.horizontal_animation = function(levels,grade) return a end
    end
    if type(b)=="function" then
        self.vertical_animation = b
    else
        self.vertical_animation = function(levels,grade) return b end
    end
    return self
end
function BuildGen:setVerticalAnimation(b)
    if type(b)=="function" then
        self.vertical_animation = b
    else
        self.vertical_animation = function(levels,grade) return b end
    end
    return self
end
function BuildGen:setHorizontalAnimation(a)
    if type(a)=="function" then
        self.horizontal_animation = a
    else
        self.horizontal_animation = function(levels,grade) return a end
    end
    return self
end
function BuildGen:setWorkVis(e)
    if type(e)=="function" then
        self.working_visualisations = e
    else
        self.working_visualisations = function(levels,grade) return e end
    end
    return self
end
function BuildGen:setSoundImpact(e)
    if type(e)=="string" then
        self.vehicle_impact_sound = { filename = e, volume = 0.65 }
    else
        self.vehicle_impact_sound = e
    end
    return self
end
function BuildGen:setSoundWorking(e,vol,mod)
    --String given, try to find an entity with that name to grab all properties, otherwise just set the filename
    if type(e) == "string" then
        local proto = omni.lib.find_entity_prototype(e)
        if proto and proto.working_sound then
            self.working_sound = function(levels,grade) return proto.working_sound end
        elseif e and (mod or self.mod) then
            if not self.working_sound then self.working_sound = function(levels,grade) return {} end end
            log(e)
            log(mod)
            log(self.mod)
            self.working_sound(0,0).sound = {filename="__"..(mod or self.mod).."__/sound/"..e..".ogg",volume = vol or 0.8}
        else
            self.working_sound = nil
        end
    elseif type(e) == "table" then
        self.working_sound = function(levels,grade) return e end
    elseif type(e) == "function" then
        self.working_sound = e
    else
        self.working_sound = nil
    end
    return self
end
function BuildGen:setSoundIdle(e,vol,mod)
    if type(e)=="string" then
        self.working_sound(0,0).idle_sound = {filename="__"..(mod or self.mod).."__/sound/"..e..".ogg",volume = vol or 0.6}
    elseif type(e) == "table" then
        self.working_sound(0,0).idle_sound = e
    elseif type(e) == "function" then
        self.working_sound(0,0).idle_sound = e
    else
        self.working_sound(0,0).idle_sound = nil
    end
    return self
end
function BuildGen:setSoundVolume(e)
    if type(e)~="function" then
        self.working_sound(0,0).apparent_volume = e or 1
    else
        self.working_sound(0,0).apparent_volume = e
    end
    return self
end
--Must come after the type decleration
--s: building bounding box by size, e.g. for a 3x3 building --> s = "XXX.XXX.XXX" (From left to right)
-- Fluidboxes can be added by replacing the corresponding "X" with a letter:
--input: A, W, S, D
--output: I, K, J, L
--in-out: F, T, H, G
--Depending on which side the fluidbox is added, the corresponding letters have to be used. E.g. on the North side the letters A, I and F are valid (East: W, K and T)...
function BuildGen:setFluidBox(s,hide,tmp)
    if type(s) == "table" then
        self.fluid_boxes = function(levels,grade) return s end
    elseif type(s)=="string" then
        self.fluid_boxes = function(levels,grade) return omni.lib.fluid_box_conversion(self.type,s,hide,tmp) end
        local spl = omni.lib.split(s,".")
        self:setSize(string.len(spl[1]),#spl)
    elseif type(s) == "function" then
        self.fluid_boxes=s
    end
    return self
end
function BuildGen:setFilter(filter,nr)
    local a = clone_function(self.fluid_boxes)
    local sb = "(1)."
    if nr then sb=nr.."." end
    self.fluid_boxes = function(levels,grade) return omni.lib.replaceValue(a(levels,grade),sb.."filter",filter) end
    return self
end
function BuildGen:setFluidInput(s)
    self.input_fluid_box = s
    return self
end
function BuildGen:setCorpse(s)
    if string.find(s,"remnants") then
        self.corpse = s
    else
        self.corpse = s.."-remnants"
    end
    return self
end
function BuildGen:setMiningSpeed(s)
    if type(s)=="number" then
        self.mining_speed = function(levels,grade) return s end
    elseif type(s)=="function" then
        self.mining_speed = s
    end
    return self
end
function BuildGen:setMiningPower(s)
    if type(s)=="number" then
        self.mining_power = function(levels,grade) return s end
    elseif type(s)=="function" then
        self.mining_power = s
    end
    return self
end
function BuildGen:setMiningRadius(s)
    if type(s)=="number" then
        self.resource_searching_radius = function(levels,grade) return s-0.01 end
    else
        self.resource_searching_radius = function(levels,grade) return s(levels,grade)-0.1 end
    end
    return self
end
function BuildGen:setMiningDiameter(s)
    if type(s)=="number" then
        self.resource_searching_radius = function(levels,grade) return s/2-0.01 end
    else
        self.resource_searching_radius = function(levels,grade) return s(levels,grade)/2-0.1 end
    end
    return self
end
function BuildGen:setPlaceShift(s)
    if type(s)=="function" then
        self.vector_to_place_result=s
    elseif type(s)=="table" then
        self.vector_to_place_result = function(levels,grade) return table.deepcopy(s) end
    else
        self.vector_to_place_result = function(levels,grade) return s end
    end
    return self
end
function BuildGen:setMiningTime(s)
    if type(s)=="function" then
        self.mining_time = s
    else
        self.mining_time = function(grade,levels) return s end
    end
    return self
end
function BuildGen:setCrafting(...)
    local arg = argTable({...})
    if type(arg)=="table" then
        self.crafting_categories = function(levels,grade) return arg end
    elseif type(arg)=="string" then
        self.crafting_categories = function(levels,grade) return {arg} end
    else
        self.crafting_categories = arg
    end
    return self
end

function BuildGen:generateBuilding()
    local size = self.size(0,0)
    local source = {}
    if self.energy_source then
        for name,f in pairs(self.energy_source) do
            if type(f)=="function" then
                source[name]=f(0,0)
            else
                source[name]=f
            end
        end
    end
    local craftcat = self.crafting_categories(0,0)
    if not craftcat and (self.type == "furnace" or self.type=="assembling-machine") then error(self.name.." does not have crafting categories assigned.") end
    if self.type == "furnace" or self.type=="assembling-machine" then
        for _,cat in pairs(craftcat) do
            if not data.raw["recipe-category"][cat] then
                data:extend({
                    {
                        type = "recipe-category",
                        name = cat,
                    }
                })
            end
        end
    end
    if self.type=="furnace" then
        self.source_inventory_size = self.source_inventory_size or 1
        self.result_inventory_size = self.source_result_size or 1
        self.ingredient_count = self.ingredient_count or 1
        self.result_count = self.result_count or 1
    end
    local lname = {"entity-name."..self.name}
    if self.loc_name(0,0) and type(self.loc_name(0,0))=="table" then
        lname = self.loc_name(0,0)
        if not (string.find(lname[1],".") and string.find(lname[1],"name")) then
            lname[1]="entity-name."..lname[1]
        end
    elseif self.loc_name(0,0) then
        lname = {"entity-name."..self.loc_name(0,0)}
    end
    if self.type=="lab" and self.inputs(0,0)==nil then error("labs require inputs for science packs, use 'setInputs' on "..self.name..".") end
    self.rtn[#self.rtn+1]= {
        type = self.type,
        name = self.name,
        icon_size = 32,
        order=self.order(0,0),
        localised_name = lname,
        localised_description = self.loc_desc(0,0), --self:setDescLocType("entity"),
        icons = self.icons(0,0),
        flags = self.flags,
        minable = {mining_time = self.mining_time(0,0), result = self.name},
        fast_replaceable_group = self.fast_replaceable_group(0,0),
        max_health = self.max_health(0,0),
        corpse = self.corpse,
        dying_explosion = "medium-explosion",
        collision_box = {{-size.width+0.3, -size.height+0.3}, {size.width-0.3, size.height-0.3}},
        selection_box = {{-size.width, -size.height}, {size.width, size.height}},
        module_specification =
        {
            module_slots = self.module.slots(0,0)
        },
        allowed_effects = self.module.effects(0,0),
        crafting_categories = craftcat,
        crafting_speed = self.crafting_speed(0,0),
        source_inventory_size = self.source_inventory_size,
        result_inventory_size = self.result_inventory_size,
        ingredient_count = self.ingredient_count,
        result_count = self.result_count,
        next_upgrade = self.next_upgrade(0,0),
        energy_source = source,
        smoke = self.smoke,
        energy_usage = self.energy_usage(0,0),
        animation =self.animation(0,0),
        animations =self.animations(0,0),
        pictures =self.pictures(0,0),
        working_visualisations = self.working_visualisations(0,0),
        vehicle_impact_sound =  self.vehicle_impact_sound,
        burns_fluid=self.burns_fluid(0,0),
        fluid_boxes = self.fluid_boxes(0,0),
        effectivity = self.effectivity(0,0),
        fluid_usage_per_tick = self.fluid_usage_per_tick(0,0),
        vertical_animation = self.vertical_animation(0,0),
        horizontal_animation = self.horizontal_animation(0,0),
        maximum_temperature = self.max_temperature(0,0),
        maximum_wire_distance = self.maximum_wire_distance(0,0),
        supply_area_distance = self.area(0,0),
        connection_points=self.connection_points(0,0),
        radius_visualisation_picture=self.radius_visualisation_picture(0,0),
        light=self.light(0,0),
        fluid_box = self.fluid_boxes(0,0),
        vector_to_place_result = self.vector_to_place_result(0,0),
        resource_searching_radius  = self.resource_searching_radius(0,0),
        mining_power = self.mining_power(0,0),
        mining_speed = self.mining_speed(0,0),
        resource_categories=self.resource_categories(0,0),
        inputs=self.inputs(0,0),
        off_animation=self.off_animation(0,0),
        on_animation=self.on_animation(0,0)
    }

    if self.fluid_boxes(0,0) and type(self.fluid_boxes(0,0))=="table" and type(self.fluid_boxes(0,0)[1])=="table" then self.rtn[#self.rtn].fluid_box = self.fluid_boxes(0,0)[1] end
    if self.fuel_categories and next(self.fuel_categories) then self.rtn[#self.rtn].energy_source.fuel_categories = self.fuel_categories end
    if self.working_sound and next(self.working_sound(0,0)) then self.rtn[#self.rtn].working_sound = self.working_sound(0,0) end
    if self.overlay.name then
        self.rtn[#self.rtn].animation.layers[#self.rtn[#self.rtn].animation.layers+1] = table.deepcopy(self.rtn[#self.rtn].animation.layers[1])
        self.rtn[#self.rtn].animation.layers[#self.rtn[#self.rtn].animation.layers].filename = "__"..self.mod.."__/graphics/entity/buildings/"..self.overlay.name..".png"
        self.rtn[#self.rtn].animation.layers[#self.rtn[#self.rtn].animation.layers].tint = omni.tint_level[self.overlay.level]
    end

    local stuff = RecGen:create(self.mod,self.name):
    setIngredients(self.ingredients):
    setResults({self.name, self.results(0,0,0)[1].amount or 1}):
    setIcons(self.icons(0,0)):
    setOrder(self.order(0,0)):
    setBuildProto(self.rtn[#self.rtn]):
    setEnergy(self.energy_required(0,0)):
    setCategory(self.category(0,0)):
    --setLocName(self.loc_name(0,0)):
    --setLocDesc(self.loc_desc(0,0)):
    setEnabled(self.enabled(0,0)):
    setMain(self.main_product(0,0)):
    setPlace(self.name):
    noTech(self.tech.noTech):
    setTechName(self.tech.name(0,0)):
    setTechUpgrade(self.tech.upgrade(0,0)):
    setTechCost(self.tech.cost(0,0)):
    setTechIcons(self.tech.icons(0,0)):
    setTechPacks(self.tech.packs(0,0)):
    setSubgroup(self.subgroup(0,0)):
    setTechTime(self.tech.time(0,0)):
    setTechLocName(self.tech.loc_name(0,0)):
    setTechLocDesc(self.tech.loc_desc(0,0)):
    setForce(self.force):
    setTechPrereq(self.tech.prerequisites(0,0)):
    return_array()
    for _, p in pairs(stuff) do
        self.rtn[#self.rtn+1] = table.deepcopy(p)
    end
end
function BuildGen:return_array()
    self:generateBuilding()
    return self.rtn
end
function BuildGen:extend()
    if self.requiredMods(0,0) and self.name then
        Omni.Gen.Build[self.name] = self
        data:extend(self:return_array())
    end
end
function BuildChain:create(mod,name)
    local b = RecChain:create(mod,name)
    return setmetatable(setBuildingParameters(b),BuildChain)
end
function BuildChain:find(name)
    if Omni.Chain.Build[name] then
        return Omni.Chain.Build[name]:setForce()
    else
        return BuildChain:create(name):setGenerationCondition(false)
    end
end
function BuildChain:setInitialBurner(efficiency,size)
    self.burner = {
        type = "burner",
        effectivity = efficiency or 0.5,
        fuel_inventory_size = size or 1,
        emissions_per_minute = 1.0,
        smoke =
        {
            {
                name = "smoke",
                deviation = {0.1, 0.1},
                frequency = 5,
                position = {1.0, -0.8},
                starting_vertical_speed = 0.08,
                starting_frame_deviation = 60
            }
        }
    }
    return setmetatable(setBuildingParameters(self),BuildChain)
end
function BuildChain:generate_building_chain()
    local levels = tonumber(self.levels)
    for i=1,levels do
        local tname = self.tech.name(levels,i) or self.name
        if not data.raw.technology[tname] then
            if self.tech.prefix then tname = self.tech.prefix.."-"..tname end
            if self.tech.suffix then tname = tname.."-"..self.tech.suffix end
        end

        local prevtname = nil
        if self.tech.name(levels,i) == self.tech.name(levels,i+1) then
            local d = 0
            local temptname = tname
            for j=i,2,-1 do
                if self.tech.name(levels,j) ~= self.tech.name(levels,j-1) then
                    d=j-1
                    break
                end
            end
            tname = temptname.."-"..i-d
            if i-d > 1 then prevtname = temptname.."-"..i-d-1 end
        end

        local nextname
        if i < levels then
            nextname = self.name.."-"..i+1
        else
            nextname = nil
        end

        --Must fix so this can adapt to fit normal and expensive
        local ingnorm,ingexp = self.ingredients(levels,i,0),self.ingredients(levels,i,1)
        if i>1 and not omni.lib.is_in_table(self.name.."-"..i,ingnorm) then ingnorm[#ingnorm+1]={name=self.name.."-"..i-1,amount=1,type="item"} end
        if i>1 and not omni.lib.is_in_table(self.name.."-"..i,ingexp) then ingexp[#ingexp+1]={name=self.name.."-"..i-1,amount=1,type="item"} end
        if i>1 and mods["omnimatter_marathon"] then omni.marathon.equalize(self.name.."-"..i-1,self.name.."-"..i) end

        local tprereq = self.tech.prerequisites(levels,i)
        if type(tprereq)=="string" then tprereq={tprereq} end
        if tprereq and #tprereq == 0 and not omni.lib.is_in_table(prevtname,tprereq) and i>1 then
            tprereq[#tprereq+1]=prevtname
        elseif i>1 and tprereq == nil then
            tprereq={prevtname}
        end
        local stuff = BuildGen:create(self.mod,self.name.."-"..i):
        setIngredients(function(levels,grade,dif) if dif==0 then return ingnorm else return ingexp end end):
        setResults(self.name.."-"..i):
        setPlace(self.name.."-"..i):
        setEnergy(self.energy_required(levels,i)):
        setUsage(self.energy_usage(levels,i)):
        setEmissions(self.energy_source.emissions_per_minute(levels,i)):
        setCrafting(self.category(levels,i)):
        setLocName(self.loc_name(levels,i)):
        addLocName(i):
        setLocDesc(self.loc_desc(levels,i)):
        setSubgroup(self.subgroup(levels,i)):
        setMain(self.main_product(levels,i)):
        setIcons(self.icons(levels,i)):
        addIconLevel(i):
        setSize(function(levels,grade) return self.size(self.levels,i) end):
        setTechName(tname):
        setReplace(self.fast_replaceable_group(levels,i)):
        setNextUpgrade(function(levels,grade) return nextname end):
        setTechUpgrade(self.tech.upgrade(levels,i)):
        setTechCost(self.tech.cost(levels,i)):
        setTechIcons(self.tech.icons(levels,i)):
        setEnabled(self.enabled(levels,i)):
        setTechPacks(self.tech.packs(levels,i)):
        setTechTime(self.tech.time(levels,i)):
        setTechLocName(self.tech.loc_name(levels,i)):
        setTechPrereq(tprereq):
        setOverlay(self.overlay.name,i+1):
        setCrafting(self.crafting_categories(levels,i)):
        setFluidBox(self.fluid_boxes):
        setFluidBurn(self.burns_fluid(levels,i)):
        setSpeed(self.crafting_speed(levels,i)):
        setSoundWorking(self.working_sound(levels,i)):
        setAnimation(self.animation(levels,i)):
        setAnimations(self.animations(levels,i)):
        setWorkVis(self.working_visualisations(levels,i)):
        setGenerationCondition(self.requiredMods(levels,i)):
        setEffectivity(self.effectivity(levels,i)):
        setFluidConsumption(self.fluid_usage_per_tick(levels,i)):
        setEffects(self.module.effects(levels,i)):
        setHorizontalAnimation(self.horizontal_animation(levels,i)):
        setVerticalAnimation(self.vertical_animation(levels,i)):
        setMaxTemp(self.max_temperature(levels,i)):
        setWireDistance(self.maximum_wire_distance(levels,i)):
        setArea(self.area(levels,i)):
        setConnectionPoints(self.connection_points(levels,i)):
        setRadVisPic(self.radius_visualisation_picture(levels,i)):
        setLight(self.light(levels,i)):
        setPlaceShift(self.vector_to_place_result(levels,i)):
        setSearchRadius(self.resource_searching_radius(levels,i)):
        setMiningPower(self.mining_power(levels,i)):
        setMiningSpeed(self.mining_speed(levels,i)):
        setResourceCategory(self.resource_categories(levels,i)):
        setInputs(self.inputs(levels,i)):
        setOffAnimation(self.off_animation(levels,i)):
        setOnAnimation(self.on_animation(levels,i))

        if self.tech.loc_name(levels,i) then
            stuff:addTechLocName(i)
        end

        for _,m in pairs(stuff:return_array()) do
            self.rtn[#self.rtn+1]=table.deepcopy(m)
        end
    end
end



function BuildGen:setOverlay(n,l)
    if n then
        self.overlay={name = n, level = l}
    end
    return self
end
function BuildChain:return_array()
    self:generate_building_chain()
    return self.rtn
end
function BuildChain:extend()
    if self.requiredMods(0,0) then
    Omni.Chain.Build[self.name]=self
        self:return_array()
        data:extend(self.rtn)
    end
end

function BotGen:create(mod,name)
    local b = BuildGen:create(mod,name)
    b.max_payload_size = function(levels,grade) return 1 end
    b.speed = function(levels,grade) return 1 end
    b.max_energy = function(levels,grade) return "1MJ" end
    b.energy_per_tick = function(levels,grade) return "0.075kJ" end
    b.speed_multiplier_when_out_of_energy = function(levels,grade) return 0.5 end
    b.energy_per_move = function(levels,grade) return "7.5kJ" end
    b.min_to_charge = function(levels,grade) return 0.4 end
    b.max_to_charge = function(levels,grade) return 0.95 end
    b.working_light = function(levels,grade) return {intensity = 0.8, size = 3} end
    b.smoke = function(levels,grade) return {
      filename = "__base__/graphics/entity/smoke-construction/smoke-01.png",
      width = 39,
      height = 32,
      frame_count = 19,
      line_length = 19,
      shift = {0.078125, -0.15625},
      animation_speed = 0.3,
    } end
    b.sparks = function(levels,grade) return {
      {
        filename = "__base__/graphics/entity/sparks/sparks-01.png",
        width = 39,
        height = 34,
        frame_count = 19,
        line_length = 19,
        shift = {-0.109375, 0.3125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-02.png",
        width = 36,
        height = 32,
        frame_count = 19,
        line_length = 19,
        shift = {0.03125, 0.125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-03.png",
        width = 42,
        height = 29,
        frame_count = 19,
        line_length = 19,
        shift = {-0.0625, 0.203125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-04.png",
        width = 40,
        height = 35,
        frame_count = 19,
        line_length = 19,
        shift = {-0.0625, 0.234375},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-05.png",
        width = 39,
        height = 29,
        frame_count = 19,
        line_length = 19,
        shift = {-0.109375, 0.171875},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-06.png",
        width = 44,
        height = 36,
        frame_count = 19,
        line_length = 19,
        shift = {0.03125, 0.3125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3,
      },
    } end
    b.idle = function(levels,grade) return {
      filename = "__base__/graphics/entity/construction-robot/construction-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      hr_version = {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0,-4.5),
        direction_count = 16,
        scale = 0.5
      }
    } end
    b.shadow_idle = function(levels,grade) return {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version = {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    } end
    b.in_motion = function(levels,grade) return {
      filename = "__base__/graphics/entity/construction-robot/construction-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      y = 36,
      hr_version = {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0, -4.5),
        direction_count = 16,
        y = 76,
        scale = 0.5
      }
    } end
    b.shadow_in_motion = function(levels,grade) return {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version = {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    } end
    b.working = function(levels,grade) return {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-working.png",
      priority = "high",
      line_length = 2,
      width = 28,
      height = 36,
      frame_count = 2,
      shift = {0, -0.15625},
      direction_count = 16,
      animation_speed = 0.3,
      hr_version = {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-working.png",
        priority = "high",
        line_length = 2,
        width = 57,
        height = 74,
        frame_count = 2,
        shift = util.by_pixel(-0.25, -5),
        direction_count = 16,
        animation_speed = 0.3,
        scale = 0.5
      }
    } end
    b.shadow_working = function(levels,grade) return {
      stripes = util.multiplystripes(2,
      {
        {
          filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
          width_in_frames = 16,
          height_in_frames = 1,
        }
      }),
      priority = "high",
      width = 50,
      height = 24,
      frame_count = 2,
      shift = {1.09375, 0.59375},
      direction_count = 16
    } end
    --b.working_sound = function(levels,grade) return flying_robot_sounds() end
    b.cargo_centered = function(levels,grade) return {0.0, 0.2} end
    b.construction_vector = function(levels,grade) return {0.30, 0.22} end
    return setmetatable(b,BotGen)
end
function BotGen:setAllAnimation(n)
    if type(n)=="function" then
        self.energy_per_tick = n
    elseif type(n)=="number" then
        self.energy_per_tick = function(levels,grade) return n.."J" end
    elseif type(n)=="string" then
        self.energy_per_tick = function(levels,grade) return n end
    end
    return self
end
function BotGen:setTickEnergy(n)
    if type(n)=="function" then
        self.energy_per_tick = n
    elseif type(n)=="number" then
        self.energy_per_tick = function(levels,grade) return n.."J" end
    elseif type(n)=="string" then
        self.energy_per_tick = function(levels,grade) return n end
    end
    return self
end
function BotGen:setChargeLevels(mini,maxi)
    if type(mini)=="function" then
        self.min_to_charge = mini
    else
        self.min_to_charge = function(levels,grade) return mini end
    end
    if type(maxi)=="function" then
        self.max_to_charge = maxi
    else
        self.max_to_charge = function(levels,grade) return maxi end
    end
    return self
end
function BotGen:setPowerPenalty(n)
    if type(n)=="function" then
        self.speed_multiplier_when_out_of_energy = n
    else
        self.speed_multiplier_when_out_of_energy = function(levels,grade) return n end
    end
    return self
end
function BotGen:setPayload(n)
    if type(n)=="function" then
        self.max_payload_size = n
    else
        self.max_payload_size = function(levels,grade) return n end
    end
    return self
end
function BotGen:setMaxEnergy(n)
    if type(n)=="function" then
        self.max_energy = n
    elseif type(n)=="number" then
        self.max_energy = function(levels,grade) return n.."MJ" end
    elseif type(n)=="string" then
        self.max_energy = function(levels,grade) return n end
    end
    return self
end

function InsertGen:create(mod,name)
    local b = BuildGen:create(mod,name)
    b.type="inserter"
    b.energy_source = {
      type = "electric",
      usage_priority = "secondary-output"
    }
    b.fast_replaceable_group = function(levels,grade) return "inserter" end
    b.next_upgrade = function(levels,grade) return nil end
    b.max_health = function(levels,grade) return 150 end
    b.mining_time = function(levels,grade) return 0.1 end
    b.flags={"placeable-neutral", "placeable-player", "player-creation"}
    b.size = function(levels,grade) return {width = 0.4, height = 0.4} end
    b.filter_count = function(levels,grade) return nil end
    b.energy_usage = function(levels,grade) return {energy_per_movement = "5kJ",energy_per_rotation = "5kJ"} end
    b.speed = function(levels,grade) return {extension_speed = 0.03, rotation_speed = 0.014,} end
    b.working_sound = function(levels,grade) return {
      match_progress_to_activity = true,
      sound =
      {
        {
          filename = "__base__/sound/inserter-basic-1.ogg",
          volume = 0.3
        },
        {
          filename = "__base__/sound/inserter-basic-2.ogg",
          volume = 0.3
        },
        {
          filename = "__base__/sound/inserter-basic-3.ogg",
          volume = 0.3
        },
        {
          filename = "__base__/sound/inserter-basic-4.ogg",
          volume = 0.3
        },
        {
          filename = "__base__/sound/inserter-basic-5.ogg",
          volume = 0.3
        }
      }
    } end

    b.pickup_position = function(levels,grade) return {0, -1} end
    b.insert_position = function(levels,grade) return {0, 1.2} end
    b.hand_base_picture =function(levels,grade) return {
      filename = "__base__/graphics/entity/inserter/inserter-hand-base.png",
      priority = "extra-high",
      width = 8,
      height = 33,
      hr_version =
      {
        filename = "__base__/graphics/entity/inserter/hr-inserter-hand-base.png",
        priority = "extra-high",
        width = 32,
        height = 136,
        scale = 0.25
      }
    } end
    b.hand_closed_picture =function(levels,grade) return
    {
      filename = "__base__/graphics/entity/inserter/inserter-hand-closed.png",
      priority = "extra-high",
      width = 18,
      height = 41,
      hr_version =
      {
        filename = "__base__/graphics/entity/inserter/hr-inserter-hand-closed.png",
        priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
      }
    } end
    b.hand_open_picture = function(levels,grade) return
    {
      filename = "__base__/graphics/entity/inserter/inserter-hand-open.png",
      priority = "extra-high",
      width = 18,
      height = 41,
      hr_version =
      {
        filename = "__base__/graphics/entity/inserter/hr-inserter-hand-open.png",
        priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
      }
    } end
    b.hand_base_shadow = function(levels,grade) return
    {
      filename = "__base__/graphics/entity/burner-inserter/burner-inserter-hand-base-shadow.png",
      priority = "extra-high",
      width = 8,
      height = 33,
      hr_version =
      {
        filename = "__base__/graphics/entity/burner-inserter/hr-burner-inserter-hand-base-shadow.png",
        priority = "extra-high",
        width = 32,
        height = 132,
        scale = 0.25
      }
    } end
    b.hand_closed_shadow = function(levels,grade) return
    {
      filename = "__base__/graphics/entity/burner-inserter/burner-inserter-hand-closed-shadow.png",
      priority = "extra-high",
      width = 18,
      height = 41,
      hr_version =
      {
        filename = "__base__/graphics/entity/burner-inserter/hr-burner-inserter-hand-closed-shadow.png",
        priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
      }
    } end
    b.hand_open_shadow = function(levels,grade) return
    {
      filename = "__base__/graphics/entity/burner-inserter/burner-inserter-hand-open-shadow.png",
      priority = "extra-high",
      width = 18,
      height = 41,
      hr_version =
      {
        filename = "__base__/graphics/entity/burner-inserter/hr-burner-inserter-hand-open-shadow.png",
        priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
      }
    } end
    b.platform_picture = function(levels,grade) return
    {
      sheet =
      {
        filename = "__base__/graphics/entity/inserter/inserter-platform.png",
        priority = "extra-high",
        width = 46,
        height = 46,
        shift = {0.09375, 0},
        hr_version =
        {
          filename = "__base__/graphics/entity/inserter/hr-inserter-platform.png",
          priority = "extra-high",
          width = 105,
          height = 79,
          shift = util.by_pixel(1.5, 7.5-1),
          scale = 0.5
        }
      }
    } end
    return setmetatable(b,InsertGen)
end
function InsertGen:setUsage(movement, rotation)
    if type(movement)=="function" then
        self.energy_usage = movement
        return self
    end
    local moveEnergy,rotEnergy
    if type(movement)=="string" then
        moveEnergy = movement
    elseif type(movement)=="number" then
        moveEnergy = movement.."kJ"
    end
    if type(rotation)=="string" then
        rotEnergy = rotation
    elseif type(rotation)=="number" then
        rotEnergy = rotation.."kJ"
    end
    self.energy_usage = function(levels,grade) return {energy_per_movement = moveEnergy,energy_per_rotation = rotEnergy} end
    return self
end
function InsertGen:setSpeed(extension,rotation)
    if type(extension) == "function" then
        self.speed = extension
        return self
    end
    local extSpeed,rotEnergy
    if type(extension)=="string" then
        extSpeed = extension
    elseif type(extension)=="number" then
        extSpeed = extension
    end
    if type(rotation)=="string" then
        rotEnergy = rotation
    elseif type(rotation)=="number" then
        rotEnergy = rotation
    end
    self.speed = function(levels,grade) return {extension_speed = extSpeed,rotation_speed = rotEnergy} end
    return self
end
function InsertGen:setPickupPos(p)
    if type(p)=="function" then
        self.pickup_position=p
    else
        self.pickup_position = function(levels,grade) return p end
    end
    return self
end
function InsertGen:setInsertPos(p)
    if type(p)=="function" then
        self.insert_position=p
    else
        self.insert_position = function(levels,grade) return p end
    end
    return self
end
function InsertGen:setFilter(c)
    if type(c)=="function" then
        self.filter_count = c
    elseif type(c)=="number" then
        self.filter_count = function(levels,grade) return c end
    end
    return self
end
function InsertGen:setAnimation(platform,base,baseShadow,open,openShadow,closed,closedShadow)
    if platform and type(platform)=="string" and not base and not baseShadow and not open and not openShadow and not closed and not closedShadow then
        base=platform
        baseShadow=platform
        open = platform
        openShadow=platform
        closed=platform
        closedShadow=platform
    end
    if type(platform)=="function" then
        self.platform_picture=platform
    elseif type(platform)=="table" then
        self.platform_picture = function(levels,grade) return platform end
    elseif type(platform)=="string" then
        self.platform_picture = function(levels,grade) return {
        sheet = {
          filename = "__"..self.mod.."__/graphics/entity/inserter/"..platform.."-platform.png",
          priority = "extra-high",
          width = 46,
          height = 46,
          shift = {0.09375, 0},
          hr_version = {
            filename = "__"..self.mod.."__/graphics/entity/inserter/hr-"..platform.."-platform.png",
            priority = "extra-high",
            width = 105,
            height = 79,
            shift = util.by_pixel(1.5, 7.5-1),
            scale = 0.5
          }
        }
      } end
    end
    if type(base)=="function" then
        self.hand_base_picture=base
    elseif type(base)=="table" then
        self.hand_base_picture = function(levels,grade) return base end
    elseif type(base)=="string" then
        self.hand_base_picture = function(levels,grade) return {
        filename = "__"..self.mod.."__/graphics/entity/inserter/"..base.."-hand-base.png",
        priority = "extra-high",
        width = 8,
        height = 33,
        hr_version =
        {
          filename = "__"..self.mod.."__/graphics/entity/inserter/hr-"..base.."-hand-base.png",
          priority = "extra-high",
        width = 32,
        height = 136,
        scale = 0.25
        }
      } end
    end
    if type(baseShadow)=="function" then
        self.hand_base_shadow=baseShadow
    elseif type(baseShadow)=="table" then
        self.hand_base_shadow = function(levels,grade) return baseShadow end
    elseif type(baseShadow)=="string" then
        self.hand_base_shadow = function(levels,grade) return {
        filename = "__"..self.mod.."__/graphics/entity/inserter/"..baseShadow.."-hand-base-shadow.png",
        priority = "extra-high",
        width = 8,
        height = 33,
        hr_version =
        {
          filename = "__"..self.mod.."__/graphics/entity/inserter/hr-"..baseShadow.."-hand-base-shadow.png",
          priority = "extra-high",
        width = 32,
        height = 132,
        scale = 0.25
        }
      } end
    end
    if type(open)=="function" then
        self.hand_open_picture=open
    elseif type(open)=="table" then
        self.hand_open_picture = function(levels,grade) return open end
    elseif type(open)=="string" then
        self.hand_open_picture = function(levels,grade) return {
        filename = "__"..self.mod.."__/graphics/entity/inserter/"..open.."-hand-open.png",
        priority = "extra-high",
      width = 18,
      height = 41,
        hr_version =
        {
          filename = "__"..self.mod.."__/graphics/entity/inserter/hr-"..open.."-hand-open.png",
          priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
        }
      } end
    end
    if type(openShadow)=="function" then
        self.hand_open_shadow=openShadow
    elseif type(openShadow)=="table" then
        self.hand_open_shadow = function(levels,grade) return openShadow end
    elseif type(openShadow)=="string" then
        self.hand_open_shadow = function(levels,grade) return {
        filename = "__"..self.mod.."__/graphics/entity/inserter/"..openShadow.."-hand-open-shadow.png",
        priority = "extra-high",
      width = 18,
      height = 41,
        hr_version =
        {
          filename = "__"..self.mod.."__/graphics/entity/inserter/hr-"..openShadow.."-hand-open-shadow.png",
          priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
        }
      } end
    end
    if type(closed)=="function" then
        self.hand_closed_picture=closed
    elseif type(closed)=="table" then
        self.hand_closed_picture = function(levels,grade) return closed end
    elseif type(closed)=="string" then
        self.hand_closed_picture = function(levels,grade) return {
        filename = "__"..self.mod.."__/graphics/entity/inserter/"..closed.."-hand-closed.png",
        priority = "extra-high",
      width = 18,
      height = 41,
        hr_version =
        {
          filename = "__"..self.mod.."__/graphics/entity/inserter/hr-"..closed.."-hand-closed.png",
          priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
        }
      } end
    end
    if type(closedShadow)=="function" then
        self.hand_closed_shadow=closedShadow
    elseif type(closedShadow)=="table" then
        self.hand_closed_shadow = function(levels,grade) return closedShadow end
    elseif type(closedShadow)=="string" then
        self.hand_closed_shadow = function(levels,grade) return
      {
        filename = "__"..self.mod.."__/graphics/entity/inserter/"..closedShadow.."-hand-closed-shadow.png",
        priority = "extra-high",
      width = 18,
      height = 41,
        hr_version =
        {
          filename = "__"..self.mod.."__/graphics/entity/inserter/hr-"..closedShadow.."-hand-closed-shadow.png",
          priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
        }
      } end
    end
    return self
end
function InsertGen:generateInserter()
    self.rtn={}
    local source = {}
    if self.energy_source then
        for name,f in pairs(self.energy_source) do
            if type(f)=="function" then
                source[name]=f(0,0)
            else
                source[name]=f
            end
        end
    end
    local size = self.size(0,0)
    self.rtn[#self.rtn+1]={
    type = "inserter",
    name = self.name,
    icons = self.icons(0,0),
    icon_size = 32,
    filter_count=self.filter_count(0,0),
    flags = self.flags,
    minable = {mining_time = self.mining_time(0,0), result = self.name},
    fast_replaceable_group = self.fast_replaceable_group(0,0),
    next_upgrade = self.next_upgrade(0,0),
    max_health = self.max_health(0,0),
    corpse = self.corpse,
    resistances =
    {
      {
        type = "fire",
        percent = 90
      }
    },
    collision_box = {{-size.width+0.25, -size.height+0.25}, {size.width-0.25, size.height-0.25}},
    selection_box = {{-size.width, -size.height}, {size.width, size.height}},
    --collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    --selection_box = {{-0.4, -0.35}, {0.4, 0.45}},
    energy_per_movement = self.energy_usage(0,0).energy_per_movement,
    energy_per_rotation = self.energy_usage(0,0).energy_per_rotation,
    energy_source =source,
    extension_speed = self.speed(0,0).extension_speed,
    rotation_speed = self.speed(0,0).rotation_speed,
    pickup_position = {0, -1},
    insert_position = {0, 1.2},
    --next_upgrade = "fast-inserter",
    vehicle_impact_sound =  self.vehicle_impact_sound,
    working_sound =
    {
      match_progress_to_activity = true,
      sound =
      {
        {
          filename = "__base__/sound/inserter-basic-1.ogg",
          volume = 0.3
        },
        {
          filename = "__base__/sound/inserter-basic-2.ogg",
          volume = 0.3
        },
        {
          filename = "__base__/sound/inserter-basic-3.ogg",
          volume = 0.3
        },
        {
          filename = "__base__/sound/inserter-basic-4.ogg",
          volume = 0.3
        },
        {
          filename = "__base__/sound/inserter-basic-5.ogg",
          volume = 0.3
        }
      }
    },
    hand_base_picture = self.hand_base_picture(0,0),
    hand_closed_picture = self.hand_closed_picture(0,0),
    hand_open_picture = self.hand_open_picture(0,0),
    hand_base_shadow = self.hand_base_shadow(),
    hand_closed_shadow = self.hand_closed_shadow(0,0),
    hand_open_shadow = self.hand_open_shadow(0,0),
    platform_picture = self.platform_picture(0,0),
    circuit_wire_connection_points = circuit_connector_definitions["inserter"].points,
    circuit_connector_sprites = circuit_connector_definitions["inserter"].sprites,
    circuit_wire_max_distance = inserter_circuit_wire_max_distance,
    default_stack_control_input_signal = inserter_default_stack_control_input_signal
  }
  if self.fuel_categories and next(self.fuel_categories) then self.rtn[#self.rtn].energy_source.fuel_categories = self.fuel_categories end

    local stuff = RecGen:create(self.mod,self.name):
    setIngredients(self.ingredients):
    setResults(self.name):
    setIcons(self.icons(0,0)):
    setBuildProto(self.rtn[#self.rtn]):
    setEnergy(self.energy_required(0,0)):
    setCategory(self.category(0,0)):
    --setLocName(self.loc_name(0,0)):
    --setLocDesc(self.loc_desc(0,0)):
    setEnabled(self.enabled(0,0)):
    setMain(self.main_product(0,0)):
    setPlace(self.name):
    noTech(self.tech.noTech):
    setTechName(self.tech.name(0,0)):
    setTechUpgrade(self.tech.upgrade(0,0)):
    setTechCost(self.tech.cost(0,0)):
    setTechIcons(self.tech.icons(0,0)):
    setTechPacks(self.tech.packs(0,0)):
    setSubgroup(self.subgroup(0,0)):
    setOrder(self.order(0,0)):
    setTechTime(self.tech.time(0,0)):
    setTechLocName(self.tech.loc_name(0,0)):
    setTechLocDesc(self.tech.loc_desc(0,0)):
    setForce(self.force):
    setTechPrereq(self.tech.prerequisites(0,0)):return_array()
    for _, p in pairs(stuff) do
        self.rtn[#self.rtn+1] = table.deepcopy(p)
    end
end
function InsertGen:return_array()
    self:generateInserter()
    return self.rtn
end
function InsertGen:extend()
    if self.requiredMods(0,0) then
        data:extend(self:return_array())
    end
end
--[[
platform_picture
hand_open_shadow
hand_closed_shadow
hand_base_shadow
hand_open_picture
hand_closed_picture
hand_base_picture
--[[{
    corpse = "small-remnants",
    resistances =
    {
      {
        type = "fire",
        percent = 90
      }
    },

  }

  --[[
    circuit_wire_connection_points = circuit_connector_definitions["inserter"].points,
    circuit_connector_sprites = circuit_connector_definitions["inserter"].sprites,
    circuit_wire_max_distance = inserter_circuit_wire_max_distance,
    default_stack_control_input_signal = inserter_default_stack_control_input_signal]]
--[[
{
    autoplace =
    {
      control = "omnite",
      sharpness = 1,
      richness_multiplier = 2000,
      richness_multiplier_distance_bonus = 15,
      richness_base = 1000,
      coverage = 0.03,
      peaks =
      {
        {
          noise_layer = "omnite",
          noise_octaves_difference = -1.5,
          noise_persistence = 0.3,
        },
      },
      starting_area_size = 600 * 0.01,
      starting_area_amount = 1000
    },
    stage_counts = {1000, 600, 400, 200, 100, 50, 20, 1},
    stages =
    {
      sheet =
      {
        filename = "__omnimatter__/graphics/entity/ores/omnite.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 8,
        variation_count = 8,
        hr_version = {
          filename = "__omnimatter__/graphics/entity/ores/hr-omnite.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5
        }
      }
    },
    stages_effect =
    {
      sheet =
      {
        filename = "__omnimatter__/graphics/entity/ores/omnite-glow.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 8,
        variation_count = 8,
        blend_mode = "additive",
        flags = {"light"},
        hr_version = {
          filename = "__omnimatter__/graphics/entity/ores/hr-omnite-glow.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5,
          blend_mode = "additive",
          flags = {"light"},
        }
      }
    },
    effect_animation_period = 5,
    effect_animation_period_deviation = 1,
    effect_darkness_multiplier = 3.6,
    min_effect_alpha = 0.2,
    max_effect_alpha = 0.3,
    map_color = {r=0.34, g=0.00, b=0.51},
  }

]]

--[[
    1: Make it so particles are generated if its a table but just grabs if its a string.
]]

--[[
setTechUpgrade(value)
setTechCost(cost)
setTechIcons(mod,icon)
setTechPacks(cost)
setTechTime(t)
setTechPrereq(prereq)
function BuildGen:()

end
]]