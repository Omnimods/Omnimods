if bobmods and bobmods.ores then
    local products={
        ["bob-lead-ore"]="Lead",
        ["bob-tin-ore"]="Tin",
        ["bob-quartz"]="Silicon",
        ["bob-zinc-ore"]="Zinc",
        ["bob-nickel-ore"]="Nickel",
        ["bob-bauxite-ore"]="Bauxite",
        ["bob-rutile-ore"]="Rutile",
        ["bob-gold-ore"]="Gold",
        ["bob-cobalt-ore"]="Cobalt",
        ["bob-silver-ore"]="Silver",
        ["bob-tungsten-ore"]="Wolfram",
        ["bob-thorium-ore"]="Thorium",
        ["bob-platinum-ore"]="Platinum",
    }
    for i, ore in pairs(bobmods.ores) do --check ore triggers (works with plates)
        if ore.enabled and products[ore.name] then
            omni.crystal.add_crystal(ore.name, products[ore.name])
        end
    end
end
