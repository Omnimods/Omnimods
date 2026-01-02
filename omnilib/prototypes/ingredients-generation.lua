
BuildMat = {}
BuildMat.__index = BuildMat

component={}
-- ELECTRONICS
component["vanilla-circuit"]={"electronic-circuit","advanced-circuit","processing-unit"}
component["crystallonics"]={"basic-crystallonic","basic-oscillo-crystallonic"}
component["bob-circuit"]={"bob-basic-circuit-board","electronic-circuit","advanced-circuit","processing-unit","bob-advanced-processing-unit","bob-advanced-processing-unit"}
component["angels-comp-circuit"]={"circuit-grey","circuit-red-loaded","circuit-green-loaded","circuit-orange-loaded","circuit-blue-loaded","circuit-yellow-loaded"}
component["bob-crystallo-circuit"]=omni.lib.union(omni.lib.cutTable(component["bob-circuit"],3),component["crystallonics"])
component["vanilla-crystallo-circuit"]=omni.lib.union(omni.lib.cutTable(component["vanilla-circuit"],2),component["crystallonics"])
component["angels-crystallo-circuit"]=omni.lib.union(omni.lib.cutTable(component["angels-comp-circuit"],3),component["crystallonics"])
-- PIPES
component["vanilla-pipe"] = {"pipe"}
component["bob-logistics"] = {"bob-stone-pipe", "bob-copper-pipe", "pipe", "bob-steel-pipe", "bob-plastic-pipe"}
component["bob-pipe"] = {"bob-stone-pipe", "bob-copper-pipe", "pipe", "bob-bronze-pipe", "bob-brass-pipe", "bob-steel-pipe", "bob-plastic-pipe", "bob-ceramic-pipe", "bob-titanium-pipe", "bob-tungsten-pipe"}
-- PLATES
component["vanilla-plate"]={"copper-plate","iron-plate"}
component["bob-plate"]={"iron-plate", "copper-plate", "bob-tin-plate", "bob-lead-plate", "bob-silver-plate", "bob-zinc-plate", "bob-nickel-plate", "bob-cobalt-plate", "bob-gold-plate", "bob-aluminium-plate", "bob-tungsten-plate", "bob-titanium-plate"}
component["angel-plate"]={"copper-plate","iron-plate","angels-plate-manganese", "angels-plate-chrome", "angels-plate-platinum"}
component["angels-comp-plate"]={"copper-plate", "iron-plate", "steel-plate","angels-plate-aluminium", "angels-plate-titanium", "angels-plate-tungsten","angels-plate-chrome", "angels-plate-platinum"}
component["angel-bob-plate"]={"iron-plate", "copper-plate", "angels-plate-tin", "angels-plate-lead", "angels-plate-silver", "angels-plate-zinc", "angels-plate-nickel", "angels-plate-cobalt", "angels-plate-manganese", "angels-plate-gold", "angels-plate-aluminium", "angels-plate-tungste", "angels-plate-titanium", "angels-plate-chrome", "angels-plate-platinum"}
component["vanilla-omniplate"]= {"omnium-plate","omnium-iron-alloy","omnium-steel-alloy"}
component["omni-alloys"] = {"omnium-plate","omnium-iron-alloy","omnium-steel-alloy"}
component["omni-bob-alloys"] = {"omnium-plate","omnium-iron-alloy","omnium-steel-alloy", "omnium-aluminium-alloy", "omnium-tungsten-alloy"}
-- GEARS
component["vanilla-gear-wheel"] = {"iron-gear-wheel"}
component["bob-gear-wheel"] = {"iron-gear-wheel", "bob-steel-gear-wheel", "bob-brass-gear-wheel", "bob-cobalt-steel-gear-wheel", "bob-titanium-gear-wheel", "bob-tungsten-gear-wheel", "bob-nitinol-gear-wheel"}
component["angels-gear-wheel"] = {"angels-gear", "angels-axle", "angels-roller-chain", "angels-spring", "angels-bearing"}
component["vanilla-gear-box"]= {"omnium-iron-gear-box"}
component["bob-gear-box"] = {"omnium-iron-gear-box","omnium-bob-steel-gear-box","omnium-bob-brass-gear-box","omnium-bob-titanium-gear-box","omnium-bob-tungsten-gear-box","omnium-bob-itinol-gear-box"}
component["angels-gear-box"] = {"omnium-iron-gear-box","omnium-steel-gear-box","omnium-titanium-gear-box","omnium-tungsten-gear-box"}
component["bearing"]={"bob-steel-bearing", nil, "bob-cobalt-steel-bearing", "bob-titanium-bearing", "bob-nitinol-bearing", "bob-ceramic-bearing"}

--------------------------------------------------------------------------------------------------
-- Component list swapping logic -----------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--ELECTRONIC SWITCHES
if mods["angelsindustries"] and angelsmods.industries.components then    
    if mods["omnimatter_crystal"] then
        component["circuit"]=component["angels-crystallo-circuit"]
    else
        component["circuit"]=component["angels-comp-circuit"]
    end
