----log(serpent.block(random_recipes))

local exclusion_list = {"void"}

local check_recipes = random_recipes

local top_value = 500
local roundRndValues = {}
local b,c,d = math.log(5),math.log(3),math.log(2)
for i=0,math.floor(math.log(top_value)/b) do
    local pow5 = math.pow(5,i)
    for j=0,math.floor(math.log(top_value/pow5)/c) do
        local pow3=math.pow(3,j)
        for k=0,math.floor(math.log(top_value/pow5/pow3)/d) do
            roundRndValues[#roundRndValues+1] = pow5*pow3*math.pow(2,k)
        end
    end
end
table.sort(roundRndValues)

local roundRandom = function(nr,round)
	local t = omni.lib.round(nr)
	local newval = t
	for i=1,#roundRndValues-1 do
		if roundRndValues[i]< t and roundRndValues[i+1]>t then
			if t-roundRndValues[i] < roundRndValues[i+1]-t then
				local c = 0
				if roundRndValues[i] ~= t and round == 1 then c=1 end
				newval = roundRndValues[i+c]
			else
				local c = 0
				if roundRndValues[i+1] ~= t and round == -1 then c=-1 end
				newval = roundRndValues[i+1+c]
			end
		end
	end
	return math.max(newval,1)
end

--log("random recipes")
for _,recipe in pairs(check_recipes) do
	if not omni.lib.is_in_table(recipe,exclusion_list) and not string.find(recipe,"creative") then
		local double = false
		--local store = data.raw.recipe[recipe]
		local rec = table.deepcopy(data.raw.recipe[recipe])
		
		if not mods["omnimatter_marathon"] then omni.marathon.standardise(rec) end
		
		local prob = {normal={},expensive={}}
		for _,dif in pairs({"normal","expensive"}) do
			for i,res in pairs(rec[dif].results) do
				local amount = res.amount
				if res.amount_min then amount = (res.amount_min+res.amount_max)/2 end
				if res.probability then amount = amount*res.probability end
				prob[dif][i]=amount/roundRandom(amount,1)
				rec[dif].results[i].amount = roundRandom(amount,1)
				res.amount_min=nil
				res.amount_max=nil
				res.probability=nil
			end
		end
		
		local new_rec = create_compression_recipe(rec)
		if new_rec then
			for _,dif in pairs({"normal","expensive"}) do
				for i,res in pairs(rec[dif].results) do
					if prob[dif][i]<1 then
						new_rec[dif].results[i].probability = prob[dif][i]
					end
				end
			end
		else
			--log("you fucked up big time with this recipe: "..rec.name)
		end
		if new_rec then data:extend({new_rec}) end
		
	end
end