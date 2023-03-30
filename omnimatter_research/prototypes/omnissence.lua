
local omnissence_extraction = {}

omnissence_extraction[#omnissence_extraction+1] = {"omnite",1}
omnissence_extraction[#omnissence_extraction+1] = {"omniwood",12}

for tier,ores in pairs(omni.matter.omnisource) do
    for _, o in pairs(ores) do
        if o.name ~= "stone" then
            omnissence_extraction[#omnissence_extraction+1] = {o.name,tonumber(tier)*7}
        end
    end
end

local added = {}

ItemGen:create("omnimatter_research","omnissence"):
    fluid():
    setBothColour(0,1,1):extend()
log("Zombiee is a douche")
log(serpent.block(data.raw.fluid["omnissence"]))
    
for _, ex in pairs(omnissence_extraction) do
    RecGen:create("omnimatter_research","omnissence-extraction-"..ex[1]):
        setLocName({"recipe-name.omnissence-extraction",{"item-name."..ex[1]}}):
        setIcons("omnissence"):
        addSmallIcon(ex[1],4):
        setEnergy(3):
        marathon():
        setCategory("omnicosm"):
        setIngredients(ex[1]):
        setResults({type="fluid",name="omnissence",amount=60*ex[2]}):
        extend()
    added[#added+1]=false
end
local rec_list={"wasteMutation"}

for _, tech in pairs(data.raw.technology) do
    if omni.lib.string_contained_entire_list(tech.name,{"omnitractor","electric"}) or omni.lib.string_contained_entire_list(tech.name,{"omnitech","extraction","impure","base"}) or tech.name == "omniwaste" then
        for _, eff in pairs(tech.effects) do
            if eff.type=="unlock-recipe" and (omni.lib.string_contained_entire_list(eff.recipe,{"base","extraction","omnirec"}) or omni.lib.is_in_table(eff.recipe,rec_list)) then
                omni.lib.standardise(data.raw.recipe[eff.recipe])
                for i,ex in pairs(omnissence_extraction) do
                    local str = omni.lib.split(ex[1],"-")
                    for _,res in pairs(data.raw.recipe[eff.recipe].normal.results) do
                        if omni.lib.string_contained_entire_list(res.name,str) then
                            omni.lib.add_unlock_recipe(tech.name,"omnissence-extraction-"..ex[1])
                            added[i]=true
                            break
                        end
                    end
                end
            end
        end
    end
end

--log("checking essences")
for i, ex in pairs(omnissence_extraction) do
    if not added[i] then
        --log(serpent.block(ex))
        data.raw.recipe["omnissence-extraction-"..ex[1]].normal.enabled=true
        data.raw.recipe["omnissence-extraction-"..ex[1]].enabled=true
        data.raw.recipe["omnissence-extraction-"..ex[1]].expensive.enabled=true
    end
end 