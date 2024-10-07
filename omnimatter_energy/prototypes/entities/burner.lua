BuildGen:import("burner-mining-drill"):
    setIngredients(
    {type="item", name="iron-gear-wheel", amount=2},
    {type="item", name="omnicium-plate", amount=4},
    {type="item", name="omnitor", amount=1}):
    setEnabled():
    extend()

--Burner assembler
BuildGen:import("assembling-machine-1"):
    setBurner(0.9,1):
    setEmissions(5.0):
    setName("omnitor-assembling-machine"):
    setIcons("omnitor-assembling-machine","omnimatter_energy"):
    setEnabled(false):
    setTechName("omnitech-simple-automation"):
    setTechIcons({{"automation-1",256}},"base"):
    setTechPrereq():
    setTechCost(10):
    setTechPacks({{"energy-science-pack", 1}}):
    setFuelCategory("omnite"):
    setSpeed(0.25):
    setIngredients({"omnitor",1},{"iron-plate",2},{"burner-inserter",1}):
    setOrder("a[assembling-machine-0]"):
    setAnimation(
    {layers={{
      filename = "__omnimatter_energy__/graphics/entity/omnitor-assembling-machine/omnitor-assembling-machine.png",
      priority="high",
      width = 107,
      height = 113,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(0, 2),
      hr_version = {
        filename = "__omnimatter_energy__/graphics/entity/omnitor-assembling-machine/hr-omnitor-assembling-machine.png",
        priority="high",
        width = 214,
        height = 226,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, 2),
        scale = 0.5
      }
    }}}
    ):
    setNextUpgrade("assembling-machine-1"):
    extend()

--Update assembling machine 1 ingredients
omni.lib.add_recipe_ingredient("assembling-machine-1", "omnitor-assembling-machine")

--Fix vanilla burner inserter
RecGen:import("burner-inserter"):
    setIngredients({"omnitor",1},{"omnicium-plate",2},{"iron-gear-wheel",1}):
    addBurnerIcon():
    extend()

--Burner Lab
BuildGen:import("lab"):
    setBurner(0.9):
    setEmissions(2.0):
    setName("omnitor-lab"):
    setIcons("omnitor-lab","omnimatter_energy"):
    setEnabled():
    setInputs("energy-science-pack"):
    setFuelCategory("omnite"):
    setIngredients({"omnitor", 5},{"copper-plate", 10},{"omnicium-plate", 5}):
    setReplace("lab"):
    setNextUpgrade("lab"):
    setOrder("g[lab-omnitor]"):
    setOnAnimation({
  layers =
  {
    {
      filename = "__omnimatter_energy__/graphics/entity/omnitor-lab/omnitor-lab.png",
      width = 97,
      height = 87,
      frame_count = 33,
      line_length = 11,
      animation_speed = 1 / 3,
      shift = util.by_pixel(0, 1.5),
      hr_version = {
        filename = "__omnimatter_energy__/graphics/entity/omnitor-lab/hr-omnitor-lab.png",
        width = 194,
        height = 174,
        frame_count = 33,
        line_length = 11,
        animation_speed = 1 / 3,
        shift = util.by_pixel(0, 1.5),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/lab/lab-integration.png",
      width = 122,
      height = 81,
      frame_count = 1,
      line_length = 1,
      repeat_count = 33,
      animation_speed = 1 / 3,
      shift = util.by_pixel(0, 15.5),
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-integration.png",
        width = 242,
        height = 162,
        frame_count = 1,
        line_length = 1,
        repeat_count = 33,
        animation_speed = 1 / 3,
        shift = util.by_pixel(0, 15.5),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/lab/lab-light.png",
      width = 106,
      height = 100,
      frame_count = 33,
      line_length = 11,      
      animation_speed = 1 / 3,
      blend_mode = "additive",
      draw_as_light = true,
      shift = {-0.03125, 0.03125},
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-light.png",
        width = 216,
        height = 194, 
        frame_count = 33,
        line_length = 11,
        animation_speed = 1 / 3,
        blend_mode = "additive",
        draw_as_light = true,
        shift = {0, 0},
        scale = 0.5
      }
    }, 
    {
      filename = "__base__/graphics/entity/lab/lab-shadow.png",
      width = 122,
      height = 68,
      frame_count = 1,
      line_length = 1,
      repeat_count = 33,
      animation_speed = 1 / 3,
      shift = util.by_pixel(13, 11),
      draw_as_shadow = true,
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-shadow.png",
        width = 242,
        height = 136,
        frame_count = 1,
        line_length = 1,
        repeat_count = 33,
        animation_speed = 1 / 3,
        shift = util.by_pixel(13, 11),
        scale = 0.5,
        draw_as_shadow = true
      }
    }
  }
}):
setOffAnimation({
  layers =
  {
    {
      filename = "__omnimatter_energy__/graphics/entity/omnitor-lab/omnitor-lab.png",
      width = 97,
      height = 87,
      frame_count = 1,
      shift = util.by_pixel(0, 1.5),
      hr_version = {
        filename = "__omnimatter_energy__/graphics/entity/omnitor-lab/hr-omnitor-lab.png",
        width = 194,
        height = 174,
        frame_count = 1,
        shift = util.by_pixel(0, 1.5),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/lab/lab-integration.png",
      width = 122,
      height = 81,
      frame_count = 1,
      shift = util.by_pixel(0, 15.5),
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-integration.png",
        width = 242,
        height = 162,
        frame_count = 1,
        shift = util.by_pixel(0, 15.5),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/lab/lab-shadow.png",
      width = 122,
      height = 68,
      frame_count = 1,
      shift = util.by_pixel(13, 11),
      draw_as_shadow = true,
      hr_version = {
        filename = "__base__/graphics/entity/lab/hr-lab-shadow.png",
        width = 242,
        height = 136,
        frame_count = 1,
        shift = util.by_pixel(13, 11),
        draw_as_shadow = true,
        scale = 0.5
      }
    }
  }
}):
extend()

--Set fast replaceable group for the vanilla lab
if data.raw["lab"]["lab"] then
    data.raw["lab"]["lab"].fast_replaceable_group = "lab"
end