
omni.compression.exclude_recipe("vehicle-fusion-reactor")
omni.compression.exclude_recipe("vehicle-fusion-reactor-1")
omni.compression.exclude_recipe("vehicle-fusion-reactor-2")
omni.compression.exclude_recipe("vehicle-fusion-reactor-3")
omni.compression.exclude_recipe("vehicle-fusion-reactor-4")
omni.compression.exclude_recipe("vehicle-fusion-reactor-5")
omni.compression.exclude_recipe("vehicle-fusion-reactor-6")

omni.compression.exclude_recipe("vehicle-fusion-cell-1")
omni.compression.exclude_recipe("vehicle-fusion-cell-2")
omni.compression.exclude_recipe("vehicle-fusion-cell-3")
omni.compression.exclude_recipe("vehicle-fusion-cell-4")
omni.compression.exclude_recipe("vehicle-fusion-cell-5")
omni.compression.exclude_recipe("vehicle-fusion-cell-6")

omni.compression.exclude_recipe("vehicle-solar-panel-1")
omni.compression.exclude_recipe("vehicle-solar-panel-2")
omni.compression.exclude_recipe("vehicle-solar-panel-3")
omni.compression.exclude_recipe("vehicle-solar-panel-4")
omni.compression.exclude_recipe("vehicle-solar-panel-5")
omni.compression.exclude_recipe("vehicle-solar-panel-6")

omni.compression.exclude_recipe("railgun-dart")
omni.compression.exclude_recipe("railgun")
omni.compression.exclude_recipe("player-port")
omni.compression.exclude_recipe("tank")
omni.compression.exclude_recipe("locomotive")
omni.compression.exclude_recipe("cargo-wagon")
omni.compression.exclude_recipe("fluid-wagon")
omni.compression.exclude_recipe("omega-drill")

omni.compression.include_recipe("burner-inserter")
omni.compression.include_recipe("inserter")
omni.compression.include_recipe("fast-inserter")

omni.compression.exclude_recipe("portable-chests-wooden-chest")
omni.compression.exclude_recipe("portable-chests-iron-chest")
omni.compression.exclude_recipe("portable-chests-steel-chest")

omni.compression.exclude_recipe("aircraft-afterburner")

if mods["angelspetrochem"] then
    omni.lib.replace_recipe_result("fill-heavy-oil-barrel","heavy-oil-barrel","liquid-naphtha-barrel")
end