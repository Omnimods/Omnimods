local equal_type = {"lab","assembling-machine","furnace","boiler","generator","mining-drill","locomotive","beacon","logistic-container","inserter"}
local eq = {}

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
end

--equalize
omni.marathon.equalize("burner-mining-drill","electric-mining-drill")
omni.marathon.equalize("burner-lab","lab")
omni.marathon.equalize("light-armor","heavy-armor")
omni.marathon.equalize("burner-lab","lab")

--exclude
omni.marathon.exclude_recipe("ye_grow_animal3fast_recipe")
omni.marathon.exclude_recipe("ping-tool")
omni.marathon.exclude_recipe("upgrade-builder")
omni.marathon.exclude_recipe("kovarex-enrichment-process")
omni.marathon.exclude_recipe("pulverize-stone")
omni.marathon.exclude_recipe("coal-liquefaction")

if mods["omnimatter_wood"] then
	omni.marathon.exclude_recipe("wood-extraction")
	omni.marathon.exclude_recipe("basic-mutated-wood-growth")
	omni.marathon.exclude_recipe("seedling-mutation")
	omni.marathon.exclude_recipe("advanced-mutated-wood-growth")
	omni.marathon.exclude_recipe("improved-wood-mutation")
end

if mods["angelspetrochem"] then
	omni.marathon.exclude_item("catalyst-metal-carrier")
	omni.marathon.exclude_item("catalyst-metal-red")
	omni.marathon.exclude_item("catalyst-metal-green")
	omni.marathon.exclude_item("catalyst-metal-blue")
	omni.marathon.exclude_item("catalyst-metal-yellow")
	omni.marathon.exclude_item("catalyst-metal-cyan")
end

--normalize
omni.marathon.normalize("light-armor")
omni.marathon.normalize("heavy-armor")
