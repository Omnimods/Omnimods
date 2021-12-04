data:extend(
{
  {
    type = "item-group",
    name = "boiling-steam",
    order = "z",
    icons = omni.lib.icon.of(data.raw.fluid["steam"]),
  },
  {
    type = "item-group",
    name = "convert-fluid",
    order = "zz",
    icons = omni.lib.icon.of(data.raw.item["solid-fuel"]),
  },
  
  {
    type = "item-subgroup",
    name = "boiler-sluid-steam",
    group = "boiling-steam",
    order = "aa",
  },
  {
    type = "item-subgroup",
    name = "boiler-sluid-converter",
    group = "convert-fluid",
    order = "ab",
  },
})