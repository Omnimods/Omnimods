require("prototypes.functions")

local c = 1
if mods["omnimatter_compression"] then c = 1/3 end
omniwateradd("omnic-water",1728*2*c,1,72,c)

if mods["angelsrefining"] then
	omniwateradd("water-viscous-mud",1728/2,1,144)
	for _,fluid in pairs(data.raw.fluid) do
		if omni.lib.start_with(fluid.name,"water") and omni.lib.end_with(fluid.name,"waste") then
			omniwateradd(fluid.name,1728/6,2,288)
		end
	end
end
