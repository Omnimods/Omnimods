local expo = settings.startup["omnimarathon_exponential"].value
local extra_time = settings.startup["omnimarathon_time_increase"].value
local extra_time_c = settings.startup["omnimarathon_time_const"].value
local eq = {}

local equal_type = {"lab","assembling-machine","furnace","boiler","generator","mining-drill","locomotive","beacon","logistic-container","inserter"}
--log("why tok, WHY!?")
for _, rec in pairs(data.raw.recipe) do
	if standardized_recipes[rec.name] == nil then
		omni.marathon.standardise(rec)
	end
	if string.find(rec.name,"creative") or #rec.normal.ingredients == 0 or (string.find(rec.name,"aspect") and string.find(rec.name,"extraction")) then omni.marathon.exclude_recipe(rec.name) end
	if expo then
	if string.find(rec.name,"molten") and string.find(rec.name,"smelting") and rec.category == "induction-smelting" then
		omni.marathon.exclude_recipe(rec.name)
	elseif string.find(rec.name,"vehicle") and string.find(rec.name,"fuel") and string.find(rec.name,"from") and rec.category == "fuel-processing" then
		omni.marathon.exclude_recipe(rec.name)
	elseif string.find(rec.name,"void") then
		omni.marathon.exclude_recipe(rec.name)
	end
	if rec.subgroup and (rec.subgroup =="empty-barrel" or rec.subgroup =="fill-barrel"  or rec.subgroup =="barreling-pump") then
		omni.marathon.exclude_recipe(rec.name)
	end
	local tot = 0
		for _,ingres in pairs({"ingredients","results"}) do
			for _,obj in pairs(rec.normal[ingres]) do
				if obj.type ~= "fluid" then 
					if obj.amount then tot = tot+obj.amount end
					if obj.amount_min then tot = tot+(obj.amount_min+obj.amount_max)/2 end
					if ingres == "ingredients" and obj.amount == 1 and data.raw.item[obj.name] and data.raw.item[obj.name].place_result then
						local prot = omni.lib.find_entity_prototype(data.raw.item[obj.name].place_result)
						if prot and omni.lib.is_in_table(prot.type,equal_type) then
							eq[obj.name] = {proto = prot}
						end
					end
				end
			end
		end
		if tot >= 1000 then omni.marathon.exclude_recipe(rec.name) end 
	end
end

local round_numbers = {2,3,5,6,10,20,50,100}
local round_numbers_threshold = {3,6,11,15,32,89,353,1000}

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

omni.marathon.exclude_recipe("pulverize-stone")
omni.marathon.exclude_recipe("coal-liquefaction")
omni.marathon.equalize("light-armor","heavy-armor")
omni.marathon.equalize("burner-lab","lab")
omni.marathon.normalize("light-armor")
omni.marathon.normalize("heavy-armor")
omni.marathon.equalize("burner-lab","lab")

local standard_fuel_value = {}

for _, item in pairs(data.raw.item) do
	if item.fuel_value then
		standard_fuel_value[item.name] = item.fuel_value
	end
end

for _, rec in pairs(data.raw.recipe) do
	local found = false
	local obj = ""
	for _, ing in pairs(rec.normal.ingredients) do
		if eq[ing.name] and ing.amount == 1 then
			found = true
			obj=ing.name
			break
		end
	end
	if found then
		for _, res in pairs(rec.normal.results) do
			if data.raw.item[res.name] and data.raw.item[res.name].place_result then
				local prot = omni.lib.find_entity_prototype(data.raw.item[res.name].place_result)
				if prot and omni.lib.is_in_table(prot.type,equal_type) and prot.fast_replaceable_group == eq[obj].proto.fast_replaceable_group then
					omni.marathon.equalize(obj,res.name)
				end
			end
		end
	end
	--fast_replaceable_group
end
omni.marathon.equalize("burner-mining-drill","electric-mining-drill")

local furnace_categories = {}

for _,entity in pairs(data.raw.furnace) do
	for _,cat in pairs(entity.crafting_categories) do
		furnace_categories[cat] = true
	end
end

local cnst_string = settings.startup["omnimarathon_constant"].value

local modified_recipe = {}

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

