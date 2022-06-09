cost = OmniGen:create():
        setYield("omniaescene"):
        setIngredients({"omnicarbide",2},{type="fluid",name="liquid-molten-bronze",amount=120},{type="fluid",name="nitromni",amount=120}):
        setWaste("omnion"):
        linearPercentOutput(300,0.3,0.8)
    
RecChain:create("omnimatter_chemistry","omniaescene"):
    fluid():
    setBothColour(1,0,0.5):
    setTechName("basic-omniganometallic-processing"):
    setTechPacks(function(levels,grade) return math.floor(grade*4/omni.chem.levels)+1 end):
    setTechIcon("omnimatter_chemistry","omniganometallic"):
    setTechLocName("basic-omniganometallic-processing"):
    setIcons("molten-bronze","angelssmelting"):
    addSmallIcon("__omnimatter_chemistry__/graphics/icons/omniganometallic.png",3):
    setTechPrereq(function(levels,grade)
        local req = {}
        if grade == 1 then
            req = {"omnitech-basic-carbomni-processing-1"}
            if mods["angelssmelting"] then
                req[#req+1]="angels-bronze-smelting-1"
            else
                req[#req+1]="alloy-processing-1"
            end
        end
        return req
    end):
    setCategory("omnismelter"):
    setIngredients(cost:ingredients()):
    setResults(cost:results()):
    setSubgroup("omninitrogen"):
    setLevel(omni.chem.levels):
    setEnergy(6):extend()
    
    --"bronze-alloy",