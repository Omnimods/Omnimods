require("prototypes.recipes.fuel-fixes")
require("prototypes.compat.krastorio2-final-fixes")

--Replace all coal from rocks with purified omnite
for _,rock in pairs(data.raw["simple-entity"]) do
    if string.find(rock.name,"rock") then
        if rock.minable then
            if rock.minable.results then
                for _,res in pairs(rock.minable.results) do
                    if res.name == "coal" then
                        res.name = "purified-omnite"
                    end
                end
            elseif rock.minable.result and rock.minable.result == "coal" then
                rock.minable.result = "purified-omnite"
            end
        end
        if rock.loot then
            for _,loot in pairs(rock.loot) do
                if loot.name == "coal" then
                    loot.name = "purified-omnite"
                end
            end
        end
    end
end

if mods["5dim_transport"] then
    -- Fixing the icon sizes back
    data.raw["splitter"]["basic-splitter"]["structure_patch"]["west"]["hr_version"]["width"] = 90
    data.raw["splitter"]["basic-splitter"]["structure"]["west"]["hr_version"]["width"] = 90
end
