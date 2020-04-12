
local ord={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r"}
omni.sciencepacks = {"automation-science-pack","logistic-science-pack","chemical-science-pack","military-science-pack", "production-science-pack","utility-science-pack"}
if mods["omnimatter_crystal"] and mods["omnimatter_science"] then
	table.insert(omni.sciencepacks,3,"omni-pack")
end
if mods["bobtech"] then
	table.insert(omni.sciencepacks,7,"advanced-logistic-science-pack")
end

omni.lib.primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997, 1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123, 1129, 1151, 1153, 1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231, 1237, 1249, 1259, 1277, 1279, 1283, 1289, 1291, 1297, 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373, 1381, 1399, 1409, 1423, 1427, 1429, 1433, 1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499, 1511, 1523, 1531, 1543, 1549, 1553, 1559, 1567, 1571, 1579, 1583, 1597, 1601, 1607, 1609, 1613, 1619, 1621, 1627, 1637, 1657, 1663, 1667, 1669, 1693, 1697, 1699, 1709, 1721, 1723, 1733, 1741, 1747, 1753, 1759, 1777, 1783, 1787, 1789, 1801, 1811, 1823, 1831, 1847, 1861, 1867, 1871, 1873, 1877, 1879, 1889, 1901, 1907, 1913, 1931, 1933, 1949, 1951, 1973, 1979, 1987, 1993, 1997, 1999, 2003, 2011, 2017, 2027, 2029, 2039, 2053, 2063, 2069, 2081, 2083, 2087, 2089, 2099, 2111, 2113, 2129, 2131, 2137, 2141, 2143, 2153, 2161, 2179, 2203, 2207, 2213, 2221, 2237, 2239, 2243, 2251, 2267, 2269, 2273, 2281, 2287, 2293, 2297, 2309, 2311, 2333, 2339, 2341, 2347, 2351, 2357, 2371, 2377, 2381, 2383, 2389, 2393, 2399, 2411, 2417, 2423, 2437, 2441, 2447, 2459, 2467, 2473, 2477, 2503, 2521, 2531, 2539, 2543, 2549, 2551, 2557, 2579, 2591, 2593, 2609, 2617, 2621, 2633, 2647, 2657, 2659, 2663, 2671, 2677, 2683, 2687, 2689, 2693, 2699, 2707, 2711, 2713, 2719, 2729, 2731, 2741, 2749, 2753, 2767, 2777, 2789, 2791, 2797, 2801, 2803, 2819, 2833, 2837, 2843, 2851, 2857, 2861, 2879, 2887, 2897, 2903, 2909, 2917, 2927, 2939, 2953, 2957, 2963, 2969, 2971, 2999, 3001, 3011, 3019, 3023, 3037, 3041, 3049, 3061, 3067, 3079, 3083, 3089, 3109, 3119, 3121, 3137, 3163, 3167, 3169, 3181, 3187, 3191, 3203, 3209, 3217, 3221, 3229, 3251, 3253, 3257, 3259, 3271, 3299, 3301, 3307, 3313, 3319, 3323, 3329, 3331, 3343, 3347, 3359, 3361, 3371, 3373, 3389, 3391, 3407, 3413, 3433, 3449, 3457, 3461, 3463, 3467, 3469, 3491, 3499, 3511, 3517, 3527, 3529, 3533, 3539, 3541, 3547, 3557, 3559, 3571, 3581, 3583, 3593, 3607, 3613, 3617, 3623, 3631, 3637, 3643, 3659, 3671, 3673, 3677, 3691, 3697, 3701, 3709, 3719, 3727, 3733, 3739, 3761, 3767, 3769, 3779, 3793, 3797, 3803, 3821, 3823, 3833, 3847, 3851, 3853, 3863, 3877, 3881, 3889, 3907, 3911, 3917, 3919, 3923, 3929, 3931, 3943, 3947, 3967, 3989, 4001, 4003, 4007, 4013, 4019, 4021, 4027, 4049, 4051, 4057, 4073, 4079, 4091, 4093, 4099, 4111, 4127, 4129, 4133, 4139, 4153, 4157, 4159, 4177, 4201, 4211, 4217, 4219, 4229, 4231, 4241, 4243, 4253, 4259, 4261, 4271, 4273, 4283, 4289, 4297, 4327, 4337, 4339, 4349, 4357, 4363, 4373, 4391, 4397, 4409, 4421, 4423, 4441, 4447, 4451, 4457, 4463, 4481, 4483, 4493, 4507, 4513, 4517, 4519, 4523, 4547, 4549, 4561, 4567, 4583, 4591, 4597, 4603, 4621, 4637, 4639, 4643, 4649, 4651, 4657, 4663, 4673, 4679, 4691, 4703, 4721, 4723, 4729, 4733, 4751, 4759, 4783, 4787, 4789, 4793, 4799, 4801, 4813, 4817, 4831, 4861, 4871, 4877, 4889, 4903, 4909, 4919, 4931, 4933, 4937, 4943, 4951, 4957, 4967, 4969, 4973, 4987, 4993, 4999, 5003, 5009, 5011, 5021, 5023, 5039, 5051, 5059, 5077, 5081, 5087, 5099, 5101, 5107, 5113, 5119, 5147, 5153, 5167, 5171, 5179, 5189, 5197, 5209, 5227, 5231, 5233, 5237, 5261, 5273, 5279, 5281, 5297, 5303, 5309, 5323, 5333, 5347, 5351, 5381, 5387, 5393, 5399, 5407, 5413, 5417, 5419, 5431, 5437, 5441, 5443, 5449, 5471, 5477, 5479, 5483, 5501, 5503, 5507, 5519, 5521, 5527, 5531, 5557, 5563, 5569, 5573, 5581, 5591, 5623, 5639, 5641, 5647, 5651, 5653, 5657, 5659, 5669, 5683, 5689, 5693, 5701, 5711, 5717, 5737, 5741, 5743, 5749, 5779, 5783, 5791, 5801, 5807, 5813, 5821, 5827, 5839, 5843, 5849, 5851, 5857, 5861, 5867, 5869, 5879, 5881, 5897, 5903, 5923, 5927, 5939, 5953, 5981, 5987, 6007, 6011, 6029, 6037, 6043, 6047, 6053, 6067, 6073, 6079, 6089, 6091, 6101, 6113, 6121, 6131, 6133, 6143, 6151, 6163, 6173, 6197, 6199, 6203, 6211, 6217, 6221, 6229, 6247, 6257, 6263, 6269, 6271, 6277, 6287, 6299, 6301, 6311, 6317, 6323, 6329, 6337, 6343, 6353, 6359, 6361, 6367, 6373, 6379, 6389, 6397, 6421, 6427, 6449, 6451, 6469, 6473, 6481, 6491, 6521, 6529, 6547, 6551, 6553, 6563, 6569, 6571, 6577, 6581, 6599, 6607, 6619, 6637, 6653, 6659, 6661, 6673, 6679, 6689, 6691, 6701, 6703, 6709, 6719, 6733, 6737, 6761, 6763, 6779, 6781, 6791, 6793, 6803, 6823, 6827, 6829, 6833, 6841, 6857, 6863, 6869, 6871, 6883, 6899, 6907, 6911, 6917, 6947, 6949, 6959, 6961, 6967, 6971, 6977, 6983, 6991, 6997, 7001, 7013, 7019, 7027, 7039, 7043, 7057, 7069, 7079, 7103, 7109, 7121, 7127, 7129, 7151, 7159, 7177, 7187, 7193, 7207, 7211, 7213, 7219, 7229, 7237, 7243, 7247, 7253, 7283, 7297, 7307, 7309, 7321, 7331, 7333, 7349, 7351, 7369, 7393, 7411, 7417, 7433, 7451, 7457, 7459, 7477, 7481, 7487, 7489, 7499, 7507, 7517, 7523, 7529, 7537, 7541, 7547, 7549, 7559, 7561, 7573, 7577, 7583, 7589, 7591, 7603, 7607, 7621, 7639, 7643, 7649, 7669, 7673, 7681, 7687, 7691, 7699, 7703, 7717, 7723, 7727, 7741, 7753, 7757, 7759, 7789, 7793, 7817, 7823, 7829, 7841, 7853, 7867, 7873, 7877, 7879, 7883, 7901, 7907, 7919, 7927, 7933, 7937, 7949, 7951, 7963, 7993, 8009, 8011, 8017, 8039, 8053, 8059, 8069, 8081, 8087, 8089, 8093, 8101, 8111, 8117, 8123, 8147, 8161, 8167, 8171, 8179, 8191, 8209, 8219, 8221, 8231, 8233, 8237, 8243, 8263, 8269, 8273, 8287, 8291, 8293, 8297, 8311, 8317, 8329, 8353, 8363, 8369, 8377, 8387, 8389, 8419, 8423, 8429, 8431, 8443, 8447, 8461, 8467, 8501, 8513, 8521, 8527, 8537, 8539, 8543, 8563, 8573, 8581, 8597, 8599, 8609, 8623, 8627, 8629, 8641, 8647, 8663, 8669, 8677, 8681, 8689, 8693, 8699, 8707, 8713, 8719, 8731, 8737, 8741, 8747, 8753, 8761, 8779, 8783, 8803, 8807, 8819, 8821, 8831, 8837, 8839, 8849, 8861, 8863, 8867, 8887, 8893, 8923, 8929, 8933, 8941, 8951, 8963, 8969, 8971, 8999, 9001, 9007, 9011, 9013, 9029, 9041, 9043, 9049, 9059, 9067, 9091, 9103, 9109, 9127, 9133, 9137, 9151, 9157, 9161, 9173, 9181, 9187, 9199, 9203, 9209, 9221, 9227, 9239, 9241, 9257, 9277, 9281, 9283, 9293, 9311, 9319, 9323, 9337, 9341, 9343, 9349, 9371, 9377, 9391, 9397, 9403, 9413, 9419, 9421, 9431, 9433, 9437, 9439, 9461, 9463, 9467, 9473, 9479, 9491, 9497, 9511, 9521, 9533, 9539, 9547, 9551, 9587, 9601, 9613, 9619, 9623, 9629, 9631, 9643, 9649, 9661, 9677, 9679, 9689, 9697, 9719, 9721, 9733, 9739, 9743, 9749, 9767, 9769, 9781, 9787, 9791, 9803, 9811, 9817, 9829, 9833, 9839, 9851, 9857, 9859, 9871, 9883, 9887, 9901, 9907, 9923, 9929, 9931, 9941, 9949, 9967, 9973,10007}
omni.lib.prime_range = {1,1}
omni.lib.prime = {}

