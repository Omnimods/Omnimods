data.raw.resource["tin-ore"] = nil
data.raw["autoplace-control"]["tin-ore"] = nil
data.raw.resource["lead-ore"] = nil
data.raw["autoplace-control"]["lead-ore"] = nil
data.raw.resource["quartz"] = nil
data.raw["autoplace-control"]["quartz"] = nil
data.raw.resource["tungsten-ore"] = nil
data.raw["autoplace-control"]["tungsten-ore"] = nil
data.raw.resource["rutile-ore"] = nil
data.raw["autoplace-control"]["rutile-ore"] = nil
data.raw.resource["silver-ore"] = nil
data.raw["autoplace-control"]["silver-ore"] = nil
data.raw.resource["bauxite-ore"] = nil
data.raw["autoplace-control"]["bauxite-ore"] = nil
data.raw.resource["gold-ore"] = nil
data.raw["autoplace-control"]["gold-ore"] = nil
data.raw.resource["nickel-ore"] = nil
data.raw["autoplace-control"]["nickel-ore"] = nil
data.raw.resource["zinc-ore"] = nil
data.raw["autoplace-control"]["zinc-ore"] = nil
data.raw.resource["gem-ore"] = nil
data.raw["autoplace-control"]["gem-ore"] = nil
data.raw.resource["sulfur"] = nil
data.raw["autoplace-control"]["sulfur"] = nil
data:extend(
{
  {
    type = "recipe",
    name = "sort-gem-ore",
    energy_required = 1,
	icon_size = 32,
    ingredients =
    {
	  {"gem-ore", 1},
    },
    results =
    {
      {type="item", name="ruby-ore", amount=1, probability = bobmods.gems.RubyRatio},
      {type="item", name="sapphire-ore", amount=1, probability = bobmods.gems.SapphireRatio},
      {type="item", name="emerald-ore", amount=1, probability = bobmods.gems.EmeraldRatio},
      {type="item", name="amethyst-ore", amount=1, probability = bobmods.gems.AmethystRatio},
      {type="item", name="topaz-ore", amount=1, probability = bobmods.gems.TopazRatio},
      {type="item", name="diamond-ore", amount=1, probability = bobmods.gems.DiamondRatio},
    },
    subgroup = "bob-ores",
    icon = "__bobores__/graphics/icons/gem-ore.png",
    order = "a-0",
  },
}
)
if data.raw["item-subgroup"]["bob-gems-ore"] then
  data.raw.recipe["sort-gem-ore"].subgroup = "bob-gems-ore"
end

bobmods.lib.module.add_productivity_limitation("sort-gem-ore")

--remove ground water if it exists and if the settings exist
if (bobmods.ores and settings.startup["bobmods-ores-enablewaterores"].value) or (bobmods.plates and bobmods.ores.bauxite.create_autoplace and settings.startup["bobmods-plates-groundwater"].value == false) then
  data.raw.resource["ground-water"] = nil
  data.raw["autoplace-control"]["ground-water"] = nil
  for _, pre in pairs(data.raw["map-gen-presets"].default) do
    if pre.basic_settings then
      if pre.basic_settings.autoplace_controls then
        pre.basic_settings.autoplace_controls["ground-water"] = nil
      end
    end
  end
end