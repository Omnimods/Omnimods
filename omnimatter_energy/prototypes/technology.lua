data:extend({
    { 
        type = "technology",
        name = "omnium-power-1",
        localised_name = {"technology-name.omnium-power-1"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "simple-automation",
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
        localised_name = {"technology-name.omnium-power-2"},
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
        localised_name = {"technology-name.omnium-power-3"},
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
        localised_name = {"technology-name.omnium-power-4"},
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
        localised_name = {"technology-name.omnium-power-5"},
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
    { 
      type = "technology",
      name = "omni-solar-road",
      localised_name = {"technology-name.omni-solar-road"},
      icon = "__omnimatter_energy__/graphics/technology/omni-solar-road.png",
      icon_size = 128,
      prerequisites =
      {
        "concrete",
        "crystal-solar-panel-tier-"..settings.startup["omnielectricity-solar-tiers"].value.."-size-"..settings.startup["omnielectricity-solar-size"].value,
      },
      effects =
      {
        {type = "unlock-recipe",recipe = "omni-solar-road"}
      },
      unit =
      {
        count = 2000,
        ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"production-science-pack", 1},
          {"utility-science-pack", 1},
          {"space-science-pack", 1},
          },
        time = 30
      },
      order = "c-a"
  },
})