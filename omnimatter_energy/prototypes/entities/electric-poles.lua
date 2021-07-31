RecGen:import("small-electric-pole"):
    setEnabled(false):
    setTechName("omnitech-anbaricity"):
    extend()

BuildGen:import("small-electric-pole"):
    setName("small-iron-electric-pole"):
    setIngredients({"iron-plate", 1},{"copper-cable", 2}):
    setPictures({
      filename = "__omnimatter_energy__/graphics/entity/small-iron-electric-pole.png",
      priority = "extra-high",
      width = 119,
      height = 124,
      direction_count = 4,
      shift = {1.4, -1.1}
    }):
    setEnabled(false):
    setTechName("omnitech-anbaricity"):
    setOrder("a[energy]-a[small-electric-pole]-iron"):
    extend()

BuildGen:import("small-electric-pole"):
    setName("small-omnicium-electric-pole"):
    setIngredients({"omnicium-plate", 1},{"copper-cable", 2}):
    setArea(3.5):
    setWireDistance(9):
    setPictures({
      filename = "__omnimatter_energy__/graphics/entity/small-omnicium-electric-pole.png",
      priority = "extra-high",
      width = 119,
      height = 124,
      direction_count = 4,
      shift = {1.4, -1.1}
    }):
    setEnabled(false):
    setTechName("omnitech-anbaricity"):
    setOrder("a[energy]-a[small-electric-pole]-omnicium"):
    extend()