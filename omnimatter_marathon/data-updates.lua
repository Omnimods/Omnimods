if not mods["only-smelting"] then
    
else

end
if mods["angelssmelting"] then
    omni.marathon.add_chain("iron-smelting",{{"iron-ore-smelting",{24,24}}},{"iron-ore"},{"ingot-iron"})
    omni.marathon.add_chain("iron-smelting",{{"iron-ore-processing",{2,4}},{"processed-iron-smelting",{24,8}}})
    omni.marathon.add_chain("iron-smelting",{"iron-ore-processing",{"iron-processed-processing",{4,3}},{"pellet-iron-smelting",{24,8}}})
    
    omni.marathon.add_chain("copper-smelting",{{"copper-ore-smelting",{24,24}}},{"copper-ore"},{"ingot-copper"})
    omni.marathon.add_chain("copper-smelting",{{"copper-ore-processing",{2,4}},{"processed-copper-smelting",{24,8}}})
    omni.marathon.add_chain("copper-smelting",{"copper-ore-processing",{"copper-processed-processing",{4,3}},{"pellet-copper-smelting",{24,8}},{"anode-copper-smelting",{12,12}}})
    
    omni.marathon.add_chain("zinc-smelting",{{"zinc-ore-smelting",{24,24}}},{"zinc-ore"},{"ingot-zinc"})
    omni.marathon.add_chain("zinc-smelting",{{"zinc-ore-processing",{2,4}},{"processed-zinc-smelting",{24,8}}})
    omni.marathon.add_chain("zinc-smelting",{"zinc-ore-processing",{"zinc-processed-processing",{4,3}},{"pellet-zinc-smelting",{24,8}},{"solid-zinc-oxide-smelting",{12,12}},{"cathode-zinc-smelting",{12,12}}})
    
    omni.marathon.add_chain("tin-smelting",{{"tin-ore-smelting",{24,24}}},{"tin-ore"},{"ingot-tin"})
    omni.marathon.add_chain("tin-smelting",{{"tin-ore-processing",{2,4}},{"processed-tin-smelting",{24,8}}})
    omni.marathon.add_chain("tin-smelting",{"tin-ore-processing",{"tin-processed-processing",{4,3}},{"pellet-tin-smelting",{24,8}}})
    
    omni.marathon.add_chain("lead-smelting",{{"lead-ore-smelting",{24,24}}},{"lead-ore"},{"ingot-lead"})
    omni.marathon.add_chain("lead-smelting",{{"lead-ore-processing",{2,4}},{"processed-lead-smelting",{24,8}},{"solid-lead-oxide-smelting",{24,24}}})
    omni.marathon.add_chain("lead-smelting",{"lead-ore-processing",{"lead-processed-processing",{4,3}},{"pellet-lead-smelting",{24,8}},{"anode-lead-smelting",{12,12}}})
    
    omni.marathon.add_chain("silica-smelting",{{"silicon-ore-smelting",{24,24}}},{"quartz"},{"ingot-silicon"})
    omni.marathon.add_chain("silica-smelting",{{"silica-ore-processing",{2,4}},{"processed-silicon-smelting",{120,8}},{"liquid-trichlorosilane-smelting",{90,24}}})
    omni.marathon.add_chain("silica-smelting",{"silica-ore-processing",{"silica-processed-processing",{4,3}},{"pellet-silicon-smelting",{120,8}},{"gas-silane-smelting",{90,24}}})
    
    omni.marathon.add_chain("aluminium-smelting", {{"bauxite-ore-smelting",{12,12}}, {"solid-aluminium-hydroxide-smelting",{24,24}}, {"solid-aluminium-oxide-smelting",{24,24}}}, {"bauxite-ore"}, {"ingot-aluminium"})
    omni.marathon.add_chain("aluminium-smelting", {{"bauxite-ore-processing",{2,4}}, {"processed-aluminium-smelting",{4,12}}, "solid-aluminium-hydroxide-smelting", "solid-aluminium-oxide-smelting"})
    omni.marathon.add_chain("aluminium-smelting", {"bauxite-ore-processing", {"aluminium-processed-processing",{4,3}}, {"pellet-aluminium-smelting",{18,6}}, {"solid-sodium-aluminate-smelting",{24,24}}, "solid-aluminium-oxide-smelting"}) 
