--[[ Mod compatibility fixes ]]--

rec_count = 0
local categories = {}
for recipe_name, prototype in pairs(data.raw.recipe) do
    categories[prototype.category or "crafting"] = (categories[prototype.category or "crafting"] or 0) + 1
    rec_count = rec_count + 1
end

--Extend compression items/recipes into the regular machines, revert machines with empty compressed categories back to their base categories
for _,kind in pairs({"assembling-machine","furnace","rocket-silo"}) do
    for _,build in pairs(data.raw[kind]) do
        for i,cat in pairs(build.crafting_categories) do
            local new_cat = cat.."-compressed"
            if not cat:find("compressed$") and data.raw["recipe-category"][new_cat] and categories[new_cat] ~= 0 then
                table.insert(build.crafting_categories,cat.."-compressed")
            elseif cat:find("compressed$") and not categories[cat] then
                local old_cat = cat:gsub("-compressed$", "")
                if data.raw["recipe-category"][old_cat] then
                    --log({"","Reverting category ", cat, " to ", old_cat, " on the building ", build.name})
                    build.crafting_categories[i] = old_cat
                end
            end
        end
        if kind ~= "furnace" then
            if string.find(build.name,"assembling") then
                if not omni.lib.is_in_table("general-compressed",build.crafting_categories) then
                    table.insert(build.crafting_categories,"general-compressed")
                end
            end
            -- Allow selection between compressed and non-compressed
            if build.fixed_recipe then
                local rec = data.raw.recipe[build.fixed_recipe] or {}
                local compressed_rec = data.raw.recipe[build.fixed_recipe .. "-compression"] or {}
                if rec and compressed_rec then
                    build.fixed_recipe = nil
                    rec.hidden = false
                    (rec.normal or {}).hidden = false
                    (rec.expensive or {}).hidden = false
                    compressed_rec.hidden = false
                    (compressed_rec.normal or {}).hidden = false
                    (compressed_rec.expensive or {}).hidden = false
                end
            end
        end
    end
end
log("Compression finished, data.raw has " .. rec_count .. " recipes.")