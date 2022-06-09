RecGen:create("omnimatter","omnite-brick"):
    setIngredients("stone","omnite"):
    setCategory("omnifurnace"):
    setSubgroup("omni-solids"):
    setStacksize(200):
    setEnabled():
    tile():
    setPlace("omnite-brick"):extend()

RecGen:create("omnimatter","early-omnite-brick"):
    setIngredients({"omnite",10},{"stone-brick"}):
    setSubgroup("omni-solids"):
    setResults("omnite-brick"):
    setEnabled():extend()

local omnitile = table.deepcopy(data.raw.tile["stone-path"])
omnitile.name = "omnite-brick"
omnitile.walking_speed_modifier = 1.5
omnitile.minable.result = "omnite-brick"
omnitile.map_color = {r = 0.29, g = 0.03, b = 0.43}

--Point (all) graphics to our folder
for _,tab in pairs({omnitile.transitions, omnitile.transitions_between_transitions,omnitile.variants}) do
    for _,trans in pairs(tab) do
        for _,pic in pairs(trans) do
            if pic and type(pic) == "table" and pic.picture then
                if not string.find(pic.picture, "effect%-maps") then
                    pic.picture = string.gsub(pic.picture,"__base__","__omnimatter__")
                    if pic.hr_version then
                        pic.hr_version.picture = string.gsub(pic.hr_version.picture,"__base__","__omnimatter__")
                    end
                end
            end
        end
    end
end
data:extend({omnitile})