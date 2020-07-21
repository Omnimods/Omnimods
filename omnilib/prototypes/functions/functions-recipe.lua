function omni.lib.get_tech_name(recipename)
	for _,tech in pairs(data.raw.technology) do
		if tech.effects then
			for _,eff in pairs(tech.effects) do
				if eff.type == "unlock-recipe" and eff.recipe ==recipename then
					return tech.name
				end
			end
		end
	end
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

function omni.lib.replace_recipe_ingredient(recipe, ingredient, replacement)
	if data.raw.recipe[recipe] then
		if data.raw.recipe[recipe].ingredient or data.raw.recipe[recipe].ingredients or not data.raw.recipe[recipe].expensive then
			omni.marathon.standardise(data.raw.recipe[recipe])
		end
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
end

function omni.lib.replace_recipe_result(recipe, result, replacement)
	if data.raw.recipe[recipe] then
		if data.raw.recipe[recipe].result or data.raw.recipe[recipe].results or not data.raw.recipe[recipe].expensive then
			omni.marathon.standardise(data.raw.recipe[recipe])
		end
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
end

function omni.lib.add_recipe_ingredient(recipe, ingredient)
	if data.raw.recipe[recipe] then
		local norm = {}
		local expens = {}
		omni.marathon.standardise(data.raw.recipe[recipe])
		if not ingredient.name then
			if type(ingredient)=="string" then
				norm = table.deepcopy({type="item",name=ingredient,amount=1})
				expens = table.deepcopy({type="item",name=ingredient,amount=1})
			elseif ingredient.normal then
				norm = table.deepcopy(ingredient.normal)
				expens = table.deepcopy(ingredient.expensive)
			elseif ingredient[1].name then
				norm = table.deepcopy(ingredient[1])
				expens = table.deepcopy(ingredient[2])
			elseif type(ingredient[1])=="string" then
				norm = table.deepcopy({type="item",name=ingredient[1],amount=ingredient[2]})
				expens = table.deepcopy({type="item",name=ingredient[1],amount=ingredient[2]})
			end
		else
			norm = table.deepcopy(ingredient)
			expens = table.deepcopy(ingredient)
		end
		local found = false
		for i, diff in pairs({"normal","expensive"}) do
			for _, ing in pairs(data.raw.recipe[recipe][diff].ingredients) do
				if ing == norm or ing == expens then
					found = true
				end
			end
		end
		if found == false then
			table.insert(data.raw.recipe[recipe].normal.ingredients,norm)
			table.insert(data.raw.recipe[recipe].expensive.ingredients,expens)
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

function omni.lib.change_recipe_category(recipe, category)
	data.raw.recipe[recipe].category=category
end

--Checks if a recipe contains a specific material as result
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