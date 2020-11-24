if not omni then omni = {} end

omnisource={}
tiercount={0,0,0}
omnifluid={}
uniomnitiers={}

phlog = false

function omni.add_resource(r,t,s,m)
	if not omnisource[tostring(t)] then omnisource[tostring(t)] = {} end
	omnisource[tostring(t)][r]={mod=m,tier = t, name = r,techicon = s}
end
function omni.add_fluid(r,t,q,s,m)
	if not omnifluid[tostring(t)] then omnifluid[tostring(t)] = {} end
	omnifluid[tostring(t)][r]={mod=m,tier = t,ratio=q, name = r,techicon = s}
end

function omni.add_omnicium_alloy(name,plate,ingot)
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

function omni.add_omniwater_extraction(mod, element, lvls, tier, gain, starter_recipe)
	local get_prereq = function(grade,element,tier)
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
	
	local get_tech_packs = function(grade,tier)
		local packs = {}
		local pack_tier = math.ceil(grade/omni.fluid_levels_per_tier) + tier-1
		for i=1,pack_tier do
			packs[#packs+1] = {omni.sciencepacks[i],1}
		end
		return packs
	end

	--Starter recipe
	if starter_recipe == true then
		RecGen:create(mod,"basic-"..element.."-omnitraction"):
			setIcons(element):
			addSmallIcon("__omnilib__/graphics/icons/small/num_1.png", 2):
			setIngredients({type="fluid",name="omnic-water",amount=720}):
			setResults({
				{type = "fluid", name = element, amount = gain*0.5},
				{type = "fluid", name = "omnic-waste", amount = gain*1.5}}):
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
    	setTechPacks(function(levels,grade) return get_tech_packs(grade,tier,true) end):
    	setTechCost(function(levels,grade) return get_tier_mult(levels,grade,1,true) end):
		setTechTime(15):
		setTechLocName("omnitech-omniwater-omnitraction",{"fluid-name."..element}):
		extend()

  	--Add the last tier as prereq for the rocket silo
  	omni.lib.add_prerequisite("rocket-silo", "omnitech-"..element.."-omnitraction-"..lvls)
end