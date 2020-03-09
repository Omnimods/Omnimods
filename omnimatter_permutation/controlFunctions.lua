ord={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
if not omni then omni={} end
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
	return string.sub(a,string.len(a)-string.len(b)+1) == b
end
function start_within_table(a,b)
	return string.sub(a,1,string.len(b)) == b
end
function clone(tab)
	local ret = {}
	if type(tab)~="table" then return tab end
	for i,row in pairs(tab) do
		if type(row)=="table" then
			if getmetatable(row) then
				ret[i]=setmetatable(clone(row),getmetatable(row))
			else
				ret[i]=clone(row)
			end
		elseif type(row)=="function" then
			ret[i]=clone(row)
		else
			ret[i]=row
		end
	end
	for i=1,#tab do
		if type(tab[i])=="table" then
			if getmetatable(tab[i]) then
				ret[i]=setmetatable(clone(tab[i]),getmetatable(tab[i]))
			else
				ret[i]=clone(tab[i])
			end
		elseif type(tab[i])=="function" then
			ret[i]=clone(tab[i])
		else
			ret[i]=tab[i]
		end
	end
	return ret
end