BuildChain:find("omniplant"):setFluidBox("XWXWX.AXXXD.XXXXX.JXXXL.XKXKX"):extend()
--log(serpent.block(data.raw["assembling-machine"]["omniplant-1"]))

--[[local i=1
while data.raw["assembling-machine"]["omniplant-"..i] do
	BuildGen:import("omniplant-"..i):setFluidBox("XWXWX.XXXXX.AXXXL.XXXXX.XKXXKX"):extend()
	i=i+1
end]]