--Burner
local burner_ingredients = {}
if mods["angelsindustries"] and angelsmods.industries.components then
    burner_ingredients = {
        {name="block-construction-1", amount=1},
        {name="block-fluidbox-1", amount=1},
        {name="block-omni-0", amount=1}
    }
else
    burner_ingredients = {
        {name="omnicium-plate", amount=8},
        {name="iron-plate", amount=4},
        {name = "omnite-brick", amount = 4}
    }
end

BuildGen:create("omnimatter","burner-omnitractor"):
    noTech():
    setIcons("omnitractor"):
    setBurner(1,1):
    setSubgroup("omnitractor"):
    setOrder("a[omnitractor-burner]"):
    setIngredients(burner_ingredients):
    setEnergy(5):
    setEmissions(4.5):
    setUsage(100):
    setEnabled():
    setReplace("omnitractor"):
    setNextUpgrade("omnitractor-1"):
    setStacksize(50):
    setSize(3):
    setCrafting({"omnite-extraction-both","omnite-extraction-burner"}):
    setSpeed(1):
    setSoundWorking("ore-crusher"):
    setSoundVolume(2):
    setAnimation({
    layers={
    {
        filename = "__omnimatter__/graphics/entity/buildings/tractor.png",
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
    }):setOverlay("tractor-over",0):
    setFluidBox("WXW.XXX.KXK",true):
    extend()

local function timestier(row,col)
    local first_row = {1,0.5,0.2}
    if row == 1 then
        return first_row[col]
    elseif col == 3 then
        return 0.2
    else
        return timestier(row-1,col)+timestier(row-1,col+1)
    end
end

local get_tech_times = function(levels,tier)
    local t = 50*timestier(tier,1)
    return t
end

local cost = OmniGen:create():
    building():
    setMissConstant(2):
    setPreRequirement("burner-omnitractor")
if mods["angelsindustries"] and angelsmods.industries.components then
    cost:setQuant("construction-block",5):
    setQuant("electric-block",2):
    setQuant("fluid-block",5):
    setQuant("omni-block",2)
else
    cost:setQuant("circuit",5):
    setQuant("omniplate",20):
    setQuant("gear-box",10)
    if mods["bobplates"] then
        cost:setQuant("bearing",5,-1)
    end
end

BuildChain:create("omnimatter","omnitractor"):
    setSubgroup("omnitractor"):
    addElectricIcon():
    setLocName("omnitractor"):
    setIngredients(cost:ingredients()):
    setEnergy(5):
    setUsage(function(level,grade) return (100+25*grade).."kW" end):
    setEmissions(function(level,grade) return math.max(3 - ((grade-1) * 0.2), 0.1) end):
    addElectricIcon():
    setTechName("omnitech-omnitractor"):
    setTechPrereq(function(levels,grade) if grade == 1 then return "omnitech-omnium-processing" end end):
    setTechSuffix("electric"):
    setTechIcons("omnitractor-electric","omnimatter"):
    setTechCost(get_tech_times):
    setTechPacks(function(levels,grade) return grade end):
    setReplace("omnitractor"):
    setTechTime(function(levels,grade) return 15*grade end):
    ifModsAddTechPrereq("omnimatter_crystal",
        function(levels,grade)
            if grade > 1 and ((grade-1)*omni.fluid_levels_per_tier) <= omni.fluid_levels then
                return "omnitech-omnisolvent-omnisludge-"..(grade-1)*omni.fluid_levels_per_tier 
            else
                return nil
            end
        end):
    setStacksize(50):
    allowProductivity():
    setLevel(settings.startup["omnimatter-max-tier"].value):
    setSoundWorking("ore-crusher"):
    setSoundVolume(2):
    setModSlots(function(levels,grade) return grade end):
    setCrafting({"omnite-extraction-both","omnite-extraction"}):
    setSpeed(function(levels,grade) return 0.5+grade/2 end):
    setFluidBox("WXW.XXX.KXK",true):
    setAnimation({
    layers={
    {
        filename = "__omnimatter__/graphics/entity/buildings/tractor.png",
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
            -1,
            -1--1.95
        },
        {
            -1,--1.9,
            -1
        },
        {
            1,
            -1--1.85
        },
        {
            -1,---1.9,
            1
        }
    },
    {
        {
            1,
            -1--   -1.95
        },
        {
            1,--    1.9,
            1
        },
        {
            -1,
            1--     1.85
        },
        {
            -1,--   -1.9,
            -1
        }
    },
    {
        {
            -1,
            1--     1.85
        },
        {
            -1,--   -1.9,
            -1
        },
        {
            1,
            -1--    -1.95
        },
        {
            1,--    1.9,
            1
        }
    },
    {
        {
            1,
            1, --   1.85
        },
        {
            -1,--   -1.9,
            1
        },
        {
            -1,
            -1--    -1.95
        },
        {
            1,--    1.9,
            -1
        }
    }
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
            south = 0,
            west = -1
        }
        -- Picture always shown, covers draws on top
        fboxes[I].pipe_picture = {
            north = {
                filename = "__base__/graphics/entity/pipe/pipe-straight-vertical.png",
                height = 128,
                width = 128,
                shift = {
                    0,
                    0.95
                },
            },
            east = {
                filename = "__base__/graphics/entity/pipe/pipe-straight-horizontal.png",
                height = 128,
                width = 128,
                shift = {
                    -0.85,
                    0
                },
            },
            south = {
                filename = "__omnimatter__/graphics/pipe-patch-south.png",
                height = 128,
                width = 128,
                shift = {
                    0,
                    -0.299
                },
            },
            west = {
                filename = "__base__/graphics/entity/pipe/pipe-straight-horizontal.png",
                height = 128,
                width = 128,
                shift = {
                    0.9,
                    0
                },
            }
        }
        fboxes[I].pipe_connections[1].positions = fbox_positions[I]
        -- Remove the "one size fits all" position table
        fboxes[I].pipe_connections[1].position = nil
    end
end
local comp_mode_active = mods["angelsindustries"] and angelsmods.industries.components
for i=1,math.min(settings.startup["omnimatter-max-tier"].value,5) do
    if comp_mode_active then
        -- Add omniblock unlocks
        omni.lib.add_unlock_recipe("omnitech-omnitractor-electric-"..i, "block-omni-"..i)
        -- Remove previous tier buildings from the recipes
        if i == 1 then
            omni.lib.remove_recipe_ingredient("omnitractor-1", "burner-omnitractor")
        else
            omni.lib.remove_recipe_ingredient("omnitractor-"..i, "omnitractor-"..i-1)
        end
    end
    -- Modify our fluid boxes
    modify_fluidboxes(data.raw["assembling-machine"]["omnitractor-"..i])
end
-- Burner as well
modify_fluidboxes(data.raw["assembling-machine"]["burner-omnitractor"])

--log(serpent.block(data.raw["assembling-machine"]["assembling-machine-1"].energy_source))