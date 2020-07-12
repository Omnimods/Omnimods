-------------------------------------------------------------------------------
--[[Initialisation and Config Variables]]--
-------------------------------------------------------------------------------
local compress_recipes, uncompress_recipes, compress_items = {}, {}, {}
local item_count = 0
local concentrationRatio = sluid_contain_fluid
--compressed_item_names = {}  --global?
random_recipes = {} --global?
local compressed_item_stack_size = 120 -- stack size for compressed items (not the items returned that is dynamic)
local hcn = {1, 2, 4, 6, 12, 24, 36, 48, 60, 120, 180, 240, 360, 720, 840, 1260, 1680, 2520}
local compress_based_recipe = {}
local compressed_recipes = {}
local new_cat={}
-------------------------------------------------------------------------------
--[[Set-up the functions for compressed recipes]]--
-------------------------------------------------------------------------------
--check if already compressed
local compressed_ingredients_exist = function(ingredients,results)
	if #ingredients > 0 then
		for _, ing in pairs(ingredients) do
			if not omni.lib.is_in_table("compressed-"..ing.name,compressed_item_names) then return false end
		end
	end
	if type(results)=="table" then
		if #results > 0 then
			for _, res in pairs(results) do
				if not omni.lib.is_in_table("compressed-"..res.name,compressed_item_names) then return false end
			end
		end
	else
		if not omni.lib.is_in_table("compressed-"..results,compressed_item_names) then return false end
	end
	return true
end

