omni.matter.omnitial = {}
omni.matter.omnisource = {}
omni.matter.omnifluid = {}
omni.matter.res_to_keep = {
	"omnite",
	"infinite-omnite",
	"trees",
	"enemy-base"
}

--------------------------
---Extraction functions---
--------------------------
--Manipulation of the extraction tables
--Open for modders to use to add compatibility

function omni.matter.add_resource(n, t, s, m)
	if not omni.matter.omnisource[tostring(t)] then omni.matter.omnisource[tostring(t)] = {} end
	omni.matter.omnisource[tostring(t)][n]={mod=m, tier = t, name = n, techicon = s}
end

function omni.matter.add_fluid(n ,t, r, s, m)
	if not omni.matter.omnifluid[tostring(t)] then omni.matter.omnifluid[tostring(t)] = {} end
	omni.matter.omnifluid[tostring(t)][n]={mod=m, tier = t, ratio=r, name = n,techicon = s}
end

function omni.matter.remove_resource(n)
	for t, tiers in pairs(omni.matter.omnisource) do
		if omni.matter.omnisource[t][n] then
			omni.matter.omnisource[t][n] = nil
			return true
		end
	end
	return nil
end

function omni.matter.remove_fluid(n)
	for t, tiers in pairs(omni.matter.omnifluid) do
		if omni.matter.omnifluid[t][n] then
			omni.matter.omnifluid[t][n] = nil
			return true
		end
	end
	return nil
end

function omni.matter.get_ore_tier(n)
	for _, tiers in pairs(omni.matter.omnisource) do
		for _,ores in pairs(tiers) do
			if ores.name == n then
				return ores.tier
			end
		end
	end
	return nil
end

function omni.matter.set_ore_tier(n,t)
	local tier = omni.matter.get_ore_tier(n)
	if tier then
		local res = table.deepcopy(omni.matter.omnisource[tostring(tier)][n])
		omni.matter.omnisource[tostring(tier)][n] = nil
		if not omni.matter.omnisource[tostring(t)] then omni.matter.omnisource[tostring(t)] = {} end
		omni.matter.omnisource[tostring(t)][n] = res
		return true
	else
		return nil
	end
end

--Add initial extraction ores
function omni.matter.add_initial(ore_name,ore_amount,omnite_amount)
	omni.matter.omnitial[ore_name] = {
		ingredients ={{name = "omnite", amount = omnite_amount}},
		results = {{name = ore_name, amount = ore_amount}, {name = "stone-crushed", amount = (omnite_amount-ore_amount) or 6}}
	}
end

function omni.matter.add_omnicium_alloy(name,plate,ingot)
	local reg = {}
	ItemGen:create("omnimatter","omnicium-"..name.."-alloy"):
		setSubgroup("omnicium"):
		setStacksize(400):
		setIcons("omnicium-plate"):
		addSmallIcon(plate,3):extend()
	local r = RecGen:create("omnimatter","molten-omnicium-"..name.."-alloy")
		r:setReqAllMods("angelssmelting"):
		fluid():
		setBothColour({r = 1, g = 0, b = 1}):
		setMaxTemp(900):
		setIcons("liquid-molten-omnicium"):
		addSmallIcon(ingot,3):
		setCategory("induction-smelting"):
		setSubgroup("omnicium-casting"):
		setEnergy(4):
		setTechName("omnitech-angels-omnicium-"..name.."-alloy-smelting"):
		setTechIcons("smelting-omnicium-"..name):
		setTechPacks("angels-"..name.."-smelting-1"):
		setTechCost(50):
		setTechTime(30):
		setTechPrereq(
			"omnitech-angels-omnicium-smelting-1",
			"angels-"..name.."-smelting-1"):
		setIngredients(
			{type="item", name="ingot-omnicium", amount=18},
			{type="item", name=ingot, amount=12}
		):
		setResults({type="fluid", name="molten-omnicium-"..name.."-alloy", amount=300}):extend()
		
	RecGen:create("omnimatter","angels-plate-omnicium-"..name.."-alloy"):
		setReqAllMods("angelssmelting"):
		setCategory("casting"):
		setSubgroup("omnicium-casting"):
		setEnergy(4):
		addProductivity():
		setTechName("omnitech-angels-omnicium-"..name.."-alloy-smelting"):
		setIngredients({type="fluid", name="molten-omnicium-"..name.."-alloy", amount=40}):
		addProductivity():
		setResults({type="item", name="omnicium-"..name.."-alloy", amount=4}):extend()
  if not mods["angelssmelting"] then
  	math.randomseed(string.len(plate..name))
	local metal_q = math.random(2,6)
	local omni_q = math.random(1,metal_q)
	reg[#reg+1]={
    type = "recipe",
    name = "omnicium-"..name.."-alloy-furnace",
    category = "omnifurnace",
	icon_size = 32,
    energy_required = 5,
	enabled = true,
    ingredients = {
		{type="item", name="omnicium-plate",amount=omni_q},
		{type="item", name=plate,amount=metal_q},
	},
    results = {{type="item", name="omnicium-"..name.."-alloy",amount=omni.lib.round(math.sqrt(omni_q+metal_q))}}
  }
  for _, tech in pairs(data.raw.technology) do
	if tech.effects then
		for _, eff in pairs(tech.effects) do
			if eff.type == "unlock-recipe" and eff.recipe == plate then
				table.insert(tech.effects,{type="unlock-recipe",recipe="omnicium-"..name.."-alloy-furnace"})
				break
			end
		end
	end
  end
  end
  if #reg > 0 then data:extend(reg) end