for i=2,#omni.lib.primes do
	for j=omni.lib.primes[i-1]+1,omni.lib.primes[i] do
		omni.lib.prime_range[j]=i
	end
end

--log(serpent.block(omni.lib.primeRound))

function omni.lib.cardTable(tab)
	local count = 0
	if type(tab)=="table" then
		for _,f in pairs(tab) do
			count=count+1
		end
	end
	return count
end

function omni.lib.factorize(nr)
	local primes = {}
	local newval = nr
	local sqr = math.sqrt(nr)
	local range = math.floor(sqr/math.log(sqr)+sqr)
	for i=1, range do
		if newval%omni.lib.primes[i]==0 then
			local amount = 0
			repeat
				amount = amount+1
				newval=newval/omni.lib.primes[i]
			until(newval/omni.lib.primes[i]>math.floor(newval/omni.lib.primes[i]))
			primes[tostring(omni.lib.primes[i])]=amount
		elseif i==range and newval~= 1 then
			primes[tostring(newval)]=1
		elseif newval == 1 then
			break
		else
			primes[tostring(omni.lib.primes[i])]=0
		end
	end
	return primes
end

function omni.lib.equal(tab1,tab2)
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
function omni.lib.equalTableIgnore(tab1,tab2,...)
	local arg = {...}
	if type(arg[1])=="table" then arg = arg[1] end
	local v = true
	local c = 0
	for name,val in pairs(tab1) do
		if omni.lib.is_in_table(name,arg) then
			c=c+1
			if tab2[name] == nil then
				return false
			else
				if type(val)=="table" then
					v=v and omni.lib.equalTableIgnore(val,tab2[name],arg)
				else
					v= v and val == tab2[name]
				end
			end
		end
	end
	return v