--stack size of more than 1 function
local more_than_one = function(recipe)
	if recipe.result or (recipe.normal and recipe.normal.result) then
		if recipe.result then
			if type(recipe.result)=="table" then
				if recipe.result[1] then return omni.lib.find_stacksize(recipe.result[1]) > 1
        else return omni.lib.find_stacksize(recipe.result.name) > 1
        end
			else return omni.lib.find_stacksize(recipe.result) > 1
			end
		else
			if type(recipe.normal.result)=="table" then
				if recipe.normal.result[1] then return omni.lib.find_stacksize(recipe.normal.result[1]) > 1
				else return omni.lib.find_stacksize(recipe.normal.result.name) > 1
				end
			else return omni.lib.find_stacksize(recipe.normal.result) > 1
			end
		end
	else
		if (recipe.results and #recipe.results > 1) or (recipe.normal and recipe.normal.results and #recipe.normal.results>1) then 
			return true
		else
			if recipe.results then
				if type(recipe.results[1])=="table" then
					if recipe.results[1][1] then 
						return omni.lib.find_stacksize(recipe.results[1][1]) > 1
					else 
						return omni.lib.find_stacksize(recipe.results[1].name) > 1
					end
				else 
					return omni.lib.find_stacksize(recipe.results[1]) > 1
				end
			elseif recipe.normal.results and #recipe.normal.results > 0 then
				if type(recipe.normal.results[1])=="table" then
					if recipe.normal.results[1][1] then
						return omni.lib.find_stacksize(recipe.normal.results[1][1]) > 1
					elseif omni.lib.find_stacksize(recipe.normal.results[1].name) then 
						return omni.lib.find_stacksize(recipe.normal.results[1].name) > 1
					else 
						return false
					end
				else
					if omni.lib.find_stacksize(recipe.normal.results[1].name) then 
						return omni.lib.find_stacksize(recipe.normal.results[1].name) > 1
					else 
						return false	--log("Something is not right, item  "..recipe.normal.results[1].name.." has no stacksize.")
					end
				end
			else
				return false
			end
		end
	end
end

--category set
local set_category = function(recipe)
  if recipe.normal.category then
    if not data.raw["recipe-category"][recipe.normal.category.."-compressed"] then
      if not omni.lib.is_in_table(recipe.normal.category.."-compressed",new_cat) then
        new_cat[#new_cat+1] = {type = "recipe-category", name = recipe.normal.category.."-compressed"}
      end
    end
    return recipe.normal.category.."-compressed"
  elseif not data.raw["recipe-category"]["general-compressed"] then
    if not omni.lib.is_in_table("general-compressed",new_cat) then
      new_cat[#new_cat+1] = {type = "recipe-category", name = "general-compressed"}
    end
    return "general-compressed"
  end
end

--fluids check, returns true if anything except fluids is present
local not_only_fluids = function(recipe)
	local all_ing = {}
	local all_res = {}
	if recipe.normal and recipe.normal.ingredients then
		all_ing=recipe.normal.ingredients
	else
		all_ing=recipe.ingredients
	end
	if recipe.normal and recipe.normal.results then
		all_res=recipe.normal.results
	elseif recipe.results then
		all_res=recipe.results
	elseif recipe.normal and recipe.normal.result then
		all_res=recipe.normal.result
	elseif recipe.result then
		all_res=recipe.result
	end
	if type(all_ing)=="table" then
		for _,ing in pairs(all_ing) do
			if ing[1] or (ing.type ~= "fluid") then return true end
		end
	elseif type(all_ing)=="string" then
		return true
	end
	if type(all_res)=="table" then
		for _,ing in pairs(all_res) do
			if ing[1] or (ing.type ~= "fluid") then return true end
		end
	else
		if type(all_res) == "string" or all_res[1] or all_res.type~="fluid" then
			return true
		end
	end
	return false
end

--checks results for probabilistic returns (probability, amount min, amount max etc)
local not_random = function(recipe)
	local results = {}
	if recipe.normal and recipe.normal.results then
		results = omni.lib.union(recipe.normal.results,recipe.expensive.results or {})
	elseif recipe.results then
		results = recipe.results
	elseif recipe.result then
		return true
	end
	for _,r in pairs(results) do
		if r.amount_min or (r.probability and r.probability > 0) or r.amount_max then
			return false
		end
	end
	return true
end

--splits fluids and solids per "table"
local seperate_fluid_solid = function(collection)
	local fluid = {}
	local solid = {}
	if type(collection) == "table" then
		for _,thing in pairs(collection) do
			if thing.type and thing.type == "fluid" then
				fluid[#fluid+1]=thing
			else
				if type(thing)=="table" then
					if thing.type then
						solid[#solid+1] = thing
					elseif thing[1] then
						solid[#solid+1] = {type="item",name=thing[1],amount=thing[2]}
					elseif thing.name then
						solid[#solid+1] = {type="item",name=thing.name,amount=thing.amount}
					end
				else solid[#solid+1] = {type="item",name=thing[1],amount=1}
				end
			end
		end
	else solid[#solid+1] = {type="item",name=collection,amount=1}
	end
	return {fluid = fluid,solid = solid}
end

--sort and clean up groups of ingredients and results for type processing
function get_recipe_values(ingredients,results)
	local parts={}
	local lng = {0,0}

	local all_ing = seperate_fluid_solid(ingredients)
	local all_res = seperate_fluid_solid(results)

	for _,comp in pairs({all_ing.solid,all_res.solid}) do
		for _,  resing in pairs(comp) do
			parts[#parts+1]={name=resing.name,amount=resing.amount}
		end
	end

	local lcm_rec = 1
	local gcd_rec = 0
	local mult_rec = 1
	local lcm_stack = 1
	local gcd_stack = 0
	local mult_stack = 1
	--calculate lcm of the parts and stacks
	for _, p in pairs(parts) do
		if gcd_rec == 0 then gcd_rec=p.amount
		else gcd_rec = omni.lib.gcd(gcd_rec,p.amount)
		end
		lcm_rec = omni.lib.lcm(lcm_rec,p.amount)
    mult_rec = mult_rec*p.amount
    
		local stacksize = omni.lib.find_stacksize(p.name)
		if gcd_stack == 0 then gcd_stack=stacksize
		else gcd_stack = omni.lib.gcd(gcd_stack,stacksize)
		end
		lcm_stack = omni.lib.lcm(lcm_stack,stacksize)
		mult_stack = mult_stack*stacksize
	end
	--lcm_rec = mult_rec/gcd_rec
	--lcm_stack = mult_stack/gcd_stack
	local new_parts = {}
	local new_stacks = {}
	for i, p in pairs(parts) do
		new_parts[i]={name = p.name, amount = lcm_rec/p.amount}
		local stacksize = omni.lib.find_stacksize(p.name)
		new_stacks[i]={name = p.name, amount = lcm_stack/stacksize}
	end
	local new = {}
	local new_gcd = 0
	local new_lcm = lcm_rec*lcm_stack--rec_max*stack_max/omni.lib.gcd(rec_max,stack_max)
	for i,p in pairs(new_parts) do
		new[i]=new_lcm*new_stacks[i].amount/new_parts[i].amount
		new[i]=math.max(math.floor(new[i]+0.5),1) --round and assume at least 1
		if new_gcd == 0 then
			new_gcd = new[i]
		else
			new_gcd=omni.lib.gcd(new_gcd,new[i])
		end
	end
	for i,p in pairs(new_parts) do
		new[i]=new[i]/new_gcd
	end

	local total_mult = new[1]*omni.lib.find_stacksize(parts[1].name)/parts[1].amount
	local newing = {}
	for i=1,#all_ing.solid do
		newing[#newing+1]={type="item",name="compressed-"..parts[i].name,amount=new[i]}
	end
	for _,f in pairs(all_ing.fluid) do
		newing[#newing+1]={type="fluid",name="concentrated-"..f.name,amount=f.amount*total_mult/concentrationRatio, minimum_temperature = f.minimum_temperature, maximum_temperature = f.maximum_temperature}
	end
	local newres = {}
	for i=1,#all_res.solid do
		newres[#newres+1]={type="item",name="compressed-"..parts[#all_ing.solid+i].name,amount=new[#all_ing.solid+i]}
	end
	for _,f in pairs(all_res.fluid) do
		newres[#newres+1]={type="fluid",name="concentrated-"..f.name,amount=f.amount*total_mult/concentrationRatio, temperature = f.temperature}
	end
	return {ingredients = newing , results = newres}
end

local supremumTime = settings.startup["omnicompression_too_long_time"].value
--output(results) adjustments
function adjustOutput(recipe)
	for _, dif in pairs({"normal","expensive"}) do
		local gcd = 0
		local tooMuchIng = nil
		for _, ing in pairs(recipe[dif].ingredients) do
			if ing.type ~= "fluid" then
				if gcd == 0 then
					gcd = ing.amount
				else
					gcd = omni.lib.gcd(gcd,ing.amount)
				end
				if ing.amount > 65535 then
					if not tooMuchIng then
						tooMuchIng = ing.amount
					else
						tooMuchIng = math.max(ing.amount,tooMuchIng)
					end
				end
			end
    end
    --adjust div to account for results too
    for _, res in pairs(recipe[dif].results) do
      if res.type ~= "fluid" then
        if gcd == 0 then --highly unlikely after dealing with the ingredients
          gcd = res.amount
        else
          gcd = omni.lib.gcd(gcd,res.amount)
        end
      end
    end
    --now we play with GCD > 0
		if gcd > 0 then
			local divisors = omni.lib.divisors(gcd)
			local div = nil
			if recipe[dif].energy_required > supremumTime or tooMuchIng then
				for i=1,#divisors do
					if recipe[dif].energy_required/divisors[i]<supremumTime and (tooMuchIng == nil or tooMuchIng/divisors[i] < 65535) then
						if div and div > divisors[i] then
							div=divisors[i]
						elseif not div then
							div=divisors[i]
						end
					end
				end
      end
			for _,res in pairs(recipe[dif].results) do
				if div then
					res.amount = res.amount/div
				end
				if res.type == "item" then
					--if res.amount_max then res.amount = (res.amount_max+res.amount_min)/2 end
					--if res.probability then res.amount = res.amount*res.probability end
					while res.amount > compressed_item_stack_size do
						local add = table.deepcopy(res)
						add.amount = compressed_item_stack_size
						res.amount = res.amount - compressed_item_stack_size
						table.insert(recipe[dif].results,add)
					end
					if res.amount and math.floor(res.amount) ~= res.amount and res.amount > 1 then
						local add = table.deepcopy(res)
						add.probability = res.amount-math.floor(res.amount)
						res.amount = math.floor(res.amount)
						add.amount = 1
						table.insert(recipe[dif].results,add)
					end
				end
			end
			if div then
				for _, ing in pairs(recipe[dif].ingredients) do
          ing.amount = ing.amount/div
				end
				recipe[dif].energy_required=recipe[dif].energy_required/div
			end
		end
  end
	return recipe
end
-----------------------------------------------------------------
-- IS VOID? check for the word void in recipe name or products --
-----------------------------------------------------------------
local is_void = function(recipe)
  if string.find(recipe.name, "void") or string.find(recipe.name, "flaring") or string.find(recipe.name, "incineration")then
    return true
  elseif recipe.normal.results and string.find(recipe.normal.results[1].name, "void") then
    return true
  end
  return false
end

----------------------------------
-- GENERATOR FLUID: duplicates? --
----------------------------------
local generatorFluidRecipes = {}
--generator styled recipes
for _, gen in pairs(data.raw.generator) do
	if not string.find(gen.name,"creative") then
		if not gen.burns_fluid and gen.fluid_box and gen.fluid_box.filter then
			if not generatorFluidRecipes[gen.fluid_box.filter] then
				generatorFluidRecipes[gen.fluid_box.filter]={name=gen.fluid_box.filter,temperature={},recipes = {}}
				generatorFluidRecipes[gen.fluid_box.filter].temperature[1]={min = gen.fluid_box.minimum_temperature, max=gen.maximum_temperature}
			else
				table.insert(generatorFluidRecipes[gen.fluid_box.filter].temperature,{min = gen.fluid_box.minimum_temperature, max=gen.maximum_temperature})
			end
		end
	end
end
-------------------------------------------------------------------------------
--[[Create Compressed Versions of Each Recipe]]--
-------------------------------------------------------------------------------
function create_compression_recipe(recipe)
  if not omni.lib.is_in_table(recipe.name,excluded_recipes) then --not excluded
    if not string.find(recipe.name,"creative") and not is_void(recipe) then --not creative mod or void
      if (recipe.normal.results and #recipe.normal.results > 0) then --ingredients.normal.results and 1+
        if (more_than_one(recipe) or omni.lib.is_in_table(recipe.name,include_recipes)) then --stack size>1 or include anyway?
          local comrec={} --set basis to zero
          local new_cat = set_category(recipe) or "crafting-compressed" --fallback should not be needed
          local icons = omni.compression.add_overlay(recipe,"compress")
          ------------------------------------
          -- **Localisation** --
            -- CLEARLY BROKEN
          ------------------------------------
          local loc = omni.compression.CleanName(recipe.name) --set default
          if recipe.localised_name then
            loc = recipe.localised_name
          elseif recipe.main_product then --other cases?
            item = omni.lib.find_prototype(recipe.main_product)
            if item and item.localised_name then
              loc = item.localised_name
            else
              loc = omni.compression.CleanName(item.name)
            end
          elseif recipe.normal.main_product then
            item=omni.lib.find_prototype(recipe.normal.main_product)
            if item and item.localised_name then
              loc = item.localised_name 
            else
              loc=omni.compression.CleanName(item.name)
            end              
          end
          
          --subgroup check--already standardised, there should be no subgroup in its own
          local subgr = {regular = {}}
          if recipe.subgroup or recipe.normal.subgroup then --already standardised, there should be no subgroup in its own
            if recipe.subgroup then
              subgr.regular = recipe.subgroup
              subgr.normal = recipe.subgroup
              subgr.expensive = recipe.subgroup
            else
              subgr.normal = recipe.normal.subgroup
              subgr.expensive = recipe.expensive.subgroup
            end
          else
            subgr.normal = subgr.regular or "crafting" --set as default "crafting"
            subgr.expensive = subgr.regular or "crafting" --set as default "crafting"
          end

          if not_random(recipe) then
            --log(serpent.block(recipe.name .. " not_random"))
            -------------------------------------------------------------------------------
            --first conditional-- 
              --contains solids and results with no probability--
            -------------------------------------------------------------------------------
            if not_only_fluids(recipe) then
              --log(serpent.block(recipe.name .. " not_only_fluids"))
              ------------------------------------
              -- **Set-up required parameters** --
              ------------------------------------
              local parts = {}
              local res = {}
              local ing = {}
              local gcd = {normal = 0, expensive = 0}
              local generatorfluid = nil
              -----------------------------------
              -- **Find GCD from base recipe** --
              -----------------------------------
              --set ingredient and result tables from recipe
              ing={normal=table.deepcopy(recipe.normal.ingredients),expensive=table.deepcopy(recipe.expensive.ingredients)}
              res={normal=table.deepcopy(recipe.normal.results),expensive=table.deepcopy(recipe.expensive.results)}
              --log(serpent.block(ing))
              --log(serpent.block(res))
              --GCD checks for each recipe
                --iterates through each ingredient to find the 2 gcd variables {gcd[norm],gcd[exp]} these are calculated across both ingredients and results            
              for _,dif in pairs({"normal","expensive"}) do
                for _,ingres in pairs({"ingredients","results"}) do
                  if #recipe[dif][ingres] > 0 then
                    for _,component in pairs(recipe[dif][ingres]) do
                      --temp fix for non-standard stuff sneaking through
                      if not component.amount then --only basic stuff
                        log(serpent.block(recipe.name .. ": BEFORE"))
                        log(serpent.block(component))
                        local name=component[1]
                        local amount=component[2]
                        component = {type = "item", name = name, amount = amount} --force standard if incorrect
                        log("AFTER")
                        log(serpent.block(component))
                      end
                      if component.type ~= "fluid" then
                        local amount = math.max(math.floor(component.amount+0.5),1) --ensure no decimals on items
                        if gcd[dif] == 0 then
                          gcd[dif] = amount
                        else
                          gcd[dif] = omni.lib.gcd(gcd[dif], amount)
                        end
                      end
                      if ingres=="results" and component.type == "fluid" and generatorFluidRecipes[component.name] then
                        generatorfluid=component.name
                      end
                    end
                  end
                end
              end
              --set new amounts based on GCD calculated from above
              for _,dif in pairs({"normal","expensive"}) do
                for _,ingres in pairs({ing,res}) do
                  for _,component in pairs(ingres[dif]) do
                    if not component.amount then --duplicate of above, seems the fix is not parsing out
                      local name=component[1]
                      local amount=component[2]
                      component = {type = "item", name = name, amount = amount} --force standard if incorrect
                    end
                    component.amount=math.min(component.amount/gcd[dif],65535) --set max cap (in case something slips through)
                  end
                end
              end

              ------------------------------------------
              -- **Check if compressed solids exist** --
              ------------------------------------------
              local check = {{seperate_fluid_solid(ing.normal),seperate_fluid_solid(res.normal)},{seperate_fluid_solid(ing.expensive),seperate_fluid_solid(res.expensive)}}
              --log(serpent.block(check))
              if compressed_ingredients_exist(check[1][1].solid,check[1][2].solid) and compressed_ingredients_exist(check[2][1].solid,check[2][2].solid) then
                local new_val_norm = get_recipe_values(ing.normal,res.normal)
                local new_val_exp = get_recipe_values(ing.expensive,res.expensive)
                local mult = {}
                --grab new ingredient costs
                if check[1][1].solid[1] then
                  mult = {
                    normal    = new_val_norm.ingredients[1].amount/check[1][1].solid[1].amount*omni.lib.find_stacksize(check[1][1].solid[1].name),
                    expensive = new_val_exp.ingredients[1].amount/check[2][1].solid[1].amount*omni.lib.find_stacksize(check[2][1].solid[1].name)
                  }
                else
                  mult = {
                    normal    = new_val_norm.results[1].amount/check[1][2].solid[1].amount*omni.lib.find_stacksize(check[1][2].solid[1].name),
                    expensive = new_val_exp.results[1].amount/check[2][2].solid[1].amount*omni.lib.find_stacksize(check[2][2].solid[1].name) 
                  }
                end
                --new crafting time calculations
                local tid = {}
                if recipe.normal and recipe.normal.energy_required then
                  tid = {normal = recipe.normal.energy_required*mult.normal,expensive = recipe.expensive.energy_required*mult.expensive}
                else
                  tid = {normal = mult.normal,expensive = mult.expensive}
                end
                tid.normal = tid.normal/gcd.normal
                tid.expensive = tid.expensive/gcd.expensive
                --------------------------------------
                -- **set up basics for new recipe** --
                --------------------------------------
                local r = {
                  type = "recipe",
                  icons = icons,
                  icon_size = 32, -- should always be 32 with the icon_overlay script
                  name = recipe.name.."-compression",
                  localised_name = {"recipe-name.compressed-recipe",loc},
                  enabled = false,
                  hidden = recipe.hidden,
                  normal = {
                    ingredients = new_val_norm.ingredients,
                    results = new_val_norm.results,
                    energy_required = tid.normal,
                    subgroup = subgr.normal
                  },
                  expensive = {
                    ingredients = new_val_exp.ingredients,
                    results = new_val_exp.results,
                    energy_required = tid.expensive,
                    subgroup = subgr.expensive
                  },
                  category = new_cat,
                  subgroup = subgr.regular,
                  order = recipe.order,
                }
                -------------------------------------------
                -- **Normalised stack building setting** --
                -------------------------------------------
                if settings.startup["omnicompression_normalize_stacked_buildings"].value then
                  for _,dif in pairs({"normal","expensive"}) do
                    if #r[dif].results == 1 and omni.lib.find_entity_prototype(string.sub(r[dif].results[1].name,string.len("compressed-")+1,string.len(r[dif].results[1].name))) then
                      for _,ing in pairs(r[dif].ingredients) do
                        ing.amount = omni.lib.round_up(ing.amount/r[dif].results[1].amount)
                      end
                      r[dif].energy_required = r[dif].energy_required/r[dif].results[1].amount
                      r[dif].results[1].amount=1
                    end
                  end
                end
                --------------------------------------------------
                -- **set up other properties from base recipe** --
                --------------------------------------------------
                if r.main_product and r.main_product ~= "" then
                  if not data.raw.fluid[r.main_product] then
                    r.main_product="compressed-"..r.main_product --set correct name for solid
                  else
                    r.main_product="concentrated-"..r.main_product --set correct name for fluid
                  end
                end
                if #r.normal.results==1 then r.normal.main_product = r.normal.results[1].name end
                if #r.expensive.results==1 then r.expensive.main_product = r.expensive.results[1].name end
                r.normal.hidden = recipe.normal.hidden
                r.expensive.enabled = false
                r.expensive.hidden = recipe.expensive.hidden
                r.expensive.category = new_cat
                r.subgroup=r.subgroup or subgr.regular
                r.normal.subgroup = r.normal.subgroup or subgr.normal
                r.expensive.subgroup = r.expensive.subgroup or subgr.expensive
                for _, module in pairs(data.raw.module) do
                  if module.limitation then
                    for _,lim in pairs(module.limitation) do
                      if lim==recipe.name then
                        table.insert(module.limitation, r.name)
                        break
                      end
                    end
                  end
                end
                if generatorfluid then
                  table.insert(generatorFluidRecipes[generatorfluid].recipes,adjustOutput(r))
                end
                comrec=adjustOutput(r)
              else
                --log(serpent.block(no ingredients or results found in compressed form))
              end
            -------------------------------------------------------------------------------
            --second conditional-- 
              --contains only fluids and results with no probability--
            -------------------------------------------------------------------------------
            else --not not_only_fluids(recipe)
              --log(serpent.block(recipe.name .. " only_fluids"))
              --------------------------------------------------
              -- **Copy base recipe** --
                -- no stack size shenanigans required for fluids
              --------------------------------------------------
              local r = table.deepcopy(recipe)

              r.name = r.name.."-compression"
              r.localised_name = {"recipe-name.compressed-recipe",loc}
              r.icon = nil
              r.icons = icons
              r.icon_size=32
              for _, dif in pairs({"normal","expensive"}) do
                r[dif].category=new_cat
                r[dif].energy_required = concentrationRatio*r[dif].energy_required
                for _,ingres in pairs({"ingredients","results"}) do
                  for i,item in pairs(r[dif][ingres]) do
                    r[dif][ingres][i].name="concentrated-"..r[dif][ingres][i].name
                  end
                end
              end
              comrec=r
            end
            -------------------------------------------------------------------------------
            --final adjustments--
              --tags, categories, grouping
            -------------------------------------------------------------------------------
            if comrec and comrec.name and comrec.type =="recipe" then
              if settings.startup["omnicompression_one_list"].value then
                comrec.subgroup = "compressor-".."items"
                if comrec.normal then comrec.normal.subgroup = "compressor-".."items" end
                if comrec.expensive then comrec.expensive.subgroup = "compressor-".."items" end
              end
              comrec.normal.hidden = recipe.normal.hidden
              comrec.normal.enabled = false
              comrec.normal.main_product = nil
              comrec.expensive.main_product = nil
              comrec.expensive.enabled = false
              comrec.enabled=false
              comrec.category=new_cat
              comrec.main_product = nil
              return comrec
            else
              return nil --should not
            end
          else --log(serpent.block(recipe.name .. " random still"))
          end
        else --log(serpent.block(recipe.name .. " stack_size = 1"))
        end
      else --log(serpent.block(recipe.name .. " results < 1"))
      end
    else --log(serpent.block(recipe.name .. " has creative or void"))
    end
  else --log(serpent.block(recipe.name .. " excluded")) 
  end
end
-------------------------------------------------------------------------------
--[[VOID CREATION RECIPE]]--
-------------------------------------------------------------------------------
local create_void = function(recipe)
  local continue = false
  local prefix = "compressed-"
  --local prob = 1
  if not omni.lib.is_in_table(recipe.name,excluded_recipes) then --not excluded
  if not more_than_one(recipe) then --add in exclusion lists
    for _, dif in pairs({"normal","expensive"}) do
      if #recipe[dif].results == 1 and recipe[dif].results[1].type=="item" then
        if #recipe[dif].ingredients == 1 and recipe[dif].ingredients[1].type == "fluid" and
        recipe[dif].results[1].probability and recipe[dif].results[1].probability == 0 then
          continue = true
          prefix = "concentrated-"
        elseif #recipe[dif].ingredients == 1 and recipe[dif].ingredients[1].type == "item" then --no probability on solids?
          continue = true
        end
      elseif #recipe[dif].results == 0 or (recipe[dif].results[1] and (string.find(recipe[dif].results[1].name,"void") or string.find(recipe[dif].results[1], "flaring") or string.find(recipe[dif].results[1], "incineration"))) then
        --capture stragglers doing odd things
        --double check fluid...
        if recipe.normal.ingredients[1].type == "fluid" then
          prefix = "concentrated-"
        end
        continue = true
      end
    end
  end
	if continue == true then
		local icons = omni.compression.add_overlay(recipe,"compress")
		local new_cat = "crafting-compressed"
		if recipe.normal.category then new_cat = recipe.normal.category.."-compressed" end
		if recipe.normal.category and not data.raw["recipe-category"][recipe.normal.category.."-compressed"] then
			data:extend({{type = "recipe-category", name = recipe.normal.category.."-compressed"}})
		elseif not data.raw["recipe-category"]["general-compressed"] then
			data:extend({{type = "recipe-category", name = "general-compressed"}})
		end
    local new_rc = table.deepcopy(recipe)
		new_rc.name = recipe.name.."-compression"
    new_rc.category = new_cat
		new_rc.normal.ingredients[1].name = prefix ..new_rc.normal.ingredients[1].name
    new_rc.expensive.ingredients[1].name = prefix ..new_rc.expensive.ingredients[1].name
    --new_rc.normal.results[1].probability = 0 --set to never actually give
    --new_rc.expensive.results[1].probability = 0 --set to never actually give
    if string.find(recipe.name,"car") then
      log(serpent.block(new_rc))
    end
		return table.deepcopy(new_rc)
	end
	return nil
end
end
-------------------------------------------------------------------------------
--[[CALL FUNCTION FOR GENERAL RECIPES]]--
-------------------------------------------------------------------------------
--call the recipe creation script, splitting off the randomised recipes and void recipes for further processing
log("start recipe compression")
for _,recipe in pairs(data.raw.recipe) do
  --if not already compressed
  if string.find(recipe.name,"compress") == nil and string.find(recipe.name,"concent") == nil then
    if not mods["omnimatter_marathon"] then omni.marathon.standardise(recipe) end --ensure standardised
    if recipe.subgroup ~= "y_personal_equip" then --exclude yuoki's personal equipment subgroup
      --check for void and swap it to the void system in place of compression_recipe
      local rc = create_compression_recipe(recipe) --call create recipe
      -- the main exclusions are added in that function since it is also called with the random recipes
      if not rc and is_void(recipe) then
        --should create void recipes in place of non-void
        rc = create_void(recipe)
      end
      if rc then
        compress_based_recipe[#compress_based_recipe+1] = table.deepcopy(rc)
      else
        if not not_random(recipe) then random_recipes[#random_recipes+1] = recipe.name end
      end
    end
  end
end
-------------------------------------------------------------------------------
--[[DEAL WITH GENERATOR FLUIDS]]-- needed for omnifluid
-------------------------------------------------------------------------------
local multiplier = settings.startup["omnicompression_multiplier"].value

for name,fluid in pairs(generatorFluidRecipes) do
  if string.find(name,"-concentrated-") == nil then --skip if already concentrated, no need to add a tier 2 superconcentrate
    --log("working on fluid "..name)
    for _,rec in pairs(fluid.recipes) do
      for i = 1, settings.startup["omnicompression_building_levels"].value do
        local new = table.deepcopy(rec)
        new.name = new.name.."-grade-"..i
        local newFluid={}
        for _,dif in pairs({"normal","expensive"}) do
          for j,res in pairs(new[dif].results) do
            if res.name == name then
              new[dif].results[j].amount = new[dif].results[j].amount/ math.pow(multiplier,i)
              newFluid=table.deepcopy(data.raw.fluid[res.name])
              new[dif].results[j].name = res.name.."-concentrated-grade-"..i
            elseif string.sub(res.name,string.len("concentrated-")+1,-1) == name then
              new[dif].results[j].amount = new[dif].results[j].amount/ math.pow(multiplier,i)*60
              newFluid=table.deepcopy(data.raw.fluid[string.sub(res.name,string.len("concentrated-")+1,-1)])
              new[dif].results[j].name = string.sub(res.name,string.len("concentrated-")+1,-1).."-concentrated-grade-"..i
            end
          end
        end

        newFluid.localised_name={"fluid-name.compressed-fluid",{"fluid-name."..newFluid.name},i}
        newFluid.name = newFluid.name.."-concentrated-grade-"..i
        if not newFluid.heat_capacity then
          newFluid.heat_capacity = "1kJ"
        end
        newFluid.heat_capacity = tonumber(string.sub(newFluid.heat_capacity,1,string.len(newFluid.heat_capacity)-2))*math.pow(multiplier,i)..string.sub(newFluid.heat_capacity,string.len(newFluid.heat_capacity)-1,string.len(newFluid.heat_capacity))
        if newFluid.fuel_value then
          newFluid.fuel_value = tonumber(string.sub(newFluid.fuel_value,1,string.len(newFluid.fuel_value)-2))*math.pow(multiplier,i)..string.sub(newFluid.fuel_value,string.len(newFluid.fuel_value)-2,string.len(newFluid.fuel_value))
        end
        if newFluid.icon then
          newFluid.icons = {{icon = newFluid.icon, icon_size = newFluid.icon_size or 32}}
          newFluid.icon=nil
        end
        table.insert(newFluid.icons, {icon = "__omnilib__/graphics/icons/small/lvl"..i..".png", icon_size = 32})
        new.icons = table.deepcopy(newFluid.icons)
        compress_recipes[#compress_recipes+1] = new
        compress_recipes[#compress_recipes+1] = newFluid
      end
    end
  end
end
-------------------------------------------------------------------------------
--[[Module limitation transfers]]--
-------------------------------------------------------------------------------
--Module Limitations
local module_limits = function()
  local max_module_speed = 0
  local max_module_prod = 0
  for _,modul in pairs(data.raw.module) do
    if modul.effect.speed and modul.effect.speed.bonus > max_module_speed then max_module_speed=modul.effect.speed.bonus end
    if modul.effect.productivity and modul.effect.productivity.bonus > max_module_prod then max_module_prod=modul.effect.productivity.bonus end
  end

  --Transfer category set modules
  local max_cat = {}
  local building_list = {"assembling-machine","furnace"}
  for _,cat in pairs(data.raw["recipe-category"]) do
    max_cat[cat.name] = {speed = 0,modules = 0}
    for _,bcat in pairs(building_list) do
      for _,build in pairs(data.raw[bcat]) do
        if omni.lib.is_in_table(cat.name,build.crafting_categories) then
          if build.crafting_speed and build.crafting_speed > tonumber(max_cat[cat.name].speed) then max_cat[cat.name].speed = build.crafting_speed end
          if build.module_specification and build.module_specification.module_slots and build.module_specification.module_slots > tonumber(max_cat[cat.name].modules) then max_cat[cat.name].modules=build.module_specification.module_slots end
          --new.module_specification.module_slots
        end
      end
    end
  end
end
-------------------------------------------------------------------------------
--[[Extend tables]]--
-------------------------------------------------------------------------------
data:extend(new_cat)
if #compress_recipes ~= 0 then
  data:extend(compress_recipes) --for generator fluid recipes
end
if #compress_based_recipe ~= 0 then
  data:extend(compress_based_recipe)
end
module_limits()
--log("Finished compressing recipes")
log("end recipe compression")
