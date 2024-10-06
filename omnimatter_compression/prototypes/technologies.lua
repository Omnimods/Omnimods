-------------------------------------------------------------------------------
--[[Create Technologies]]--
-------------------------------------------------------------------------------
--local tech_cat = {ores=1, items=2, tiles=3, ammo=4, entities=5, modules=6, equipment=7}
--{"automation-science-pack","logistic-science-pack","chemical-science-pack","military-science-pack", "production-science-pack","utility-science-pack"}
local tech1 = {
    --compression
    type = "technology",
    name = "compression-initial",
    icon = "__omnimatter_compression__/graphics/compress-tech.png",
    icon_size = 128,
    order = "z",
    effects = {{type = "unlock-recipe",recipe="auto-compressor"}, {type = "unlock-recipe",recipe="auto-concentrator"}},
    upgrade = true,
    prerequisites = {"logistics", "steel-processing"},
    unit =
    {
        count = 750,
        ingredients =
        {
            {"automation-science-pack",1},
            {"logistic-science-pack",1},
            {"chemical-science-pack",1},
        },
        time = 20
    }
}
if settings.startup["omnicompression_entity_compression"].value then
    tech1.effects[#tech1.effects+1] = {type = "unlock-recipe",recipe="auto-condensator"}
end

local tech22 = {
    --ores
    type = "technology",
    name = "compression-hand",
    icon = "__omnimatter_compression__/graphics/compress-tech.png",
    icon_size = 128,
    order = "z",
    effects = {},
    upgrade = true,
    prerequisites = {"compression-initial"},
    unit =
    {
        count = 1500,
        ingredients =
        {
            {"automation-science-pack",1},
            {"logistic-science-pack",1},
            {"chemical-science-pack",1}
        },
        time = 35
    }
}

local tech2 = {
    --ores
    type = "technology",
    name = "compression-recipes",
    icon = "__omnimatter_compression__/graphics/compress-tech.png",
    icon_size = 128,
    order = "z",
    effects = {},
    upgrade = true,
    prerequisites = {"compression-initial","advanced-circuit"},
    unit =
    {
        count = 1000,
        ingredients =
        {
            {"automation-science-pack",1},
            {"logistic-science-pack",1},
            {"chemical-science-pack",1}
        },
        time = 20
    }
}

local tech3 = {
    --ores
    type = "technology",
    name = "compression-mining",
    icon = "__omnimatter_compression__/graphics/compress-tech.png",
    icon_size = 128,
    order = "z",
    upgrade = true,
    prerequisites = {"compression-recipes","processing-unit"},
    unit =
    {
        count = 1500,
        ingredients =
        {
            {"automation-science-pack",1},
            {"logistic-science-pack",1},
            {"chemical-science-pack",1},
            {"production-science-pack",1}
        },
        time = 20
    }
}

local tech4 = {
    --ores
    type = "technology",
    name = "compression-compact-buildings",
    icon = "__omnimatter_compression__/graphics/compress-tech.png",
    icon_size = 128,
    order = "z",
    effects = {},
    upgrade = true,
    prerequisites = {"compression-mining"},
    unit =
    {
        count = 2000,
        ingredients =
        {
            {"automation-science-pack",1},
            {"logistic-science-pack",1},
            {"chemical-science-pack",1},
            {"production-science-pack",1}
        },
        time = 20
    }
}

local tech5 = {
    --ores
    type = "technology",
    name = "compression-nanite-buildings",
    icon = "__omnimatter_compression__/graphics/compress-tech.png",
    icon_size = 128,
    order = "z",
    effects = {},
    upgrade = true,
    prerequisites = {"compression-compact-buildings"},
    unit =
    {
        count = 2500,
        ingredients =
        {
            {"automation-science-pack",1},
            {"logistic-science-pack",1},
            {"chemical-science-pack",1},
            {"production-science-pack",1}
        },
        time = 20
    }
}

local tech6 = {
    --ores
    type = "technology",
    name = "compression-quantum-buildings",
    icon = "__omnimatter_compression__/graphics/compress-tech.png",
    icon_size = 128,
    order = "z",
    effects = {},
    upgrade = true,
    prerequisites = {"compression-nanite-buildings"},
    unit =
    {
        count = 3000,
        ingredients =
        {
            {"automation-science-pack",1},
            {"logistic-science-pack",1},
            {"chemical-science-pack",1},
            {"production-science-pack",1},
            {"utility-science-pack",1}
        },
        time = 20
    }
}

local tech7 = {
    --ores
    type = "technology",
    name = "compression-singularity-buildings",
    icon = "__omnimatter_compression__/graphics/compress-tech.png",
    icon_size = 128,
    order = "z",
    effects = {},
    upgrade = true,
    prerequisites = {"compression-quantum-buildings"},
    unit =
    {
        count = 3500,
        ingredients =
        {
            {"automation-science-pack",1},
            {"logistic-science-pack",1},
            {"chemical-science-pack",1},
            {"production-science-pack",1},
            {"utility-science-pack",1}
        },
        time = 20
    }
}

data:extend({tech1,tech2,tech3,tech4,tech5,tech6,tech7,tech22})