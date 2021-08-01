--Heat
RecGen:create("omnimatter_energy","heat"):
    fluid():
    setIcons({{icon = "__omnilib__/graphics/icons/small/burner.png", icon_size = 32}}):
    setBothColour(1,0,0):
    setCategory("omnite-extraction-burner"):
    setSubgroup("omnienergy-power"):
    setOrder("ab"):
    setEnergy(10):
    setMaxTemp(250):
    setFuelCategory("thermo"):
    setCapacity(1):
    setTechName("omnitech-anbaricity"):
    setResults({type = "fluid", name = "heat", amount=150, temperature = 250}):
    extend()

data.raw.fluid.heat.auto_barrel = false

--Heat Burner
BuildGen:import("steam-turbine"):
    setName("omni-heat-burner","omnimatter_energy"):
    --setFluidBox("XTX.XXX.XXX.XXX.XGX","heat",400):
    setFluidBox("XXX.XXX.FXH.XXX.XXX"):
    setLocName():
    setIcons("omnium-turbine","omnimatter_energy"):
    setFilter("heat"):
    setIngredients({{"anbaric-omnitor",4},{"omnicium-gear-wheel",5},{"stone-furnace",1}}):
    setReplace("heat-burner"):
    setSubgroup("omnienergy-power"):
    setOrder("aa"):
    setTechName("omnitech-anbaricity"):
    setFluidConsumption(1):
    setEffectivity(2/13.5/2):
    setMaxTemp(250):
    setNextUpgrade():
    setDirectionAnimation(
        {
            layers = {
              {
                filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-turbine-h.png",
                frame_count = 36,
                height = 160,
                line_length = 6,
                run_mode = "backward",
                shift = {
                  0,
                  -0.078125
                },
                width = 224
              },
              {
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/steam-turbine/steam-turbine-H-shadow.png",
                frame_count = 1,
                height = 74,
                line_length = 1,
                repeat_count = 36,
                run_mode = "backward",
                shift = {
                  0.8984375,
                  0.5625
                },
                width = 217
              }
            }
        },
        {
            layers = {
              {
                filename = "__omnimatter_energy__/graphics/entity/buildings/omnium-turbine-v.png",
                frame_count = 36,
                height = 224,
                line_length = 6,
                run_mode = "backward",
                shift = {
                  -0.07,
                  0.25
                },
                scale = 0.92,
                width = 160
              },
              {
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/steam-turbine/steam-turbine-V-shadow.png",
                frame_count = 1,
                height = 131,
                line_length = 1,
                repeat_count = 36,
                run_mode = "backward",
                shift = {
                  1.234375,
                  0.765625
                },
                width = 151
              }
            }
        }):
    extend()