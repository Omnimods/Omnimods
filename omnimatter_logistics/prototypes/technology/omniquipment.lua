data:extend({
{ 
    type = "technology",
    name = "omniquipment-basic",
    icon = "__omnimatter_logistics__/graphics/technology/omniquipment-basic.png",
    icon_size = 128,
    prerequisites =
    {
        "advanced-material-processing",
        "heavy-armor",
    },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "primitive-armour"
      },
      {
        type = "unlock-recipe",
        recipe = "omni-generator-eff-1-slot-1"
      },
      --[[{
        type = "unlock-recipe",
        recipe = "battery-steam"
      },]]
    },
    unit =
    {
      count = 150,
      ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      },
      time = 60
    },
    order = "c-a"
    },
    { 
    type = "technology",
    name = "omniquipment-shoes-1",
    icon = "__omnimatter_logistics__/graphics/technology/omnishoes.png",
    icon_size = 128,
    prerequisites =
    {
        "omniquipment-basic",
    },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "omni-shoes-1"
      },
    },
    unit =
    {
      count = 250,
      ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      },
      time = 60
    },
    order = "c-a"
    },
})