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

local function set_icons_tab(it) --pass item table to fish icons from
	local ics={}--set icons table as 0
	--icon only
	if it.icon and not it.icons then
		ics[#ics+1] = {icon=it.icon,icon_size=it.icon_size or 32}
	--icons only
	elseif it.icons and not it.icon then
		--check tags and set name and size in each
		for i,ic in pairs(it.icons) do
			ic.icon = ic.icon or ic[1]
			ic.icon_size = ic.icon_size or ic[2] or 32
			ic.scale =ic.scale or 32/ic.icon_size
			ics[#ics+1]=ic
		end
	--both, this implies an error has occurred with the item lookup function
	elseif it.icon and it.icons then
		ics[#ics+1]={icon=it.icon,icon_size=it.icon_size or 32}
	end
	return ics
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
	local ingpass = false
	-- check if every ingredient has a name tag, fluids always have them, items not, find mixed recipes
	if recipe.normal.ingredients and recipe.expensive.ingredients and not recipe.ingredients then
		ingpass = true
		for i,ingred in pairs(recipe.normal.ingredients) do
			if ingred and ingred.name == nil then ingpass = false end
		end
	end
	if ingpass == false then
		local norm={}
		local expens={}
		-- check if each exists and parse to set part of the script
		--.normal.ingredients already exists:
		if recipe.normal.ingredients then
			for i,ingred in pairs(recipe.normal.ingredients) do
				--name tag exists
				if ingred.name and ingred.amount then -- name tag
					norm[i] = ingred
				--no name tag
				else
					norm[i] = {type="item" ,name = ingred[1], amount = ingred[2] or 1}
				end
			end
		else
			for i,ingred in pairs(recipe.ingredients) do
				--name tag exists
				if ingred.name and ingred.amount then
					norm[i] = ingred
				--no name tag
				else
					norm[i] = {type="item" ,name = ingred[1], amount = ingred[2] or 1}
				end
			end
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
						temp = {type = ing.type, name=ing.name, amount=ing.amount, maximum_temperature=ing.maximum_temperature, minimum_temperature=ing.minimum_temperature, fluidbox_index=ing.fluidbox_index}
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
	local respass = false
	--check if already normalised before jumping in
	if recipe.normal.results and recipe.expensive.results and not (recipe.results or recipe.result) then
		respass = true
		for i,res in pairs(recipe.normal.results) do
			if (res and not res.name) or #res ~= 0 then respass = false end
		end
	end

	if respass == false then
		local norm={}
		local expens={}
		-- check if each exists and parse to set part of the script
		--normal.results exists
		if recipe.normal.results then
			--norm = table.deepcopy(recipe.normal.results)
			for i,res in pairs(recipe.normal.results) do
				--name tag exists and there are no subtables without tags (#res)
				if res.name and (res.amount or res.amount_min or res.amount_max) and #res == 0 then
					norm[i] = res
				--no name tag or broken recipe
				else
					norm[i] = {type="item" ,name = res[1], amount = res[2] or 1}
				end
			end
		elseif recipe.normal.result then
			norm = {{type="item" ,name = recipe.normal.result, amount = recipe.normal.result_count or 1}}
		elseif recipe.result then
			norm = {{type="item" ,name = recipe.result, amount = recipe.result_count or 1}}
			--recipe.results only choice left
		else
			for i,res in pairs(recipe.results) do
				--name tag exists
				if res.name and (res.amount or res.amount_min or res.amount_max) and #res == 0 then
					norm[i] = res
				--no name tag
				else
					norm[i] = {type="item" ,name = res[1], amount = res[2] or 1}
				end
			end
		end

		if recipe.expensive.results then
			expens = table.deepcopy(recipe.expensive.results)
		elseif recipe.expensive.result then
			expens = {{recipe.expensive.result,recipe.expensive.result_count or 1}}
			--if not expens[1][2] then expens[1][2]=1 end
		else
			expens = norm
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
						temp = {type = res.type, name=res.name, amount=res.amount, amount_min = res.amount_min, amount_max = res.amount_max, probability = res.probability, temperature=res.temperature, fluidbox_index=res.fluidbox_index}
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

	---------------------------------------------------------------------------
	-- Localisation
	---------------------------------------------------------------------------
	--Update loc. name if there is no localised name or no main product set
	if (type(recipe.localised_name) ~= "table" and recipe.localised_name == nil) or (not recipe.main_product and not recipe.normal.main_product) then
		local it={}
		---------------------------------------------------------------------------
		-- Multiple Results
		---------------------------------------------------------------------------
		if (recipe.results and #recipe.results > 1) or (recipe.normal.results and #recipe.normal.results > 1) then
			--use the main product name if it exists
			if recipe.main_product and recipe.main_product~="" then
				it = omni.lib.find_prototype(recipe.main_product)
			elseif recipe.normal.main_product and recipe.normal.main_product~="" then
				it = omni.lib.find_prototype(recipe.normal.main_product)
			--else use the recipe name
			else
				recipe.localised_name={"recipe-name."..recipe.name}
			end
		---------------------------------------------------------------------------
		-- Single Result
		---------------------------------------------------------------------------
		elseif (recipe.results and #recipe.results == 1) or (recipe.normal.results and #recipe.normal.results == 1) then
			--use the main product name if it exists
			if recipe.main_product and recipe.main_product~="" then
				it = omni.lib.find_prototype(recipe.main_product)
			elseif recipe.normal.main_product and recipe.normal.main_product~="" then
				it = omni.lib.find_prototype(recipe.normal.main_product)
			elseif #recipe.normal.results>=1 then
				it = omni.lib.find_prototype(recipe.normal.results[1].name)
			--if not find result 1 or main product
			else
				it = recipe.name --hail mary
			end
			recipe.localised_name=set_loc_name(it)
		end
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

	---------------------------------------------------------------------------
	-- Icons standardisation
	---------------------------------------------------------------------------
	if recipe.icons and recipe.icon then -- case both, replace icons with icon (assume icon is new)
		--replace recipe.icons with the new
		recipe.icons[1]={icon=recipe.icon,icon_size=recipe.icon_size or 32,icon_mipmaps=recipe.icon_mipmaps or nil}
	elseif recipe.icon then --only icon, set icons
		recipe.icons={{icon=recipe.icon,icon_size=recipe.icon_size or 32,icon_mipmaps=recipe.icon_mipmaps or nil}}
	elseif (not recipe.icons and not recipe.icon) then -- case neither icon or icons (search via product)
		----------------------------------------------
		-- NO RECIPE ICONS, SEARCH FOR MAIN PRODUCT --
		----------------------------------------------
		if (recipe.main_product and recipe.main_product ~= "") then
			res=recipe.main_product
		elseif (recipe.normal.main_product and recipe.normal.main_product ~= "") then
			res=recipe.normal.main_product
		----------------------------------------------
		-- NO MAIN PRODUCT, SEARCH FOR FIRST RESULT --
		----------------------------------------------
		elseif recipe.result and recipe.result.name then
			res=recipe.result.name
		elseif recipe.result then
			res=recipe.result
		elseif recipe.normal.result and recipe.normal.result.name then
			res=recipe.normal.result.name
		elseif recipe.normal.result then
			res=recipe.normal.result
		elseif recipe.results and recipe.results[1] and recipe.results[1].name then
			res=recipe.results[1].name
		elseif 	recipe.normal.results and recipe.normal.results[1] and recipe.normal.results[1].name then
			res=recipe.normal.results[1].name
		else
			res=recipe.name --should never get this far...
		end
		--find res
		local item = omni.lib.find_prototype(res)
		if item then
			recipe.icons=set_icons_tab(item)
		end
	end
	-- nil out non-compliant
	recipe.icon=nil
	return table.deepcopy(recipe)
end
