
omni.crystal.metals = {}

local function salt_omnide_icon(metal)
    --Build the icons table
    local icons = util.combine_icons(
        {{
            icon = "__omnimatter_crystal__/graphics/icons/omnide-salt.png",
            icon_size = 32
        }},
        omni.lib.icon.of(data.raw.item[metal]),
        {}
    )
    for I=2, #icons do
        icons[I].scale = 0.4 * 32 / icons[I].icon_size
        icons[I].shift = {-10, 10}
    end
    return icons
end


function omni.crystal.add_crystal(ore_name, metal_name)
    if data.raw.item[ore_name] and not data.raw.recipe[ore_name.."-crystal"] then
        omni.crystal.metals[#omni.crystal.metals+1]=data.raw.item[ore_name]

        RecGen:create("omnimatter_crystal", ore_name.."-crystal"):
            setLocName("recipe-name.crystal", metal_name):
            --setFuelValue(35):
            --setFuelCategory("crystal"):
            setSubgroup("crystallization"):
            setOrder("a["..ore_name.."-crystal]"):
            setStacksize(500):
            setIcons({ore_name.."-crystal", 32}):
            setCategory("omniplant"):
            setIngredients({
                {type = "item", name = "omnine-shards", amount = 1},
                {type = "fluid", name = ore_name.."-omnide-solution", amount = 120},
                {type = "fluid", name = "omnisludge", amount = 120},
                }):
            setResults({type = "item", name = ore_name.."-crystal", amount=10}):
            setEnergy(2.5):
            extend()

        ItemGen:create("omnimatter_crystal", ore_name.."-omnide-salt"):
            setLocName("item-name.omnide-salt", metal_name):
            setIcons({"omnide-salt", 32}):
            addSmallIcon(ore_name, 3):
            setSubgroup("crystallization"):
            setStacksize(200):
            extend()

        RecGen:create("omnimatter_crystal", ore_name.."-omnide-solution"):
            setLocName("recipe-name.ore-solvation", metal_name):
            fluid():
            setBothColour(omni.lib.ore_tints[string.lower(metal_name)] or {1,1,1}):
            setSubgroup("solvation"):
            setOrder("a["..ore_name.."-omnide-solution]"):
            setIcons({"omnide-solution", 32}):
            addSmallIcon(ore_name, 3):
            setCategory("omniplant"):
            setIngredients({
                {type = "item", name = ore_name.."-omnide-salt", amount = 1},
                {type = "fluid", name = "water", amount = 100},
                }):
            setResults({type = "fluid", name = ore_name.."-omnide-solution", amount=120}):
            setEnergy(2.5):
            extend()

        --Since vanilla creates barrel recipes in data-updates, we need to create barreling recipes for this manually
        omni.lib.create_barrel(ore_name.."-omnide-solution")

        RecGen:create("omnimatter_crystal", ore_name.."-crystal-omnitraction"):
            setLocName("recipe-name.crystal-omnitraction","item-name."..ore_name):
            setSubgroup("traction"):
            setOrder("a["..ore_name.."-crystal-omnitraction]"):
            setIcons(omni.lib.icon.of(ore_name, true)):
            setCategory("omnite-extraction"):
            addProductivity():
            setIngredients({type = "item", name = ore_name.."-crystal", amount=3}):
            setResults({type = "item", name = ore_name, amount=4}):
            setEnergy(1.5):
            extend()
    end
end

local function ingrediences_solvation(recipe)
    local ing = {}
    ing[#ing+1]={type = "fluid", name = "hydromnic-acid", amount = 120}
    for _, i in pairs(data.raw.recipe[recipe].ingredients) do
        if i.name ~= "catalysator-brown" then
            ing[#ing+1]=i
        end
    end
    return ing
end

local function results_solvation(recipe)
    local ing = {}
    --ing[#ing+1]={type = "fluid", name = "hydromnic-acid", amount = 120}
    for _, i in pairs(data.raw.recipe[recipe].results) do
        --log(recipe..":"..i.name)
        if i.name ~= "slag" then
            ing[#ing+1]={type = "item", name=i.name.."-omnide-salt", amount = 5*i.amount}
        end
    end
    return ing
end

function omni.crystal.add_recipe(recipe,name)
    crystalines={}
    local ing = ingrediences_solvation(recipe)
    local res = results_solvation(recipe)
    local metal = name
    if not name then metal = data.raw.recipe[recipe].ingredients[1].name end
    local ic = salt_omnide_icon(metal)
    if not data.raw["item-subgroup"][data.raw.recipe[recipe].subgroup.."-omnide"] then
        local cat = {
            type = "item-subgroup",
            name = data.raw.recipe[recipe].subgroup.."-omnide",
            group = "omnicrystal",
            order = data.raw["item-subgroup"]["solvation"].order, -- set the order of the "solvation" subgroup to be able to control the order of all created subgroups
        }
        crystalines[#crystalines+1]=cat
    end
    ----log(recipe..":"..metal..","..data.raw.recipe[recipe].subgroup.."-omnide")
    local solution = {
        type = "recipe",
        name = metal.."-salting",
        localised_name = {"recipe-name.omnide-salting", metal},
        localised_description = {"recipe-description.pure_extraction", metal},
        category = "omniplant",
        subgroup = data.raw.recipe[recipe].subgroup.."-omnide",
        order = data.raw.recipe[recipe].order,
        enabled = false,
        ingredients = ing,
        icons = ic,
        results = res,
        energy_required = 5,
    }
    crystalines[#crystalines+1]=solution

    data:extend(crystalines)
end
