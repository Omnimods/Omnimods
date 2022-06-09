local upgrades = {}
for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered({
        type = "resource"
    })) do 
        if entity.valid and entity.prototype.name:find("compressed") then
            local oldname = entity.prototype.name
            local newname = oldname:gsub("compressed%-concentrated%-", "")
            newname = newname:gsub("compressed%-", "")
            newname = newname:gsub("-ore$", ""):gsub("-ore$", "")

            local attribs = {
                position = entity.position,
                force = entity.force,
                amount = entity.amount,
                initial_amount = entity.initial_amount
            }
            --log("compressed-" .. newname)
            --log("concentrated-" .. newname:gsub("-ore", ""))
            attribs.name = (game.entity_prototypes["compressed-resource-" .. newname] or {}).name
            attribs.name = attribs.name or (game.entity_prototypes["concentrated-resource-" .. newname] or {}).name

            if attribs.name and attribs.name ~= oldname then
                upgrades[oldname] = upgrades[oldname] or {
                    new_name = attribs.name,
                    amount = 0
                }
                upgrades[oldname].amount = upgrades[oldname].amount + 1
                entity.destroy()
                surface.create_entity(attribs)
            end
        end
    end
end

for old_name, values in pairs(upgrades) do
    log(string.format(
        "MIGRATION: Replaced %d of %s with %s.",
        values.amount,
        old_name,
        values.new_name
    ))
end