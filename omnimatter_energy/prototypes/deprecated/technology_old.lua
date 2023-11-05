data:extend({
{ 
    type = "technology",
    name = "omnium-power",
    icon = "__omnimatter_electricity__/graphics/technology/omnium-power.png",
    icon_size = 128,
    prerequisites =
    {
        "fluid-handling",
        "omnicells",
        "omnitech-crystallonics-2",
    },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "omnictor"
      },
      {
        type = "unlock-recipe",
        recipe = "omnium-reactor"
      },
      {
        type = "unlock-recipe",
        recipe = "molten-hydromnide-salt"
      },
      {
        type = "unlock-recipe",
        recipe = "omnium"
      },
      {
        type = "unlock-recipe",
        recipe = "oxyomnide-cooling-500"
      },
      {
        type = "unlock-recipe",
        recipe = "oxyomnide-cooling-400"
      },
      {
        type = "unlock-recipe",
        recipe = "oxyomnide-cooling-300"
      },
      {
        type = "unlock-recipe",
        recipe = "oxyomnide-solidification"
      },
      {
        type = "unlock-recipe",
        recipe = "omnium-turbine"
      },
      {
        type = "unlock-recipe",
        recipe = "oxyomnide-hydromnization"
      },
    },
    unit =
    {
      count = 250,
      ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      },
      time = 30
    },
    order = "c-a"
    },

    { 
    type = "technology",
    name = "omnibattery",
    icon = "__omnimatter_electricity__/graphics/technology/battery.png",
    icon_size = 128,
    prerequisites =
    {
        "omnitech-omniston-solvation-1",
        "battery",
    },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "charge-omnicell"
      },
      {
        type = "unlock-recipe",
        recipe = "naturize-omnicell"
      },
    },
    unit =
    {
      count = 450,
      ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      },
      time = 30
    },
    order = "c-a"
    },
    
    { 
    type = "technology",
    name = "omni-electric-train",
    icon = "__omnimatter_electricity__/graphics/technology/battery.png",
    icon_size = 128,
    prerequisites =
    {
        "omnibattery",
        "railway",
    },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "charge-omnicell"
      },
      {
        type = "unlock-recipe",
        recipe = "naturize-omnicell"
      },
    },
    unit =
    {
      count = 450,
      ingredients = {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
      {"science-pack-3", 1},
      },
      time = 30
    },
    order = "c-a"
    }
})

if mods["boblogistics"] then
    omni.lib.replace_prerequisite("omnicells","fluid-handling","bob-fluid-handling-2")
  omni.lib.replace_prerequisite("omnium-power","fluid-handling","bob-fluid-handling-2")
  omni.lib.replace_prerequisite("naturize-omnicell","fluid-handling","bob-fluid-handling-2")
end

if mods["bobpower"] then
    omni.lib.add_prerequisite("omnium-power","bob-steam-power-2")
end

if mods["omnimatter_science"] then
    omni.lib.replace_science_pack("omnicells","science-pack-3", "omni-pack")
    omni.lib.replace_science_pack("omnibattery","science-pack-3", "omni-pack")
    omni.lib.add_science_pack("omnium-power", "omni-pack")
end