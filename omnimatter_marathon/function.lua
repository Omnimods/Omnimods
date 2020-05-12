production_chains = {}
fuel_chains = {}

function omni.marathon.add_fuel_chain(name,chain,initial,final)
	fuel_chains[name] = {name=name}
	if type(chain)=="table" then
		fuel_chains[name].chain=chain
	else
		fuel_chains[name].chain={chain}
	end
	fuel_chains[name].final=final
	fuel_chains[name].initial=initial
end

function omni.marathon.add_chain(name,chain,initial,final)
	if production_chains[name] then
	else
		production_chains[name] = {name=name}
		production_chains[name].chain={}
		if type(final) == "table" then
			production_chains[name].final=final
		else
			production_chains[name].final={final}
		end
		if type(initial) == "table" then
			production_chains[name].initial=initial
		else
			production_chains[name].initial={initial}
		end
	end
	if type(chain)=="table" then
		local ch = {}
		for _, c in pairs(chain) do
			if type(c)=="table" then
				if type(c[1]) == "table" then
					ch[#ch+1]={name=c[1], amount={ing={},res={}}}
				else
					ch[#ch+1]={name={c[1]},amount={ing={},res={}}}					
				end
				local ingres = {"ing","res"}
				for i=1,2 do
					if type(c[2][i]) ~="table" then
						ch[#ch].amount[ingres[i]]={c[2][i]}
					end
				end
			else
				if type(c[1]) == "table" then
					ch[#ch+1]={name=c,amount={ing={10},res={10}}}
				else
					ch[#ch+1]={name={c},amount={ing={10},res={10}}}				
				end
			end
		end
		production_chains[name].chain[#production_chains[name].chain+1]=ch
	else
		production_chains[name].chain[#production_chains[name].chain+1]={{recipe=chain,amount={ing={10},res={10}}}}
	end
end


int = {}

function int.root(alpha,n,closest)
	local m = 1
	while math.pow(m,n) < alpha do
		m=m+1
	end
	if closest == nil or not closest then
		return m-1
	else
		if alpha-math.pow(m-1,n)<alpha-math.pow(m,n) then
			return m-1
		else
			return m
		end
	end
end

function int.log(alpha,base)
	local i=1
	while math.pow(base,i) < alpha do
		i=i+1
	end
	return i-1
end

ratio={}

function ratio.multiply(alpha,beta,simplify)
	local new = {}
	new[1]=alpha[1]*beta[1]
	new[2]=alpha[2]*beta[2]
	if simplify or simplify==nil then
		return ratio.simplify(new)
	else
		return new
	end
end

function ratio.power(alpha,n,simplify)
	local new = {}
	new[1]=math.pow(alpha[1],n)
	new[2]=math.pow(alpha[2],n)
	if simplify or simplify==nil then
		return ratio.simplify(new)
	else
		return new
	end
end

function ratio.divide(alpha,beta, simplify)
	local new = {}
	new[1]=alpha[1]*beta[2]
	new[2]=alpha[2]*beta[1]
	if simplify or simplify==nil then
		return ratio.simplify(new)
	else
		return new
	end
end

function ratio.simplify(alpha)
	local new = {}
	new[1]=alpha[1]/omni.lib.gcd(alpha[1],alpha[2])
	new[2]=alpha[2]/omni.lib.gcd(alpha[1],alpha[2])
	return new
end

function ratio.enlong(alpha,n)
	local new = {}
	new[1]=alpha[1]*n
	new[2]=alpha[2]*n
	return new
end

function ratio.invert(alpha)
	return {alpha[2],alpha[1]}
end

function ratio.sum(alpha,beta,simplify)
	local new = {}
	new[1]=alpha[1]*beta[2]+alpha[2]*beta[1]
	new[2]=math.abs(alpha[2]*beta[2])
	if simplify or simplify==nil then
		return ratio.simplify(new)
	else
		return new
	end
end

function ratio.dif(alpha,beta,simplify)
	local new = {}
	new[1]=alpha[1]*beta[2]-alpha[2]*beta[1]
	new[2]=math.abs(alpha[2]*beta[2])
	if simplify or simplify==nil then
		return ratio.simplify(new)
	else
		return new
	end
end

function ratio.root(alpha,root,limit)
	local new = {}
	
	local max_deno = omni.marathon.max_denominator
	local max_nume = omni.marathon.max_denominator
	if limit then
		if type(limit) == "table" then
			max_nume = limit[1]
			max_deno = limit[2]
		else
			max_nume = limit
			max_deno = limit
		end
	end
	local part = {1,1}
	for i=1,omni.lib.prime_range[max_deno] do
		local nume = omni.lib.round(math.pow(alpha[1]/alpha[2]*math.pow(omni.lib.primes[i],root),1/root))
		if ratio.greater(ratio.abs(ratio.dif(alpha,ratio.power(part,root))),ratio.abs(ratio.dif(alpha,ratio.power({nume,omni.lib.primes[i]},root)))) then
			part={nume,omni.lib.primes[i]}
		end
	end
		
	return part
	
	--[[
	local max_deno = omni.marathon.max_denominator
	local max_nume = omni.marathon.max_denominator
	if limit then
		if type(limit) == "table" then
			max_nume = limit[1]
			max_deno = limit[2]
		else
			max_nume = limit
			max_deno = limit
		end
	end
	
	local dist = 100
	local part = {1,1}
	local start_deno = 1
	local start_nume = 1
	
	if alpha[2]> alpha[1] then start_deno=math.pow(alpha[2],root) end
	if alpha[1]> alpha[2] then start_nume=math.pow(alpha[1],root) end
	
	for i = start_deno,max_deno do
		local loc_max = alpha[1]*math.pow(i,root)
		local new_num = 1
		for j=start_nume,max_nume do
			local test = alpha[2]*math.pow(j,root)
			if test > loc_max then
				if math.abs(alpha[2]*math.pow(j-1,root)-loc_max) > alpha[2]*math.pow(j,root)-loc_max then
					new_num=j
				elseif j>1 then
					new_num = j-1
				end
				break
			end
		end
		if ratio.greater(ratio.abs(ratio.dif(alpha,ratio.power(part,root))),ratio.abs(ratio.dif(alpha,ratio.power({new_num,i},root)))) then
			part={new_num,i}
		end
	end
	return ratio.simplify(part)]]
end


function ratio.greater(alpha,beta)
	return alpha[1]*beta[2]>alpha[2]*beta[1]
end

function ratio.lesser(alpha,beta)
	return alpha[1]*beta[2]<alpha[2]*beta[1]
end

function ratio.equal(alpha,beta)
	return alpha[1]*beta[2]==alpha[2]*beta[1]
end
function ratio.greater_equal(alpha,beta)
	return ratio.greater(alpha,beta) or ratio.equal(alpha,beta) 
end

function ratio.lesser_equal(alpha,beta)
	return ratio.lesser(alpha,beta) or ratio.equal(alpha,beta) 
end

function ratio.abs(alpha)
	return {math.abs(alpha[1]),math.abs(alpha[2])}
end

omni.marathon.max_denominator = 20

function ratio.approx(alpha,limit,ineff)
	local max_deno = omni.marathon.max_denominator
	local max_nume = omni.marathon.max_denominator
	if limit then
		if type(limit) == "table" then
			max_nume = limit[1]
			max_deno = limit[2]
		else
			max_nume = limit
			max_deno = limit
		end
	end
	
	local part = {1,1}
	if ineff == nil or not ineff then
		for i=1,omni.lib.prime_range[max_deno]+1 do
			local nume = omni.lib.round(alpha[1]/alpha[2]*omni.lib.primes[i])
			if ratio.greater(ratio.abs(ratio.dif(alpha,part)),ratio.abs(ratio.dif(alpha,{nume,omni.lib.primes[i]}))) then
				part={nume,omni.lib.primes[i]}
			end
		end
	else
		for i=1,max_deno do
			for j=1,max_nume do
			
			end
		end
	end
	
	return ratio.simplify(part)
end

function ratio.find(alpha,limit)
	local part = {1,1}
	
	local max_deno = omni.marathon.max_denominator
	local max_nume = omni.marathon.max_denominator
	if limit then
		if type(limit) == "table" then
			max_nume = limit[1]
			max_deno = limit[2]
		else
			max_nume = limit
			max_deno = limit
		end
	end
	
	for i=1,omni.lib.prime_range[max_deno] do
	
		local nume = omni.lib.round(alpha*omni.lib.primes[i])
		if math.abs(part[1]/part[1]-alpha)> math.abs(nume/omni.lib.primes[i]-alpha) then
			part={nume,omni.lib.primes[i]}
		end
	end
	
	return part
end

function omni.marathon.analyse_chain(name)
	local yield = {}
	--log("Chain: "..name)
	local ratio_part={}
	local intersection={}
	local in_out = {}
	local portion = {}
	for i,chain in pairs(production_chains[name].chain) do
		--log("chain nr: "..i)
		yield[i]={1,1}
		local ing_list={}
		local res_list={}
		ratio_part[i]={}
		intersection[i]={}
		portion[i]={}
		for j,recipe in pairs(chain) do
			if data.raw.recipe[recipe.name[1]] then
				ing_list[j]={name={},amount={}}
				res_list[j]={name={},amount={}}
				for _, ing in pairs(data.raw.recipe[recipe.name[1]].normal.ingredients) do
					ing_list[j].name[#ing_list[j].name+1]=ing.name
					ing_list[j].amount[#ing_list[j].amount+1]=ing.amount
				end
				for _, res in pairs(data.raw.recipe[recipe.name[1]].normal.results) do
					res_list[j].name[#res_list[j].name+1]=res.name
					res_list[j].amount[#res_list[j].amount+1]=res.amount
				end
			else
				--log(serpent.block(recipe))
				log("Something is wrong, the recipe "..recipe.name.." does not exist and cannot be analysed in the chain "..name..":"..i)
				break
			end
		end
		intersection[i][1]=table.deepcopy(production_chains[name].initial)
		local am = 0
		portion[i][1]={ing={},res={}}
		for _,ing in pairs(data.raw.recipe[chain[1].name[1]].normal.ingredients) do
			for l=1,#intersection[i][1] do
				if ing.name == intersection[i][1][l] then
					am=am+ing.amount
					portion[i][1].ing[l]=ing.amount
				end
			end
		end
		for t, r in pairs(portion[i][1].ing) do
			portion[i][1].ing[t]=r/am
		end
		yield[i]=ratio.multiply(yield[i],{1,am},false)
		ratio_part[i][1]={1,am}
		for j=2,#chain do
			local insect = omni.lib.table_intersection(ing_list[j].name,res_list[j-1].name)
			intersection[i][j]=table.deepcopy(insect)
			portion[i][j]={ing={},res={}}
			am=0
			for k=1,#res_list[j-1].name do
				for l=1,#insect do
					if res_list[j-1].name[k] == insect[l] then
						am=am+res_list[j-1].amount[k]
						portion[i][j-1].res[l]=res_list[j-1].amount[k]
					end
				end
			end
			for t, r in pairs(portion[i][j-1].res) do
				portion[i][j-1].res[t]=r/am
			end
			yield[i]=ratio.multiply(yield[i],{am,1},false)
			ratio_part[i][j-1][1]=table.deepcopy(am)
			
			am=0
			for k=1,#ing_list[j].name do
				for l=1,#insect do
					if ing_list[j].name[k] == insect[l] then
						am=am+ing_list[j].amount[k]
						portion[i][j].ing[l]=ing_list[j].amount[k]
					end
				end
			end
			for t, r in pairs(portion[i][j].ing) do
				portion[i][j].ing[t]=r/am
			end
			yield[i]=ratio.multiply(yield[i],{1,am},false)
			ratio_part[i][j]=table.deepcopy({1,am})
		end
		intersection[i][#chain+1]=table.deepcopy(production_chains[name].final)
		am=0
		for _,res in pairs(data.raw.recipe[chain[#chain].name[1]].normal.results) do
			for l=1,#production_chains[name].final do
				if res.name == production_chains[name].final[l] then
					am=am+res.amount
					portion[i][#chain].res[l]=res.amount
				end
			end
		end
		for t, r in pairs(portion[i][#chain].res) do
			portion[i][#chain].res[t]=r/am
		end
		ratio_part[i][#chain][1]=table.deepcopy(am)
		yield[i]=ratio.multiply(yield[i],{am,1},false)
		in_out[i]=table.deepcopy(yield[i])
		yield[i]=ratio.simplify(yield[i])
		for j,r in pairs(ratio_part[i]) do
			ratio_part[i][j]=table.deepcopy(ratio.divide(table.deepcopy(r),ratio.root(yield[i],#chain)))
		end
	end
	return {yield=yield,ratio=ratio_part,intersection=intersection,in_out=in_out, portion = portion}
end

function round_values(int)
	if settings.startup["omnimarathon_rounding"].value == true then
		local val = 0
		for i, v in pairs(round_numbers_threshold) do
			if int > v then
				val=i
			else
				break
			end
		end
		if val == 0 then return int end
		return (math.floor(int/round_numbers[val])+1)*round_numbers[val]
	else
		return int
	end
end

function omni.marathon.split(inputstr, sep)
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








function omni.marathon.analyse_fuel(name)
end


function omni.marathon.modify(recipe,item)
end

