--sortTiers()

local m = 3
for _,om in pairs({omnisource,omnifluid}) do
	for i, tier in pairs(om) do
		if tonumber(i)> m then m=tonumber(i) end
	end
end
omni.max_tier = math.min(math.max(omni.max_tier,m+2),8)

if mods["angelsrefining"] then
	data.raw.resource["uranium-ore"]=nil
end
for _,f in pairs(data.raw.fluid) do
	data.raw.recipe["angels-fluid-splitter-"..f.name]=nil
end

omni.lib.add_unlock_recipe("base-impure-extraction","crushed-omnite")
omni.lib.add_unlock_recipe("base-impure-extraction","pulverized-omnite")
omni.lib.add_unlock_recipe("base-impure-extraction","pulverized-stone")
omni.lib.add_unlock_recipe("base-impure-extraction","pulver-omnic-waste")

--TEMPORARY
--omnifluid (basically should be same timing as barrelling)
local fluids = {}
for _, fluid in pairs(data.raw.fluid) do
	if fluid.name ~= "heat" and fluid.name ~= "omnic-water" then
		RecGen:create("omnimatter","omniflush-"..fluid.name):
		setIngredients({type="fluid",amount=360,name=fluid.name}):
		setResults({type="fluid",amount=60,name="omnic-water"}):
		setIcons("omnic-water"):
		addSmallIcon(fluid.name,3):
		setCategory("omniphlog"):
		setEnabled(fluid.name=="omnic-waste"):
		setSubgroup(fluid.subgroup):
		extend()
		fluids[#fluids+1] = {new ="omniflush-"..fluid.name, old=fluid.name}
	end
end

for _, rec in pairs(data.raw.recipe) do
	for _, flu in pairs(fluids) do
		if omni.lib.recipe_result_contains(rec.name, flu.old) then
			local techname = omni.lib.get_tech_name(rec.name)
			if techname then
				omni.lib.add_unlock_recipe(techname, flu.new)
			else
				rec.enabled = true
			end
		end
	end
end
--END TEMPORARY

--omni.lib.add_unlock_recipe("omnic-hydrolyzation-"..math.floor(omni.fluid_levels/2),"stone-omnisolvent")
--omni.lib.add_unlock_recipe("omnic-hydrolyzation-"..math.floor(omni.fluid_levels/2),"omnite-crystalization")

for _,tier in pairs(omnisource) do
	for _, ore in pairs(tier) do
		for _, gen in pairs(data.raw["resource"]) do
			if gen.minable.result == ore.name then
				data.raw.resource[gen.name] = nil
				data.raw["autoplace-control"][gen.name] = nil
			elseif gen.minable.results  then
				for _,res in pairs(gen.minable.results) do
					if res.name == ore.name then
						data.raw.resource[gen.name] = nil
						data.raw["autoplace-control"][gen.name] = nil
					end
				end
			end
		end
		for _, pre in pairs(data.raw["map-gen-presets"].default) do
			if pre.basic_settings then
				if pre.basic_settings.autoplace_controls then
					pre.basic_settings.autoplace_controls[ore.name] = nil
					pre.basic_settings.autoplace_controls["sulfur"] = nil
					pre.basic_settings.autoplace_controls["infinite-"..ore.name] = nil
				end
			end
		end
	end
end

for _,tier in pairs(omnifluid) do
	for _,fluid in pairs(tier) do
		for _, gen in pairs(data.raw["resource"]) do
			if gen.minable.results then
				for _,f in pairs(gen.minable.results) do
					if f.name == fluid.name then
						data.raw.resource[gen.name] = nil
						data.raw["autoplace-control"][gen.name] = nil
						--return
					end
				end
			end
		end
		for _, pre in pairs(data.raw["map-gen-presets"].default) do
			if pre.basic_settings then
				if pre.basic_settings.autoplace_controls then
					pre.basic_settings.autoplace_controls[fluid.name] = nil
					pre.basic_settings.autoplace_controls["crude-oil"] = nil
					pre.basic_settings.autoplace_controls["angels-fissure"] = nil
					pre.basic_settings.autoplace_controls["angels-natural-gas"] = nil
				end
			end
		end
	end
end
if bobmods and bobmods.ores then
	require("prototypes.bob-compensation")
end

for _,rock in pairs(data.raw["simple-entity"]) do
	if string.find(rock.name,"rock") then
		if rock.minable and rock.minable.results then
			for _,res in pairs(rock.minable.results) do
				if res.name == "stone" then
					res.name = "omnite"
				end
			end
		end
		if rock.loot then
			for _,loot in pairs(rock.loot) do
				if loot.name == "stone" then
					loot.name = "omnite"
				end
			end
		end
	end
end
--sortTiers()
----log(serpent.block(data.raw.technology))
if omni.rocket_locked then
--"rocket-silo"
	for _,tier in pairs(omnisource) do
		for _,ore in pairs(tier) do
			omni.lib.add_prerequisite("rocket-silo","omnitech-extraction-"..ore.name.."-"..3*omni.pure_levels_per_tier)
		end
	end
	for _,tier in pairs(omnifluid) do
		for _,fluid in pairs(tier) do
			omni.lib.add_prerequisite("rocket-silo","omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels)
		end
	end
end

local debrick = table.deepcopy("stone-brick")
if debrick.normal then


end

for _,pump in pairs(data.raw["offshore-pump"]) do
	if pump.fluid == "water" then
		pump.fluid="omnic-water"
		pump.fluid_box.filter="omnic-water"
	end
end

RecGen:import("coal-liquefaction"):replaceIngredients("heavy-oil","omniston"):replaceIngredients("liquid-naphtha","omniston"):extend()



--log("zombiee why more ideas?")

--data.raw.technology["coal-liquefaction"]=nil
--data.raw.recipe["coal-liquefaction"]=nil

--require("prototypes.omnitractor-requirements")


--require("migrations.omnimatter_reset")
