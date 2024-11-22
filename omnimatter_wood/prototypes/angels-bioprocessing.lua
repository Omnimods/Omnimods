if mods["angelsbioprocessing"] then
    --------------------------
    ---Angels algae updates---
    --------------------------

    --Create omnialgae recipe
    --This unlocks with algae farm 1 (bio-processing-brown)
    RecGen:create("omnimatter_wood","omnialgae"):
        setStacksize(500):
        setSubgroup("algae"):
        setOrder("aa[omnialgae]"):
        -- setTechName("omnitech-omnialgae"):
        -- setTechPrereq("omnitech-omnimutator"):
        -- setTechIcons("algae-farm-tech","angelsbioprocessing"):
        -- setTechCost(250):
        -- setTechTime(15):
        setTechName("bio-processing-brown"):
        setCategory("bio-processing"):
        setSubgroup("bio-processing-purple"):
        setIngredients({{type="fluid",name="omnic-acid",amount=144},{type="item",name="omnite",amount=24},}):
        setResults({type="item",name="omnialgae", amount = 144}):
        extend()

    omni.lib.add_prerequisite("bio-processing-brown","omnitech-omnic-acid-hydrolyzation-1")

    --All algaes should require the omnialgae
    omni.lib.add_recipe_ingredient("algae-green-simple",{type="item",name="omnialgae",amount=30})
    omni.lib.add_recipe_ingredient("algae-green",{type="item",name="omnialgae",amount=40})
    omni.lib.add_recipe_ingredient("algae-brown",{type="item",name="omnialgae",amount=40})
    omni.lib.add_recipe_ingredient("algae-red",{type="item",name="omnialgae",amount=40})
    omni.lib.add_recipe_ingredient("algae-blue",{type="item",name="omnialgae",amount=40})

    -- --Hide the algae green simple recipe (easy way to get green/brown algae)
    -- omni.lib.remove_unlock_recipe("bio-processing-brown", "algae-green-simple")
    -- RecGen:import("algae-green-simple"):
    --     setEnabled(false):
    --     setHidden():
    --     extend()

    -- --Change algae green icon
    -- data.raw.recipe["algae-green"].icons = nil
    -- data.raw.recipe["algae-green"].icon = data.raw.recipe["algae-green-simple"].icon

    -- --Since the algae green starter recipe has been removed, we need to make the others craftable in a t1 farm
    -- data.raw.recipe["algae-green"].category = "bio-processing"
    -- data.raw.recipe["algae-brown"].category = "bio-processing"

    --omni.lib.add_unlock_recipe("omnitech-omnialgae","algae-farm")
    --omni.lib.remove_unlock_recipe("bio-processing-green","algae-farm")
    --omni.lib.add_prerequisite("bio-processing-brown","omnitech-omnialgae") 

    data:extend({{
        type = "item-subgroup",
        name = "bio-processing-purple",
        group = "bio-processing-nauvis",
        order = "0",
    }})

    for i=1,3 do
        local rec = data.raw.recipe["wood-sawing-"..i]
        omni.lib.replace_recipe_result(rec.name, "wood", "omniwood")
        rec.icons[1].icon = data.raw.item["omniwood"].icons[1].icon
        rec.icons[1].icon_size = data.raw.item["omniwood"].icons[1].icon_size
        rec.icons[1].scale = 1
        rec.localised_name = {"item-name.omniwood"}
    end

    if mods["bobgreenhouse"] then --checks both bio and greenhouse
        omni.lib.replace_all_ingredient("seedling","omniseedling")
        omni.lib.replace_recipe_result("wood-sawing-manual","wood","omniwood")
        omni.lib.remove_recipe_all_techs("bob-greenhouse")

        data.raw.recipe["wood-sawing-manual"].icons[1].icon = data.raw.item["omniwood"].icons[1].icon
        data.raw.recipe["wood-sawing-manual"].icons[1].icon_size = 32
        data.raw.recipe["wood-sawing-manual"].icons[1].scale = 1
        data.raw.recipe["wood-sawing-manual"].localised_name = {"item-name.omniwood"}
    end
end

RecGen:importIf("solid-soil"):
    setCategory("omnimutator"):
    addIngredients({type="fluid",name="omnic-acid",amount=20}):
    setTechName("omnitech-omnimutator"):
    extend()