omni.fluid.forbidden_boilers = {}
omni.fluid.forbidden_assembler = {}
omni.fluid.forbidden_recipe = {}
omni.fluid.excluded_strings = {{"empty","barrel"},{"fill","barrel"},{"fluid","unknown"},"barreling-pump","creative"}

function omni.fluid.excempt_boiler(boiler)
    omni.fluid.forbidden_boilers[boiler]=true
end

function omni.fluid.excempt_assembler(boiler)
    omni.fluid.forbidden_assembler[boiler]=true
end

function omni.fluid.excempt_recipe(boiler)
    omni.fluid.forbidden_recipe[boiler]=true
end
local fluid_solid = {}

function omni.fluid.convert_mj(value)
    local unit = string.sub(value,string.len(value)-1,string.len(value)-1)
    local val = tonumber(string.sub(value,1,string.len(value)-2))
    if unit == "K" or unit == "k" then
        return val/1000
    elseif unit == "M" then
        return val
    elseif unit=="G" then
        return val*1000
    elseif tonumber(unit) ~= nil then
        return tonumber(string.sub(value,1,string.len(value)-1))
    end
end

function omni.fluid.check_string_excluded(comparison) --checks fluid/recipe name against exclusion list
    for _, str in pairs(omni.fluid.excluded_strings) do
        --deal with multiple values (multi search)
        if type(str) == "table" then
            local check = table_size(str)
            for _,stringy in pairs(str) do
                if string.find(comparison,stringy) then
                    check=check-1
                end
            end
            if check == 0 or nil then
                return true
            end
        elseif string.find(comparison,str) then
            return true
        end
    end
    return false
end

function omni.fluid.has_fluid(recipe)
    for _,ingres in pairs({"ingredients","results"}) do
        for _,component in pairs(recipe.normal[ingres]) do
            if component.type == "fluid" then return true end
        end
    end
    return false
end

function omni.fluid.SetRoundFluidValues()
    local top_value = 500000
    local roundFluidValues = {}
    local b,c,d = math.log(5),math.log(3),math.log(2)
    for i=0,math.floor(math.log(top_value)/b) do
        local pow5 = math.pow(5,i)
        for j=0,math.floor(math.log(top_value/pow5)/c) do
            local pow3=math.pow(3,j)
            for k=0,math.floor(math.log(top_value/pow5/pow3)/d) do
                roundFluidValues[#roundFluidValues+1] = pow5*pow3*math.pow(2,k)
            end
        end
    end
    table.sort(roundFluidValues)
    return(roundFluidValues)
end

local roundFluidValues = omni.fluid.SetRoundFluidValues()
log(serpent.block(roundFluidValues))

function omni.fluid.round_fluid(nr,round)
    local t = omni.lib.round(nr)
    local newval = t
    for i=1, #roundFluidValues-1 do
        if roundFluidValues[i]< t and roundFluidValues[i+1]>t then
            if t-roundFluidValues[i] < roundFluidValues[i+1]-t then
                local c = 0
                if roundFluidValues[i] ~= t and round == 1 then c=1 end
                newval = roundFluidValues[i+c]
            else
                local c = 0
                if roundFluidValues[i+1] ~= t and round == -1 then c=-1 end
                newval = roundFluidValues[i+1+c]
            end
        end
    end
    return math.max(newval,1)
end

function omni.fluid.get_true_amount(subtable) --individual ingredient/result table
    local probability = subtable.probability or 1
    local amount = subtable.amount or (subtable.amount_min + subtable.amount_max)/2 or 0
    return amount * probability
end