end

function omni.lib.prime.lcm(...)
	local arg = {...}
	local union = table.deepcopy(arg[1])
	for _,p in pairs({"2","3","5"}) do
		for i=2,#arg do
			if arg[i][p] and union[p] then
				if union[p]<arg[i][p] then
					union[p]=arg[i][p]
				end
			elseif not union[p] then
				union[p]=arg[i][p]
			end
		end
	end
	return union
end
function omni.lib.prime.gcd(...)
	local arg = {...}
	local inter = table.deepcopy(arg[1])
	for _,p in pairs({"2","3","5"}) do
		for i=2,#arg do
			if arg[i][p] and inter[p] then
				if inter[p]>arg[i][p] then
					inter[p]=arg[i][p]
				end
			else
				inter[p] = 0
			end
		end
	end
	return inter
end
function omni.lib.prime.div(...)
	local arg = {...}
	local div = table.deepcopy(arg[1])
	for _,p in pairs({"2","3","5"}) do
		for i=2,#arg do
			if arg[i][p] and div[p] then
				div[p]=math.max(div[p]-arg[i][p],0)
			end
		end
	end
	return div
end
function omni.lib.prime.mult(...)
	local arg = {...}
	local div = table.deepcopy(arg[1])
	for _,p in pairs({"2","3","5"}) do
		for i=2,#arg do
			if arg[i][p] and div[p] then
				div[p]=div[p]+arg[i][p]
			end
		end
	end
	return div
end

function omni.lib.prime.value(nr)
	local val = 1
	for _,p in pairs({"2","3","5"}) do
		if nr[p] then
			val=val*math.pow(tonumber(p),nr[p])
		end
	end
	return val
end

function omni.lib.union(...)
	local t = {}
	local arg={...}
	for _, tab in pairs(arg) do
		if type(tab) ~= "table" and type(tab) ~= "nil" then
			tab={tab}
		elseif type(tab) == "nil" then
			tab={}
		end
		for name, i in pairs(tab)  do
			if type(name) == "number" then
				table.insert(t,i)
			else
				t[name]=i
			end
		end
	end
	return table.deepcopy(t)
