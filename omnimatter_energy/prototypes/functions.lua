--returns the fuel value unit
function omni.lib.getFuelUnit(fv)
    return string.match(fv, "%a+")
end

-- returns the plain fuel value number
function omni.lib.getFuelNumber(fv)
    local unit = omni.lib.getFuelUnit(fv)
    return tonumber(string.sub(fv,1,-#unit-1))
end

--Multiplies the fuel value with mult
function omni.lib.multFuelValue(fv,mult)
    return (omni.lib.getFuelNumber(fv)*mult)..omni.lib.getFuelUnit(fv)
end

-- converts the fuel value into MJ and returns the number
function omni.lib.getFuelNumberInMJ(fv)
    local unit = omni.lib.getFuelUnit(fv)
    if unit == "J" then
        return omni.lib.getFuelNumber(fv)/1000000
    elseif unit == "kJ" then
        return omni.lib.getFuelNumber(fv)/1000
    elseif unit == "MJ" then
        return omni.lib.getFuelNumber(fv)
    elseif unit == "GJ" then
        return omni.lib.getFuelNumber(fv)*1000
    elseif unit == "TJ" then
        return omni.lib.getFuelNumber(fv)*1000000
    else
        log("Error: Omnilib- Unknown Fuel Unit: "..fv)
        return nil
    end
end

-- Tried to make it work for multi-recipe items like solid fuel
--Not logging all tech unlocks for some reason, also a HUGE performance hook
-- 	for _,tech in pairs(data.raw.technology) do
-- 		if tech.effects then
-- 			for _,eff in pairs(tech.effects) do
--                 if eff.type == "unlock-recipe" then --and eff.recipe.results
--                     rectech[#rectech+1] = {recname = eff.recipe, techname = tech.name}
--                 end
-- 			end
-- 		end
--     end
--     log(serpent.block(rectech))
--     for _,rec in pairs(data.raw.recipe) do
--         for _,list in pairs(rectech) do
--             if list.recname == rec.name then

--                 --log(serpent.block(rec))
--                 if rec.results then
--                     for _,res in pairs(rec.results) do
--                         --log("RESNAME: "..res.name)
--                         --log(serpent.block(rec))
--                         if res.name == recipename then
--                             return list.techname
--                         end
--                     end
--                 elseif rec.result and rec.result.name == recipename then
--                     return list.techname
--                 end
--             end
--         end
--     end
-- end