function omni.lib.set_recipe_ingredients(recipename,...)
    local rec = data.raw.recipe[recipename]
    if rec then
        local arg = {...}
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

        if rec.ingredients then
            rec.ingredients = ing
        end
        if rec.normal and rec.normal.ingredients then
            rec.normal.ingredients = ing
        end
        if rec.expensive and rec.expensive.ingredients then
            rec.expensive.ingredients = ing
        end
	end
end

function omni.lib.set_recipe_results(recipename,...)
    local rec = data.raw.recipe[recipename]
    if rec then
        local arg = {...}
	    local res = {}
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
		    res = omni.lib.union(res,tmp)
	    end
        if rec.result then
            rec.result = nil
            rec.result_count = nil
            if not rec.results then
                rec.normal.results = {}
            end
        end
        if rec.results then
            rec.results = res
        end
        if rec.normal then
            if rec.normal.result then
                rec.normal.result = nil
                rec.normal.result_count = nil
            end
            rec.normal.results = res
        end
        if rec.expensive then
            if rec.expensive.result then
                rec.expensive.result = nil
                rec.expensive.result_count = nil
            end
            rec.expensive.results = res
        end
	end
end

function omni.lib.add_recipe_ingredient(recipename, ingredient)
    local rec = data.raw.recipe[recipename]
    if rec then
		local norm = {}
        local expens = {}
		if not ingredient.name then
			if type(ingredient)=="string" then
				norm = {type="item",name=ingredient,amount=1}
				expens = {type="item",name=ingredient,amount=1}
            elseif ingredient.normal or ingredient.expensive then
                if ingredient.normal then
                    norm = {type=ingredient.normal.type or "item",name=ingredient.normal.name or ingredient.normal[1], amount=ingredient.normal.amount or ingredient.normal[2] or 1}
                else
                    norm = nil
                end
                if ingredient.expensive then
                    expens = {type=ingredient.expensive.type or "item",name=ingredient.expensive.name or ingredient.expensive[1], amount=ingredient.expensive.amount or ingredient.expensive[2] or 1}
                else
                    expens = nil
                end
			elseif ingredient[1].name then
				norm = ingredient[1]
				expens = ingredient[2]
			elseif type(ingredient[1])=="string" then
				norm = {type="item",name=ingredient[1],amount=ingredient[2]}
				expens = {type="item",name=ingredient[1],amount=ingredient[2]}
			end
		else
			norm = ingredient
            expens = ingredient
        end
        local found = false
        --rec.ingredients --If only .normal needs to be modified, keep ingredients, else copy into .normal/.expensive
        if rec.ingredients and  norm ~= expens  then
            rec.normal = {}
            rec.expensive = {}
            rec.normal.ingredients = table.deepcopy(rec.ingredients)
            rec.expensive.ingredients = table.deepcopy(rec.ingredients)
            rec.ingredients = nil
            --move result(s) aswell into diffs
            if rec.result then
                rec.normal.results =  {{type = "item", name = rec.result, amount = rec.result_count or 1}}
                rec.expensive.results = {{type = "item", name = rec.result, amount = rec.result_count or 1}}
                rec.result = nil
                rec.result_count = nil
            end
            if rec.results then
                rec.normal.results = table.deepcopy(rec.results)
                rec.expensive.results = table.deepcopy(rec.results)
                rec.results = nil
            end
        elseif rec.ingredients and norm then
            found = false
            --check if ingredient the ingredient is already used
            for i,ing in pairs(rec.ingredients) do
                 --check if nametags exist (only check ing[i] when no name tags exist)
                if ing.name then
                    if ing.name == norm.name then
                        found = true
                        ing.amount = ing.amount + norm.amount
                        break
                    end
                elseif ing[1] and ing[1] == norm.name then
                    found= true
                    ing[2] = ing[2] + norm.amount
                    break
                end
            end
            if  not found then
                table.insert(rec.ingredients, norm)
            end
        end
        --rec.normal.ingredients
        if norm and rec.normal and rec.normal.ingredients then
            found = false
            for i,ing in pairs(rec.normal.ingredients) do
                --check if nametags exist (only check ing[i] when no name tags exist)
               if ing.name then
                   if ing.name == norm.name then
                       found= true
                       ing.amount = ing.amount + norm.amount
                       break
                   end
               elseif ing[1] and ing[1] == norm.name then
                   found= true
                   ing[2] = ing[2] + norm.amount
                   break
               end
           end
           if  not found then
               table.insert(rec.normal.ingredients, norm)
           end
        end
        --rec.expensive.ingredients
        if expens and rec.expensive and rec.expensive.ingredients then
            found = false
            for i,ing in pairs(rec.expensive.ingredients) do
                --check if nametags exist (only check ing[i] when no name tags exist)
               if ing.name then
                   if ing.name == expens.name then
                       found= true
                       ing.amount = ing.amount + expens.amount
                       break
                   end
               elseif ing[1] and ing[1] == expens.name then
                   found= true
                   ing[2] = ing[2] + expens.amount
                   break
               end
           end
           if  not found then
               table.insert(rec.expensive.ingredients, expens)
           end
        end
	else
		--log(recipe.." does not exist.")
	end