local digit_length = function(int)
	local i = 0
	
	while int*math.pow(10,i)-math.floor(int*math.pow(10,i))> 0 do
		i=i+1
	end
	return i-1
end
local const = {}

if string.find(cnst_string,"/") then
	const = split(cnst_string,"/")
elseif string.find(cnst_string,".") then
	local number = tonumber(cnst_string)
	local int_len = math.floor(math.log10(number))
	local length = string.len(cnst_string)-1-digit_length(math.floor(number))
	const={number*math.pow(10,length)/omni.lib.gcd(number*math.pow(10,length),math.pow(10,length)),math.pow(10,length)/omni.lib.gcd(number*math.pow(10,length),math.pow(10,length))}
else
	const={tonumber(cnst_string),1}
end


local mod_constant = function(nr)
	local part = {}
	if expo then
		return ratio.root(ratio.power(nr,const[2]),const[1]+const[2],100)
	else
		return ratio.multiply(nr,ratio.invert(const))
	end
end

local enlong_with = function(frac,target)
	if ratio.equal(frac,{1,1}) then return 1 end
	local part = {1,1}
	local max_deno = target[2]
	local i = 1
	local nume = omni.lib.round(frac[1]/frac[2]*omni.lib.primes[i])
	while nume == omni.lib.primes[i] do
		i=i+1
		nume = omni.lib.round(frac[1]/frac[2]*omni.lib.primes[i])
	end
	if i < max_deno then
		return 1
	else
		return omni.lib.round(omni.lib.primes[i]/frac[2]*1.5)+1
	end
end

