data:extend({
 {
    type = "item-group",
    name = "omnipermutation",
    order = "z",
    inventory_order = "z",
    icon = "__omnimatter_permutation__/graphics/permutation.png",
	icon_size = 128,
  }
})

local fluidCount = function(ingres)
	local count = 0
	for _, p in pairs(ingres) do
		if p.type == "fluid" then count= count+1 end
	end
	return count
end
local grabFluids = function(ingres)
	local catch = {}
	for _, p in pairs(ingres) do
		if p.type == "fluid" then catch[#catch+1]=table.deepcopy(p) end
	end
	return catch
end

local addTechRec={}

function factorial(n)
	if n == 0 then
		return 1
	else
		return n*factorial(n-1)
	end
end
function pickFluidOrder(fluids)
	local alla = {}
	if #fluids == 1 then return {fluids} end
	for i,fluid in pairs(fluids) do
		local nfluid = table.deepcopy(fluids)
		table.remove(nfluid,i)
		local omall = pickFluidOrder(nfluid)
		for _, f in pairs(omall) do
			alla[#alla+1]=omni.lib.union(f,{fluid})
		end
	end
	return table.deepcopy(alla)
end

--error("meep")
log("test ordering")
local recipesExpanded = {}
local techRec = {}
log(serpent.block(data.raw.recipe["ingot-mingnisium"]))
for _,rec in pairs(data.raw.recipe) do
	omni.marathon.standardise(rec)
	if fluidCount(rec.normal.results) > 1 or fluidCount(rec.normal.ingredients) > 1 then
		techRec[rec.name] = {}
		if not omni.lib.equalTableIgnore(rec.normal.ingredients,rec.expensive.ingredients,"amount") or not omni.lib.equalTableIgnore(rec.normal.results,rec.expensive.results,"amount") then
			for _,dif in pairs({"normal","expensive"}) do
				local fluids = {ingredients = {},results={}}
				local solids = {ingredients = {},results={}}
				for _,ingres in pairs({"ingredients","results"}) do
					fluids[ingres]=grabFluids(rec[dif][ingres])
					solids[ingres]=omni.lib.dif(rec[dif][ingres],fluids[ingres])
				end
			end
		else
			local fluids = {normal={ingredients = {},results={}},expensive={ingredients = {},results={}}}
			local solids = {normal={ingredients = {},results={}},expensive={ingredients = {},results={}}}
			for _,dif in pairs({"normal","expensive"}) do
				for _,ingres in pairs({"ingredients","results"}) do
					fluids[dif][ingres]=grabFluids(rec[dif][ingres])
					solids[dif][ingres]=omni.lib.dif(rec[dif][ingres],fluids[dif][ingres])
				end
			end
			local ingOrders = {normal=pickFluidOrder(fluids.normal.ingredients),expensive=pickFluidOrder(fluids.expensive.ingredients)}
			local resOrders = {normal=pickFluidOrder(fluids.normal.results),expensive=pickFluidOrder(fluids.expensive.results)}
			local i=1
			repeat
				local j=1
				repeat
					local new = table.deepcopy(rec)
					for _, dif in pairs({"normal","expensive"}) do
						if ingOrders[dif][i] and #ingOrders[dif][i] > 0 then new[dif].ingredients = omni.lib.union(ingOrders[dif][i],solids[dif].ingredients) end
						if resOrders[dif][j] and #resOrders[dif][j] > 0 then new[dif].results = omni.lib.union(resOrders[dif][j],solids[dif].results) end
					end
					if not new.localised_name and new.main_product==nil then new.localised_name = {"recipe-name."..rec.name} end
					new.name=new.name.."-omniperm-"..i.."-"..j
					techRec[rec.name][#techRec[rec.name]+1]=new.name
					new.hidden = true
					if not data.raw["item-subgroup"][new.subgroup] then error("the subgroup "..new.subgroup.." does not exist, make sure you have defined it properly and extended it.") end
					recipesExpanded[#recipesExpanded+1]={
						type = "item-subgroup",
						name = new.subgroup.."-perm",
						group = "omnipermutation",
						order = data.raw["item-subgroup"][new.subgroup].order,
					  }
					if not (i==1 and j==1) then new.subgroup=new.subgroup.."-perm" end
					recipesExpanded[#recipesExpanded+1]=table.deepcopy(new)
					j=j+1
				until(j>#resOrders.normal)
				i=i+1
			until(i>#ingOrders.normal)
		end
		data.raw.recipe[rec.name]=nil
	end
end
log(serpent.block(data.raw.recipe["ingot-mingnisium"]))
--error("derp")

local rawsize = table_size(data.raw.recipe) + #recipesExpanded
if rawsize > 65535 then
	error("data.raw.recipe exceeds the limit of 65535 (" .. rawsize .. "). Please disable either your largest mod or omnipermute.")
end

if #recipesExpanded > 0 then
	data:extend(recipesExpanded)
end

for _,tech in pairs(data.raw.technology) do
	if tech.effects then
		for i,eff in pairs(tech.effects) do
			if eff.type == "unlock-recipe" and techRec[eff.recipe] then
				for _, r in pairs(techRec[eff.recipe]) do
					tech.effects[#tech.effects+1]={type="unlock-recipe",recipe=r}
				end
				tech.effects[i]=nil
			end
		end
	end
end



for _,mod in pairs(data.raw.module) do
	if mod.limitation then
		local newRestrict = {}
		for i, restrict in pairs(mod.limitation) do
			if techRec[restrict] then
				newRestrict = omni.lib.iunion(newRestrict, techRec[restrict])
			else
				newRestrict[#newRestrict+1] = restrict
			end
		end
		mod.limitation = table.deepcopy(newRestrict)
	end
end