end

function omni.lib.add_recipe_result(recipename, result)
    local rec = data.raw.recipe[recipename]
    if rec then
        local norm = {}
        local expens = {}
	    if not result.name then
	    	if type(result)=="string" then
	    		norm = {type="item",name=result,amount=1}
	    		expens = {type="item",name=result,amount=1}
	    	elseif result.normal or result.expensive then
                if result.normal then
                    norm = {type=result.normal.type or "item",name=result.normal.name or result.normal[1], amount=result.normal.amount or result.normal[2] or 1}
                else
                    norm = nil
                end
                if result.expensive then
                    expens = {type=result.expensive.type or "item",name=result.expensive.name or result.expensive[1], amount=result.expensive.amount or result.expensive[2] or 1}
                else
                    expens = nil
                end
	    	elseif result[1].name then
	    		norm = result[1]
	    		expens = result[2]
	    	elseif type(result[1])=="string" then
	    		norm = {type="item",name=result[1],amount=result[2]}
	    		expens = {type="item",name=result[1],amount=result[2]}
    		end
	    else
	    	norm = result
	    	expens = result
        end
        local found = false
        -- Single result checks
        if rec.result then
            rec.results = {type ="item", name = rec.result, amount = 1}
            rec.result = nil
            rec.result_count = nil
        end
        if rec.normal.result then
            rec.normal.results = {type ="item", name = rec.result, amount = 1}
            rec.normal.result = nil
            rec.normal.result_count = nil
        end
        if rec.expensive.result then
            rec.expensive.results = {type ="item", name = rec.result, amount = 1}
            rec.expensive.result = nil
            rec.expensive.result_count = nil
        end
        --rec.results --If only .normal needs to be modified, keep results, else copy into .normal/.expensive
        if rec.results and norm ~= expens  then
            rec.normal = {}
            rec.expensive = {}
            rec.normal.results = table.deepcopy(rec.results)
            rec.expensive.results = table.deepcopy(rec.results)
            rec.results = nil
            if rec.ingredients then
                rec.normal.results = table.deepcopy(rec.ingredients)
                rec.expensive.results = table.deepcopy(rec.ingredients)
                rec.ingredients = nil
            end
        elseif rec.results and norm then
            found = false
            for i,res in pairs(rec.results) do
                 --check if nametags exist (only check res[i] when no name tags exist)
                if res.name then
                    if res.name == norm.name then
                        found= true
                        res.amount = res.amount + norm.amount
                        break
                    end
                elseif res[1] and res[1] == norm.name then
                    found= true
                    res[2] = res[2] + norm.amount
                    break
                end
            end
            if  not found then
                table.insert(rec.results, norm)
            end
        end
        --rec.normal.results
        if norm and rec.normal and rec.normal.results then
            found = false
            for i,res in pairs(rec.normal.results) do
                --check if nametags exist (only check res[i] when no name tags exist)
               if res.name then
                   if res.name == norm.name then
                       found= true
                       res.amount = res.amount + norm.amount
                       break
                   end
               elseif res[1] and res[1] == norm.name then
                   found= true
                   res[2] = res[2] + norm.amount
                   break
               end
           end
           if  not found then
               table.insert(rec.normal.results, norm)
           end
        end
        --rec.expensive.results
        if expens and rec.expensive and rec.expensive.results then
            found = false
            for i,res in pairs(rec.expensive.results) do
                --check if nametags exist (only check res[i] when no name tags exist)
               if res.name then
                   if res.name == expens.name then
                       found= true
                       res.amount = res.amount + expens.amount
                       break
                   end
               elseif res[1] and res[1] == expens.name then
                   found= true
                   res[2] = res[2] + expens.amount
                   break
               end
           end
           if  not found then
               table.insert(rec.expensive.results, expens)
           end
        end   
	else
		--log(recipe.." does not exist.")
	end
end

