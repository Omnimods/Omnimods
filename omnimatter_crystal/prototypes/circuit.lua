colours = {}
function add_colour(name,colour,short)
    colours[name]={name=name, rgb={r=colour[1], b=colour[3], g=colour[2]},short=short}    
    colours[name].norm_rgb=colours[name].rgb
    local mx = math.max(colours[name].rgb.r,math.max(colours[name].rgb.g,colours[name].rgb.b))
    colours[name].norm_rgb.r=colours[name].norm_rgb.r/mx
    colours[name].norm_rgb.g=colours[name].norm_rgb.g/mx
    colours[name].norm_rgb.b=colours[name].norm_rgb.b/mx
end

local circuitry = {}
circuitry[1] = {circuit = 1, node = nil}
circuitry[2] = {circuit = 2, node = 2}

function omni.crystal.oscillocrystal(material)
    if not data.raw.item[material.."-oscillocrystal"] then
        local items = {}
        local board = "__omnimatter_crystal__/graphics/icons/shards/"..material.."-alpha.png"
        items[#items+1]=  {
            type = "item",
            name = material.."-oscillocrystal",
            localised_name = {"item-name.oscillocrystal", omni.lib.capitalize(material)},
            icons = {
                {icon = board}
            },
            icon_size = 32,
            flags = {"goes-to-main-inventory"},
            subgroup = "omni-basic",
            stack_size = 200
        }
        local crystal = ""
        if material == "omnine" then crystal = material else crystal = material.."-crystal" end
        items[#items+1]= {
            type = "recipe",
            name = material.."-oscillocrystal",
            subgroup = "shard",
            enabled = false,
            ingredients = {
            {type = "item", name = crystal, amount=1}
            },
            order = "a[angelsore1-crushed]",
            icon = board,
            icon_size = 32,
            results = {{type = "item", name = material.."-oscillocrystal", amount=3}},
            energy_required = 2,
        }
    end
end

function omni.crystal.electrocrystal(material)
    if not data.raw.item[material.."-electrocrystal"] then
        local items = {}
        local board = "__omnimatter_crystal__/graphics/icons/shards/"..material.."-beta.png"
        items[#items+1]=  {
            type = "item",
            name = material.."-electrocrystal",
            localised_name = {"item-name.electrocrystal", omni.lib.capitalize(material)},
            icon = board,
            icon_size = 32,
            flags = {"goes-to-main-inventory"},
            subgroup = "omni-basic",
            stack_size = 200
        }
        local crystal = ""
        --if name_beta == "omnine" then crystal = name_beta else crystal = name_beta.."-crystal" end
        items[#items+1]= {
            type = "recipe",
            name = material.."-electrocrystal",
            subgroup = "shard",
            enabled = false,
            ingredients = {
            {type = "item", name = crystal, amount=1}
            },
            order = "a[angelsore1-crushed]",
            icon = board,
            icon_size = 32,
            results = {{type = "item", name = material.."-electrocrystal", amount=6}},
            energy_required = 1,
        }
    end
end
function omni.crystal.electrocrystal(material)
    if not data.raw.item[material.."-thermocrystal"] then
        local items = {}
        local board = "__omnimatter_crystal__/graphics/icons/shards/"..material.."-gamma.png"
        items[#items+1]=  {
            type = "item",
            name = material.."-thermocrystal",
            localised_name = {"item-name.thermocrystal", omni.lib.capitalize(material)},
            icon = board,
            icon_size = 32,
            flags = {"goes-to-main-inventory"},
            subgroup = "omni-basic",
            stack_size = 200
        }
        local crystal = ""
        --if name_gamma == "omnine" then crystal = name_gamma else crystal = name_gamma.."-crystal" end
        items[#items+1]= {
            type = "recipe",
            name = material.."-thermocrystal",
            subgroup = "shard",
            enabled = false,
            ingredients = {
            {type = "item", name = crystal, amount=1}
            },
            order = "a[angelsore1-crushed]",
            icon = board,
            icon_size = 32,
            results = {{type = "item", name = material.."-thermocrystal", amount=4}},
            energy_required = 1,
        }
    end
