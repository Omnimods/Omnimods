--Ignore recipes of Mining_Drones and most of its forks, including Mining_Drones_Remastered
--To not break their behaviour when replacing the fluid
--This has to be in final fixes AND before sluids generation
for _, rec in pairs(data.raw.recipe) do
    if rec.category == "mining-depot" and string.find(rec.name,"mine%-") then
        --log("Excluded recipe "..rec.name)
        omni.fluid.excempt_recipe(rec.name)
    end
end

--Late requires
require("prototypes.sluids-generation")
require("prototypes.offshore-pump")
require("prototypes.compat.late-compat")
