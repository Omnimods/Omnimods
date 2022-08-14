--Omnite concrete
RecGen:create("omnimatter","omnite-concrete"):
    setIngredients("stone","omnite"):
    setCategory("crafting-with-fluid"):
    setSubgroup("omni-solids"):
    setIcons({{icon="omnite-concrete", icon_size=64}}, "omnimatter"):
    setStacksize(500):
    setEnergy(10):
    setEnabled(false):
    tile():
    setPlace("omnite-concrete"):
    extend()

local conc = table.deepcopy(data.raw.tile["concrete"])
conc.name = "omnite-concrete"
conc.walking_speed_modifier = 1.5
conc.minable.result = "omnite-concrete"
conc.map_color = {r = 0.29, g = 0.03, b = 0.43}

--Omnite refined concrete
RecGen:create("omnimatter","omnite-refined-concrete"):
    setIngredients("stone","omnite"):
    setCategory("crafting-with-fluid"):
    setSubgroup("omni-solids"):
    setIcons({{icon="omnite-refined-concrete", icon_size=64}}, "omnimatter"):
    setStacksize(500):
    setEnergy(10):
    setEnabled(false):
    tile():
    setPlace("omnite-refined-concrete"):
    extend()

local reconc = table.deepcopy(data.raw.tile["refined-concrete"])
reconc.name = "omnite-refined-concrete"
reconc.walking_speed_modifier = 1.6
reconc.minable.result = "omnite-refined-concrete"
reconc.map_color = {r = 0.29, g = 0.03, b = 0.43}

--Point (all) graphics to our folder
local function repoint_folder(pic)
    pic.picture = string.gsub(pic.picture, "__base__", "__omnimatter__")
    if pic.hr_version then
        pic.hr_version.picture = string.gsub(pic.hr_version.picture, "__base__", "__omnimatter__")
    end
end

for _,tab in pairs({conc.transitions, conc.transitions_between_transitions, conc.variants, reconc.transitions, reconc.transitions_between_transitions, reconc.variants}) do
    for _, trans in pairs(tab) do
        if type(trans) == "table" and trans.picture then
            if not string.find(trans.picture, "effect%-maps") then
                repoint_folder(trans)
            end
        else
            for _, pic in pairs(trans) do
                if pic and type(pic) == "table" and pic.picture then
                    if not string.find(pic.picture, "effect%-maps") then
                        repoint_folder(pic)
                    end
                end
            end
        end
    end
end

data:extend({conc, reconc})