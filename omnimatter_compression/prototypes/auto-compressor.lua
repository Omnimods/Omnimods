--GFX by Arch666Angel
local mini = settings.startup["omnicompression_1x1_buildings"].value

local function minify(a_value, b_value)
    return mini and a_value or b_value
end

local fluidbox = minify({
    {
        pipe_covers = pipecoverspictures(),
        volume = 1000,
        production_type = "input",
        pipe_connections = {{
            flow_direction = "input",
            direction = defines.direction.south,
            position = {
                0,
                -0.1
            }
        }}
    },
    {
        pipe_covers = pipecoverspictures(),
        volume = 1000,
        production_type = "output",
        pipe_connections = {{
            flow_direction = "output",
            direction = defines.direction.north,
            position = {
                0,
                0.1
            }
        }}
    }
}, "XWX.XXX.XKX")

BuildGen:create("omnimatter_compression","auto-compressor"):
    setStacksize(50):
    setFlags({"placeable-neutral", "placeable-player", "player-creation"}):
    setSubgroup("production-machine"):
    setIngredients({"steel-plate", 15}, {"electronic-circuit", 5}, {"stone-brick", 10}):
    setEnergy(10):
    setModSlots(0):
    setModEffects():
    setUsage(225):
    setSpeed(3):
    setFurnace():
    noTech():
    setIcons({"auto-compressor", 32}):
    setSize(minify(1, 3)):
    setCrafting({"compression"}):
    setGraphics({
        animation = {
            layers = {
                {
                    filename = "__omnimatter_compression__/graphics/auto-compressor-sheet.png",
                    priority = "high",
                    width = 160,
                    height = 160,
                    frame_count = 25,
                    line_length = 5,
                    shift = util.by_pixel(0, -0.5*minify(0.33, 1)),--{0.0, 0.0},
                    scale = minify(0.33, 1)*1.1,
                    animation_speed = 0.25
                },
                {
                    filename = "__omnimatter_compression__/graphics/auto-compressor-sheet-mask.png",
                    priority = "high",
                    tint = {
                        r = 0.6,
                        g = 0.6,
                        b = 0.6,
                        a = 0.8
                    },
                    width = 160,
                    height = 160,
                    frame_count = 25,
                    line_length = 5,
                    shift = util.by_pixel(0, -0.5*minify(0.33, 1)),--{0.0, 0.0},
                    scale = minify(0.33, 1)*1.1,
                    animation_speed = 0.25
                },
                {
                    filename = "__omnimatter_compression__/graphics/auto-compressor-sheet-highlights.png",
                    priority = "high",
                    blend_mode = "additive",
                    width = 160,
                    height = 160,
                    frame_count = 25,
                    line_length = 5,
                    shift = util.by_pixel(0, -0.5*minify(0.33, 1)),--{0.0, 0.0},
                    scale = minify(0.33, 1)*1.1,
                    animation_speed = 0.25
                }
            }
        }
    }):
    extend()

BuildGen:create("omnimatter_compression","auto-concentrator"):
    setStacksize(50):
    setFlags({"placeable-neutral", "placeable-player", "player-creation"}):
    setSubgroup("production-machine"):
    setIngredients({"steel-plate", 50}, {"electronic-circuit", 20}, {"stone-brick", 40}):
    setEnergy(10):
    setModSlots(0):
    setModEffects():
    setUsage(225):
    setSpeed(3):
    setFurnace():
    noTech():
    setIcons({"auto-concentrator", 32}):
    setSize(minify(1, 3)):
    setFluidBox(fluidbox):
    setCrafting({"fluid-concentration"}):
    setGraphics({
        animation = {
            layers = {
                {
                    filename = "__omnimatter_compression__/graphics/liquifier.png",
                    priority = "high",
                    width = 160,
                    height = 160,
                    frame_count = 30,
                    line_length = 10,
                    shift = util.by_pixel(0, -0.5*minify(0.33, 1)),--{0.0, 0.0},
                    scale = minify(0.33, 1)*1.1,
                    animation_speed = 0.25
                }
            }
        }
    }):
    extend()

data.raw["furnace"]["auto-concentrator"].fluid_boxes[1].volume = 2 * omni.compression.sluid_contain_fluid * omni.compression.sluid_contain_fluid

if settings.startup["omnicompression_entity_compression"].value then
    BuildGen:create("omnimatter_compression","auto-condensator"):
        setStacksize(50):
        setFlags({"placeable-neutral", "placeable-player", "player-creation"}):
        setSubgroup("production-machine"):
        setIngredients({"steel-plate", 50}, {"electronic-circuit", 20}, {"stone-brick", 40}):
        setEnergy(10):
        setModSlots(0):
        setModEffects():
        setUsage(225):
        setSpeed(3):
        noTech():
        setIcons({"auto-concentrator", 32}):
        setSize(minify(1, 3)):
        setFluidBox(fluidbox):
        setCrafting({"fluid-condensation"}):
        setGraphics({
            animation = {
                layers = {
                    {
                        filename = "__omnimatter_compression__/graphics/liquifier.png",
                        priority = "high",
                        width = 160,
                        height = 160,
                        frame_count = 30,
                        line_length = 10,
                        shift = util.by_pixel(0, -0.5*minify(0.33, 1)),--{0.0, 0.0},
                        scale = minify(0.33, 1)*1.1,
                        animation_speed = 0.25
                    }
                }
            }
        }):
        extend()
end