local already_found={}
--for i,prod in pairs(production_chains) do
--	local analyse = omni.marathon.analyse_chain(prod.name)
--	local new_c = {}
--	for j,an in pairs(analyse.yield) do
--		new_c[j] = mod_constant(an)
--	end
----	for j,chain in pairs(prod.chain) do
--		local mult= {1,1}
--		local total_mult = {1,1}
--		for k,recipe in pairs(chain) do
--			if already_found[recipe.name[1]] == nil then
--				local val = ratio.multiply(ratio.multiply(analyse.ratio[j][k],mult),ratio.root(new_c[j],#chain),{100,100})
--				local new = ratio.approx(val,ratio.enlong({recipe.amount.ing[1],recipe.amount.res[1]},enlong_with(val,{recipe.amount.res[1],recipe.amount.ing[1]})))
--				--local new = ratio.find(analyse.ratio[j][k][1]/analyse.ratio[j][k][2]*mult[1]/mult[2]*math.pow(new_c[j][1]/new_c[j][2],1/#chain),analyse.ratio[j][k][1])
--				local prev_rec = ""
--				--if already_found[prev_rec] ~= nil then new=table.deepcopy(ratio.approx(ratio.multiply(new,modified_recipe[prev_rec]))) end
--				if new[1] < analyse.ratio[j][k][1] and new[2] < analyse.ratio[j][k][2] or type(recipe)=="table" then
--					local c = 1
--					local test = ratio.multiply(new,{c,c})
--					local ingredient_limit = analyse.ratio[j][k][2]
--					if type(recipe)=="table" and recipe.amount.ing[1] then ingredient_limit=recipe.amount.ing[1] end
--					local result_limit = analyse.ratio[j][k][1]
--					if type(recipe)=="table" and recipe.amount.res[1] then result_limit=recipe.amount.res[1] end
--					while test[1] < result_limit and test[2] < ingredient_limit do
--						c=c+1
--						test = ratio.enlong(new,c)
--					end
--					if (math.abs(test[1]-result_limit) > new[1]/2 or math.abs(test[2]-ingredient_limit) > new[2]/2) and c>1 then
--						new=table.deepcopy(ratio.enlong(new,c-1))
--					else
--						new=table.deepcopy(test)
--					end
--				end
--				for l,ing in pairs(data.raw.recipe[recipe.name[1]].normal.ingredients) do
--					for m=1,#analyse.intersection[j][k] do
--						if analyse.intersection[j][k][m] == ing.name then
--							data.raw.recipe[recipe.name[1]].expensive.ingredients[l].amount = omni.lib.round(new[2]*analyse.portion[j][k].ing[m])
--							omni.marathon.exclude_item_in_recipe(recipe.name[1],ing.name)
--						end
--					end
--				end
--				for l,res in pairs(data.raw.recipe[recipe.name[1]].normal.results) do
--					for m=1,#analyse.intersection[j][k+1] do
--						if analyse.intersection[j][k][m] == res.name then
--							data.raw.recipe[recipe.name[1]].expensive.results[l].amount = omni.lib.round(new[1]*analyse.portion[j][k].res[m])
--							omni.marathon.exclude_item_in_recipe(recipe.name[1],res.name)
--						end
--					end
--				end
--				already_found[recipe.name[1]]=new
--				total_mult=ratio.multiply(total_mult,new)
--			else
--				total_mult=ratio.multiply(total_mult,already_found[recipe.name[1]])
--				--mult=table.deepcopy(ratio.multiply(mult,ratio.root(ratio.divide(analyse.ratio[j][k],already_found[rec]),#chain-k,{100,100})))
--			end
--		end
--	end
--end]]

local configure_item = function (rec,item)
	return (marathon_items[item.name] == nil or (marathon_items[item.name] and (marathon_items[item.name].results==nil and marathon_items[item.name].ingredients ~=nil or marathon_items[item.name].equal ~= nil))) and not (marathon_recipes[rec.name] and marathon_recipes[rec.name].item and marathon_recipes[rec.name].item[item.name] and marathon_recipes[rec.name].item[item.name].mult == 0)
end
--log("tokmor damn you!")
--(marathon_items[res][ingress.name]==nil or marathon_items[res].equal ~= nil)

for _,rec in pairs(data.raw.recipe) do
	if not omni.lib.start_with(rec.name,"omnirec") and marathon_recipes[rec.name] == nil or (marathon_recipes[rec.name] and (marathon_recipes[rec.name].item or marathon_recipes[rec.name].inverse or marathon_recipes[rec.name].normalize)) then
		local result = {name="results",total = 0,count = 0, component={}}
		local pre_fuel = { ingredients = {},results = {}}
		local post_fuel = { ingredients = {},results = {}}
		local enlarge = 60
		local maxEnlarge = math.huge
		for _,ingres in pairs({rec.normal.ingredients,rec.normal.results}) do
			for _,component in pairs(ingres) do
				if component.type=="fluid" then
					if component.amount then
						component.amount = math.max(10*omni.lib.round(component.amount/10),10)
						maxEnlarge = math.min(maxEnlarge,omni.lib.round(component.amount))
						enlarge = omni.lib.lcm(enlarge,omni.lib.round(component.amount))
					else
						component.amount_min = math.max(10*omni.lib.round(component.amount_min/10),10)
						component.amount_max = math.max(10*omni.lib.round(component.amount_max/10),10)
						maxEnlarge = math.min(maxEnlarge,omni.lib.round((component.amount_min+component.amount_max)/2))
						enlarge = omni.lib.lcm(enlarge,omni.lib.round((component.amount_min+component.amount_max)/2))
					end
				end
			end
		end
		if enlarge > 60 or maxEnlarge<math.huge then
			for _,ingres in pairs({rec.normal.ingredients,rec.normal.results}) do
				for i,component in pairs(ingres) do
					if component.amount then
						ingres[i].amount=component.amount*enlarge/maxEnlarge
					else
						ingres[i].amount_min=component.amount_min*enlarge/maxEnlarge
						ingres[i].amount_max=component.amount_max*enlarge/maxEnlarge
					end
				end
			end
		end
		for j,res in pairs(rec.normal.results) do
			if configure_item(rec,res) then
				local am = res.amount
				local dis = 0
				if not am then
					am=(res.amount_min+res.amount_max)/2
					dis = res.amount_max-res.amount_min
				else
					dis=nil
				end
				if res.type == "fluid" then am=math.floor(am/60) end
				result.component[res.name]={amount=am,min=res.amount_min,max=res.amount_max,dis=dis,nr=j}
				result.total=result.total+am
				result.count=result.count+1
				local proto = omni.lib.find_prototype(res.name)
				if proto and proto.fuel_value then
					pre_fuel.results[res.name]={name = res.name,amount = res.amount, value = proto.fuel_value, type = proto.fuel_category}
				end
			else
				local am = res.amount
				if not am then
					am=(res.amount_min+res.amount_max)/2
				end
				if res.type == "fluid" then am=math.floor(am/60) end
				result.total=result.total+am
			end
		end
		local ingredient = {name="ingredients",total = 0,count = 0, component={}}
		for j,ing in pairs(rec.normal.ingredients) do
			if ing.name ~= nil and configure_item(rec,ing) then
				local am=ing.amount
				if ing.type == "fluid" then am=omni.lib.round_up(ing.amount/60) end
				--if ing.type == "fluid" then am=math.log(am) end
				ingredient.component[ing.name]={amount=am,nr=j}
				ingredient.total=ingredient.total+am
				ingredient.count=ingredient.count+1
				local proto = omni.lib.find_prototype(ing.name)
				if proto and proto.fuel_value then
					pre_fuel.ingredients[ing.name]={name = ing.name,amount = ing.amount, value = proto.fuel_value,type = proto.fuel_category}
				end
			else
				local am=ing.amount
				if ing.type == "fluid" then am=omni.lib.round_up(ing.amount/60) end
				ingredient.total=ingredient.total+am		
			end
		end
		local found=false
		local expensive_amount = 0
		local time_mult = {}
		
		
		if result.count > 0 or ingredient.count > 0 then
			found=true
			local frac = {1,1}
			if expo then
				if ingredient.total > 1 then
					--frac=ratio.find(result.total[kind]/math.pow(ingredient.total[kind],1+const[1]/const[2])/(1+math.log(ingredient.total[kind])),math.max(ingredient.total[kind],result.total[kind]))
					local max_res = 2*math.floor(math.pow(result.total,1+const[1]/const[2])+1)
					local max_ing = 2*math.floor(math.pow(ingredient.total,1+const[1]/const[2])+1)
					if max_res > 10000 then max_res = 10000 end
					if max_ing > 10000 then max_ing = 10000 end
					local power = ratio.root(ratio.power({1,ingredient.total},const[1]+const[2]),const[2],{max_res,max_ing})
					if ratio.lesser_equal(power,{1,10000}) then
						frac={1,10000}
					elseif max_res < 10000 and max_ing < 10000 then
						frac=ratio.approx(ratio.multiply({result.total,1},power),{max_res,max_ing})
					else
						frac={math.min(100000,power[1]),math.min(100000,power[2])}	
					end
				elseif result.total > 1 then
					local max_res = 2*math.floor(math.pow(result.total,1+const[1]/const[2])+1)
					local max_ing = 2*math.floor(math.pow(ingredient.total,1+const[1]/const[2])+1)
					if max_res > 10000 then max_res = 10000 end
					if max_ing > 10000 then max_ing = 10000 end
					frac=ratio.find(math.pow(result.total,1/(1+const[1]/const[2])),{max_res,max_ing})
				else
					local sd = const[1]*const[2]+const[2]
					math.randomseed(sd)
					local new_ratio = {math.random(1,const[1])}
					sd=sd+1
					math.randomseed(sd)
					new_ratio[2]=math.random(new_ratio[1],const[2])
					--if ratio.greater_equal(new_ratio,{1,1}) then new_ratio = ratio.power(const,2) end
					--if ratio.greater_equal(new_ratio,{1,1}) then new_ratio = ratio.invert(new_ratio) end
					frac=new_ratio--ratio.root(ratio.power(new_ratio,const[1]+const[2]),const[2],{20,40})
				end
			else
				frac=ratio.divide({result.total,ingredient.total},const,true)
			end
			
			local mult = 1
			for i,ingres in pairs({result,ingredient}) do
				for _,component in pairs(ingres.component) do
					if omni.lib.round(frac[i]*component.amount/ingres.total) < 1 and math.floor(ingres.total/(frac[i]*component.amount))+1 > mult then
						mult = math.floor(ingres.total/(frac[i]*component.amount))+1 
					end
				end
			end
			for i,ingres in pairs({result,ingredient}) do
				for _,component in pairs(ingres.component) do
					if omni.lib.round(frac[i]*component.amount/ingres.total*mult) > 50000 then
						mult = 50000/omni.lib.round(frac[i]*component.amount/ingres.total)
					end
				end
			end
			if kind=="item" then expensive_amount = frac[1] end
			if marathon_recipes[rec.name] and marathon_recipes[rec.name].normalize then
				frac[2]=omni.lib.round(frac[2]/frac[1])
				frac[1]=1
				expensive_amount=1
			end	
			frac=table.deepcopy(ratio.enlong(frac,mult))
			
			for i,ingres in pairs({result,ingredient}) do
				--log(serpent.block(ingres))
				for _,component in pairs(ingres.component) do
					local res = rec.normal[ingres.name][component.nr].name
					if (marathon_items[res] == nil or (marathon_items[res] and (marathon_items[res][ingres.name]==nil or marathon_items[res].equal ~= nil))) and not (marathon_recipes[rec.name] and marathon_recipes[rec.name].item and marathon_recipes[rec.name].item[res] and marathon_recipes[rec.name].item[res].mult == 0) then
						if expo then
							local m = frac[i]*component.amount/ingres.total
							if furnace_categories[rec.category] then
								m=math.min(m,omni.lib.find_stacksize(rec.normal[ingres.name][component.nr].name))
							end
							if marathon_recipes[rec.name] and marathon_recipes[rec.name].item and marathon_recipes[rec.name].item[res] and marathon_recipes[rec.name].item[res].mult and marathon_recipes[rec.name].item[res].mult> 0 then
								time_mult[#time_mult+1]=marathon_recipes[rec.name].item[res].mult
								if ingres.name=="ingredients" then
									--time_mult[#time_mult+1]=m/marathon_recipes[rec.name].item[res].mult
								else
									--time_mult[#time_mult+1]=m*marathon_recipes[rec.name].item[res].mult
								end
								m=m*marathon_recipes[rec.name].item[res].mult
							end
							if marathon_recipes[rec.name] and marathon_recipes[rec.name].item and marathon_recipes[rec.name].item[res] and marathon_recipes[rec.name].item[res].add and marathon_recipes[rec.name].item[res].add~= 0 then
								m=m+marathon_recipes[rec.name].item[res].add
							end
							if rec.normal[ingres.name][component.nr].type=="fluid" then m=m*60 end
							local val = omni.lib.round(m)
							if val == 0 then val =1 end
							rec.expensive[ingres.name][component.nr] = {name=res,amount = round_values(val),type=rec.normal[ingres.name][component.nr].type}
						else
						
							local m = 1
							if ingredient.count > 0 then
								m = frac[2]/ingredient.total
								if ingres.name == "results" then
									m = 1
								end
							elseif result.count > 1 then
								m = 1+math.pow(math.log(result.total),const[1]/const[2])
								if ingres.name == "results" then
									m = 1
								end
							else
								m = math.pow(1+int.log(ingres.total,10)/10,1+const[1]/const[2])
								if ingres.name == "results" then
									m = 1/m
								end
							end
							if component.type=="fluid" then m=m*60 end
							local div_value = math.pow(10,int.log(ingres.total,10))
							if rec.normal[ingres.name][component.nr].amount then
								rec.expensive[ingres.name][component.nr] = {name=rec.normal[ingres.name][component.nr].name,amount=omni.lib.round(rec.normal[ingres.name][component.nr].amount*m),type=rec.normal[ingres.name][component.nr].type}
							else
								rec.expensive[ingres.name][component.nr] = {name=rec.normal[ingres.name][component.nr].name,
									type=rec.normal[ingres.name][component.nr].type,
									amount_min = omni.lib.round(rec.normal[ingres.name][component.nr].amount_min*m),
									amount_max = omni.lib.round(rec.normal[ingres.name][component.nr].amount_max*m)
								}
							end
						end
					end
				end
			end	
		else
			found[kind]=false
		end
		for j,ing in pairs(rec.expensive.ingredients) do
			if marathon_items[ing.name] and  marathon_items[ing.name].equal then
				for _,res in pairs(rec.expensive.results) do
					for _, eq in pairs(marathon_items[ing.name].equal) do
						if res.name == eq then
							rec.expensive.ingredients[j].amount = res.amount
						end
					end
				end
			end
		end
		--Fuel checking
		if settings.startup["omnimarathon_adapt_fuel_value"].value and #pre_fuel.ingredients > 0 and #pre_fuel.results > 0 then
			local tot_energy = {all = 0}
			for _,ingres in pairs({"ingredients","results"}) do
				tot_energy[ingres]={}
				for _,fuel in pairs(pre_fuel[ingres]) do
					if not tot_energy[ingres][fuel.type] then tot_energy[ingres][fuel.type]={total = 0,name=fuel.type} end
					tot_energy[ingres][fuel.type].total=tot_energy[ingres][fuel.type].total+fuel.amount*fuel.value
				end
			end
			for _,kind in pairs(data.raw["fuel-category"]) do
				if tot_energy["ingredients"] and tot_energy["results"] then
					
				end
			end
		end
		local gcd = 0
		
		for _, ingres in pairs({rec.expensive.ingredients,rec.expensive.results}) do
			for _,part in pairs(ingres) do
				if part.type == "item" then
					if gcd == 0 then
						gcd = part.amount
					else
						gcd = omni.lib.gcd(gcd,part.amount or math.floor((part.amount_min+part.amount_max)/2))
					end
				else
					if gcd == 0 then
						gcd = part.amount
					else
						gcd = omni.lib.gcd(gcd,math.max(omni.lib.round((part.amount or (part.amount_min+part.amount_max)/2)/60),1))
					end
				end
			end
		end
		if gcd > 1 then
			for _, ingres in pairs({rec.expensive.ingredients,rec.expensive.results}) do
				for _,part in pairs(ingres) do
					if part.amount then
						part.amount = part.amount/gcd 
					else
						part.amount_max = part.amount_max/gcd 
						part.amount_min = part.amount_min/gcd 
					end
				end
			end
		end
		if result.total and result.total > 0 and expensive_amount > 0 then
			local c = 1
			if extra_time then
				if extra_time_c == 0 then
					c=(1+const[1]/const[2]) 
				else
					c=1+extra_time_c
				end
			end
			local t=1
			if time_mult and #time_mult > 0 then
				for _, ti in pairs(time_mult) do
					t=t*ti
				end
				t=math.pow(t,1/#time_mult)
			end
			local tid_a = t*expensive_amount/result.total
			local tid_b = 0
			if tid_a > 1 then
				tid_b = math.pow(t*expensive_amount/result.total,c)
			else
				tid_b = math.pow(t*expensive_amount/result.total,1/c)
			end
			rec.expensive.energy_required = math.max(omni.lib.round(10*rec.normal.energy_required*tid_b/gcd)/10,rec.normal.energy_required)
		end
		if marathon_recipes[rec.name] and marathon_recipes[rec.name].inverse and data.raw.recipe[marathon_recipes[rec.name].inverse] then
			omni.marathon.exclude_recipe(marathon_recipes[rec.name].inverse)
			data.raw.recipe[marathon_recipes[rec.name].inverse].expensive.results = rec.expensive.ingredients
			data.raw.recipe[marathon_recipes[rec.name].inverse].expensive.ingredients = rec.expensive.results
		end
		if enlarge > 60 or maxEnlarge<math.huge then
			for _,ingres in pairs({rec.normal.ingredients,rec.normal.results}) do
				for i,component in pairs(ingres) do
					if component.amount then
						ingres[i].amount=component.amount*maxEnlarge/enlarge
					else
						ingres[i].amount_min=component.amount_min*maxEnlarge/enlarge
						ingres[i].amount_max=component.amount_max*maxEnlarge/enlarge
					end
				end
			end
		end
		--error("read")
		--log(serpent.block(rec))
		--[[
		for _,res in pairs(rec.expensive.results) do
			local size = omni.lib.find_stacksize(res.name)
			if size and size>1 and res.type == "item" and not res.probability and res.amount and res.amount > size then
				while res.amount > size do
					rec.expensive.results[#rec.expensive.results+1]={name=res.name, amount = size,type=res.type}
					res.amount = res.amount-size
				end
			elseif size and size==1 then
				rec.expensive
			end
		end]]
	end
end