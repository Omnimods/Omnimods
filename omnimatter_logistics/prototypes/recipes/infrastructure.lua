if not mods["angelsindustries"] then --no need to add duplicates, only adds these if angels mods not active
  data:extend(
  {
  --CHESTS
    {
      type = "recipe",
      name = "angels-big-chest",
      enabled = false,
      energy_required = 5,
      ingredients ={
        {"iron-chest", 1},
        {"iron-plate", 10},
      },
      results=
      {
        {type="item", name="angels-big-chest", amount=1},
      },
    },
    {
      type = "recipe",
      name = "angels-logistic-chest-requester",
      enabled = false,
      energy_required = 5,
      ingredients ={
        {"angels-big-chest", 1},
        {"iron-plate", 10},
        {"electronic-circuit", 5}
      },
      results=
      {
        {type="item", name="angels-logistic-chest-requester", amount=1},
      },
    },
    {
      type = "recipe",
      name = "angels-logistic-chest-passive-provider",
      enabled = false,
      energy_required = 5,
      ingredients ={
        {"angels-big-chest", 1},
        {"iron-plate", 10},
        {"electronic-circuit", 5}
      },
      results=
      {
        {type="item", name="angels-logistic-chest-passive-provider", amount=1},
      },
    },
    {
      type = "recipe",
      name = "angels-logistic-chest-active-provider",
      enabled = false,
      energy_required = 5,
      ingredients ={
        {"angels-big-chest", 1},
        {"iron-plate", 10},
        {"electronic-circuit", 5}
      },
      results=
      {
        {type="item", name="angels-logistic-chest-active-provider", amount=1},
      },
    },
    {
      type = "recipe",
      name = "angels-logistic-chest-storage",
      enabled = false,
      energy_required = 5,
      ingredients ={
        {"angels-big-chest", 1},
        {"iron-plate", 10},
        {"electronic-circuit", 5}
      },
      results=
      {
        {type="item", name="angels-logistic-chest-storage", amount=1},
      },
    },
    {
      type = "recipe",
      name = "angels-logistic-chest-buffer",
      enabled = false,
      energy_required = 5,
      ingredients ={
        {"angels-big-chest", 1},
        {"iron-plate", 10},
        {"electronic-circuit", 5}
      },
      results=
      {
        {type="item", name="angels-logistic-chest-buffer", amount=1},
      },
    },
  })
end
data:extend(--add regardless
{
--construction roboport
  {
    type = "recipe",
    name = "omni-construction-roboport",
    enabled = false,
    energy_required = 5,
    ingredients ={
      {"steel-plate", 40},
      {"stone-brick", 20},
      {"iron-gear-wheel", 40},
      {"electronic-circuit", 40}
    },
    results=
    {
      {type="item", name="omni-construction-roboport", amount=1},
    },
  },
  --logistic roboport
  {
    type = "recipe",
    name = "omni-logistic-roboport",
    enabled = false,
    energy_required = 5,
    ingredients ={
      {"steel-plate", 60},
      {"stone-brick", 40},
      {"iron-gear-wheel", 60},
      {"electronic-circuit", 60}
    },
    results=
    {
      {type="item", name="omni-logistic-roboport", amount=1},
    },
  },
  --ZONE EXPANDER
  {
    type = "recipe",
    name = "omni-zone-expander",
    enabled = false,
    energy_required = 5,
    ingredients ={
    {"iron-plate", 5},
      {"electronic-circuit", 2},
    },
    results=
    {
      {type="item", name="omni-zone-expander", amount=1},
    },
  },
  --[[{
    type = "recipe",
    name = "omni-zone-expander-2",
    enabled = false,
    energy_required = 5,
    ingredients ={
    {"steel-plate", 5},
    {"iron-plate", 5},
      {"advanced-circuit", 2},
    },
    results=
    {
      {type="item", name="omni-zone-expander-2", amount=1},
    },
  },]]
--RELAY STATION
  {
    type = "recipe",
    name = "omni-relay-station",
    enabled = false,
    energy_required = 5,
    ingredients ={
    {"iron-plate", 5},
      {"electronic-circuit", 2},
    },
    results=
    {
      {type="item", name="omni-relay-station", amount=1},
    },
  },
  {
    type = "recipe",
    name = "omni-relay-station-2",
    enabled = false,
    energy_required = 5,
    ingredients ={
    {"steel-plate", 5},
    {"iron-plate", 5},
      {"advanced-circuit", 2},
    },
    results=
    {
      {type="item", name="omni-relay-station-2", amount=1},
    },
  },
})