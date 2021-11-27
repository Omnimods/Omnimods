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

function omni.fluid.round_fluid(nr,round)
    local roundFluidValues = omni.fluid.SetRoundFluidValues()
    local t = omni.lib.round(nr)
    local newval = t
    for i=1,#roundFluidValues-1 do
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

function omni.fluid.has_fluid(recipe)
    for _,ingres in pairs({"ingredients","results"}) do
        for _,component in pairs(recipe.normal[ingres]) do
            if component.type == "fluid" then return true end
        end
    end
    return false
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

function omni.fluid.get_fluid_amount(subtable) --individual ingredient/result table
    -- amount min system
    -- "min-max" parses mininum, sets mm_prob as max/min
    -- "min-chance" parses minimum, sets mp_prob as min*prob
    -- "zero-max" parses maximum only
    -- "chance" parses average yield, sets prob as prob
    -- does this interferre with the GCD functionallity?
    if subtable.amount then
        if subtable.probability then --normal style, priority over previous step
            return omni.fluid.round_fluid((subtable.amount * subtable.probability) / omni.fluid.sluid_contain_fluid)
        else
            return omni.fluid.round_fluid(subtable.amount / omni.fluid.sluid_contain_fluid) --standard
        end
    elseif subtable.amount_min and subtable.amount_min > 0 then
        if subtable.amount_max then
            return omni.fluid.round_fluid((subtable.amount_max + subtable.amount_min) / (2 * omni.fluid.sluid_contain_fluid))
        elseif subtable.probability then
            return omni.fluid.round_fluid(subtable.amount_min * subtable.probability)
        end
    elseif subtable.amount_min and subtable.amount_min == 0 then
        if subtable.amount_max then
            return omni.fluid.round_fluid(subtable.amount_max / omni.fluid.sluid_contain_fluid)
        end
    elseif subtable.amount_max and subtable.amount_max > 0 then
        if subtable.probability then
            return omni.fluid.round_fluid(subtable.amount_max * subtable.probability)
        end
    end
    log("an error has occured with this ingredient, please find logs to find out why")
    log(serpent.block(subtable))
end