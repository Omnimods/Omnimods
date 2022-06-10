cost = OmniGen:create():
        setYield("xenokaryote"):
        setIngredients({type="fluid",name="water",amount=100}):
        setWaste():
        linearPercentOutput(5,0.2)
    
RecChain:create("omnimatter_chemistry","xenokaryote"):
    setTechName("basic-biomni-processing"):
    setTechPacks(function(levels,grade) return math.floor(grade*4/omni.chem.levels)+3 end):
    setTechIcon("omnimatter_chemistry","biomni"):
    setTechPrereq({"omnitech-omnitractor-electric-3"}):--"omnitech-omnic-water-omnitraction-5"
    setTechLocName("basic-biomni-processing"):
    setCategory("water-treatment"):
    setIngredients(cost:ingredients()):
    setResults(cost:results()):
    addResults({type="fluid",name="water",amount=100}):
    setSubgroup("biomni"):        
    setLevel(omni.chem.levels):
    setEnergy(0.75):extend()
    
RecGen:create("omnimatter_chemistry","omnikaryote"):
    setTechName("basic-biomni-processing"):
    setCategory("omnimutator"):
    setIngredients({"xenokaryote",5},{"omnite",5},{type="fluid",name="omnic-mutagen",amount=5*12}):
    setResults({"omnikaryote",5}):
    setSubgroup("biomni"):
    marathon():
    setEnergy(1.5):extend()
    
RecGen:create("omnimatter_chemistry","chlorodizing-omnikaryote"):
    setTechName("basic-biomni-processing"):
    setCategory("omnimutator"):
    setIngredients({"omnikaryote",10},{"omnite",5},{type="fluid",name="gas-chlorine",amount=5*12},{type="fluid",name="omnic-mutagen",amount=10*12}):
    setResults({"chlorodizing-omnikaryote",10}):
    setIcons("omnikaryote"):
    addSmallIcon("gas-chlorine",3):
    setSubgroup("biomni"):
    marathon():
    setEnergy(1.5):extend()