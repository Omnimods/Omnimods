local nr_tiers = settings.startup["omnielectricity-solar-tiers"].value
local max_size = settings.startup["omnielectricity-solar-size"].value

local parts = {"plate","crystal","circuit"}

local quant = {}
quant["plate"] = 8
quant["crystal"] = 4
quant["circuit"] = 6

local component={}
component["plate"] = {"omnium-plate", "omnium-iron-alloy", "omnium-steel-alloy"}
component["crystal"] = {}
component["circuit"] = {}

if mods["omnimatter_crystal"] then
    component["crystal"] = {"iron-ore-crystal"}
    component["circuit"] = {"basic-crystallonic", "basic-oscillo-crystallonic"}
else
    component["crystal"] = {"iron-plate"}
    component["circuit"] = {"electronic-circuit", "advanced-circuit", "processing-unit"}
end

if data.raw.item["lead-ore-crystal"] then component["crystal"][#component["crystal"]+1] = "lead-ore-crystal" end
if data.raw.item["quartz-crystal"] then component["crystal"][#component["crystal"]+1] = "quartz-crystal" end
if data.raw.item["cobalt-ore-crystal"] then component["crystal"][#component["crystal"]+1] = "cobalt-ore-crystal" end
if data.raw.item["silver-ore-crystal"] then component["crystal"][#component["crystal"]+1] = "silver-ore-crystal" end

if data.raw.item["omnium-aluminium-alloy"] then component["plate"][#component["plate"]+1] = "omnium-aluminium-alloy" end
if data.raw.item["omnium-tungsten-alloy"] then component["plate"][#component["plate"]+1] = "omnium-tungsten-alloy" end


local get_cost = function(tier, size)
    local ing = {}
    --Add components to each crystal panel recipe
    for _,part in pairs(parts) do
        local amount = quant[part]
        for i=tier, 1, -1 do

            if component[part] and component[part][i] then
                ing[#ing+1]={type="item",name=component[part][i],amount=amount}
                break
            else
                amount = amount + 2
            end
        end
    end

    if size > 1 then
        if size > 2 then
            ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-"..size-1,amount=1}
            ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-1",amount=math.pow(size,2)-math.pow(size-1,2)}
        elseif size==2 then
            ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..tier.."-size-"..size-1,amount=4}
        end
    else
        ing[#ing+1]={type="item",name="crystal-panel",amount=7}
    end

    if tier > 1 and size == 1 then
        ing[#ing+1]={type="item",name="crystal-solar-panel-tier-"..(tier-1).."-size-1",amount=1}
    end

    return ing
end

local get_req = function(tier, size)
    local req = {}
    local crystal = mods["omnimatter_crystal"]

    if tier == 1 and size == 1 then
        req = {"solar-energy"}
        if crystal then req[2] = "omnitech-crystallonics-1" end
    elseif size == 1 then
        if tier <= 5 then
            req = {"omnitech-crystal-solar-panel-tier-"..(tier-1).."-size-"..max_size}
            if crystal then req[2] = "omnitech-crystallonics-"..tier end
        else
            req = {"omnitech-crystal-solar-panel-tier-"..(tier-1).."-size-"..max_size}
        end
    else
        req = {"omnitech-crystal-solar-panel-tier-"..tier.."-size-"..size-1}
    end
    return req
end

local get_scienceing = function(tier)
    local packs = {}
    for i=1,math.min(tier+1,5) do
        packs[#packs+1] = {omni.sciencepacks[i],1}
    end
    return packs
end

local sol = {}
for j=1,nr_tiers do
    --subgroup
    sol[#sol+1]={
        type = "item-subgroup",
        name = "omnienergy-solar-tier-"..j,
        group = "omnienergy",
        order = data.raw["item-subgroup"]["omnienergy-solar"].order..j,
    }

    for i=1,max_size do
        --panel pictures
        local pic = {}
        local icons={{icon="__omnimatter_energy__/graphics/icons/empty.png",icon_size=32}}
        local ticons={{icon="__omnimatter_energy__/graphics/technology/empty.png",icon_size=32}}
        for k=i,1,-1 do
            for l=1, i do
                --entity pictures
                pic[#pic+1]={
                    filename = "__omnimatter_energy__/graphics/entity/buildings/zolar-panel.png",
                    priority = "high",
                    width = 192,
                    height = 192,
                    scale=0.5,
                    shift = {k-i/2-0.5,l-i/2-0.4},
                }
                --recipe icons
                icons[#icons+1]={
                    icon="__omnimatter_energy__/graphics/icons/zolar-panel.png",
                    icon_size= 32,
                    scale = 1/i,
                    shift={(k-i/2-0.5)*32/i,(l-i/2-0.5)*32/i}
                }

                --tech icons
                ticons[#ticons+1]={
                    icon="__omnimatter_energy__/graphics/technology/zolar-panel.png",
                    icon_size= 128,
                    scale = 1/i*72/128,
                    shift={(k-i/2-0.5)*32/i,(l-i/2-0.5)*32/i}
                }
            end
        end
        --crystal links
        for k=1,i-1 do
            for l=1, i-1 do
                --entity pictures
                pic[#pic+1]={
                    filename = "__omnimatter_energy__/graphics/entity/buildings/zolar-crystal.png",
                    priority = "high",
                    width = 192,
                    height = 192,
                    scale=0.5,
                    shift = {k-i/2,l-i/2},
                }
                --recipe icons
                ticons[#icons+1]={
                    icon="__omnimatter_energy__/graphics/entity/buildings/zolar-crystal.png",
                    icon_size=192,
                    scale = 1/i*72/192,
                    shift={(k-i/2)*32/i,(l-i/2)*32/i}
                }

                --tech icons
                ticons[#ticons+1]={
                    icon="__omnimatter_energy__/graphics/entity/buildings/zolar-crystal.png",
                    icon_size=192,
                    scale = 1/i*72/192,
                    shift={(k-i/2)*32/i,(l-i/2)*32/i}
                }
            end
        end

        --add tier icon
        icons[#icons+1]={icon="__omnilib__/graphics/icons/small/lvl"..j..".png",icon_size=64,scale=0.5} --handles 0-8
        ticons[#ticons+1]={icon="__omnilib__/graphics/icons/small/lvl"..j..".png",icon_size=64,scale=0.5} --handles 0-8

        --solar panel array entity
        sol[#sol+1]={
            type = "solar-panel",
            name = "crystal-solar-panel-tier-"..j.."-size-"..i,
            localised_name = {"entity-name.crystal-solar-panel", j, i},
            icons = icons,
            icon_size = 32,
            flags = {"placeable-neutral", "player-creation"},
            minable = {mining_time = 0.5, result = "crystal-solar-panel-tier-"..j.."-size-"..i},
            max_health = 200,
            corpse = "big-remnants",
            collision_box = {{-i*0.5+0.1, -i*0.5+0.1}, {i*0.5-0.1, i*0.5-0.1}},
            selection_box = {{-i*0.5, -i*0.5}, {i*0.5, i*0.5}},
            energy_source =
            {
                type = "electric",
                usage_priority = "solar"
            },
            picture =
            {
                layers =pic,
            },
            vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
            production = math.floor(5*math.pow(i,2)*math.pow(1.2,i-1)*math.pow(1.5,j-1)).."kW"
        }

        RecGen:create("omnimatter_energy", "crystal-solar-panel-tier-"..j.."-size-"..i):
            setLocName({"recipe-name.crystal-solar-panel", j, i}):
            setIcons(icons):
            setIngredients(get_cost(j,i)):
            setResults({name = "crystal-solar-panel-tier-"..j.."-size-"..i, amount = 1}):
            setPlace("crystal-solar-panel-tier-"..j.."-size-"..i):
            setSubgroup("omnienergy-solar-tier-"..j):
            setOrder("a[crystal-solar-panel-tier-"..j.."-size-"..i.."]"):
            setCategory("crafting"):
            setEnergy(10):
            setEnabled(false):
            setStacksize(50):
            setTechName("omnitech-crystal-solar-panel-tier-"..j.."-size-"..i):
            setTechLocName("omnitech-crystal-solar-panel", j, i):
            setTechIcons(ticons):        
            setTechCost(150+((j-1)*max_size+i)*75+j*100):    --base_cost+...*cost_between_techs+...*addidional_cost_between_tiers
            setTechPacks(get_scienceing(j)):
            setTechPrereq(get_req(j,i)):
            setForce():
            extend()
    end
end

data:extend(sol)


for j=1,nr_tiers do
    for i=1,max_size do
        --Add an upgrade recipe from previous tier max size to this tier size 1
        if i == 1 and j > 1 then
            RecGen:create("omnimatter_energy", "crystal-solar-panel-tier-"..j.."-size-"..i.."-upgrade"):
                noItem():
                setLocName({"recipe-name.crystal-solar-panel", j, i}):
                setIcons(omni.lib.icon.of("crystal-solar-panel-tier-"..j.."-size-"..i, "item")):
                addSmallIcon({{icon = "__core__/graphics/icons/technology/effect-constant/effect-constant-capacity.png", icon_size = 64, scale = 0.6, icon_mipmaps = 2}}, 4):
                setIngredients(get_cost(j,i)):
                removeIngredients("crystal-solar-panel-tier-"..(j-1).."-size-"..i):
                multiplyIngredients(max_size*max_size):
                addIngredients({name = "crystal-solar-panel-tier-"..(j-1).."-size-"..max_size, amount = 1}):
                setResults({name="crystal-solar-panel-tier-"..j.."-size-"..i, amount=max_size*max_size}):
                setSubgroup("omnienergy-solar-tier-"..j):
                setOrder("a[crystal-solar-panel-tier-"..j.."-size-"..i.."]z"):
                setCategory("crafting"):
                setEnergy(40):
                setEnabled(false):
                setTechName("omnitech-crystal-solar-panel-tier-"..j.."-size-"..i):
                extend()
        end

        --Add an upgrade recipe from size 1 to max size that unlocks with the final tier research
        if i == max_size then
            RecGen:create("omnimatter_energy", "crystal-solar-panel-tier-"..j.."-size-"..i.."-upgrade"):
                noItem():
                setLocName({"recipe-name.crystal-solar-panel", j, i}):
                setIcons(omni.lib.icon.of("crystal-solar-panel-tier-"..j.."-size-"..i, "item")):
                addSmallIcon({{icon = "__core__/graphics/icons/technology/effect-constant/effect-constant-movement-speed.png", icon_size = 64, scale = 0.6, icon_mipmaps = 2}}, 4):
                setIngredients(get_cost(j,i)):
                removeIngredients("crystal-solar-panel-tier-"..j.."-size-"..(i-1),"crystal-solar-panel-tier-"..j.."-size-"..1):
                multiplyIngredients(max_size-1):
                addIngredients({name = "crystal-solar-panel-tier-"..j.."-size-"..1, amount = max_size*max_size}):
                setResults({name="crystal-solar-panel-tier-"..j.."-size-"..i, amount=1}):
                setSubgroup("omnienergy-solar-tier-"..j):
                setOrder("a[crystal-solar-panel-tier-"..j.."-size-"..i.."]z"):
                setCategory("crafting"):
                setEnergy(40):
                setEnabled(false):
                setTechName("omnitech-crystal-solar-panel-tier-"..j.."-size-"..i):
                extend()
        end
    end
end

omni.lib.replace_all_ingredient("solar-panel","crystal-panel")