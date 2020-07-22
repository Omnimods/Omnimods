BuildGen:import("burner-omni-furnace"):
setLocName("entity-name.burner-omni-furnace-1"):
addIcon("__omnilib__/graphics/icons/small/lvl1.png"):
setFuelCategory("omnite"):
setNextUpgrade("burner-omni-furnace-2"):extend()

BuildGen:import("burner-omni-furnace"):
setName("burner-omni-furnace-2","omnimatter_energy"):
addIcon("__omnilib__/graphics/icons/small/lvl2.png"):
setSpeed(1.5):
setFuelCategory("chemical"):
setIngredients({"burner-omni-furnace",1},{"omnicium-iron-alloy",15},{"iron-plate",20},{"omnicium-iron-gear-box",60}):
setEnabled(false):
setTechName("advanced-material-processing"):
setNextUpgrade("burner-omni-furnace-3"):extend()

BuildGen:import("burner-omni-furnace"):
setName("burner-omni-furnace-3","omnimatter_energy"):
addIcon("__omnilib__/graphics/icons/small/lvl3.png"):
setSpeed(2.0):
setFuelCategory("chemical"):
setIngredients({"burner-omni-furnace-2",1},{"omnicium-steel-alloy",25},{"steel-plate",30},{"omnicium-iron-gear-box",150}):
setEnabled(false):
setTechName("advanced-material-processing-2"):
setNextUpgrade():extend()