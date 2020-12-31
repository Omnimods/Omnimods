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

--Replace all stone from rocks with stone
for _,rock in pairs(data.raw["simple-entity"]) do
	if string.find(rock.name,"rock") then
		if rock.minable then
			if rock.minable.results then
				for _,res in pairs(rock.minable.results) do
					if res.name == "stone" then
						res.name = "omnite"
					end
				end
			elseif rock.minable.result and rock.minable.result == "stone" then
				rock.minable.result = "omnite"
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