elseif mods["bobelectronics"] then
    if mods["omnimatter_crystal"] then
        component["circuit"]=component["bob-crystallo-circuit"]
    else
        component["circuit"]=component["bob-circuit"]
    end
else
    if mods["omnimatter_crystal"] then
        component["circuit"]=component["vanilla-crystallo-circuit"]
    else
        component["circuit"]=component["vanilla-circuit"]
    end
end
--PIPE SWITCHES
if mods["boblogistics"] then
    if mods["bobplates"] then
        component["pipe"]=component["bob-pipe"]
    else
        component["pipe"]=component["bob-logistics"]
    end
else
    component["pipe"]=component["vanilla-pipe"]
end
--Gear SWITCHES
if mods["bobplates"] then
    component["gear-wheel"]=component["bob-gear-wheel"]
    component["gear-box"]=component["bob-gear-box"]
    component["omniplate"]=component["omni-bob-alloys"]
elseif mods["angelsindustries"] and angelsmods.industries.overhaul then
    if angelsmods.industries.components then
        component["gear-wheel"]=component["angels-gear-wheel"]
    else
        component["gear-wheel"]=component["vanilla-gear-wheel"]
    end
    component["gear-box"]=component["vanilla-gear-box"]--["angels-gear-box"] -- not functional as an angels list yet
    component["omniplate"]=component["vanilla-omniplate"]--["omni-bob-alloys"]-- not functional as an angels list yet
else
    component["gear-wheel"]=component["vanilla-gear-wheel"]
    component["gear-box"]=component["vanilla-gear-box"]
    component["omniplate"]=component["vanilla-omniplate"]
end
--PLATE SWITCHES
if mods["angelsindustries"] and angelsmods.industries.components then
    component["plates"]=component["angels-comp-plate"]
elseif mods["bobplates"] then
    if mods["angelssmelting"] then
        component["plates"]=component["angel-bob-plate"]
    else
        component["plates"]=component["bob-plate"]
    end
else
    if mods["angelssmelting"] then
        component["plates"]=component["angel-plate"]
    else
        component["plates"]=component["vanilla-plate"]
    end
end
--AUTO GROUP SWITCHES
local cmpn = {"vanilla-circuit","crystallonics","vanilla-gear-wheel","bob-gear-wheel","vanilla-gear-box","bob-gear-box","plate","bob-plate","angel-plate","angel-bob-plate","angels-gear-wheel","omni-bob-alloys",
"omni-plate","vanilla-pipe","bob-pipe","bob-logistics","bob-circuit","omni-alloys","bob-crystallo-circuit","vanilla-crystallo-circuit","angels-comp-circuit","angels-crystallo-circuit","angels-comp-plate"}

for _, c in pairs(cmpn) do
    --component[c]=setmetatable(component[c],BuildMat)
end

function OmniGen:building()
    self.type="building"
    return self
end
function OmniGen:addComponent(t)
    if type(t)=="string" then
        if component[t] then
            if self.comp then
                self.comp[#self.comp+1]=component[t]
            else
                self.comp={component[t]}
            end
        end
    elseif type(t)=="table" then
        for _,i in pairs(t) do
            if component[i] then
                if self.comp then
                    self.comp[#self.comp+1]=component[i]
                else
                    self.comp={component[i]}
                end
            end
        end
    end
    return self
end
function OmniGen:setMissConstant(c)
    if type(c)=="function" then
        self.miss = c
    elseif type(c)=="number" then
        self.miss=function(levels,grade) return c end
    end
    return self
end
function OmniGen:setQuant(kind,c,add)
    if not self.quant then self.quant = {} end
    if not self.comp then self.comp={kind} end
    if not omni.lib.is_in_table(kind,self.comp) then self.comp[#self.comp+1]=kind end
    self.shift[kind] = add
    if type(c)=="function" then
        self.quant[kind] = c
    elseif type(c)=="number" then
        self.quant[kind]=function(levels,grade) return c end
    elseif type(c)=="table" then
        self.quant[kind]=function(levels,grade) return c[grade] or c[#c] end
    end
    return self
end
function OmniGen:setPreRequirement(c)
    if type(c)=="table" then
        self.prereq = c
    elseif type(c)=="string" then
        self.prereq = {name=c,type="item",amount=1}
    end
    return self
end
function OmniGen:buildingCost()
    return function(levels,grade)
        local ing = {}
        if self.prereq and grade == 1 then
            ing[#ing+1]=self.prereq
        end
        for _, part in pairs(self.comp) do
            local amount = self.quant[part](levels,grade)
            for i=grade,1,-1 do
                if i+(self.shift[part] or 0) > 0 and component[part] and component[part][i+(self.shift[part] or 0)]~="" and component[part][i+(self.shift[part] or 0)]~=nil then
                    ing[#ing+1]={type="item",name=component[part][i+(self.shift[part] or 0)],amount=omni.lib.round(amount)}
                    break
                else
                    amount = self.miss(levels,grade)*amount
                end
            end
        end
        return ing
    end
end
