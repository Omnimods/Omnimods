if not omni then omni={} end
require("util")

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function start_with(a,b)
	return string.sub(a,1,string.len(b)) == b
end

function end_with(a,b)
	return string.sub(a,string.len(a)-string.len(b)+1,string.len(a)) == b
end

function start_within_table(a,b)
	return string.sub(a,1,string.len(b)) == b
end

function equal(tab1,tab2)
	local v = true
	local c = 0
	if type(tab1)~="table" or type(tab2)~= "table" then  return tab1==tab2 end
	if type(tab1)=="table" then
		for name,val in pairs(tab1) do
			c=c+1
			if tab2[name] == nil then
				return false
			else
				if type(val)=="table" then
					v=v and omni.lib.equal(val,tab2[name])
				else
					v= v and val == tab2[name]
				end
			end
		end
	else
		v=v and tab1==tab2
	end
	return v
end

function inTable(element, tab)
	for _, t in pairs(tab) do
		if equal(t,element) then return true end
	end
	return false
end