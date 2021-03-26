for _, rocketsilo in pairs(data.raw["rocket-silo"]) do
    if string.find(rocketsilo.crafting_categories[1],"-compressed") and data.raw.recipe[rocketsilo.fixed_recipe.."-compression"] then     
        rocketsilo.fixed_recipe = rocketsilo.fixed_recipe .. "-compression"
    end
end