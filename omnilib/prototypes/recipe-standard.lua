if not omni then omni={} end
if not omni.marathon then omni.marathon={} end

standardized_recipes={}

local function set_loc_name(item) --pass full table
	if item then
		if item.localised_name then
			loc_name = table.deepcopy(item.localised_name)
		--elseif item.type == "entity" and item.place_result then
		--	loc_name = {"entity-name."..item.place_result}
		elseif item.place_result then
			loc_name = {"entity-name."..item.name}
		elseif item.type == "fluid" then
			loc_name = {"fluid-name."..item.name}
		elseif string.find(item.name,"equipment") then
			loc_name = {"equipment-name."..item.name}
		else --should cover items, tools, capsules etc...
			loc_name = {"item-name."..item.name}
 		end
	end
return loc_name
end

function omni.marathon.standardise(recipe)
	if recipe == nil then return nil end
	--Set table parts if they don't already exist
	if not recipe.expensive then recipe.expensive={} end
	if not recipe.normal then recipe.normal={} end
	---------------------------------------------------------------------------
	-- Ingredient Standarisation
	---------------------------------------------------------------------------
	local ingredients = {}
	if recipe.normal.ingredients and recipe.expensive.ingredients and not recipe.ingredients then
		--skip
	else
		local norm={}
		local expens={}
		-- check if each exists and parse to set part of the script
		if recipe.normal.ingredients then
			norm = table.deepcopy(recipe.normal.ingredients)
		else --if recipe.ingredients
			norm = table.deepcopy(recipe.ingredients)
		end
		if recipe.expensive.ingredients then
			expens = table.deepcopy(recipe.expensive.ingredients)
		else --if recipe.ingredients
			expens = norm
		end
		--set normal and expensive ingredients
		ingredients = {expensive=expens,normal=norm}
		
		--reset and repopulate ingredients list ensuring tags exist
		recipe.normal.ingredients={}
		recipe.expensive.ingredients={}
		for _, diff in pairs({"normal","expensive"}) do
			if ingredients[diff] then
				for i,ing in pairs(ingredients[diff]) do
					local temp = {}
					if ing.name then
						temp = {type = ing.type, name=ing.name,amount=ing.amount,maximum_temperature=ing.maximum_temperature,minimum_temperature=ing.minimum_temperature,fluidbox_index=ing.fluidbox_index}
						if not temp.type then temp.type ="item" end
					else
						temp = {type = "item", name=ing[1],amount=ing[2]}
					end
					recipe[diff].ingredients[i] = temp -- table.deepcopy(temp) why deepcopy?table.deepcopy(temp)
				end
			end
		end
		--nil out non-standard ingredients
		recipe.ingredients = nil
	end
	---------------------------------------------------------------------------
	-- Results Standarisation
	---------------------------------------------------------------------------
	local results = {}
	--check if already normalised before jumping in
	if recipe.normal.results and recipe.expensive.results and not (recipe.results or recipe.result) then
		--skip
	else
		local norm={}
		local expens={}
		-- check if each exists and parse to set part of the script
		if recipe.normal.results then
			norm = table.deepcopy(recipe.normal.results)
		elseif recipe.normal.result then
			norm = {{recipe.normal.result,recipe.normal.result_count or 1}}
			--if not norm[1][2] then norm[1][2]=1 end
		elseif recipe.results then
			norm = table.deepcopy(recipe.results)
		elseif recipe.result then
			norm = {{recipe.result,recipe.result_count or 1}}
		end

		if recipe.expensive.results then
			expens = table.deepcopy(recipe.expensive.results)
		elseif recipe.expensive.result then
			expens = {{recipe.expensive.result,recipe.expensive.result_count or 1}}
			--if not expens[1][2] then expens[1][2]=1 end
		elseif recipe.results then
			expens = table.deepcopy(recipe.results)
		elseif recipe.result then
			expens = {{recipe.result,recipe.result_count or 1}}
		end
		--set normal and expensive results
		results = {expensive=expens,normal=norm}
		
		--reset and repopulate ingredients list ensuring tags exist
		recipe.normal.results={}
		recipe.expensive.results={}
		for i, diff in pairs({"normal","expensive"}) do
			if results[diff] then
				for j,res in pairs(results[diff]) do
					local temp = {}
					if res.name then
						temp = {type = res.type, name=res.name,amount=res.amount,probability = res.probability, amount_min = res.amount_min, amount_max = res.amount_max,temperature=res.temperature,fluidbox_index=res.fluidbox_index}
						if not temp.type then temp.type ="item" end
					else
						temp = {type = "item", name=res[1],amount=res[2]}
					end
					recipe[diff].results[j] = temp -- table.deepcopy(temp) why deepcopy?
				end
			end
		end
		--nil out non-standard ingredients
		recipe.result = nil
		recipe.result_count = nil
		recipe.results = nil
	end
	---------------------------------------------------------------------------
	-- Localisation
	---------------------------------------------------------------------------
	--if no localised name, seach for one in main product or first ingredient in the list
	if recipe.localized_name == nil and type(recipe.localised_name) ~= "table" then
		local it={}
		if recipe.main_product and recipe.main_product~="" then
			it = omni.lib.find_prototype(recipe.main_product)
		elseif recipe.normal.main_product and recipe.normal.main_product~="" then
			it = omni.lib.find_prototype(recipe.normal.main_product)
		elseif #recipe.normal.results>=1 then
			it = omni.lib.find_prototype(recipe.normal.results[1].name)
		else--if not find result 1 or main product
			it = recipe.name --hail mary
		end
		recipe.localised_name=set_loc_name(it)
	end
	---------------------------------------------------------------------------
	-- Move Flags to difficulty zone
	---------------------------------------------------------------------------
	for _, flag in pairs({"hidden", "enabled", "allow_decomposition", "hide_from_player_crafting", "allow_as_intermediate", "allow_intermediates"}) do
		for _, difficulty in pairs({"normal", "expensive"}) do
			-- is this adding all of the flags, or only the ones that already exist?
			if recipe[difficulty][flag] == nil then
				recipe[difficulty][flag] = recipe[flag]
			end
		end
	end
	-- remove settings outside of difficulty
	recipe.hidden = nil
	recipe.enabled = nil
	---------------------------------------------------------------------------
	-- Subgroup setting
	---------------------------------------------------------------------------
	if not recipe.subgroup and recipe.main_product and recipe.main_product ~="" then
		-- group based in main product settings
		local it = omni.lib.find_prototype(recipe.main_product)
		if it then
			if it.subgroup then
				recipe.subgroup = it.subgroup
			elseif it.type=="fluid" then
				recipe.subgroup="fluid-recipes"
			end
		end
	elseif not recipe.subgroup and #recipe.normal.results == 1 then
		-- group based on single result settings
		local it = omni.lib.find_prototype(recipe.normal.results[1].name)
		if it then
			if it.subgroup then
				recipe.subgroup = it.subgroup
			elseif it.type=="fluid" then
				recipe.subgroup="fluid-recipes"
			end
		end
	end
	---------------------------------------------------------------------------
	-- Misc setting properties
	---------------------------------------------------------------------------
	if recipe.normal.category == nil then recipe.normal.category = recipe.category end
	if recipe.expensive.category == nil then recipe.expensive.category = recipe.category end

	if recipe.normal.energy_required == nil then recipe.normal.energy_required = recipe.energy_required or 0.5 end
	if recipe.expensive.energy_required == nil then recipe.expensive.energy_required = recipe.energy_required or 0.5 end
	recipe.energy_required = nil

	--if recipe.normal == false then recipe.normal = table.deepcopy(recipe.expensive) end -- really? that is an interesting potential option...

	---------------------------------------------------------------------------
	-- Icons standardisation 
	---------------------------------------------------------------------------
	-- no specific recipe icons
	if not recipe.icon and not recipe.icons then
		if (recipe.main_product and recipe.main_product ~= "") or (recipe.normal.main_product and recipe.normal.main_product ~= "") or (recipe.expensive.main_product and recipe.expensive.main_product ~= "") then
			local item = omni.lib.find_prototype(recipe.main_product or recipe.normal.main_product or recipe.expensive.main_product)
			if item then
				if item.icon then recipe.icon = item.icon end
				if item.icons then recipe.icons = item.icons end
				if item.icon_size then recipe.icon_size = item.icon_size end
			end
		else
			if recipe.result and recipe.result.name then
				res=recipe.result.name
			elseif recipe.result then
				res=recipe.result 
			elseif recipe.results and recipe.results[1] and recipe.results[1].name then
				res=recipe.results[1].name
			elseif 	recipe.normal.results and recipe.normal.results[1] and recipe.normal.results[1].name then
				res=recipe.normal.results[1].name
			else
				res=recipe.name
			end
			local item = omni.lib.find_prototype(res)
			if item then
				if item.icon then recipe.icon = item.icon end
				if item.icons then recipe.icons = item.icons end
				if item.icon_size then recipe.icon_size = item.icon_size end
			end
		end
	elseif recipe.icon and recipe.icon ~= "" then
		recipe.icons = {{icon=recipe.icon,icon_size=recipe.icon_size}}
		recipe.icon=nil 
	end
	---------------------------------------------------------------------------
	-- Main Product Check
	---------------------------------------------------------------------------
	-- this will run each time a main product is found
	if (recipe.main_product and recipe.main_product ~= "") or (recipe.normal.main_product and recipe.normal.main_product ~= "") or (recipe.expensive.main_product and recipe.expensive.main_product ~= "") then  	
		-- check if main_product is in results list
		local mp_check=false
		if recipe.main_product and recipe.main_product ~= "" then
			if not recipe.normal.main_product then recipe.normal.main_product=recipe.main_product end
			if not recipe.expensive.main_product then recipe.expensive.main_product=recipe.main_product end
			recipe.main_product=nil
		end
		local mp = recipe.normal.main_product
		for j,res in pairs(recipe.normal.results) do
			local temp = {}
			if res.name and res.name==mp then
				mp_check=true
			end
		end
		if mp_check==false then -- may need a more sophisticated main_product checking system 
			recipe.normal.main_product=nil
			recipe.expensive.main_product=nil
		end
	end
	--clobber main product in all cases regardless?
	--recipe.main_product=nil
	--recipe.normal.main_product=nil
	--recipe.expensive.main_product=nil
	--standardized_recipes[recipe.name] = true
	return table.deepcopy(recipe)
end
