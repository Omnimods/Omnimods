--Ignore mining drones recipes to not break its script when replacing the fluid
--This has to be in final fixes AND before sluids generation
if mods["Mining_Drones"] then
    for _, rec in pairs(data.raw.recipe) do
        if rec.category == "mining-depot" and string.find(rec.name,"mine%-") then
            --log("Excluded recipe "..rec.name)
            omni.fluid.excempt_recipe(rec.name)
        end
    end
end

--Late requires
require("prototypes.sluids-generation")
require("prototypes.offshore-pump")
require("prototypes.late-compat")