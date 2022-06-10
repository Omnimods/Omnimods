if mods["Bio_Industries"] then

    if not mods["bobgreenhouse"] then
        ItemGen:create("omnimatter_wood","omniseedling"):
            setFuelValue(0.7):
            setSubgroup("omnimutator-items"):
            setStacksize(100):extend()
    end

    --replace all seedlings with omniseedlings 1:1
    omni.lib.replace_all_ingredient("seedling", "omniseedling")
    omni.lib.replace_all_result("seedling", "omniseedling")

    data.raw.recipe["bi-seedling-1"].category="omnimutator"
    data.raw.recipe["bi-seedling-1"].icon=nil
    data.raw.recipe["bi-seedling-1"].icons={
        {icon="__omnimatter_wood__/graphics/icons/Seedling.png", icon_size=32},
        {icon="__base__/graphics/icons/fluid/water.png",
        scale = 0.23,
        shift = { 10, 10},
        icon_size = 64,
        icon_mipmaps = 4,}
    }
    
    data.raw.recipe["bi-seedling-2"].category="omnimutator"
    data.raw.recipe["bi-seedling-2"].icon=nil
    data.raw.recipe["bi-seedling-2"].icons={
        {icon="__omnimatter_wood__/graphics/icons/Seedling.png", icon_size=32},
        {icon="__Bio_Industries__/graphics/icons/ash_64.png",
        scale = 0.4375,
        shift = { 10, 10},
        icon_size=64,}
    }
    
    data.raw.recipe["bi-seedling-3"].category="omnimutator"
    data.raw.recipe["bi-seedling-3"].icon=nil
    data.raw.recipe["bi-seedling-3"].icons={
        {icon="__omnimatter_wood__/graphics/icons/Seedling.png", icon_size=32},
        {icon="__Bio_Industries__/graphics/icons/fertilizer_64.png",
        scale = 0.4375,
        shift = { 10, 10},
        icon_size=64,}
    }
    
    data.raw.recipe["bi-seedling-4"].category="omnimutator"
    data.raw.recipe["bi-seedling-4"].icon=nil
    data.raw.recipe["bi-seedling-4"].icons={
        {icon="__omnimatter_wood__/graphics/icons/Seedling.png", icon_size=32},
        {icon="__Bio_Industries__/graphics/icons/advanced_fertilizer_64.png",
        scale = 0.4375,
        shift = { 10, 10},
        icon_size=64,}
    }
    
    
    omni.lib.replace_recipe_result("bi-logs-1","wood",{name = "omniwood", amount =60})
    data.raw.recipe["bi-logs-1"].icon=nil
    data.raw.recipe["bi-logs-1"].icons={
        {icon="__omnimatter_wood__/graphics/icons/mutated-wood2.png", icon_size=32},
        {icon="__base__/graphics/icons/fluid/water.png",
        scale = 0.23,
        shift = { 10, 10},
        icon_size = 64,
        icon_mipmaps = 4,}
    }
    
    omni.lib.replace_recipe_result("bi-logs-2","wood",{name = "omniwood", amount =100})
    data.raw.recipe["bi-logs-2"].icon=nil
    data.raw.recipe["bi-logs-2"].icons={
        {icon="__omnimatter_wood__/graphics/icons/mutated-wood2.png", icon_size=32},
        {icon="__Bio_Industries__/graphics/icons/ash_64.png",
        scale = 0.4375,
        shift = { 10, 10},
        icon_size=64,}
    }
    
    omni.lib.replace_recipe_result("bi-logs-3","wood",{name = "omniwood", amount =150})
    data.raw.recipe["bi-logs-3"].icon=nil
    data.raw.recipe["bi-logs-3"].icons={
        {icon="__omnimatter_wood__/graphics/icons/mutated-wood2.png", icon_size=32},
        {icon="__Bio_Industries__/graphics/icons/fertilizer_64.png",
        scale = 0.4375,
        shift = { 10, 10},
        icon_size=64,}
    }
    
    omni.lib.replace_recipe_result("bi-logs-4","wood",{name = "omniwood", amount =250})
    data.raw.recipe["bi-logs-4"].icon=nil
    data.raw.recipe["bi-logs-4"].icons={
        {icon="__omnimatter_wood__/graphics/icons/mutated-wood2.png", icon_size=32},
        {icon="__Bio_Industries__/graphics/icons/advanced_fertilizer_64.png",
        scale = 0.4375,
        shift = { 10, 10},
        icon_size=64,}
    }
    
    omni.lib.add_prerequisite("bi-tech-bio-farming", "omnitech-omnimutator") 
end