end
function omni.lib.dif(tab1,tab2)
	local t = {}
	for name,i in pairs(tab1) do
		if (type(name)=="string" and (tab2[name]==nil or not omni.lib.equal(i,tab2[name]))) or not omni.lib.is_in_table(i,tab2) then
			if type(name)=="string" then
				t[name]=table.deepcopy(i)
			else
				t[#t+1]=table.deepcopy(i)
			end
		end
	end
	return table.deepcopy(t)
end

function omni.lib.cutTable(tbl,n)
	local t = {}
	for i=1,n do
		t[#t+1]=tbl[i]
	end
	return t
end

--Strings
function omni.lib.start_with(a,b)
	return string.sub(a,1,string.len(b)) == b
end

function omni.lib.end_with(a,b)
	return string.sub(a,string.len(a)-string.len(b)+1) == b
end

function omni.lib.get_end(a,b)
	return string.sub(a,string.len(a)-b+1,string.len(a))
end

function omni.lib.recipe_change_category(recipe, category)
	if data.raw.recipe[recipe] and data.raw["recipe-category"][item] then
		data.raw.recipe[recipe].category = category
	end
end

function omni.lib.insert(array, ins)
	array[#array+1]=ins
end
--mathematics

function omni.lib.round_up(number)
	local decimal = number-math.floor(number)
	if decimal > 0 then return math.floor(number)+1 else return math.floor(number) end
end

function omni.lib.round(number)
	local decimal = number-math.floor(number)
	if decimal > 0.5 then return math.floor(number)+1 else return math.floor(number) end
end

function omni.lib.max(set)
	local t = 0
	for _,s in set do
		t=math.max(s,t)
	end
	return t
end

--Omni specific
function omni.lib.omni_recipe_fluid_change_category(fluid, category)
	if data.raw.recipe["omnirec-"..fluid.."-a"] then
		for i=1,omni.matter.get_constant("fluid level") do
			data.raw.recipe["omnirec-"..fluid.."-"..ord[i]].category = category
		end
	end
end
function omni.lib.lowest_omnite_cost(item)
	for _,recipe in pairs(data.raw.recipe) do

	end
end


local fit_ingredients = function(ingredients,multiple)
	local substance = {}
	local amount = {}
	for i=1,#ingredients do
		substance[#substance+1]=ingredients[i].name
		amount[#amount]=ingredients[i].amount*multiple
	end
	return {name=substance,amount=amount}
end
local sort_dependency = function(list)
	local l = {}
	l[1] = list[1]

end

local fix_content_list = function(list)
	local substance = {}
	local amount = {}
	for _,ing in pairs(list) do
		substance[#substance+1]=ing.name
		amount[#amount]=ing.amount
	end
	return {name=substance,amount=amount}
end

function omni.lib.achain_omnite_cost(item,chain)
	local cost = 0
	local target_amount = 0
	local required_ingrediences = {}
	for _,result in pairs(data.raw.recipe[chain[1]].results) do
		if result.type == "item" and result.name == item then
			if result.amount then
				target_amount = omni.lib.round_up(1/result.amount)
			else
				target_amount = omni.lib.round_up(1/((result.amount_min+result.amount_max)/2*result.probability))
			end
			break
		end
	end

	required_ingredients=data.raw.recipe[chain[1]].ingredients
	required_ingredients=fit_ingredients(required_ingredients,target_amount)
	local list = chain--sort_dependency(chain)
	--table.remove(list,1)
	for i=2,#chain do
		local sorted_ingredients = fix_content_list(data.raw.recipe[chain[i]].ingredients)
		local sorted_results = fix_content_list(data.raw.recipe[list[i]].results)
		local intersect = omni.lib.table_intersection(sorted_results.name,required_ingredients.name)
		if intersect then
			for j,res in pairs(sorted_results.name) do

			end
		end
	end

	return cost
end

function omni.lib.chain_omnite_cost(item,chain)
	local cost = 0
	local target_amount = 0
	local required_ingrediences = {}
	for _,result in pairs(data.raw.recipe[chain[1]].results) do
		if result.type == "item" and result.name == item then
			if result.amount then
				target_amount = omni.lib.round_up(1/result.amount)
			else
				target_amount = omni.lib.round_up(1/((result.amount_min+result.amount_max)/2*result.probability))
			end
			break
		end
	end

	required_ingredients=data.raw.recipe[chain[1]].ingredients
	required_ingredients=fit_ingredients(required_ingredients,target_amount)
	local list = chain--sort_dependency(chain)
	--table.remove(list,1)
	for i=2,#chain do
		local sorted_ingredients = fix_content_list(data.raw.recipe[chain[i]].ingredients)
		local sorted_results = fix_content_list(data.raw.recipe[list[i]].results)
		local intersect = omni.lib.table_intersection(sorted_results.name,required_ingredients.name)
		if intersect then
			for j,res in pairs(sorted_results.name) do

			end
		end
	end

	return cost
end


--Modifications
function omni.lib.add_number_item(item, val)
	if data.raw.item[item] then
		data.raw.item[item].icons={{icon=data.raw.item[item].icon},{icon = "__omnimatter__/graphics/icons/extraction-"..val..".png"}}
		data.raw.item[item].icon=nil
	end
end

function omni.lib.set_item_icon(item,icon, tint)
	data.raw.item[item].icon = icon
	if tint then omni.lib.change_icon_tint(item,tint) end
end

function omni.lib.change_icon_tint(item, tint)
	local t = {}
	if tint.r then t=tint else t={r=tint[1],g=tint[2],b=tint[3]} end
	local icons = {{icon = data.raw.item[item].icon, tint=t}}
	--data.raw.item[item].icon = icons
	data.raw.item[item].icons = icons
end

function omni.lib.remove_recipe_all_techs(name)
	for _,tech in pairs(data.raw.technology) do
		if tech.effects then
			for i,eff in pairs(tech.effects) do
				if eff.type == "unlock-recipe" and eff.recipe == name then
					table.remove(data.raw.technology[tech.name].effects,i)
				end
			end
		end
	end
end

function omni.lib.replace_recipe_all_techs(name,replacement)
	for _,tech in pairs(data.raw.technology) do
		if tech.effects then
			for i,eff in pairs(tech.effects) do
				if eff.type == "unlock-recipe" and eff.recipe == name then
					eff.recipe=replacement
				end
			end
		end
	end
end

function omni.lib.replace_all_ingredient(ingredient,replacement)
	for _,recipe in pairs(data.raw.recipe) do
		omni.lib.replace_recipe_ingredient(recipe.name, ingredient,replacement)
	end
end

function omni.lib.set_recipe_ingredients(recipe,...)
	local arg = {...}
	local rec = data.raw.recipe[recipe]
	omni.marathon.standardise(rec)
	local ing = {}
	for i,v in pairs(arg) do
		local tmp = {}
		if type(v)=="string" then
			tmp = {{name=v,type="item", amount=1}}
		elseif type(v)=="table" then
			if type(v[1]) == "string" then
				tmp = {{name=v[1],type="item", amount=v[2]}}
			elseif v.name then
				tmp = {{name=v.name,type=v.type or "item", amount=v.amount,probability = v.probability, amount_min = v.amount_min, amount_max=v.amount_max}}
			end
		end
		ing = omni.lib.union(ing,tmp)
	end
	if rec then
		for _, dif in pairs({"normal","expensive"}) do
			rec[dif].ingredients = ing
		end
	end
end
function omni.lib.replace_recipe_ingredient(recipe, ingredient,replacement)
	if not data.raw.recipe[recipe] then
		--log("could not find "..recipe)

	end
	omni.marathon.standardise(data.raw.recipe[recipe])
	for _,dif in pairs({"normal","expensive"}) do
		for i,ing in pairs(data.raw.recipe[recipe][dif].ingredients) do
			if ing.name==ingredient then
				if type(replacement)=="table" then
					if replacement[1] == nil then
						data.raw.recipe[recipe][dif].ingredients[i]=replacement
					else
						ing.name=replacement[1]
						ing.amount=replacement[2]
					end
				else
					ing.name=replacement
				end
			end
		end
	end
end

function omni.lib.replace_recipe_result(recipe,result,replacement)
	omni.marathon.standardise(data.raw.recipe[recipe])
	--log(recipe)
	for _,dif in pairs({"normal","expensive"}) do
		for i,res in pairs(data.raw.recipe[recipe][dif].results) do
			if not res[1] then
				if res.name==result then
					if type(replacement)=="table" then
						res.name=replacement[1]
						res.amount=replacement[2]
					else
						res.name=replacement
					end
				end
			end
		end
	end
end

function omni.lib.add_recipe_ingredient(recipe, ingredient)
	if data.raw.recipe[recipe] then
		omni.marathon.standardise(data.raw.recipe[recipe])
		if not ingredient.name then
			if type(ingredient)=="string" then
					table.insert(data.raw.recipe[recipe].normal.ingredients,table.deepcopy({type="item",name=ingredient,amount=1}))
					table.insert(data.raw.recipe[recipe].expensive.ingredients,table.deepcopy({type="item",name=ingredient,amount=1}))
			elseif ingredient.normal then
				table.insert(data.raw.recipe[recipe].normal.ingredients,table.deepcopy(ingredient.normal))
				table.insert(data.raw.recipe[recipe].expensive.ingredients,table.deepcopy(ingredient.expensive))
			elseif ingredient[1].name then
				table.insert(data.raw.recipe[recipe].normal.ingredients,table.deepcopy(ingredient[1]))
				table.insert(data.raw.recipe[recipe].expensive.ingredients,table.deepcopy(ingredient[2]))
			elseif type(ingredient[1])=="string" then
				table.insert(data.raw.recipe[recipe].normal.ingredients,table.deepcopy({type="item",name=ingredient[1],amount=ingredient[2]}))
				table.insert(data.raw.recipe[recipe].expensive.ingredients,table.deepcopy({type="item",name=ingredient[1],amount=ingredient[2]}))
			end
		else
			table.insert(data.raw.recipe[recipe].normal.ingredients,table.deepcopy(ingredient))
			table.insert(data.raw.recipe[recipe].expensive.ingredients,table.deepcopy(ingredient))
		end
	else
		--log(recipe.." does not exist.")
	end
end

function omni.lib.add_recipe_result(recipe, result)
	if data.raw.recipe[recipe] then
		if data.raw.recipe[recipe].result then
			data.raw.recipe[recipe].results={{type="item",amount=1,name=data.raw.recipe[recipe].result}}
			data.raw.recipe[recipe].result=nil
			table.insert(data.raw.recipe[recipe].results,result)
		elseif data.raw.recipe[recipe].results then
			table.insert(data.raw.recipe[recipe].results,result)
		elseif data.raw.recipe[recipe].normal.results then
			table.insert(data.raw.recipe[recipe].normal.results,result)
			table.insert(data.raw.recipe[recipe].expensive.results,result)
		end
	else
		--log(recipe.." does not exist.")
	end
end

function omni.lib.remove_recipe_ingredient(recipe, ingredient)
	if data.raw.recipe[recipe].ingredients then
		for i,ing in pairs(data.raw.recipe[recipe].ingredients) do
			if ing.name == ingredient then
				table.remove(data.raw.recipe[recipe].ingredients,i)
			end
		end
	elseif data.raw.recipe[recipe].normal.ingredients then
		for i,ing in pairs(data.raw.recipe[recipe].normal.ingredients) do
			if ing.name == ingredient then
				table.remove(data.raw.recipe[recipe].normal.ingredients,i)
			end
		end
		for i,ing in pairs(data.raw.recipe[recipe].expensive.ingredients) do
			if ing.name == ingredient then
				table.remove(data.raw.recipe[recipe].expensive.ingredients,i)
			end
		end
	end
end

function omni.lib.remove_recipe_result(recipe, result)
	if not data.raw.recipe[recipe].result and not data.raw.recipe[recipe].normal.result then
		if data.raw.recipe[recipe].results then
			for i,ing in pairs(data.raw.recipe[recipe].results) do
				if ing.name == ingredient then
					table.remove(data.raw.recipe[recipe].results,i)
					break
				end
			end
		elseif data.raw.recipe[recipe].normal.results then
			for i,ing in pairs(data.raw.recipe[recipe].normal.results) do
				if ing.name == ingredient then
					table.remove(data.raw.recipe[recipe].normal.results,i)
				end
			end
			for i,ing in pairs(data.raw.recipe[recipe].expensive.results) do
				if ing.name == ingredient then
					table.remove(data.raw.recipe[recipe].expensive.results,i)
				end
			end
		end
	else
		log("Attempted to remove the only result that recipe "..recipe.." has. Cannot be done")
	end
end

function omni.lib.multiply_recipe_result(recipe, result, mult)
	--result_count
	omni.marathon.standardise(data.raw.recipe[recipe])
	if mult==nil then
		for _,dif in pairs({"normal","expensive"}) do
			for _, res in pairs(data.raw.recipe[recipe][dif].results) do
				res.amount=res.amount*result
			end
		end
	else
		for _,dif in pairs({"normal","expensive"}) do
			for _, res in pairs(data.raw.recipe[recipe][dif].results) do
				if res.name == result then
					res.amount=res.amount*result
					break
				end
			end
		end
	end
end

function omni.lib.add_unlock_recipe(tech, recipe,force)
	local found = false
	if data.raw.technology[tech] then
		if data.raw.technology[tech].effects then
			for _,eff in pairs(data.raw.technology[tech].effects) do
				if eff.type == "unlock-recipe" and eff.recipe == recipe then
					found = true
					break
				end
			end
		else
			data.raw.technology[tech].effects = {}
		end
		if not found then table.insert(data.raw.technology[tech].effects,{type="unlock-recipe",recipe = recipe}) end
	else
		--log("cannot add recipe to "..tech.." as it doesn't exist")
	end
end
function omni.lib.remove_unlock_recipe(tech, recipe)
	local res = {}
	if tech then
		for _,eff in pairs(data.raw.technology[tech].effects or {}) do
			if eff.type == "unlock-recipe" and eff.recipe ~= recipe then
				res[#res+1]=eff
			end
		end
		data.raw.technology[tech].effects=res
	end
end
function omni.lib.replace_unlock_recipe(tech, recipe,new)
	local res = {}
	for _,eff in pairs(data.raw.technology[tech].effects) do
		if eff.type == "unlock-recipe" and eff.recipe == recipe then
			eff.recipe=new
		end
	end
	--data.raw.technology[tech].effects=res
end

function omni.lib.change_recipe_category(recipe, category)
	data.raw.recipe[recipe].category=category
end

function omni.lib.replace_science_pack(tech,old, new)
	local r = new
	if not r then r = "omni-pack" end
	if data.raw.technology[tech] then
		for i,ing in pairs(data.raw.technology[tech].unit.ingredients) do
			if ing[1]==old then
				data.raw.technology[tech].unit.ingredients[i][1]=r
			end
		end
	else
		log(tech.." cannot be found, replacement of "..old.." with "..r.." has failed.")
	end
end


function omni.lib.add_science_pack(tech,pack)
	if data.raw.technology[tech] then
		local found = false
		for __,sp in pairs(data.raw.technology[tech].unit.ingredients) do
			for __,ing in pairs(sp) do
				if ing == pack then found=true end
			end
		end
		if not found then
			if type(pack) == "table" then
				table.insert(data.raw.technology[tech].unit.ingredients,pack)
			elseif type(pack) == "string" then
				table.insert(data.raw.technology[tech].unit.ingredients,{pack,1})
			elseif type(pack)=="number" then
				table.insert(data.raw.technology[tech].unit.ingredients,{"omni-pack",pack})
			else
				table.insert(data.raw.technology[tech].unit.ingredients,{"omni-pack",1})
			end
		else
			log("Ingredient "..pack.." already exists.")
		end
	else
		log("Cannot find "..tech..", ignoring it.")
	end
end

function omni.lib.remove_science_pack(tech,pack)
	if data.raw.technology[tech] then
		for i,ing in pairs(data.raw.technology[tech].unit.ingredients) do
			if ing[1]==pack then
				table.remove(data.raw.technology[tech].unit.ingredients,i)
			end
		end
	else
		log(tech.." does not seem to exist, check spelling and mods.")
	end
end

function omni.lib.replace_prerequisite(tech,old, new)
	for i,req in pairs(data.raw.technology[tech].prerequisites) do
		if req==old then
			data.raw.technology[tech].prerequisites[i]=new
		end
	end
end
function clone_function(fn)
  local dumped = string.dump(fn)
  local cloned = loadstring(dumped)
  local i = 1
  while true do
    local name = debug.getupvalue(fn, i)
    if not name then
      break
    end
    debug.upvaluejoin(cloned, i, fn, i)
    i = i + 1
  end
  return cloned
end

function omni.lib.remove_prerequisite(tech,prereq)
	local pr={}
	for i,req in pairs(data.raw.technology[tech].prerequisites) do
		if req~=prereq then
			pr[#pr+1]=req
		end
	end
	data.raw.technology[tech].prerequisites=pr
end

function omni.lib.set_prerequisite(tech, req)
	if type(req) == "table" then
		data.raw.technology[tech].prerequisites = req
	else
		data.raw.technology[tech].prerequisites = {req}
	end
end

function omni.lib.add_prerequisite(tech, req)
	local found = nil
	--check that the table exists, or create a blank one
	if data.raw.technology[tech] then
		if not data.raw.technology[tech].prerequisites then
			data.raw.technology[tech].prerequisites = {}
		end
	end
	if type(req) == "table" then
		for _,r in pairs(req) do
			for i,prereq in pairs(data.raw.technology[tech].prerequisites) do
				if prereq == r then found = 1 end
			end
			if not found then
				table.insert(data.raw.technology[tech].prerequisites,r)
			else
				log("Prerequisite"..r.."already exists")
			end
			found = nil
		end
	elseif req then
		if data.raw.technology[tech] then
			for i,prereq in pairs(data.raw.technology[tech].prerequisites) do
				if prereq == req then found = 1 end
			end
			if not found then
				table.insert(data.raw.technology[tech].prerequisites,req)
			else
				log("Prerequisite"..req.."already exists")
			end
		else
			error(tech.." does not exist, please check spelling.")
		end
	else
		log("There is no prerequisities to add to "..tech)
	end
end

function omni.lib.capitalize(str)
	return string.upper(string.sub(str,1,1))..string.sub(str,2,string.len(str))
end

function omni.lib.gcd(m,n)
	    while m ~= 0 do
			m, n = n % m, m;
		end

	return n;
end

function omni.lib.lcm(...)
	local arg = {...}
	local val = arg[1]

	for i=2,#arg do
		val = val*arg[i]/omni.lib.gcd(val,arg[i])
	end

	return val
end

function omni.lib.divisors(m)
	local mx = math.floor(math.sqrt(m))
	local div = {1,m}
	for i=2,mx do
		if m%i == 0 then
			div[#div+1]=i
			if i ~= m/i then
				div[#div+1]=m/i
			end
		end
	end
	return div
end

--checks
function omni.lib.is_number(str)
	return tonumber(str) ~= nil
end
--[[
Checks a recipe contains a specific material as the result
]]
function omni.lib.recipe_result_contains(recipe, item)
	if data.raw.recipe[recipe] and data.raw.recipe[recipe].results then
		for _,res in pairs(data.raw.recipe[recipe].results) do
			local r = {}
			if res.name then
				r=res
			else
				r={type="item",name=res[1],amount=res[2]}
			end
			if type(item) == "table" then
				if omni.lib.is_in_table(r.name,item) then return true end
			else
				if r.name==item then return true end
			end
		end
		return false
	else
		log(recipe.." does not have any results to scan.")
	end
end

--String
--[[
Checks if a string contains anything within the provided list
]]
function omni.lib.string_contained_list(str, list)
	for i=1, #list do
		if type(list[i])=="table" then
			local found_it = true
			for _,words in pairs(list[i]) do
				found_it = found_it and string.find(str,words)
			end
			if found_it then return true end
		else
			if string.find(str,list[i]) then return true end
		end
	end
	return false
end

function omni.lib.string_contained_entire_list(str, list)
	local found_it = true
	for i=1, #list do
		if type(list[i])=="table" then
			for _,words in pairs(list[i]) do
				found_it = found_it and string.find(str,words)
			end
		else
			found_it = found_it and string.find(str,list[i])
		end
	end
	return found_it
end

function omni.lib.split(inputstr, sep)
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

--Set theoretical
--[[
Checks if a table contains a specific element
]]
function omni.lib.is_in_table(element, tab)
	if tab then
		for _, t in pairs(tab) do
			if omni.lib.equal(t,element) then return true end
		end
	end
	return false
end
--[[
A function that takes two tables and gives out the elements they have in common
]]
function omni.lib.table_intersection(t, d)
	local inter={}
	for i=1,#t do
		if omni.lib.is_in_table(t[i],d) then inter[#inter+1]=t[i] end
	end
	if #inter > 0 then return inter else return nil end
end

--[[
Check if tabels are the same
]]
function omni.lib.tables_equal(t, d)
	local inter={}
	for i=1,#t do
		if t[i] ~=d[i] then return false end
	end
	return true
end

--[[
Check if tabels are the same
]]
function omni.lib.sub_table_of(t, d)
	local inter={}
	for i=1,#t do
		local found = false
		for j=1,#d do
			if t[i]==d[j] then
				found = true
				break
			end
		end
		if not found then return false end
	end
	return true
end

--[[
Checks if object exists
]]

function omni.lib.does_exist(item)
	for _, p in pairs({"item","mining-tool","gun","ammo","armor","repair-tool","capsule","module","tool","rail-planner","selection-tool","item-with-entity-data","fluid","recipe","technology"}) do
		if data.raw[p][item] then
			if data.raw[p][item] then
				return true
			end
		end
	end
	return false
end

--[[
Add barrels for fluid that are late.
]]

function omni.lib.create_barrel(fluid)
	if type(fluid)=="string" then fluid = data.raw.fluid[fluid] end

	local icons = {}

	  local side_tint = util.table.deepcopy(fluid.base_color)
	  side_tint.a = 0.75
	  local top_hoop_tint = util.table.deepcopy(fluid.flow_color)
	  top_hoop_tint.a = 0.75

	  icons = {		{
		  icon = data.raw.item["empty-barrel"].icon,
		},{
		  icon = "__base__/graphics/icons/fluid/barreling/barrel-side-mask.png",
		  tint = side_tint
		},{
		  icon = "__base__/graphics/icons/fluid/barreling/barrel-hoop-top-mask.png",
		  tint = top_hoop_tint
		} }

	local reg = {}
	reg[#reg+1] =   {
    type = "item",
    name = fluid.name.."-barrel",
    localised_name = {"item-name.filled-barrel", {"fluid-name." .. fluid.name}},
    icon_size = 32,
    icons = icons,
    flags = {},
    subgroup = "fill-barrel",
    order = "b",
    stack_size = 20
  }
  if mods["angelsrefining"] then reg[#reg].subgroup = "angels-fluid-control" end

    side_tint = util.table.deepcopy(fluid.base_color)
	  side_tint.a = 0.75
	  top_hoop_tint = util.table.deepcopy(fluid.flow_color)
	  top_hoop_tint.a = 0.75


	  icons= {
		{
		  icon = "__base__/graphics/icons/fluid/barreling/barrel-fill.png"
		},
		{
		  icon = "__base__/graphics/icons/fluid/barreling/barrel-fill-side-mask.png",
		  tint = side_tint
		},
		{
		  icon = "__base__/graphics/icons/fluid/barreling/barrel-fill-top-mask.png",
		  tint = top_hoop_tint
		},
	  }
	if fluid.icon then
		icons[#icons+1]=
		{
		  icon = fluid.icon,
		  scale = 0.5,
		  shift = {4, -8}
		}
	else
		for _, ic in pairs(fluid.icons) do
			local scale = ic.scale or 1
			local pos = ic.shift or {0,0}
			icons[#icons+1]=
			{
			  icon = ic.icon,
			  scale = 0.5*scale,
			  shift = {4-pos[1], -8-pos[2]}
			}
		end
	end
	reg[#reg+1]={
    type = "recipe",
    name = "fill-" .. fluid.name.."-barrel",
    localised_name = {"recipe-name.fill-barrel", {"fluid-name." .. fluid.name}},
    category = "crafting-with-fluid",
    energy_required = 1,
    subgroup = "fill-barrel",
    order = "b",
    enabled = false,
    icons = icons,
    icon_size = 32,
    ingredients =
    {
      {type = "fluid", name = fluid.name, amount = 250},
      {type = "item", name = "empty-barrel", amount = 1},
    },
    results=
    {
      {type = "item", name = fluid.name.."-barrel", amount = 1}
    },
    hide_from_stats = true,
    allow_decomposition = false
  }

  if mods["angelsrefining"] then reg[#reg].subgroup = "angels-fluid-control" end
  if angelsmods and angelsmods.trigger and angelsmods.trigger.enable_auto_barreling then reg[#reg].hidden = true end
  omni.lib.add_unlock_recipe("fluid-handling","fill-" .. fluid.name.."-barrel")

  side_tint = util.table.deepcopy(fluid.base_color)
  side_tint.a = side_alpha
  top_hoop_tint = util.table.deepcopy(fluid.flow_color)
  top_hoop_tint.a = top_hoop_alpha


  icons={
    {
      icon = "__base__/graphics/icons/fluid/barreling/barrel-empty.png"
    },
    {
      icon = "__base__/graphics/icons/fluid/barreling/barrel-empty-side-mask.png",
      tint = side_tint
    },
    {
      icon = "__base__/graphics/icons/fluid/barreling/barrel-empty-top-mask.png",
      tint = top_hoop_tint
    },
  }
  	if fluid.icon then
		icons[#icons+1]=
		{
		  icon = fluid.icon,
		  scale = 0.5,
		  shift = {4, -8}
		}
	else
		for _, ic in pairs(fluid.icons) do
			local scale = ic.scale or 1
			local pos = ic.shift or {0,0}
			icons[#icons+1]=
			{
			  icon = ic.icon,
			  scale = 0.5*scale,
			  shift = {4-pos[1], -8-pos[2]}
			}
		end
	end

	reg[#reg+1]=  {
    type = "recipe",
    name = "empty-" .. fluid.name.."-barrel",
    localised_name = {"recipe-name.empty-filled-barrel", {"fluid-name." .. fluid.name}},
    category = "crafting-with-fluid",
    energy_required = 1,
    subgroup = "empty-barrel",
    order = "c",
    enabled = false,
    icons = icons,
    icon_size = 32,
    ingredients =
    {
      {type = "item", name = fluid.name.."-barrel", amount = 1}
    },
    results=
    {
      {type = "fluid", name = fluid.name, amount = 250},
      {type = "item", name = "empty-barrel", amount = 1}
    },
    hide_from_stats = true,
    allow_decomposition = false
  }
  omni.lib.add_unlock_recipe("fluid-handling","empty-" .. fluid.name.."-barrel")
  if angelsmods and angelsmods.trigger and angelsmods.trigger.enable_auto_barreling then reg[#reg].hidden = true end
  if mods["angelsrefining"] then reg[#reg].subgroup = "angels-fluid-control" end
	data:extend(reg)
end

function omni.lib.find_stacksize(item)
	if data.raw.fluid[item] or (type(item)=="table" and item.type=="fluid") then return 50 end
	if type(item)=="table" then return item.stack_size elseif type(item)~="string" then return nil end
	for _, p in pairs({"item","mining-tool","gun","ammo","armor","repair-tool","capsule","module","tool","rail-planner","selection-tool","item-with-entity-data","item-with-inventory"}) do
		if data.raw[p][item] and data.raw[p][item].stack_size then return data.raw[p][item].stack_size end
	end
	log("Could not find "..item.."'s stack size, check it's type.")
end

function omni.lib.find_prototype(item)
	if type(item)=="table" then return item elseif type(item)~="string" then return nil end
	for _, p in pairs({"item","mining-tool","gun","ammo","armor","repair-tool","capsule","module","tool","rail-planner","selection-tool","item-with-entity-data","fluid","selection-tool","item-with-inventory"}) do
		if data.raw[p][item] then return data.raw[p][item] end
	end
	--log("Could not find "..item.."'s prototype, check it's type.")
	return nil
end
function omni.lib.find_entity_prototype(item)
	if type(item)=="table" then return item elseif type(item)~="string" then return nil end
	for _, p in pairs({"assembling-machine","furnace","mining-drill","boiler","generator","lab","locomotive","beacon","logistic-container","electric-pole"}) do
		if data.raw[p][item] then return data.raw[p][item] end
	end
	--log("Could not find "..item.."'s entity prototype, check it's type.")
	return nil
end
function omni.lib.find_recipe(item)
	if type(item)=="table" then return item elseif type(item)~="string" then return nil end
	for _, p in pairs(data.raw.recipe) do
		if standardized_recipes[p.name] == nil then omni.marathon.standardise(p) end
		for _,r in pairs(p.normal.results) do
			if r.name == item then return p end
		end
	end
	--log("Could not find "..item.."'s recipe prototype, check it's type.")
	return nil
end

local c=0.9
local dir={W={0,-c},S={0,c},A={-c,0},D={c,0},I={0,-c},K={0,c},J={-c,0},L={c,0},T={0,-c},G={0,c},F={-c,0},H={c,0}}
local inflow={A=true,W=true,S=true,D=true}
local passthrough={F=true,T=true,H=true,G=true}

function omni.lib.assemblingFluidBox(str,hide)
	if str==nil then return nil end
	local code=omni.lib.split(str,".")
	local size = #code
	local box = {}
	for i, row in pairs(code) do
		for j=1, string.len(row) do
			local letter = string.sub(row,j,j)
			if letter ~= "X" then
				local b = {}
				b.pipe_covers = pipecoverspictures()
				b.base_area = 120
				if inflow[letter] then
					b.production_type = "input"
					b.base_level = -1
				elseif passthrough[letter] then
					b.production_type = "input-output"
				else
					b.production_type = "output"
					b.base_level = 1
				end
				local pos = {-0.5*(string.len(row)+1)+j,-0.5*(#code+1)+i}
				pos[1]=pos[1]+dir[letter][1]
				pos[2]=pos[2]+dir[letter][2]
				b.pipe_connections = {{ type=b.production_type, position = pos }}
				box[#box+1]=table.deepcopy(b)
			end
		end
	end
	if type(hide) == "boolean" and hide then box.off_when_no_fluid_recipe = true end
	return box
end

--[[
Name code
(), Optional depth
]]
function omni.lib.replaceValue(tab,name,val,flags)
	if tab==nil then return val end
	local t= table.deepcopy(tab)
	local n = string.find(name,"%.")
	if n then
		local sb,sbnum = string.sub(name,1,n-1),tonumber(string.sub(name,1,n-1))
		local sb2,sb2num = string.sub(name,2,n-2),tonumber(string.sub(name,2,n-2))

		local newname = string.sub(name,n+1,-1)

		if string.sub(sb,1,1)=="(" and string.sub(sb,-1,-1)==")" then
			if type(t[sb2num or sb2])=="table" then
				t[sb2num or sb2]=omni.lib.replaceValue(tab[sb2num or sb2],newname,val)
			elseif string.find(newname,"%.") then
				local s = string.split(newname,".")
				for i=2,#s do
					if tab[s[i]] then
						if i<#s then
							local nxt = s[i+1]
							for j=i+2,#s do
								nxt=nxt.."."..s[j]
							end
							t[s[i]]=omni.lib.replaceValue(tab[s[i]],nxt,val)
						else
							t[s[i]]=val
						end
					end
				end
			else
				t[newname]=val
			end
		else
			t[sbnum or sb]=omni.lib.replaceValue(tab[sbnum or sb],newname,val)
		end
	else
		t[name]=val
	end
	return t
end
--[[
{ Generator
      base_area = 1,
      height = 2,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        { type = "input-output", position = {0, 3} },
        { type = "input-output", position = {0, -3} }
      },
      production_type = "input-output",
      filter = "steam",
      minimum_temperature = 100.0
    }

{ ASsembling machine
      {
        production_type = "input",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0, -2} }},
        secondary_draw_orders = { north = -1 }
      },
      {
        production_type = "output",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 1,
        pipe_connections = {{ type="output", position = {0, 2} }},
        secondary_draw_orders = { north = -1 }
      },
      off_when_no_fluid_recipe = true
    }
]]
function omni.lib.generatorFluidBox(str,filter,tmp)
	if str==nil then return nil end
	local code=omni.lib.split(str,".")
	local box = {
      base_area = 1,
      height = 2,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
      pipe_connections ={},
	  production_type = "input-output"
	  }
	for i, row in pairs(code) do
		for j=1, string.len(row) do
			local letter = string.sub(row,j,j)
			if letter ~= "X" then
				local b = {}
				b.pipe_covers = pipecoverspictures()
				b.base_area = 10
				if inflow[letter] then
					b.production_type = "input"
					b.base_level = -1
				elseif passthrough[letter] then
					b.production_type = "input-output"
				else
					b.production_type = "output"
					b.base_level = 1
				end
				local pos = {-0.5*(string.len(row)+1)+j,-0.5*(#code+1)+i}
				pos[1]=pos[1]+dir[letter][1]
				pos[2]=pos[2]+dir[letter][2]
				b = { type=b.production_type, position = pos }
				box.pipe_connections[#box.pipe_connections+1]=table.deepcopy(b)
			end
		end
	end
	box.filter = filter
	box.minimum_temperature = tmp
	return box
end

function omni.lib.fluid_box_conversion(kind,str,hide,tmp)
	if str==nil then return nil end
	local box = {}
	if kind == "assembling-machine" or kind=="furnace" then
		if type(hide)=="boolean" then
			box = omni.lib.assemblingFluidBox(str,hide)
		else
			box = omni.lib.assemblingFluidBox(str)
		end
	elseif kind == "generator" then
		if hide then
			box = omni.lib.generatorFluidBox(str,hide,tmp)
		else
			box = omni.lib.generatorFluidBox(str)
		end
	end
	return box
end

function omni.lib.addProductivity(recipe)

end
