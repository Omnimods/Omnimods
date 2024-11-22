---------------------
--Autoplace Removal--
---------------------

--autoplace-control
--keep non resource autoplace control
for name, cats in pairs(data.raw) do
    if name ~= "resource" then
        for _,proto in pairs(cats) do
            if proto.autoplace and proto.autoplace.control and not omni.matter.res_to_keep[proto.autoplace.control] then
                omni.matter.res_to_keep[proto.autoplace.control] = true
                log("Excluded "..proto.autoplace.control.." from category "..name)
            end
        end
    end
end

--We need to remove all nauvis exclusive autoplaces that are not already excluded
--Find nauvis exclusive autoplaces
local non_nauvis_auto = {}
local nauvis_auto = {}
local nauvis_excl_auto = {}
for planname, plan in pairs(data.raw.planet) do
    if plan["map_gen_settings"] and plan["map_gen_settings"]["autoplace_controls"] then
        for orename, v in pairs(plan["map_gen_settings"]["autoplace_controls"]) do
            if orename and not omni.matter.res_to_keep[orename] then
                if planname == "nauvis" then
                    nauvis_auto[orename] = true
                else
                    non_nauvis_auto[orename] = true
                end
            end
        end
        for orename, v in pairs(plan["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]) do
            if orename and not omni.matter.res_to_keep[orename] then
                if planname == "nauvis" then
                    nauvis_auto[orename] = true
                else
                    non_nauvis_auto[orename] = true
                end
            end
        end
    end
end

for ore, _ in pairs(nauvis_auto) do
    if not non_nauvis_auto[ore] then
        nauvis_excl_auto[ore] = true
    end
end

for _, ore in pairs(data.raw["autoplace-control"]) do
    if ore.category  and ore.category  == "resource" and ore.name and not omni.matter.res_to_keep[ore.name] then
        --Only nil nauvis exclusive autoplace controls
        if nauvis_auto[ore.name] then
            data.raw["autoplace-control"][ore.name] = nil
            --log("Removed "..ore.name.." from autoplace control")
        end
    elseif not omni.matter.res_to_keep[ore.name] then
        omni.matter.res_to_keep[ore.name] = true
        --log("Excluded "..ore.name)
    end
end

--Remove resource autoplace controls that are not excluded and nauvis exclusive
for _,ore in pairs(data.raw["resource"]) do
    if ore.autoplace and ore.name and not omni.matter.res_to_keep[ore.name] and nauvis_excl_auto[ore.name] then
        ore.autoplace = nil
        --log("Removed "..ore.name.." ´s resource autoplace")
    end
end

--for planname, plan in pairs(data.raw.planet) do
    for orename, v in pairs(data.raw.planet["nauvis"]["map_gen_settings"]["autoplace_controls"]) do
        if orename and not omni.matter.res_to_keep[orename] then --and nauvis_auto[orename] then
            data.raw.planet["nauvis"]["map_gen_settings"]["autoplace_controls"][orename] = nil
            --log("Removed "..orename.." from planet ".."nauvis".." autoplace control")
        end
    end
--end

for orename, v in pairs(data.raw.planet["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]) do
    if orename and not omni.matter.res_to_keep[orename] and data.raw["resource"][orename] then --and nauvis_auto[orename] then
        data.raw.planet["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"][orename] = nil
        --log("Removed "..orename.." from planet ".."nauvis".." autoplace settings")
    end
end

--map presets
for _,presets in pairs(data.raw["map-gen-presets"]) do
    for _,preset in pairs(presets) do
        if type(preset) == "table" and preset.basic_settings and preset.basic_settings.autoplace_controls then
            for ore_name,ore in pairs(preset.basic_settings.autoplace_controls) do
                if ore_name and not omni.matter.res_to_keep[ore_name] then
                    preset.basic_settings.autoplace_controls[ore_name] = nil
                    --log("Removed "..ore_name.." ´s autoplace controls from presets")
                end
            end
        end
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

--Fix research triggers with type = mine-resource that were affected by autoplace removal
for _,tech in pairs(data.raw["technology"]) do
    if tech.research_trigger and tech.research_trigger.type == "mine-entity" then
        if omni.matter.omnitial[tech.research_trigger.entity] or omni.matter.get_ore_tier(tech.research_trigger.entity) then
            tech.research_trigger.type = "craft-item"
            tech.research_trigger.item = tech.research_trigger.entity
            tech.research_trigger.entity = nil
        elseif omni.matter.get_fluid_tier(tech.research_trigger.entity) then
            tech.research_trigger.type = "craft-fluid"
            tech.research_trigger.fluid = tech.research_trigger.entity
            tech.research_trigger.entity = nil
        end
    end
end