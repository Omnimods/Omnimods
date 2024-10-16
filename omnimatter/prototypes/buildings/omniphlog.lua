--Burner
local phlog_cost = {}
if mods["angelsindustries"] and angelsmods.industries.components then
    phlog_cost = {
        {name="block-construction-1", amount=3, type = "item"},
        {name="block-electronics-0", amount=1, type = "item"},
        {name="block-fluidbox-1", amount=2, type = "item"},
        {name="block-omni-0", amount=1, type = "item"}
    }
else
    phlog_cost = {
        {name = "omnicium-plate", amount = 8, type = "item"},
        {name = "copper-plate", amount = 4, type = "item"},
        {name = "omnite-brick", amount = 4, type = "item"},
    }
end

BuildGen:create("omnimatter","burner-omniphlog"):
    noTech():
    setIcons({"omniphlog", 32}):
    setBurner(0.75,1):
    setEmissions(5.5):
    setStacksize(50):
    setSubgroup("omniphlog"):
    setOrder("a[omniphlog-burner]"):
    setReplace("omniphlog"):
    setNextUpgrade("omniphlog-1"):
    setSize(3):
    setEnergy(5):
    setCrafting("omniphlog"):
    setFluidBox("XWX.XXX.XKX"):
    setUsage(300):
    setAnimation({
    layers={
    {
        filename = "__omnimatter__/graphics/entity/buildings/omniphlog.png",
        priority = "extra-high",
        width = 160,
        height = 160,
        frame_count = 36,
        line_length = 6,
        shift = {0.00, -0.05},
        scale = 0.90,
        animation_speed = 0.5
    },
    }
    }):
    setIngredients(phlog_cost):
    setEnabled():
    extend()

--Electric
local cost = OmniGen:create():
        building():
        setMissConstant(3):
        setPreRequirement("burner-omniphlog")

if mods["angelsindustries"] and angelsmods.industries.components then
    cost:setQuant("construction-block",5):
    setQuant("electric-block",2):
    setQuant("fluid-block",5):
    setQuant("logistic-block",1):
    setQuant("omni-block",1)
else
    cost:setQuant("omniplate",10):
    setQuant("plates",20):
    setQuant("gear-box",15)
end

BuildChain:create("omnimatter","omniphlog"):
    setSubgroup("omniphlog"):
    setLocName("omniphlog"):
    setIngredients(cost:ingredients()):
    setIcons({"omniphlog", 32}):
    setEnergy(5):
    setUsage(function(level,grade) return (200+100*grade).."kW" end):
    setEmissions(function(level,grade) return math.max(3.8 - ((grade-1) * 0.2), 0.1) end):
    addElectricIcon():
    setReplace("omniphlog"):
    setStacksize(50):
    setSize(3):
    setTechName("omnitech-omnitractor-electric"):
    setFluidBox("XWX.XXX.XKX"):
    setLevel(omni.max_tier):
    setSoundWorking("ore-crusher"):
    setSoundVolume(2):
    setModSlots(function(levels,grade) return grade end):
    setCrafting("omniphlog"):
    setSpeed(function(levels,grade) return 0.5+grade/2 end):
    setAnimation({
    layers={
    {
        filename = "__omnimatter__/graphics/entity/buildings/omniphlog.png",
        priority = "extra-high",
        width = 160,
        height = 160,
        frame_count = 36,
        line_length = 6,
        shift = {0.00, -0.05},
        scale = 0.90,
        animation_speed = 0.5
    },
    },
    }):setOverlay("tractor-over"):
    extend()

local fbox_positions = {
    {
        {
            0,
            -1.0--    -1.95
        },
        {
            1.0,--       1.9,
            0
        },
        {
            0,
            1.0,--      1.85
        },
        {
            -1.0,--     -1.9,
            0
        }
    },
    {
        {
            0,
            1.0,--      1.85
        },
        {
            -1.0,--     -1.9,
            0
        },
        {
            0,
            -1.0--     -1.95
        },
        {
            1.0,--      1.9,
            0
        }
    }
}
local shift = {
    north = {0, 0.25},
    east = {-0.1, 0},
    south = {0, 0.19},
    west = {-0.1, 0}
}
local function modify_fluidboxes(proto)
    local fboxes = proto.fluid_boxes
    for I=1, #fboxes do
        -- Covers = no active connection
        fboxes[I].pipe_covers = pipecoverspictures()
        -- Move the north cover up a little
        fboxes[I].pipe_covers.north.layers[1].shift = {0, -0.05}
        -- Only south should draw "on top"
        fboxes[I].secondary_draw_orders = {
            north = -1,
            east = -1,
            south = 2,
            west = -1
        }
        -- Offset fluidbox
        fboxes[I].pipe_connections[1].positions = fbox_positions[I]
        -- Remove the "one size fits all" position table
        fboxes[I].pipe_connections[1].position = nil
        fboxes[I].pipe_picture = assembler3pipepictures()
        for dir, picture in pairs(fboxes[I].pipe_picture) do
            -- X, Y
            for II=1, 2 do
                picture.shift[II] = picture.shift[II] + shift[dir][II]
            end
            -- Override the "assembler 3" tint
            picture.tint = {1,0.9,1,1}
        end
    end
end
local is_comp_mode = mods["angelsindustries"] and angelsmods.industries.components
for i=1,settings.startup["omnimatter-max-tier"].value do
    if is_comp_mode then
        -- Remove previous tier buildings from the recipes
        if i == 1 then
            omni.lib.remove_recipe_ingredient("omniphlog-1", "burner-omniphlog")
        else
            omni.lib.remove_recipe_ingredient("omniphlog-"..i, "omniphlog-"..i-1)
        end
    end
    -- Modify our fluid boxes
    modify_fluidboxes(data.raw["assembling-machine"]["omniphlog-"..i])
end
-- Burner as well
modify_fluidboxes(data.raw["assembling-machine"]["burner-omniphlog"])