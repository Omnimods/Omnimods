require("prototypes.compat.bob-compensation")

local m = 3
for _,om in pairs({omni.omnisource,omni.omnifluid}) do
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

omni.lib.add_unlock_recipe("omnitech-base-impure-extraction","crushed-omnite")
omni.lib.add_unlock_recipe("omnitech-base-impure-extraction","pulverized-omnite")
omni.lib.add_unlock_recipe("omnitech-base-impure-extraction","pulverized-stone")
omni.lib.add_unlock_recipe("omnitech-base-impure-extraction","pulver-omnic-waste")

--TEMPORARY
--omnifluid (basically should be same timing as barrelling)
local fluids = {}
for _, fluid in pairs(data.raw.fluid) do
	if fluid.name ~= "heat" and fluid.name ~= "omnic-water" then
		RecGen:create("omnimatter","omniflush-"..fluid.name):
			setIngredients({type="fluid",amount=360,name=fluid.name}):
			setResults({type="fluid",amount=60,name="omnic-water"}):
			setIcons("omnic-water"):
			addSmallIcon(omni.icon.of(fluid.name, "fluid"),3):
			setCategory("omniphlog"):
			setEnabled(fluid.name=="omnic-waste"):
			--setSubgroup(fluid.subgroup):
			setSubgroup("omnilation"):
			--Same subgroup & order, but put the omnic water block behind all other recipes in that subgroup
			setOrder("zzz"..(fluid.order or "")):
			setLocName({"recipe-name.omnilation", omni.locale.of(fluid).name }):
			extend()
		fluids[#fluids+1] = fluid.name
	end
end

for _, rec in pairs(data.raw.recipe) do
	if not rec.hidden and not string.find(rec.name, "barrel") then
		for _, flu in pairs(fluids) do
			if  omni.lib.recipe_result_contains(rec.name, flu) then
				local techname = omni.lib.get_tech_name(rec.name)
				if rec.enabled or (rec.normal and rec.normal.enabled) or (rec.expensive and rec.expensive.enabled) then
					omni.lib.enable_recipe("omniflush-"..flu)
				elseif techname then
					omni.lib.add_unlock_recipe(techname, "omniflush-"..flu)
				end
			end
		end
	end
end
--END TEMPORARY

---------------------
--Autoplace Removal--
---------------------
--remove everything that is not on this whitelist from all autoplace controls
local ores_to_keep ={
	"omnite",
	"infinite-omnite",
	"trees",
	"enemy-base"
}

--autoplace-control
for _,ore in pairs(data.raw["autoplace-control"]) do
	if ore.category  and ore.category  == "resource" and ore.name and not omni.lib.is_in_table(ore.name, ores_to_keep) then
		data.raw["autoplace-control"][ore.name] = nil
		--log("Removed "..ore.name.." from autoplace control")
	end
end

--map presets
for _,preset in pairs(data.raw["map-gen-presets"]["default"]) do
	if type(preset) == "table" and preset.basic_settings and preset.basic_settings.autoplace_controls then
		for ore_name,ore in pairs(preset.basic_settings.autoplace_controls) do
			if ore_name and not omni.lib.is_in_table(ore_name, ores_to_keep) then
				preset.basic_settings.autoplace_controls[ore_name] = nil
				--log("Removed "..ore_name.." ´s autoplace controls from presets")
			end
		end
	end
end
--resources

for _,ore in pairs(data.raw["resource"]) do
	if ore.autoplace and ore.name and not omni.lib.is_in_table(ore.name, ores_to_keep) then
		data.raw["resource"][ore.name].autoplace = nil
		--log("Removed "..ore.name.." ´s resource autoplace")
	end
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

--Add last extraction techs as rocket silo prereq
if omni.rocket_locked then
	--Get highest ore and fluid tier
	local max_tier = 0
	for _,tier in pairs(omni.omnisource) do
		max_tier = max_tier + 1
	end

	local max_fluid_tier = 0
	for _,tier in pairs(omni.omnifluid) do
		max_fluid_tier = max_fluid_tier + 1
	end

	--Check if there is a higher fluid than ore tier
	if max_tier > max_fluid_tier then
		local pure_extractions = 3 * omni.pure_levels_per_tier
		for _,ore in pairs(omni.omnisource[tostring(max_tier)]) do
			omni.lib.add_prerequisite("rocket-silo","omnitech-extraction-"..ore.name.."-"..pure_extractions)
		end
	end
	
	--Check if there is a higher ore than fluid tier
	if max_fluid_tier > max_tier then
		for _,fluid in pairs(omni.omnifluid[tostring(max_fluid_tier)]) do
			omni.lib.add_prerequisite("rocket-silo","omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels)
		end
	end
end

--Offshore pump should output omnic water
for _,pump in pairs(data.raw["offshore-pump"]) do
	if pump.fluid == "water" then
		pump.fluid="omnic-water"
		pump.fluid_box.filter="omnic-water"
	end
end

RecGen:import("coal-liquefaction"):
	replaceIngredients("heavy-oil","omniston"):
	replaceIngredients("liquid-naphtha","omniston"):
	extend()