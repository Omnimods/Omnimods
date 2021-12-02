-- Run module limit updates/transfers once we're for sure done screwing with recipes
local recipes = data.raw.recipe
local n = 0
for module_name, module in pairs(data.raw.module) do
    for _, rec_name in pairs(module.limitation or {}) do
        local compressed = rec_name .. "-compression"      
        if recipes[compressed] then
            module.limitation[#module.limitation + 1] = compressed
            n = n + 1
        end
    end
end
log("Added module limitations for " .. n .. " recipes.")

--[[ Mod compatibility fixes ]]--

local rec_count = 0
local categories = {}
for recipe_name, prototype in pairs(recipes) do
    categories[prototype.category or "crafting"] = (categories[prototype.category or "crafting"] or 0) + 1
    rec_count = rec_count + 1
end

--Extend compression items/recipes into the regular machines, revert machines with empty compressed categories back to their base categories
for _,kind in pairs({"assembling-machine","furnace","rocket-silo"}) do
    for _,build in pairs(data.raw[kind]) do
        local has_advanced = false -- Add our "general" category if the machine is capable of advanced crafting
        local has_general_compressed = false -- but only if it isn't there already
        for i,cat in pairs(build.crafting_categories) do
            local new_cat = cat.."-compressed"
            if cat == "advanced-crafting" then
                has_advanced = true
            elseif cat == "general-compressed" then
                has_general_compressed = true
            end
            if not cat:find("compressed$") and data.raw["recipe-category"][new_cat] and categories[new_cat] ~= 0 then
                table.insert(build.crafting_categories,new_cat)
            elseif cat:find("compressed$") and not categories[cat] then
                local old_cat = cat:gsub("-compressed$", "")
                if data.raw["recipe-category"][old_cat] then
                    --log({"","Reverting category ", cat, " to ", old_cat, " on the building ", build.name})
                    build.crafting_categories[i] = old_cat
                end
            end
        end
        if has_advanced and not has_general_compressed then
            build.crafting_categories[#build.crafting_categories+1] = "general-compressed"
        end
        if kind ~= "furnace" then
            -- Allow selection between compressed and non-compressed
            if build.fixed_recipe then
                local rec = recipes[build.fixed_recipe]
                local compressed_rec = recipes[build.fixed_recipe .. "-compression"]
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