end

if mods["angelspetrochem"] then
    omni.marathon.exclude_item("catalyst-metal-carrier")
    omni.marathon.exclude_item("catalyst-metal-red")
    omni.marathon.exclude_item("catalyst-metal-green")
    omni.marathon.exclude_item("catalyst-metal-blue")
    omni.marathon.exclude_item("catalyst-metal-yellow")
    omni.marathon.exclude_item("catalyst-metal-cyan")
end

omni.marathon.exclude_recipe("ye_grow_animal3fast_recipe")

omni.marathon.exclude_recipe("ping-tool")
omni.marathon.exclude_recipe("upgrade-builder")
omni.marathon.exclude_recipe("kovarex-enrichment-process")

if mods["angelsrefining"] then
    omni.marathon.inverse_recipes("crush-stone","stone-crushed")    
end

if mods["omnimatter_crystal"] then
    local list = {}
    list[#list+1]="iron-ore"
    list[#list+1]="copper-ore"    
    list[#list+1]="uranium-ore"    
    if mods["bobsores"] then
        list[#list+1]="lead-ore"
        list[#list+1]="tin-ore"
        list[#list+1]="bauxite-ore"
        list[#list+1]="zinc-ore"
        list[#list+1]="silver-ore"
        list[#list+1]="rutile-ore"
        list[#list+1]="gold-ore"
        list[#list+1]="cobalt-ore"
        list[#list+1]="nickel-ore"
        list[#list+1]="tungsten-ore"
        list[#list+1]="platinum-ore"
        list[#list+1]="quartz-ore"
    end
    if mods["angelsrefining"] then
        list[#list+1]="manganese-ore"
        list[#list+1]="chrome-ore"    
    end
    if mods["angelsrefining"] then
        local angel_string = {"crushed","chunk","crystal","pure"}
        for i=1, 6 do
            for _,ang in pairs(angel_string) do
                if data.raw.recipe["angelsore"..i.."-"..ang.."-processing"] then
                    local rec = data.raw.recipe["angelsore"..i.."-"..ang.."-processing"]
                    local target = {}
                    local source = "angelsore"..i
                    local quant = 0
                    for _,res in pairs(rec.normal.results) do
                        if res.name ~= "slag" then
                            target[#target+1] = res.name
                            quant=quant+res.amount
                        end
                    end
                    --omni.marathon.add_chain("angelsore"..i.."-"..ang.."-sorting",{{"iron-ore-smelting",{24,24}}},{source},target)
                end
                if data.raw.recipe["angelsore-"..ang.."-mix"..i.."-processing"] then
                    local rec = data.raw.recipe["angelsore-"..ang.."-mix"..i.."-processing"]
                    omni.lib.standardise(rec)
                    local target = rec.normal.results[1].name
                    if target ~= "angels-void" then
                        local source = {}
                        local quant = 0
                        for _,ing in pairs(rec.normal.ingredients) do
                            if ing.name ~= "catalysator-brown" then
                                source[#source+1] = ing.name
                                quant=quant+ing.amount
                            end
                        end
                        --omni.marathon.add_chain(target.."-sorting",{{"angelsore-"..ang.."-mix"..i.."-processing",{quant,quant}}},source,{target})
                        local step1 = {target.."-salting",{quant,quant}}
                        local step2 = {target.."-solvation",{120,1}}
                        local step3 = {target.."-crystalization",{10,120}}
                        local step4 = {target.."-omnitraction",{4,3}}
                        --omni.marathon.add_chain(target.."-sorting",{step1,step2,step3,step4})
                    end
                end
            end
        
        end
    end
    
end

    --"angelsore1-pure-processing"
    --"angelsore-crushed-mix1-processing"
    --omni.marathon.add_chain("impure-iron-sorting",{{"angelsore1-crushed-processing",{4,2}}},{"angelsore1-crushed"},{"iron-ore"})

if mods["omnimatter_wood"] then
    omni.marathon.exclude_recipe("wood-extraction")
    omni.marathon.exclude_recipe("basic-mutated-wood-growth")
    omni.marathon.exclude_recipe("seedling-mutation")
    omni.marathon.exclude_recipe("advanced-mutated-wood-growth")
    omni.marathon.exclude_recipe("improved-wood-mutation")
end
