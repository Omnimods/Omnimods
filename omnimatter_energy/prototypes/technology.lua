local function get_packs(tier)
  local c = {}
  local length = math.min(tier,#omni.sciencepacks)
  for l=1,length do
    c[#c+1] = {omni.sciencepacks[l],1}
  end
  return c
end

data:extend({
    { 
        type = "technology",
        name = "omnitech-omnium-power-1",
        localised_name = {"technology-name.omnium-power-1"},
        localised_description = {"technology-description.omnium-power-1"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "steam-power",
        },
        effects =
        {
        },
        unit =
        {
          count = 80,
          ingredients = get_packs(2),
          time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnitech-omnium-power-2",
        localised_name = {"technology-name.omnium-power-2"},
        localised_description = {"technology-description.omnium-power-2"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-omnium-power-1",
        },
        effects =
        {
        },
        unit =
        {
          count = 160,
          ingredients = get_packs(2),
          time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnitech-omnium-power-3",
        localised_name = {"technology-name.omnium-power-3"},
        localised_description = {"technology-description.omnium-power-3"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-omnium-power-2",
        },
        effects =
        {
        },
        unit =
        {
          count = 175,
          ingredients = get_packs(3),
          time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnitech-omnium-power-4",
        localised_name = {"technology-name.omnium-power-4"},
        localised_description = {"technology-description.omnium-power-4"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-omnium-power-3",
        },
        effects =
        {
        },
        unit =
        {
          count = 250,
          ingredients = get_packs(4),
          time = 30
        },
        order = "c-a"
    },
    { 
        type = "technology",
        name = "omnitech-omnium-power-5",
        localised_name = {"technology-name.omnium-power-5"},
        localised_description = {"technology-description.omnium-power-5"},
        icon = "__omnimatter_energy__/graphics/technology/omnium-power.png",
        icon_size = 128,
        prerequisites =
        {
            "omnitech-omnium-power-4",
        },
        effects =
        {
        },
        unit =
        {
          count = 400,
          ingredients = get_packs(5),
          time = 30
        },
        order = "c-a"
    },
    { 
      type = "technology",
      name = "omnitech-omni-solar-road",
      localised_name = {"technology-name.omni-solar-road"},
      icon = "__omnimatter_energy__/graphics/technology/omni-solar-road.png",
      icon_size = 128,
      prerequisites =
      {
        "concrete",
        "omnitech-crystal-solar-panel-tier-"..settings.startup["omnielectricity-solar-tiers"].value.."-size-"..settings.startup["omnielectricity-solar-size"].value,
        "space-science-pack",
      },
      effects =
      {
        {type = "unlock-recipe",recipe = "omni-solar-road"}
      },
      unit =
      {
        count = 2000,
        ingredients = get_packs(6),
        time = 30
      },
      order = "c-a"
  },
})