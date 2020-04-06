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
          count = 250,
          ingredients = 
            {
            {"automation-science-pack", 50},
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
          count = 250,
          ingredients = {
            {"automation-science-pack", 50},
            {"logistic-science-pack", 50},
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
          count = 250,
          ingredients = {
            {"automation-science-pack", 50},
            {"logistic-science-pack", 50},
            {"chemical-science-pack", 50},
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
            {"automation-science-pack", 50},
            {"logistic-science-pack", 50},
            {"chemical-science-pack", 50},
            {"production-science-pack", 50},
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
          count = 250,
          ingredients = {
            {"automation-science-pack", 50},
            {"logistic-science-pack", 50},
            {"chemical-science-pack", 50},
            {"production-science-pack", 50},
            {"utility-science-pack", 50},
            },
          time = 30
        },
        order = "c-a"
    },
})