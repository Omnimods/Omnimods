omni.add_omnicium_alloy("steel","steel-plate","ingot-steel")
omni.add_omnicium_alloy("iron","iron-plate","ingot-iron")
if mods["bobplates"] then
	omni.add_omnicium_alloy("aluminium","aluminium-plate","ingot-aluminium")
	omni.add_omnicium_alloy("tungsten","tungsten-plate","casting-powder-tungsten")
end
if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("pulverize-omnite")
	omni.marathon.exclude_recipe("omni-iron-general-1")
	omni.marathon.exclude_recipe("omni-copper-general-1")
	omni.marathon.exclude_recipe("omni-saphirite-general-1")
	omni.marathon.exclude_recipe("omni-stiratite-general-1") 
end

omni.add_resource("coal",2)
omni.add_resource("stone",3)

if mods["SigmaOne_Nuclear"] then
	omni.add_resource("fluorine-ore",3)
end
	
if angelsmods and angelsmods.refining then
	omni.add_resource("angels-ore1",1)
	omni.add_resource("angels-ore3",1)
	if bobmods and bobmods.ores then
		omni.add_resource("angels-ore5",2)
		omni.add_resource("angels-ore6",2)
		omni.add_resource("angels-ore2",3)
		omni.add_resource("angels-ore4",3)
	else
		omni.add_resource("angels-ore2",2)
		omni.add_resource("angels-ore4",3)
		omni.add_resource("uranium-ore",3)
		omni.add_fluid("crude-oil",1,1)
	end
	omni.add_fluid("thermal-water",3,3)
else
	if bobmods and bobmods.ores then
		omni.add_resource("iron-ore",1)
		omni.add_resource("copper-ore",1)
		omni.add_resource("lead-ore",1)
		omni.add_resource("tin-ore",1)
		omni.add_resource("quartz",2)
		omni.add_resource("zinc-ore",2)
		omni.add_resource("nickel-ore",2)
		omni.add_resource("bauxite-ore",2)
		omni.add_resource("rutile-ore",3)
		omni.add_resource("gold-ore",3)
		omni.add_resource("cobalt-ore",3)
		omni.add_resource("silver-ore",3)
		omni.add_resource("uranium-ore",3)
		omni.add_resource("tungsten-ore",3)
		
		omni.add_resource("gem-ore",3)
		
		omni.add_fluid("lithia-water",2,3/4)
		--sulfur
	else
		omni.add_resource("iron-ore",1)
		omni.add_resource("copper-ore",2)
		omni.add_resource("uranium-ore",3)
	end
	for _, gen in pairs(data.raw["resource"]) do
		if gen.minable.result == "stone" then
			data.raw.resource[gen.name] = nil
			data.raw["autoplace-control"][gen.name] = nil
		elseif gen.minable.results  then
			for _,res in pairs(gen.minable.results) do
				if res.name == "stone" then
					data.raw.resource[gen.name] = nil
					data.raw["autoplace-control"][gen.name] = nil			
				end
			end
		end
	end
end
if angelsmods and angelsmods.petrochem then
	omni.add_fluid("gas-natural-1",1,3+4/7)
	omni.add_fluid("liquid-multi-phase-oil",2,1+3/8)
	if not mods["omnimatter_water"] then omni.add_resource("sulfur",2) end
else
	omni.add_fluid("crude-oil",1,1)
end
if mods["dark-matter-replicators"] then
	omni.add_resource("tenemut",3)
end
if mods["Yuoki"] then
	omni.add_resource("y-res1",2)
	omni.add_resource("y-res2",3)
end
for i,tech in pairs(data.raw.technology) do
	if string.find(tech.name,"pumpjack") then
		--table.remove(data.raw.technology,i)
		data.raw.technology[tech.name].enabled=false
	elseif tech.prerequisites then
		for j=1,#tech.prerequisites do
			if string.find(tech.prerequisites[j],"pumpjack") then
				data.raw.technology[tech.name].prerequisites[j]=nil
			end
		end
		if tech and tech.effects then
			for i,eff in pairs(tech.effects) do
				if eff.type == "unlock-recipe" and string.find(eff.recipe,"pumpjack") then
					table.remove(data.raw.technology[tech.name].effects,i)
				end
			end
		end
	end
end
for _,recipe in pairs(data.raw.recipe) do
	log(recipe.name)
	if (recipe.result and string.find(recipe.result,"pumpjack"))
	or (recipe.results and recipe.results[1] and recipe.results[1].name 
		and string.find( recipe.results[1].name,"pumpjack")) then
		data.raw.recipe[recipe.name].enabled=false
	end
end

for _, item in pairs(data.raw.item) do
	if string.find(item.name,"pumpjack") then
		--data.raw.item[item.name]=nil
		--data.raw["mining-drill"][item.place_result]=nil
	end
end

if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("omnicium-plate-pure")
	omni.marathon.exclude_recipe("crushing-omnite-by-hand")
end
--data:extend(set)
ItemGen:create("omnimatter","omniline-water"):
	setSubgroup("water-treatment"):
	fluid():
	setReqAllMods("angelsrefining"):extend()
	
ItemGen:create("omnimatter","purified-omnic-water"):
	setSubgroup("water-treatment"):
	fluid():
	setReqAllMods("angelsrefining"):extend()
	
RecGen:create("omnimatter","omnic-water-purificiation"):
	setCategory("water-treatment"):
	setEnergy(1):
	setIcons("omnic-water-purification","omnimatter"):
	setSubgroup("water-treatment"):
	setTechName("water-treatment"):
	setIngredients({name="omnic-water",amount = 150, type = "fluid"}):
	setResults(
			{type="fluid", name="omniline-water", amount=50},
			{type="fluid", name="purified-omnic-water", amount=100}):
	marathon():
	setReqAllMods("angelsrefining"):extend()
	