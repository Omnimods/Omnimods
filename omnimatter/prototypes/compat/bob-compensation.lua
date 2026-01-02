if bobmods and bobmods.ores and settings.startup["bobmods-ores-unsortedgemore"].value then
    data:extend({
        {
            type = "recipe",
            name = "bob-sort-gem-ore",
            energy_required = 1,
            icon_size = 32,
            ingredients = {
                {type="item", name = "bob-gem-ore", amount = 1},
            },
            results = {
                {type="item", name="bob-ruby-ore", amount=1, probability = bobmods.gems.RubyRatio},
                {type="item", name="bob-sapphire-ore", amount=1, probability = bobmods.gems.SapphireRatio},
                {type="item", name="bob-emerald-ore", amount=1, probability = bobmods.gems.EmeraldRatio},
                {type="item", name="bob-amethyst-ore", amount=1, probability = bobmods.gems.AmethystRatio},
                {type="item", name="bob-topaz-ore", amount=1, probability = bobmods.gems.TopazRatio},
                {type="item", name="bob-diamond-ore", amount=1, probability = bobmods.gems.DiamondRatio},
            },
            subgroup = "bob-ores",
            icon = "__bobores__/graphics/icons/gem-ore.png",
            order = "a-0",
        },
    })
    
    if data.raw["item-subgroup"]["bob-gems-ore"] then
        data.raw.recipe["bob-sort-gem-ore"].subgroup = "bob-gems-ore"
    end

    bobmods.lib.module.add_productivity_limitation("bob-sort-gem-ore")
end

if mods["bobplates"] then
    omni.matter.add_omnium_alloy("aluminium","bob-aluminium-plate","ingot-aluminium")
    omni.matter.add_omnium_alloy("tungsten","bob-tungsten-plate","casting-powder-tungsten")
end