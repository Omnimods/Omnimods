if angelsmods and angelsmods.refining then
    ----log("test: "..settings.startup["omnicrystal-sloth"].value)
    --"angelsore7-crystallization-"
    if not settings.startup["omnicrystal-sloth"].value then
        for _,rec in pairs(data.raw.recipe) do
            if omni.lib.start_with(rec.name,"slag-processing-") and not omni.lib.recipe_result_contains(rec.name,"slag-slurry") and not omni.lib.recipe_result_contains(rec.name,"mineral-sludge") and rec.name ~= "slag-processing-stone" then
                omni.lib.remove_recipe_all_techs(rec.name)
                rec.enabled = false
            end
        end
    end
end