if bobmods and bobmods.ores then
    data:extend({
        {
            type = "recipe",
            name = "sort-gem-ore",
            energy_required = 1,
	        icon_size = 32,
            ingredients = {
                {"gem-ore", 1},
            },
            results = {
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
    })
    
    if data.raw["item-subgroup"]["bob-gems-ore"] then
        data.raw.recipe["sort-gem-ore"].subgroup = "bob-gems-ore"
    end

    bobmods.lib.module.add_productivity_limitation("sort-gem-ore")
end