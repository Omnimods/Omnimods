if mods["bobassembly"] and data.raw.recipe["steam-science-pack"] then
    local tractor_ingredients = {
        {name="omnicium-iron-gear-box", amount=2},
        {name="omnicium-gear-wheel", amount=3},
        {name="iron-plate", amount=6}
    }
    local phlog_ingredients = {
        {type = "item", name = "omnicium-plate", amount = 15},
        {type = "item", name = "omnicium-gear-wheel", amount = 20},
        {type = "item", name = "iron-plate", amount = 15},
        {type = "item", name = "copper-plate", amount = 10}
    }
    if mods["angelsindustries"] and angelsmods.industries.components then
        tractor_ingredients = {
            {name="block-construction-1", amount=1},
            {name="block-fluidbox-1", amount=3},
            {name="block-omni-0", amount=3}
        }
        phlog_ingredients = {
            {name="block-construction-1", amount=3},
            {name="block-electronics-0", amount=2},
            {name="block-fluidbox-1", amount=4},
            {name="block-omni-0", amount=3}
        }
    end

    BuildGen:create("omnimatter","steam-omnitractor"):
        noTech():
        setIcons("omnitractor"):
        setSubgroup("omnitractor"):
        setIngredients(tractor_ingredients):
        setEnergy(10):
        setSteam(1,1):
        setUsage(100):
        setReplace("omnitractor"):
        setStacksize(10):
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
        
        BuildGen:create("omnimatter","steam-omniphlog"):
        noTech():
        setIcons("omniphlog"):
        setSteam(1,1):
        setStacksize(10):
        setSubgroup("omniphlog"):
        setReplace("omniphlog"):
        setSize(3):
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
        setIngredients(phlog_ingredients):
        extend()

    omni.lib.add_unlock_recipe("steam-automation", "steam-omnitractor")
    omni.lib.add_unlock_recipe("steam-automation", "steam-omniphlog")
end

-- Fix for Steam SP Bob's Tech introduces sometimes
if data.raw.recipe["steam-science-pack"] then
    omni.lib.replace_recipe_ingredient("steam-science-pack","coal","omnite")
end