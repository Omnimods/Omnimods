--log(serpent.block(random_recipes))

local exclusion_list = {"void"}

local check_recipes = random_recipes

for _,recipe in pairs(check_recipes) do
	if not omni.lib.is_in_table(recipe,exclusion_list) then
		
		local double = false
		--local store = data.raw.recipe[recipe]
		local rec = table.deepcopy(data.raw.recipe[recipe])
		
		if not mods["omnimatter_marathon"] then omni.marathon.standardise(rec) end
		
		local complete_res = {}
		
		if rec.results then complete_res[#complete_res+1]=rec.results end
		if rec.normal and rec.normal.results then complete_res[#complete_res+1]=rec.normal.results end
		if rec.expensive and rec.expensive.results then complete_res[#complete_res+1]=rec.expensive.results end
		local res_list = {}
		for _,res_group in pairs(complete_res) do
			for _,res in pairs(res_group) do
				if res.amount_min and (res.amount_min+res.amount_max)%2==1 then
					double = true
				end
			end
			
			for _,res in pairs(res_group) do
				if res.type or res.name then
					local cnst = 1
					if double then cnst=2 end
					res_list[res.name] = {probability=res.probability}
					local am = res.amount
					if res.amount_min then
						res_list[res.name].spread = 2*(res.amount_max-res.amount_min)/(res.amount_min+res.amount_max)
						am = (res.amount_min+res.amount_max)/2
					end
					res.amount = am*cnst
					res.amount_min = nil
					res.amount_max = nil
					res.probability = nil
				elseif double then
					res[2]=res[2]*2
				end
			end
		end
		if double then
			local complete_ing = {}
			if rec.ingredients then complete_ing[#complete_ing+1]=rec.ingredients end
			if rec.normal and rec.normal.ingredients then complete_ing[#complete_ing+1]=rec.normal.ingredients end
			if rec.expensive and rec.expensive.ingredients then complete_ing[#complete_ing+1]=rec.expensive.ingredients end
			
			for _,ing_group in pairs(complete_ing) do
				for _,ing in pairs(ing_group) do
					if ing.type then
						ing.amount=ing.amount*2
					else
						ing[2]=ing[2]*2
					end
				end
			end
		end
		
		local new_rec = create_compression_recipe(rec)
		if new_rec then
			for _, res_group in pairs({new_rec.normal.results,new_rec.expensive.results}) do
				for _,res in pairs(res_group) do
					if res_list[string.sub(res.name,string.len("compressed-")+1,string.len(res.name))] then
						local list =res_list[string.sub(res.name,string.len("compressed-")+1,string.len(res.name))]
						if list.spread then
							local am = res.amount
							local am_min = omni.lib.round(am*(1-list.spread/2))
							local am_max = omni.lib.round(am*(1+list.spread/2))
							
							if am_min < 1 then
								am_max = am_max-am_min+1
								am_min=1
							end
							
							res.amount_min = am_min
							res.amount_max = am_max
						end
						res.probability = list.probability
					end
				end
			end
		else
			log("you fucked up big time with this recipe: "..rec.name)
		end
		if new_rec then data:extend({new_rec}) end
		
	end
end