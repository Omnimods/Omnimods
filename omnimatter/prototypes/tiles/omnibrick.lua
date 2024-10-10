RecGen:create("omnimatter","omnite-brick"):
    setIngredients("stone","omnite"):
    setCategory("omnifurnace"):
    setSubgroup("omni-solids"):
    setIcons({"omnite-brick", 32}):
    setStacksize(200):
    setEnergy(1.6):
    setEnabled():
    tile():
    setPlace("omnite-brick"):
    extend()

RecGen:create("omnimatter","early-omnite-brick"):
    setIngredients({"omnite",10},{"stone-brick"}):
    setSubgroup("omni-solids"):
    setResults("omnite-brick"):
    setIcons({"omnite-brick", 32}):
    setEnabled():
    extend()

local omnitile = table.deepcopy(data.raw.tile["stone-path"])
omnitile.name = "omnite-brick"
omnitile.walking_speed_modifier = 1.4
omnitile.minable.result = "omnite-brick"
omnitile.map_color = {r = 0.23, g = 0.02, b = 0.35}
omnitile.layer = 120

--Point (all) graphics to our folder
local function repoint_folder(pic)
    local str = "picture"
    if not pic[str] then str = "spritesheet" end
    pic[str] = string.gsub(pic[str] , "__base__", "__omnimatter__")
end

for _,tab in pairs({omnitile.transitions, omnitile.transitions_between_transitions, omnitile.variants.main, omnitile.variants.transition}) do
    for _, trans in pairs(tab) do
        if type(trans) == "table" and (trans.picture or trans.spritesheet) then
            if  (trans.picture and not string.find(trans.picture, "effect%-maps")) or (trans.spritesheet and not string.find(trans.spritesheet, "effect%-maps")) then
                repoint_folder(trans)
            end
        else
            for _, pic in pairs(trans) do
                if pic and type(pic) == "table" then
                    if (pic.picture and not string.find(pic.picture, "effect%-maps")) or (pic.spritesheet and not string.find(pic.spritesheet, "effect%-maps")) then
                        repoint_folder(pic)
                    end
                end
            end
        end
    end
end

data:extend({omnitile})