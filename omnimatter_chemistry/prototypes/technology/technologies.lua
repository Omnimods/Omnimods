data:extend({
    {
    type = "technology",
    name = "carbomni-1",
    icon = "__omnimatter_chemistry__/graphics/technology/carbomni.png",
    icon_size = 128,
    order = "z",
    effects = {
        {type = "unlock-recipe",
        recipe="omnicarbide"},
        {type = "unlock-recipe",
        recipe="omnixylic-acid"},
        {type = "unlock-recipe",
        recipe="orthomnide"},
        
    },
    --upgrade = true,
    prerequisites = {"omni-processing-1", "angels-coal-processing"},
    unit =
    {
        count = 100,
        ingredients =
        {
            {"science-pack-1",1},
        },
        time = 20
    }
    },
    {
    type = "technology",
    name = "omni-processing-1",
    icon = "__omnimatter_chemistry__/graphics/technology/omni-processing.png",
    icon_size = 128,
    order = "z",
    effects = {
        {type = "unlock-recipe",
        recipe="omnion"}
        
    },
    --upgrade = true,
    prerequisites = {"omnic-hydrolyzation-1", "basic-chemistry"},
    unit =
    {
        count = 75,
        ingredients =
        {
            {"science-pack-1",1},
        },
        time = 30
    }
    },
    {
    type = "technology",
    name = "thiomni-1",
    icon = "__omnimatter_chemistry__/graphics/technology/thiomni.png",
    icon_size = 128,
    order = "z",
    effects = {
        {type = "unlock-recipe",
        recipe="omnisite"},
    },
    --upgrade = true,
    prerequisites = {"omnic-hydrolyzation-1", "basic-chemistry"},
    unit =
    {
        count = 75,
        ingredients =
        {
            {"science-pack-1",1},
            {"science-pack-2",1},
        },
        time = 30
    }
    },
})