function omni.lib.remove_recipe_ingredient(recipename, ingredient)
    local rec = data.raw.recipe[recipename]
    if rec then
	    if rec.ingredients then
	    	for i,ing in pairs(rec.ingredients) do
		    	if ing.name == ingredient or ing[1] == ingredient then
		    		table.remove(rec.ingredients,i)
		    	end
         end
        end
	    if rec.normal and rec.normal.ingredients then
		    for i,ing in pairs(rec.normal.ingredients) do
		    	if ing.name == ingredient or ing[1] == ingredient then
		    		table.remove(rec.normal.ingredients,i)
		    	end
            end
        end
        if rec.expensive and rec.expensive.ingredients then
		    for i,ing in pairs(rec.expensive.ingredients) do
			    if ing.name == ingredient or ing[1] == ingredient then
			    	table.remove(rec.expensive.ingredients,i)
			    end
		    end
        end
    else
        log("Can not remove ingredient "..ingredient..". Recipe "..recipename.." not found.")
    end
end

function omni.lib.remove_recipe_result(recipename, result)
    local rec = data.raw.recipe[recipename]
	if not rec.result and not rec.normal.result then
		if rec.results then
			for i,res in pairs(rec.results) do
				if res.name == result then
                    table.remove(rec.results,i)
                    if rec.normal.main_product and rec.normal.main_product == result then
                        rec.normal.main_product = nil
                    end
                    break
                end   
            end
        end
		if rec.normal and rec.normal.results then
			for i,res in pairs(rec.normal.results) do
				if res.name == result then
                    table.remove(rec.normal.results,i)
                    if rec.normal.main_product and rec.normal.main_product == result then
                        rec.normal.main_product = nil
                    end
                    break
				end
            end
        end
        if rec.expensive and rec.expensive.results then
			for i,res in pairs(rec.expensive.results) do
				if res.name == result then
                    table.remove(rec.expensive.results,i)
                    if rec.expensive.main_product and rec.expensive.main_product == result then
                        rec.expensive.main_product = nil
                    end
                    break
                end
            end
		end
	else
		log("Attempted to remove the only result that recipe "..recipename.." has. Cannot be done")
	end
end

