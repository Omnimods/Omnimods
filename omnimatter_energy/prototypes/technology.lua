data:extend({
    { 
        type = "technology",
        name = "omnium-power-1",
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "basic-automation",
        },
        effects =
        {
        },
        unit =
        {
          count = 80,
          ingredients = 
            {
            {"automation-science-pack", 1},
            },
          time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnium-power-2",
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnium-power-1",
        },
        effects =
        {
        },
        unit =
        {
          count = 120,
          ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
          },
          time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnium-power-3",
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnium-power-2",
        },
        effects =
        {
        },
        unit =
        {
          count = 175,
          ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
          },
          time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnium-power-4",
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnium-power-3",
        },
        effects =
        {
        },
        unit =
        {
          count = 250,
          ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            },
          time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnium-power-5",
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnium-power-4",
        },
        effects =
        {
        },
        unit =
        {
          count = 400,
          ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"utility-science-pack", 1},
            },
          time = 30
        },
        order = "c-a"
    },
})