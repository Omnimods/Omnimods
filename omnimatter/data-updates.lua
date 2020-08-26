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
----------------------------------------------------------------------------
-- ore generation removal and omnitraction creation --
-- common alternative mods --
----------------------------------------------------------------------------
if mods["SigmaOne_Nuclear"] then
	omni.add_resource("fluorine-ore",3)
end
if mods["dark-matter-replicators"] then
	omni.add_resource("tenemut",3)
end
if mods["Yuoki"] then
	omni.add_resource("y-res1",2)
	omni.add_resource("y-res2",3)
end
if mods["pycoalprocessing"] then
	-- Green
	omni.add_resource("raw-borax", 1)
	omni.add_resource("niobium-ore", 2)	
end
if mods["pyfusionenergy"] then
	-- Blue
	omni.add_resource("molybdenum-ore", 3)
	-- Beyond
	omni.add_resource("regolite-rock", 3)
	omni.add_resource("kimberlite-rock", 3)
end
if mods["pyhightech"] then
	-- Blue
	omni.add_resource("rare-earth-ore", 3)
	-- Beyond
	omni.add_resource("phosphate-rock", 3)
end
if mods["pypetroleumhandling"] then
	-- Green
	omni.add_resource("oil-sand", 2)
	omni.add_fluid("tar", 2, 1)
	omni.add_resource("sulfur", 2)
end
if mods["pyalienlife"] then
	-- Green
	omni.add_resource("bio-sample", 2)

end
if mods["pyrawores"] then
	-- Pre-sci/red
	omni.add_resource("ore-aluminium", 1)
	omni.add_resource("ore-tin", 1)
	omni.add_resource("ore-quartz", 1)
	omni.add_resource("raw-coal", 1)
	omni.add_resource("nexelit-ore", 1)
	-- Green
	omni.add_resource("ore-lead", 2)
	omni.add_resource("ore-titanium", 2)
	omni.add_resource("ore-chromium", 2)
	omni.add_resource("salt", 2)
	-- Blue
	omni.add_resource("ore-nickel", 3)
	-- Beyond
	omni.add_resource("ore-zinc", 3)
end
----------------------------------------------------------------------------
-- Vanilla, Angels and Bobs combo solid ores section --
----------------------------------------------------------------------------
-- all the time resources
omni.add_resource("coal",2)
omni.add_resource("stone",3)
if angelsmods and angelsmods.refining then
	omni.add_resource("angels-ore1",1)
	omni.add_resource("angels-ore3",1) 
	omni.add_resource("angels-ore4",3)
	omni.add_fluid("thermal-water",3,3)
	if bobmods and bobmods.ores or (angelsmods.industries and angelsmods.industries.overhaul) then
		omni.add_resource("angels-ore2",3)
		omni.add_resource("angels-ore5",2)
		omni.add_resource("angels-ore6",2)
	else
		omni.add_resource("angels-ore2",2)
	end
else
	omni.add_resource("iron-ore",1)
	omni.add_resource("copper-ore",1)
	omni.add_resource("uranium-ore",3)
	if bobmods and bobmods.ores then
		local levels={		
			--["iron-ore"]=1,
			--["copper-ore"]=1,
			["lead-ore"]=1,
			["tin-ore"]=1,
			["quartz"]=2,
			["zinc-ore"]=2,
			["nickel-ore"]=2,
			["bauxite-ore"]=2,
			["rutile-ore"]=3,
			["gold-ore"]=3,
			["cobalt-ore"]=3,
			["silver-ore"]=3,
			["tungsten-ore"]=3,
			--["uranium-ore"]=3,
			["thorium-ore"]=3,
			--["gem-ore"]=3
		}
		for i, ore in pairs(bobmods.ores) do --check ore triggers (works with plates)
			if ore.enabled and levels[ore.name] then
				omni.add_resource(ore.name,levels[ore.name])
			end
		end
		omni.add_resource("gem-ore",3)
		omni.add_fluid("lithia-water",2,1)
	end
	--remove stone from mining
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

----------------------------------------------------------------------------
-- Oils ain't oils section --
----------------------------------------------------------------------------
if angelsmods and angelsmods.petrochem then
	omni.add_fluid("gas-natural-1",1,3+4/7)
	omni.add_fluid("liquid-multi-phase-oil",2,1+3/8)
	if not mods["omnimatter_water"] and not mods["pypetroleumhandling"] then omni.add_resource("sulfur",2) end
else
	omni.add_fluid("crude-oil",1,1)
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
----------------------------------------------------------------------------
-- Steam science compatability --
----------------------------------------------------------------------------
-- Fix for Steam SP Bob's Tech introduces sometimes
if data.raw.recipe["steam-science-pack"] then
	omni.lib.replace_recipe_ingredient("steam-science-pack","coal","omnite")
end
----------------------------------------------------------------------------
-- Late requires --
----------------------------------------------------------------------------
require("prototypes.buildings.omnitractor-dynamic")
require("prototypes.recipes.extraction-dynamic")
require("prototypes.recipes.solvation-dynamic")
require("prototypes.buildings.omniphlog")
require("prototypes.buildings.steam-omni")