function omni.lib.replace_recipe_result(recipename, result, replacement)
    local rec = data.raw.recipe[recipename]
    if rec then
        local repname = nil
        local repamount = nil
        local reptype = nil
        if type(replacement) == "table" then
            repname = replacement.name or replacement[1]
            repamount = replacement.amount or replacement[2]
            reptype = replacement.type
        else
            repname = replacement
        end
        -- Single result
        if rec.result and rec.result == result then
            rec.result = repname
        end
        if rec.normal and rec.normal.result and rec.normal.result == result then
            rec.normal.result = repname
        end
        if rec.expensive and rec.expensive.result and rec.expensive.result == result then
            rec.expensive.result = repname
        end

        --rec.results
        local ress = {}
        if rec.results then ress[#ress+1] = rec.results end
        if rec.normal and rec.normal.results then ress[#ress+1] = rec.normal.results end
        if rec.expensive and rec.expensive.results then ress[#ress+1] = rec.expensive.results end

        for _,diff in pairs(ress) do
            local found = false
            local num = 0
            --create a new variable that gets reset to repamount for each diff
            local amount = repamount
            --check if the replacement is already an result
            for i,res in pairs(diff) do
                if (res.name or res[1]) == repname then        
                    found = true
                    num=i
                    amount = (repamount or 1) + res.amount or res[2]
                    break
                end
            end

            for i,res in pairs(diff) do
                --check if nametags exist (only check res[i] when no name tags exist)
                if res.name and res.name == result then
                    if found then
                        if diff[num].amount then
                            diff[num].amount = amount          
                        else        
                            diff[num][2] = repamount
                        end
                        diff[i] = nil
                    else
                        res.name = repname
                        res.amount = repamount or res.amount
                        res.type = reptype or res.type  
                    end
                    break
                elseif not res.name and res[1] and res[1] == result then
                    if found then
                        if diff[num].amount then
                            diff[num].amount = amount          
                        else        
                            diff[num][2] = repamount
                        end
                        diff[i] = nil
                    else
                        res[1] = repname
                        res[2] = repamount or res[2]
                    end
                    break
                end
            end
        end
        --Check if the main product was replaced
        if rec.main_product and rec.main_product == result then
            rec.main_product = repname
        end
        if rec.normal and rec.normal.main_product and rec.normal.main_product == result then
            rec.normal.main_product = repname
        end
        if rec.expensive and rec.expensive.main_product and rec.expensive.main_product == result then
            rec.normexpensiveal.main_product = repname
        end
    end
end

function omni.lib.replace_recipe_ingredient(recipename, ingredient, replacement)
	local rec = data.raw.recipe[recipename]
    if rec then
        local repname = nil
        local repamount = nil
        local reptype = nil
        if type(replacement) == "table" then
            repname = replacement.name or replacement[1]
            repamount = replacement.amount or replacement[2]
            reptype = replacement.type
            reptemp = replacement.temperature --use the word "blank" to clobber it
        else
            repname = replacement
        end

        local ings = {}
        if rec.ingredients then ings[#ings+1] = rec.ingredients end
        if rec.normal and rec.normal.ingredients then ings[#ings+1] = rec.normal.ingredients end
        if rec.expensive and rec.expensive.ingredients then ings[#ings+1] = rec.expensive.ingredients end

        for _,diff in pairs(ings) do
            local found = false
            local num = 0
            --create a new variable that gets reset to repamount for each diff
            local amount = repamount
            --check if the replacement is already an ingredient
            for i,ing in pairs(diff) do
                if (ing.name or ing[1]) == repname then        
                    found = true
                    num=i
                    amount = (repamount or 1) + ing.amount or ing[2]
                    break
                end
            end

            for i,ing in pairs(diff) do
                --check if nametags exist (only check ing[i] when no name tags exist)
                if ing.name and ing.name == ingredient then
                    if found then
                        if diff[num].amount then
                            diff[num].amount = amount          
                        else        
                            diff[num][2] = repamount
                        end
                        diff[i] = nil
                    else
                        ing.name = repname
                        ing.amount = repamount or ing.amount
                        ing.type = reptype or ing.type
                        if reptemp == "blank" then
                          ing.temperature = nil
                          ing.maximum_temperature = nil
                          ing.minimum_temperature = nil
                        else
                          ing.temperature = reptemp or ing.temp
                        end
                    end
                    break
                elseif not ing.name and ing[1] and ing[1] == ingredient then
                    if found then
                        if diff[num].amount then
                            diff[num].amount = amount          
                        else        
                            diff[num][2] = repamount
                        end
                        diff[i] = nil
                    else
                        ing[1] = repname
                        ing[2] = repamount or ing[2]
                    end
                    break
                end
            end
        end
	end
end

function omni.lib.multiply_recipe_ingredient(recipename, ingredient, mult)
	local rec = data.raw.recipe[recipename]
    if rec then
        --rec.ingredients
        if rec.ingredients then
            for i,ing in pairs(rec.ingredients) do
                 --check if nametags exist (only check ing[i] when no name tags exist)
                if ing.name then
                    if ing.name == ingredient then
                        ing.amount = omni.lib.round(ing.amount * mult)
                        break
                    end
                elseif ing[1] and ing[1] == ingredient then
                    ing[2] = omni.lib.round(ing[2] * mult)
                    break
                end
            end
        end
        --rec.normal.ingredients
        if rec.normal and rec.normal.ingredients then
            for i,ing in pairs(rec.normal.ingredients) do
                --check if nametags exist (only check ing[i] when no name tags exist)
                if ing.name then
                    if ing.name == ingredient then
                        ing.amount = omni.lib.round(ing.amount * mult)
                        break
                    end
                elseif ing[1] and ing[1] == ingredient then
                    ing[2] = omni.lib.round(ing[2] * mult)
                    break
                end
           end
        end
        --rec.expensive.ingredients
        if rec.expensive and rec.expensive.ingredients then
            for i,ing in pairs(rec.expensive.ingredients) do
                --check if nametags exist (only check ing[i] when no name tags exist)
                if ing.name then
                    if ing.name == ingredient then
                        ing.amount = omni.lib.round(ing.amount * mult)
                        break
                    end
                elseif ing[1] and ing[1] == ingredient then
                    ing[2] = omni.lib.round(ing[2] * mult)
                    break
                end
           end
        end   
	end
end

function omni.lib.multiply_recipe_result(recipename, result, mult)
	local rec = data.raw.recipe[recipename]
    if rec then
        -- Single result
        if rec.result and rec.result == result then
            rec.results = {type = "item", name = rec.result, amount = 1}
            rec.result = nil
            rec.result_count = nil
        end
        if rec.normal and rec.normal.result and rec.normal.result == result then
            rec.normal.results = {type = "item", name = rec.normal.result, amount = 1}
            rec.normal.result = nil
            rec.normal.result_count = nil
        end
        if rec.expensive and rec.expensive.result and rec.expensive.result == result then
            rec.expensive.results = {type = "item", name = rec.expensive.result, amount = 1}
            rec.expensive.result = nil
            rec.expensive.result_count = nil
        end
        --rec.results
        if rec.results then
            for i,res in pairs(rec.results) do
                 --check if nametags exist (only check res[i] when no name tags exist)
                if res.name then
                    if res.name == result then
                        res.amount = omni.lib.round(res.amount * mult)
                        break
                    end
                elseif res[1] and res[1] == result then
                    res[2] = omni.lib.round(res[2] * mult)
                    break
                end
            end
        end
        --rec.normal.results
        if rec.normal and rec.normal.results then
            for i,res in pairs(rec.normal.results) do
                --check if nametags exist (only check res[i] when no name tags exist)
                if res.name then
                    if res.name == result then
                        res.amount = omni.lib.round(res.amount * mult)
                        break
                    end
                elseif res[1] and res[1] == result then
                    res[2] = omni.lib.round(res[2] * mult)
                    break
                end
           end
        end
        --rec.expensive.results
        if rec.expensive and rec.expensive.results then
            for i,res in pairs(rec.expensive.results) do
                --check if nametags exist (only check res[i] when no name tags exist)
                if res.name then
                    if res.name == result then
                        res.amount = omni.lib.round(res.amount * mult)
                        break
                    end
                elseif res[1] and res[1] == result then
                    res[2] = omni.lib.round(res[2] * mult)
                    break
                end
           end
        end   
	end
end

function omni.lib.replace_all_ingredient(ingredient, replacement)
	for _,recipe in pairs(data.raw.recipe) do
		omni.lib.replace_recipe_ingredient(recipe.name, ingredient, replacement)
	end
end

function omni.lib.replace_all_result(result, replacement)
	for _,recipe in pairs(data.raw.recipe) do
		omni.lib.replace_recipe_result(recipe.name, result, replacement)
	end
end

function omni.lib.change_recipe_category(recipe, category)
	data.raw.recipe[recipe].category=category
end

--Checks if a recipe contains a specific material as result
function omni.lib.recipe_result_contains(recipename, itemname)
    local rec = data.raw.recipe[recipename]
    if rec then
        -- Single result
        if rec.result and rec.result == itemname then
            return true
        end
        if rec.normal and rec.normal.result and rec.normal.result == itemname then
            return true
        end
        if rec.expensive and rec.expensive.result and rec.expensive.result == itemname then
            return true
        end
        --rec.results
        if rec.results then
            for i,res in pairs(rec.results) do
                if omni.lib.is_in_table(itemname, res) then return true end
            end
        end
        --rec.normal.results
        if rec.normal and rec.normal.results then
            for i,res in pairs(rec.normal.results) do
                if omni.lib.is_in_table(itemname, res) then return true end
           end
        end
        --rec.expensive.results
        if rec.expensive and rec.expensive.results then
            for i,res in pairs(rec.expensive.results) do
                if omni.lib.is_in_table(itemname, res) then return true end
           end
        end 
        return nil
    end
end

function omni.lib.find_recipe(itemname)
	if type(itemname)=="table" then return itemname elseif type(itemname)~="string" then return nil end
	for _, rec in pairs(data.raw.recipe) do
        if omni.lib.recipe_result_contains(rec.name,itemname) then
			return rec
		end
	end
	--log("Could not find "..item.."'s recipe prototype, check it's type.")
	return nil
end

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
    return nil
end

function omni.lib.remove_recipe_all_techs(recipename)
	for _,tech in pairs(data.raw.technology) do
		if tech.effects then
			for i,eff in pairs(tech.effects) do
				if eff.type == "unlock-recipe" and eff.recipe == recipename then
					table.remove(data.raw.technology[tech.name].effects,i)
				end
			end
		end
	end
end

function omni.lib.replace_recipe_all_techs(recipename,replacement)
	for _,tech in pairs(data.raw.technology) do
		if tech.effects then
			for i,eff in pairs(tech.effects) do
				if eff.type == "unlock-recipe" and eff.recipe == recipename then
					eff.recipe=replacement
				end
			end
		end
	end
end

function omni.lib.enable_recipe(recipename)
    local rec = data.raw.recipe[recipename]
    if rec then
        --in some cases rec.enabled does not exist at all...
        if rec.enabled or not (rec.normal or rec.expensive) then
            rec.enabled = true
        end
        if rec.normal then
            rec.normal.enabled = true
        end
        if rec.expensive then
            rec.expensive.enabled = true
        end
    end
end

function omni.lib.disable_recipe(recipename)
    local rec = data.raw.recipe[recipename]
    if rec then
        --in some cases rec.enabled does not exist at all...
        if rec.enabled or not (rec.normal or rec.expensive) then
            rec.enabled = false
        end
        if rec.normal then
            rec.normal.enabled = false
        end
        if rec.expensive then
            rec.expensive.enabled = false
        end
    end
end
