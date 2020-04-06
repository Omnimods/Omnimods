-- returns the plain fuel value number
function omni.lib.getFuelNumber(fv)
    return tonumber(string.sub(fv,1,-3))
end

--returns the fuel value unit
function omni.lib.getFuelUnit(fv)
    return string.sub(fv,-2)
end

--Multiplies the fuel value with mult
function omni.lib.multFuelValue(fv,mult)
    return (omni.lib.getFuelNumber(fv)*mult)..omni.lib.getFuelUnit(fv)
end

-- converts the fuel value into MJ and returns the number
function omni.lib.getFuelNumberInMJ(fv)
    local unit = omni.lib.getFuelUnit(fv)
    if unit == "kJ" then
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

-- find the tech name of a recipe
function omni.lib.find_tech_name(recipename)
	for _,tech in pairs(data.raw.technology) do
		if tech.effects then
			for i,eff in pairs(tech.effects) do
                if eff.type == "unlock-recipe" and eff.recipe == recipename then
                    log("FOUND1"..recipename.."TECH: "..tech.name)
                    return tech.name
                end
			end
		end
	end
end