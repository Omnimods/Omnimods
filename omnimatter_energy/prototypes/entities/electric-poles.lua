--Move electric pole unlocks to anbaricity
omni.lib.add_unlock_recipe("omnitech-anbaricity", "small-electric-pole")
omni.lib.add_unlock_recipe("omnitech-anbaricity","copper-cable")

omni.lib.remove_unlock_recipe("electronics", "small-electric-pole")
omni.lib.remove_unlock_recipe("electronics","copper-cable")

BuildGen:import("small-electric-pole"):
    setName("small-iron-electric-pole"):
    setIngredients({"iron-plate", 1},{"small-electric-pole", 2}):
    setArea(3.5):
    setWireDistance(7.5):
    setOrder("a[energy]-a[small-electric-pole]-iron"):
    setIcons({{icon = "__omnimatter_energy__/graphics/icons/small-iron-electric-pole.png", icon_size = 64,}}):
    setEnabled(false):
    setTechName("omnitech-small-iron-electric-pole"):
    setTechLocName("entity-name.small-iron-electric-pole"):
    setTechPacks({"energy-science-pack", 1}):
    setTechCost(35):
    setTechPrereq("omnitech-anbaricity"):
    setTechIcons({{icon = "__omnimatter_energy__/graphics/icons/small-iron-electric-pole.png", icon_size = 64,}}):
    setPictures({
        layers = {
            {
                direction_count = 4,
                filename = "__omnimatter_energy__/graphics/entity/small-iron-electric-pole/small-iron-electric-pole.png",
                height = 220,
                width = 72,
                priority = "extra-high",
                shift = {
                    0.0625,
                    -1.3125
                },
            },
            {
                direction_count = 4,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/small-electric-pole/small-electric-pole-shadow.png",
                height = 52,
                width = 256,
                priority = "extra-high",
                shift = {
                    1.5625,
                    0.0625
                },
            }
        }
    }):
    extend()

BuildGen:import("small-electric-pole"):
    setName("small-omnium-electric-pole"):
    setIngredients({"omnium-plate", 1},{"small-iron-electric-pole", 2}):
    setArea(3.5):
    setWireDistance(8.5):
    setOrder("a[energy]-a[small-electric-pole]-omnium"):
    setIcons({{icon = "__omnimatter_energy__/graphics/icons/small-omnium-electric-pole.png", icon_size = 64,}}):
    setEnabled(false):
    setTechName("omnitech-small-omnium-electric-pole"):
    setTechLocName("entity-name.small-omnium-electric-pole"):
    setTechPacks({"energy-science-pack", 1}):
    setTechCost(40):
    setTechPrereq("omnitech-small-iron-electric-pole"):
    setTechIcons({{icon = "__omnimatter_energy__/graphics/icons/small-omnium-electric-pole.png", icon_size = 64,}}):
    setPictures({
        layers = {
            {
                direction_count = 4,
                filename = "__omnimatter_energy__/graphics/entity/small-omnium-electric-pole/small-omnium-electric-pole.png",
                height = 220,
                width = 72,
                priority = "extra-high",
                shift = {
                    0.0625,
                    -1.3125
                },
            },
            {
                direction_count = 4,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/small-electric-pole/small-electric-pole-shadow.png",
                height = 52,
                width = 256,
                priority = "extra-high",
                shift = {
                    1.5625,
                    0.0625
                },
            }
        }
    }):
    extend()

--Fix hitboxes, lib changes them for some reason. Remove with new lib
data.raw["electric-pole"]["small-omnium-electric-pole"].collision_box = {{-0.15, -0.15}, {0.15, 0.15}}
data.raw["electric-pole"]["small-iron-electric-pole"].collision_box = {{-0.15, -0.15}, {0.15, 0.15}}
data.raw["electric-pole"]["small-omnium-electric-pole"].selection_box = {{-0.4, -0.4}, {0.4, 0.4}}
data.raw["electric-pole"]["small-iron-electric-pole"].selection_box = {{-0.4, -0.4}, {0.4, 0.4}}

--Set new remnants
local rem1 = table.deepcopy(data.raw.corpse["small-electric-pole-remnants"])
rem1.name ="small-omnium-electric-pole-remnants"
rem1.localised_name ={"remnant-name", {"entity-name.small-omnium-electric-pole"}}
rem1.icon = "__omnimatter_energy__/graphics/icons/small-omnium-electric-pole.png"

local rem2 = table.deepcopy(data.raw.corpse["small-electric-pole-remnants"])
rem2.name ="small-iron-electric-pole-remnants"
rem2.localised_name ={"remnant-name", {"entity-name.small-iron-electric-pole"}}
rem2.icon = "__omnimatter_energy__/graphics/icons/small-iron-electric-pole.png"

--Swap out all graphics
for i,tab in pairs({rem1.animation, rem1.animation_overlay, rem2.animation, rem2.animation_overlay}) do
    for _,sub in pairs(tab) do
        for _,layer in pairs(sub.layers) do
            if layer.filename then
                local pole = "small-omnium-electric-pole"
                if i > 2 then pole = "small-iron-electric-pole" end
                layer.filename  = string.gsub(layer.filename ,"__base__","__omnimatter_energy__")
                layer.filename  = string.gsub(layer.filename ,"small%-electric%-pole", pole)
            end
        end
    end
end

data:extend({rem1,rem2})

data.raw["electric-pole"]["small-omnium-electric-pole"].corpse = "small-omnium-electric-pole-remnants"
data.raw["electric-pole"]["small-iron-electric-pole"].corpse = "small-iron-electric-pole-remnants"