end


function omni.crystal.generate_control_crystal(board_crystal,circuit_crystal,connection_crystal,node_crystal,nr,electronic)
    local items={}
    
    local b_t = {}
    local c_t = {}
    local cn_t = {}
    local n_t = {}
    --[[if type(board_colour)== "table" then
        if board_colour.r then
            b_t = {r=board_colour.r,g=board_colour.g,b=board_colour.b,a=0.8}
        else
            b_t = {r=board_colour[1],g=board_colour[2],b=board_colour[3],a=0.8}
        end
    else
        b_t = {r=colours[board_colour].rgb.r,g=colours[board_colour].rgb.g,b=colours[board_colour].rgb.b,a=0.8}
    end]]
    b_t = {r=colours[board_crystal].rgb.r,g=colours[board_crystal].rgb.g,b=colours[board_crystal].rgb.b,a=0.8}
    c_t = {r=colours[circuit_crystal].rgb.r,g=colours[circuit_crystal].rgb.g,b=colours[circuit_crystal].rgb.b,a=0.8}
    cn_t = {r=colours[connection_crystal].rgb.r,g=colours[connection_crystal].rgb.g,b=colours[connection_crystal].rgb.b,a=0.8}
    if node_crystal then n_t = {r=colours[node_crystal].rgb.r,g=colours[node_crystal].rgb.g,b=colours[node_crystal].rgb.b,a=0.8} end
    
    local resources = {}
    
    local name_board = ""
    if data.raw.item[board_crystal.."-ore"] then name_board = board_crystal.."-ore" else name_board = board_crystal end
    
    if  not omni.lib.is_in_table(name_board, resources) then resources[#resources+1]=name_board end    
    
    if not data.raw.item[board_crystal.."-crystal-board"] then
        local board = {{icon="__omnimatter_crystal__/graphics/icons/circuit/base-crystal-board.png",tint=colours[board_crystal].rgb}}
        items[#items+1]=  {
            type = "item",
            name = board_crystal.."-crystal-board",
            localised_name = {"item-name.crystal-board", omni.lib.capitalize(board_crystal)},
            icons = board,
            icon_size = 32,
            flags = {"goes-to-main-inventory"},
            subgroup = "omni-basic",
            stack_size = 200
        }
        local crystal = ""
        if name_board == "omnine" then crystal = name_board else crystal = name_board.."-crystal" end
        items[#items+1]= {
            type = "recipe",
            name = board_crystal.."-crystal-board",
            subgroup = "omnine",
            enabled = false,
            ingredients = {
            {type = "item", name = crystal, amount=1}
            },
            order = "a[angelsore1-crushed]",
            icons = board,
            icon_size = 32,
            results = {{type = "item", name = board_crystal.."-crystal-board", amount=1}},
            energy_required = 3,
        }
    end
    local name_alpha = ""
    if data.raw.item[circuit_crystal.."-ore"] then name_alpha = circuit_crystal.."-ore" else name_alpha = circuit_crystal end
    
    if  not omni.lib.is_in_table(name_alpha, resources) then resources[#resources+1]=name_alpha end
    
    omni.crystal.oscillocrystal(name_alpha)
    
    local name_beta = ""
    if data.raw.item[connection_crystal.."-ore"] then name_beta = connection_crystal.."-ore" else name_beta = connection_crystal end
    
    if  not omni.lib.is_in_table(name_beta, resources) then resources[#resources+1]=name_beta end
    
    omni.crystal.electrocrystal(name_beta)
    
    if node_crystal then
        local name_gamma = ""
        if data.raw.item[node_crystal.."-ore"] then name_gamma = node_crystal.."-ore" else name_gamma = node_crystal end
        
        if  not omni.lib.is_in_table(name_gamma, resources) then resources[#resources+1]=name_gamma end
    end
    local icons = {}
    icons[#icons+1]={icon="__omnimatter_crystal__/graphics/icons/circuit/base-crystal-board.png",tint=colours[board_crystal].rgb}
    icons[#icons+1]={icon="__omnimatter_crystal__/graphics/icons/circuit/hole-crystal-board.png",tint=colours[connection_crystal].rgb}
    icons[#icons+1]={icon="__omnimatter_crystal__/graphics/icons/circuit/crystal-circuit-"..circuitry[nr].circuit..".png",tint=colours[circuit_crystal].rgb}
    if node_crystal then
        icons[#icons+1]={icon="__omnimatter_crystal__/graphics/icons/circuit/crystal-node-"..circuitry[nr].circuit..".png",tint=colours[node_crystal].rgb}
    end
    
    local circuit_name = board_crystal.."-"..circuit_crystal.."-"..connection_crystal
    local ing = {
        {type = "item", name = board_crystal.."-crystal-board", amount=1},
        {type = "item", name = circuit_crystal.."-oscillocrystal", amount=3},
        {type = "item", name = connection_crystal.."-electrocrystal", amount=2},
        }
    if node_crystal then
        circuit_name=circuit_name.."-"..node_crystal 
        ing[#ing+1]={type = "item", name = node_crystal.."-thermocrystal", amount=1}
    end
    if electronic then
        ing[#ing+1]={type = "item", name = electronic, amount=1}
    end
    --log("Generating control crystal: "..circuit_name)
    circuit_name=circuit_name.."-circuit-"..nr
    items[#items+1]=  {
        type = "item",
        name = circuit_name,
        icon_size = 32,
        localised_name = {"item-name.control_crystal", colours[board_crystal].short,colours[connection_crystal].short,colours[circuit_crystal].short},
        icons = icons,
        flags = {"goes-to-main-inventory"},
        subgroup = "omni-basic",
        stack_size = 200
    }
    items[#items+1]= {
        type = "recipe",
        name = circuit_name,
        subgroup = "omnine",
        enabled = false,
        ingredients = ing,
        order = "a[angelsore1-crushed]",
        icons = icons,
        icon_size = 32,
        results = {{type = "item", name = circuit_name, amount=1}},
        energy_required = 1,
    }
    data:extend(items)
    
    local tech_unlock={}
    for i=1,4 do
        tech_unlock[i]={}
        if i==1 then
            tech_unlock[i][1]="omnine"
        else
            for _,x in pairs(tech_unlock[i-1]) do
                tech_unlock[i][#tech_unlock[i]+1]=x
            end
        end
        for _,eff in pairs(data.raw.technology["omnitech-crystallology-"..i].effects) do
            --log("crystal effect: "..eff.recipe)
            if eff.type=="unlock-recipe" and string.find(eff.recipe,"omnitraction") and data.raw.recipe[eff.recipe] then
                --log("Circuit: "..eff.recipe)
                omni.lib.standardise(data.raw.recipe[eff.recipe])
                for _,res in pairs(data.raw.recipe[eff.recipe].normal.results) do
                    tech_unlock[i][#tech_unlock[i]+1]=res.name
                end
            end
        end
    end
    
    
    if not mods["angelsrefining"] then
        for i,bob in pairs(resources) do
            if omni.lib.end_with(bob,"ore") then
                resources[i] = string.sub(bob,1,string.len(bob)-3).."plate"
            end
        end
    end
    
    for i=1,4 do
        if omni.lib.sub_table_of(resources,tech_unlock[i]) then 
            omni.lib.add_unlock_recipe("omnitech-crystallonics-"..i,circuit_name)
            omni.lib.add_unlock_recipe("omnitech-crystallonics-"..i,connection_crystal.."-electrocrystal")
            omni.lib.add_unlock_recipe("omnitech-crystallonics-"..i,circuit_crystal.."-oscillocrystal")
            omni.lib.add_unlock_recipe("omnitech-crystallonics-"..i,board_crystal.."-crystal-board")
            if node_crystal then omni.lib.add_unlock_recipe("omnitech-crystallonics-"..i,node_crystal.."-thermocrystal") end
            break
        end
    end
    --Find the tech to unlock them
end

function omni.crystal.generate_hybrid_circuit(control_crystal,electronic_circuit,name)
    local cc = ""
    if type(control_crystal)=="table" then
        if type(control_crystal[1])=="table" then
            cc=omni.crystal.find_crystallonic(control_crystal[1],control_crystal[2])
        else
            if #control_crystal == 4 then
                cc=omni.crystal.find_crystallonic({control_crystal[1],control_crystal[2],control_crystal[3]},control_crystal[4])
            else
                cc=omni.crystal.find_crystallonic({control_crystal[1],control_crystal[2],control_crystal[3],control_crystal[4]},control_crystal[5])
            end
        end
    else
        cc=control_crystal
    end
    --log("generating hybrid: "..cc)
    
    local items = {}
    --    icons[#icons+1]={icon="__omnimatter_crystal__/graphics/blank.png"}
    local icons = util.combine_icons(
        omni.lib.icon.of(data.raw.item[cc]),
        omni.lib.icon.of(data.raw.item[electronic_circuit]),
        {}
    )
    icons[#icons].scale = 0.5
    icons[#icons].shift = {-6, 8}
    local loc = {"item-name.control_crystal_hybrid"}
    for i = 2, #data.raw.item[cc].localised_name do
        loc[#loc+1]=data.raw.item[cc].localised_name[i]
    end
    ----log(serpent.block(data.raw.item[electronic_circuit]))
    loc[#loc+1]=name
    items[#items+1]=  {
        type = "item",
        name = cc.."-"..electronic_circuit.."-hybrid",
        localised_name = loc,
        icons = icons,
        flags = {"goes-to-main-inventory"},
        subgroup = "omni-basic",
        stack_size = 200
    }
    items[#items+1]= {
        type = "recipe",
        name = cc.."-"..electronic_circuit.."-hybrid",
        subgroup = "omnine",
        enabled = false,
        ingredients = {{type="item",name=cc,amount=1},{type="item",name=electronic_circuit,amount=1}},
        order = "a[angelsore1-crushed]",
        icons = icons,
        results = {{type = "item", name = cc.."-"..electronic_circuit.."-hybrid", amount=1}},
        energy_required = 1,
    }
    data:extend(items)
    
    
    
    for i=1,4 do
        for _,eff in pairs(data.raw.technology["omnitech-crystallonics-"..i].effects) do
            if eff.type == "unlock-recipe" and eff.recipe == cc then
                omni.lib.add_unlock_recipe("omnitech-crystallonics-"..i, cc.."-"..electronic_circuit.."-hybrid")
                break
            end
        end
    end
end

function omni.crystal.find_crystallonic(ingredients, class)
    local circuit_name = ""
    --board_crystal.."-"..circuit_crystal.."-"..connection_crystal
    circuit_name=ingredients[1]
    for i=2,#ingredients do
        if string.len(ingredients[i])<=2 then
            for _,col in pairs(colours) do
                if col.short == ingredients[i] then
                    circuit_name=circuit_name.."-"..col.name
                end
            end
        else
            circuit_name=circuit_name.."-"..ingredients[i]
        end
    end
    circuit_name=circuit_name.."-circuit-"..class
    if not data.raw.item[circuit_name] then    
        --log(circuit_name.." does not exist, may cause issues.")
    end
    return circuit_name 
end

function omni.crystal.find_hybrid(ingredients,class,electric)
    local circuit_name = ""
    --board_crystal.."-"..circuit_crystal.."-"..connection_crystal
    circuit_name=ingredients[1]
    for i=2,#ingredients do
        if string.len(ingredients[i])<=2 then
            for _,col in pairs(colours) do
                if col.short == ingredients[i] then
                    circuit_name=circuit_name.."-"..col.name
                end
            end
        else
            circuit_name=circuit_name.."-"..ingredients[i]
        end
    end
    circuit_name=circuit_name.."-circuit-"..class.."-"..electric.."-hybrid"
    if not data.raw.item[circuit_name] then    
        --log(circuit_name.." does not exist, may cause issues.")
    end
    return circuit_name 
end
