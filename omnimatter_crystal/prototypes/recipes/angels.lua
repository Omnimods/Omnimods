
--local angel_stupid = {"manganese","chrome"}
--ingredient lists (may need to remove old nodule stuff)
local ingrediences_solvation=function(recipe)
	local ing = {}
	ing[#ing+1]={type = "fluid", name = "hydromnic-acid", amount = 120}
	if recipe.normal and recipe.normal.ingredients then
		for _, i in pairs(recipe.normal.ingredients) do
			if i.name ~= "catalysator-brown" and i.name ~= "angels-void" and i.name ~= "catalysator-green" and i.name ~= "catalysator-orange" then
				ing[#ing+1]=i
			end
		end
	elseif recipe.ingredients then
		for _, i in pairs(recipe.ingredients) do
			if i.name ~= "catalysator-brown" and i.name ~= "angels-void" and i.name ~= "catalysator-green" and i.name ~= "catalysator-orange" then
				ing[#ing+1]=i
			end
		end
	end
	return ing
end
local ingrediences_nodule_solvation=function(recipe)
	local ing = {}
	ing[#ing+1]={type = "fluid", name = "hydromnic-acid", amount = 120}
	for _, i in pairs(recipe.ingredients) do
		if i.name ~= "catalysator-brown" and i.name ~= "angels-void" and i.name ~= "catalysator-green" then
			ing[#ing+1]=i
		end
	end
	return ing
end
local results_solvation=function(recipe)
	local ing = {}
	--ing[#ing+1]={type = "fluid", name = "hydromnic-acid", amount = 120}
	if recipe.normal and recipe.normal.ingredients then
		for _, i in pairs(recipe.normal.results) do
			if i.name ~= "slag" and not string.find(i.name,"void") then
				ing[#ing+1]={type = "item", name=i.name.."-omnide-salt", amount = i.amount}
			end
		end
	elseif recipe.results then
		for _, i in pairs(recipe.results) do
			if i.name ~= "slag" and not string.find(i.name,"void") then
				ing[#ing+1]={type = "item", name=i.name.."-omnide-salt", amount = i.amount}
			end
		end
	end
	return ing
end
local results_nodule_solvation=function(recipe)
	local ing = {}
	--ing[#ing+1]={type = "fluid", name = "hydromnic-acid", amount = 120}
	for _, i in pairs(recipe.results) do
		if i.name ~= "slag"  and not string.find(i.name,"void") then
			ing[#ing+1]={type = "item", name=i.name.."-omnide-salt", amount = i.amount}
		end
	end
	return ing
end
--icons
local salt_omnide_icon = function(metal)
	local nr = 5
	--Build the icons table
	local icons = {}
	icons[#icons+1] = {icon = "__omnimatter_crystal__/graphics/icons/omnide-salt.png",icon_size=32}
	icons[#icons+1] = {
		icon = data.raw.item[metal].icon or data.raw.item[metal].icons[1].icon,
		icon_size=omni.crystal.get_ore_ic_size(metal),
		scale=0.4*32/omni.crystal.get_ore_ic_size(metal),
		shift={-10,10}
	}
	return icons
end
--checks
local find_type = function(recipe,name)
	if recipe.normal and recipe.normal.ingredients then
		for _,ing in pairs(recipe.normal.ingredients) do
			if string.find(ing.name,name) then return true end
		end
	elseif recipe.ingredients then
		for _,ing in pairs(recipe.ingredients) do
			if string.find(ing.name,name) then return true end
		end
	end
	return false
end

local has_unlock = function(tech,recipe)
	for _,eff in pairs(data.raw.technology[tech].effects) do
		if eff.type == "unlock-recipe" and eff.recipe==recipe then return true end
	end
	return false
end


if angelsmods and angelsmods.refining then
  	spec_vanilla=true --set else case of no bobs or overhaul
  	if mods["bobplates"] then
		spec_vanilla=false
	elseif mods["angelsindustries"] and angelsmods.industries.overhaul then
		spec_vanilla=false
	end

	if spec_vanilla==true then
		log("angels-special-vanilla-case")
		--find angels refining special case
		omni.crystal.add_crystal("angels-iron-nugget","Iron nugget")
		omni.crystal.add_crystal("angels-iron-pebbles","Iron pebbles")
		omni.crystal.add_crystal("angels-iron-slag","Iron slag")
		omni.crystal.add_crystal("angels-copper-nugget","Copper nugget")
		omni.crystal.add_crystal("angels-copper-pebbles","Copper pebbles")
		omni.crystal.add_crystal("angels-copper-slag","Copper slag")
	end
	if angelsmods.petrochem then omni.crystal.add_crystal("fluorite-ore","Fluorite") end
	--Force cobalt omnitraction with AB since cobalt is not spawning by default with pure Bob
	if data.raw.item["cobalt-ore"] then omni.crystal.add_crystal("cobalt-ore","Cobalt") end
	omni.crystal.add_crystal("manganese-ore","Manganese") -- do these show up in special vanilla?
	omni.crystal.add_crystal("chrome-ore","Chrome")

	local rec = {}
	local crystalines = {}
	local processed={}

	for _,recipe in pairs(data.raw.recipe) do
		--log(serpent.block (recipe.name))
		local results={}
		if recipe.normal and recipe.normal.results then --non-standardised check?
			results=recipe.normal.results
		elseif recipe.results then
			results=recipe.results
		end
		--now we do the checks
		if #results>1 or string.find(recipe.name,"mix") or string.find(recipe.name,"ore8") or string.find(recipe.name,"ore9") then
			if string.find(recipe.name,"angelsore") and string.find(recipe.name,"processing") then
				local ing = table.deepcopy(ingrediences_solvation(recipe))
				local res = table.deepcopy(results_solvation(recipe))
				if #ing > 0 and #res > 0 then
					local metal = {}
					if #ing == 2 then
						metal = ing[2].name
					else
						metal = string.sub(res[1].name,1,string.len(res[1].name)-string.len("-omnide-salt"))
					end
					--log(metal)
					local ic = salt_omnide_icon(metal)
					if not data.raw["item-subgroup"][recipe.subgroup.."-omnide"] then
						local cat = {
							type = "item-subgroup",
							name = recipe.subgroup.."-omnide",
							group = "omnicrystal",
							order = data.raw["item-subgroup"]["salting"].order, -- set the order of the "salting" subgroup to be able to control the order of all created subgroups
						}
						crystalines[#crystalines+1]=cat
					end
					local loc_key = {"item-name."..metal}
					if #ing == 2 then
						local tot = 0
						for _, r in pairs(res) do
							tot=tot+r.amount
						end
						ing[2].amount = tot
					end
					local solution = {
						type = "recipe",
						name = metal.."-salting",
						localised_name = {"recipe-name.omnide-salting", loc_key},
						localised_description = {"recipe-description.pure_extraction", loc_key},
						category = "omniplant",
						subgroup = recipe.subgroup.."-omnide",
						order = recipe.order.."salting",
						enabled = false,
						ingredients = ing,
						icons = ic,
						icon_size=32,--just in case
						results = res,
						energy_required = 5,
					}
					if mods["omnimatter_marathon"] then omni.marathon.exclude_recipe(metal.."-salting") end
					crystalines[#crystalines+1]=solution
					--"angelsore-crushed-mix1-processing"
					--adding unlocks in sequence, once unlocked, add exclusion...
					local blended_ore="false"
					if string.find(recipe.name,"ore8") or string.find(recipe.name,"ore9") then blended_ore="true" end

					--find unlock tier
					local tier=nil
					if find_type(recipe,"crushed") then tier= 1 --covers cupric/ferrous tier 1
					elseif find_type(recipe,"chunk") or (blended_ore=="true" and string.find(recipe.name,"powder")) then tier= 2
					elseif (find_type(recipe,"crystal") and blended_ore=="false") or (blended_ore=="true" and string.find(recipe.name,"dust")) then	tier= 3
					elseif find_type(recipe,"pure") or (blended_ore=="true" and string.find(recipe.name,"crystal")) then tier= 4
					else tier = 4 --if something goes horribly wrong...
					end
					omni.lib.add_unlock_recipe("crystallology-"..tier, metal.."-salting")
					--check and set unlock tier
					for i,ore in pairs(results) do
						if not processed[ore.name] then processed[ore.name]=tier end
					end
				end
			end
		end
	end
	data:extend(crystalines)
	local suffixes = {"-omnide-solution","-crystal","-crystal-omnitraction"}
	for _,suf in pairs(suffixes) do
		for ore,i in pairs(processed) do
			if ore~="slag" then
				for _,eff in pairs(data.raw.technology["crystallology-"..i].effects) do	omni.lib.add_unlock_recipe("crystallology-"..i, ore..suf) end
			end
		end
	end
	if settings.startup["angels-salt-sorting"].value then
		RecGen:create("omnimatter_crystal","omni-catalyst"):
		setSubgroup("omnine"):
		setStacksize(500):
		marathon():
		--setIcons("catalysator-yellow","angelsrefining"):
		setIcons("omni-catalyst"):
		setCategory("crystallizing"):
		setTechName("crystallology-1"):
		setOrder("zz"):
		setIngredients	({
			{type = "fluid", name = "hydromnic-acid", amount = 120},
		}):
		setResults({type = "item", name = "omni-catalyst", amount=1}):
		setEnergy(0.5):extend()
		for i, rec in pairs(data.raw.recipe) do
			if rec.category == "omniplant" and string.find(rec.name,"salting") then
				omni.lib.replace_recipe_ingredient(rec.name, "hydromnic-acid",{type = "item", name = "omni-catalyst", amount=1})
				rec.category = "ore-sorting"
			end
		end
	end
end
