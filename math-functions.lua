function gcd(m, n)
    -- greatest common divisor
    while m ~= 0 do
        m, n = math.mod(n, m), m;
    end

    return n;
end

function round(number)
	local decimal = number - math.floor(number)
	if decimal >= 0.5 then
		return math.floor(number)+1
	else
		return math.floor(number)
	end
	
end

function halfround(number)
	local decimal = number - math.floor(number)
	
	if decimal >= 0.75 then
		return math.floor(number)+1
	elseif decimal >= 0.25 then
		return math.floor(number)+0.5
	else
		return math.floor(number)
	end
	
end