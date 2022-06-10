if bobmods and bobmods.ores then
    local products={        
        ["lead-ore"]="Lead",
        ["tin-ore"]="Tin",
        ["quartz"]="Silicon",
        ["zinc-ore"]="Zinc",
        ["nickel-ore"]="Nickel",
        ["bauxite-ore"]="Bauxite",
        ["rutile-ore"]="Rutile",
        ["gold-ore"]="Gold",
        ["cobalt-ore"]="Cobalt",
        ["silver-ore"]="Silver",
        ["tungsten-ore"]="Wolfram",
        ["thorium-ore"]="Thorium",
        ["platinum-ore"]="Platinum",
    }
    for i, ore in pairs(bobmods.ores) do --check ore triggers (works with plates)
        if ore.enabled and products[ore.name] then
            omni.crystal.add_crystal(ore.name, products[ore.name])
        end
    end
end