end

function omni.matter.get_tier_mult(levels,r,c)
	local peak = math.floor(levels/2)+1.5 --1
	if r==1 and c==1 then
		return 1
	elseif r==c and r<=peak then
		return omni.pure_tech_level_increase
	elseif r>peak and c==2*peak-r+levels%2 then
		return -omni.pure_tech_level_increase
	else
		local val = omni.matter.get_tier_mult(levels,r-1,c)+omni.matter.get_tier_mult(levels,r,c+1)
		return val
	end
end

function omni.matter.add_omniwater_extraction(mod, element, lvls, tier, gain, starter_recipe)
	local function get_prereq(grade,element,tier)
		local req = {}
		local tractor_lvl = ((grade-1)/omni.fluid_levels_per_tier)+tier-1 
		--Add previous tech as prereq if its in the same tier
		if grade > 1 and grade%omni.fluid_levels_per_tier~=1 then
			req[#req+1]="omnitech-"..element.."-omnitraction-"..(grade-1)
		end
		--Add an electric omnitractor tech as prereq if this is the first tech of a new tier
		if grade%omni.fluid_levels_per_tier== 1 and (tractor_lvl <=omni.max_tier) and (tractor_lvl >= 1)then
			req[#req+1]="omnitech-omnitractor-electric-"..tractor_lvl
			--Add the last tech as prereq for this omnitractor tech
			if (grade-1) > 0 then
				omni.lib.add_prerequisite("omnitech-omnitractor-electric-"..tractor_lvl, "omnitech-"..element.."-omnitraction-"..(grade-1), true)
			end
		end
		return req
	end

	local function get_tech_packs(grade,tier)
		local packs = {}
		local pack_tier = math.ceil(grade/omni.fluid_levels_per_tier) + tier-1
		for i=1,pack_tier do
			packs[#packs+1] = {omni.sciencepacks[i],1}
		end
		return packs
	end

	local function get_tech_cost(levels,grade,tier,start,constant)
		local lvl = grade + (tier-1) * omni.fluid_levels_per_tier
		return  start*lvl + constant*lvl*omni.matter.get_tier_mult(levels,grade,1)
	end

	--Starter recipe
	if starter_recipe == true then
		RecGen:create(mod,"basic-"..element.."-omnitraction"):
			setIcons(element):
			addSmallIcon("__omnilib__/graphics/icons/small/num_1.png", 2):
			setIngredients({type="fluid",name="omnic-water",amount=720}):
			setResults({
				{type = "fluid", name = element, amount = gain*0.5},
				{type = "fluid", name = "omnic-waste", amount = gain*1.3}}):
			setSubgroup("omni-fluid-basic"):
			setOrder("b[basic-"..element.."-omnitraction]"):
			setCategory("omnite-extraction-both"):
			setLocName("recipe-name.basic-omnic-water-omnitraction",{"fluid-name."..element}):
			setEnergy(5):
			setEnabled(true):
			extend()
	end

	--Chained recipes
	local cost = OmniGen:create():
		setYield(element):
		setIngredients({type="fluid",name="omnic-water",amount=720}):
		setWaste("omnic-waste"):
		yieldQuant(function(levels,grade) return gain+(grade-1)*gain/(levels-1) end):
		wasteQuant(function(levels,grade) return gain-(grade-1)*gain/(levels-1) end)
	local omniston = RecChain:create(mod, element.."-omnitraction"):
		setLocName("recipe-name.omnic-water-omnitraction",{"fluid-name."..element}):
		setIngredients(cost:ingredients()):
		setCategory("omnite-extraction-both"):
		setIcons(element):
		setResults(cost:results()):
		setSubgroup("omni-fluid-extraction"):
		setOrder("b["..element.."-omnitraction]"):
		setLevel(lvls):
		setEnergy(function(levels,grade) return 0.5 end):
		setEnabled(false):
		setTechIcons(element.."-omnitraction",mod):
		setTechPrereq(function(levels,grade) return get_prereq(grade,element,tier) end):
    	setTechPacks(function(levels,grade) return get_tech_packs(grade,tier) end):
    	setTechCost(function(levels,grade) return get_tech_cost(levels,grade,tier,18,0.8) end):
		setTechTime(15):
		setTechLocName("omnitech-omniwater-omnitraction",{"fluid-name."..element}):
		extend()

  	--Add the last tier as prereq for the rocket silo
  	omni.lib.add_prerequisite("rocket-silo", "omnitech-"..element.."-omnitraction-"..lvls)
end

--------------------------
---Other functions---
--------------------------

--Add a resource to our whitelist. Whitelisted resources will not be removed from autoplace control
function omni.matter.add_ignore_resource(name)
	if not omni.lib.is_in_table(name, omni.matter.res_to_keep) then
		omni.matter.res_to_keep[#omni.matter.res_to_keep+1] = name
	end
end

--Remove a resource from our whitelist.
function omni.matter.remove_ignore_resource(name)
	if omni.lib.is_in_table(name, omni.matter.res_to_keep) then
		omni.lib.remove_from_table(name, omni.matter.res_to_keep)
	end
end