RecGen:create("omnimatter_research","copper-iron-ore-mixture"):
    setSubgroup("raw-material"):
    setStacksize(250):
    setEnabled():
    setEnergy(0.5):
    marathon():
    setCategory("omnite-extraction-both"):
    setIngredients({"iron-ore", 3},{"copper-ore", 3}):
    setResults({"copper-iron-ore-mix",6}):extend()
    
RecGen:create("omnimatter_research","omnicium-plate-gear"):
    setSubgroup("raw-material"):
    setIcons({
        {icon=data.raw.item["omnicium-plate"].icons[1].icon,
            scale = 0.5,
            shift = {-6,-6},},
        {icon=data.raw.item["omnicium-gear-wheel"].icons[1].icon,
            scale = 0.5,
            shift = {6,6},},
    }):addBlankIcon():
    setStacksize(250):
    setEnabled():
    setIngredients({"omnicium-plate", 1},{"omnicium-gear-wheel", 1}):
    setResults("omnicium-plate-gear")--:extend()
    
RecGen:create("omnimatter_research","plate-smelting-omnicium"):
    setSubgroup("raw-material"):
    fluid():
    setItemName("liquid-molten-omnicium"):
    setIcons("molten-omnicium","omnimatter"):
    addSmallIcon("omnicium-plate",3):
    setEnabled():
    setIngredients({"omnicium-plate", 5}):
    setCategory("omnifurnace"):
    marathon():
    setNormalResults({name="liquid-molten-omnicium",amount=100,type="fluid"}):
    setExpensiveResults({name="liquid-molten-omnicium",amount=50,type="fluid"}):extend()
    
BuildGen:import("omni-furnace"):setFluidBox("XI.XX"):extend()
    
    
RecGen:create("omnimatter_research","omnisssence-ore-mixture"):
    setSubgroup("raw-material"):
    setStacksize(250):
    setEnabled():
    setEnergy(1):
    setCategory("omnicosm"):
    setIngredients({"copper-iron-ore-mix", 3},{type="fluid",name="omnissence", amount=350}):
    setResults({"ore-mix-essence",2}):extend()
    
RecGen:create("omnimatter_research","omnidized-steel"):
    setSubgroup("raw-material"):
    setStacksize(100):
    setCategory("omniphlog"):
    setTechName("angels-iron-smelting-1"):
    setIngredients({"ingot-steel", 1},{type="fluid",name="omnic-waste", amount=50}):
    setResults("omnidized-steel"):extend()
    
RecGen:create("omnimatter_research","omnissenced-wood"):
    setSubgroup("raw-material"):
    setStacksize(100):
    setCategory("omnicosm"):
    setIngredients({"omniwood", 1},    {type="fluid",name="omnissence", amount=75}):
    setResults("omnissenced-wood"):extend()
    
RecGen:create("omnimatter_research","omnissenced-iron-crystal"):
    setSubgroup("raw-material"):
    setStacksize(100):
    setCategory("omnicosm"):
    setIngredients({"iron-ore-crystal", 1},{type="fluid",name="omnissence", amount=75}):
    setResults("omnissenced-iron-crystal"):extend()
    
RecGen:create("omnimatter_research","ingot-mingnisium"):
    setSubgroup("raw-material"):
    setStacksize(100):
    setEnergy(5):
    --setTechName("omnismelter-1"):
    setCategory("omnismelter"):
    setIngredients(
        {"angels-ore6-chunk", 2},
        {type="fluid",name="omnirgyrum", amount=60},
        {type="fluid",name="oxomnithiolic-acid", amount=60}):
    setResults({"ingot-mingnisium",2}):extend()

RecGen:create("omnimatter_research","crushed-mixture"):
    setSubgroup("raw-material"):
    setStacksize(500):
    setEnergy(2):
    setMain("crushed-mixture"):
    --setTechName("omnismelter-1"):
    setCategory("omnite-extraction"):
    setIngredients(
        {"angels-ore1-crushed", 1},
        {"angels-ore2-crushed", 1},
        {"angels-ore3-crushed", 1},
        {"angels-ore4-crushed", 1},
        {"angels-ore5-crushed", 1},
        {"angels-ore6-crushed", 1}):
    setResults({"crushed-mixture",3},{"stone-crushed",3}):extend()
    
RecGen:create("omnimatter_research","hydrosalamite"):
    setSubgroup("raw-material"):
    setStacksize(50):
    setEnergy(3):
    --setTechName("omnismelter-1"):
    setCategory("omnite-extraction"):
    setIngredients(
        {"crushed-mixture", 1},
        {type="fluid",name="omnirous-acid",amount = 60}):
    setResults("hydrosalamite"):extend()
    
RecGen:create("omnimatter_research","omnissenced-plastic"):
    setSubgroup("raw-material"):
    setStacksize(200):
    setEnergy(1):
    --setTechName("omnismelter-1"):
    setCategory("omnicosm"):
    setIngredients(
        {"plastic-bar", 1},
        {type="fluid",name="omnissence",amount = 100}):extend()

RecGen:create("omnimatter_research","primitive-iron-ore-extraction"):
    setSubgroup("raw-material"):
    setStacksize(100):
    setIcons("iron-ore"):
    setEnergy(1):
    setEnabled():
    marathon():
    setCategory("omnite-extraction-burner"):
    setIngredients({"angels-ore1", 5}):
    setResults("iron-ore"):extend()
    
RecGen:create("omnimatter_research","primitive-copper-ore-extraction"):
    setSubgroup("raw-material"):
    setStacksize(100):
    setIcons("copper-ore"):
    setEnergy(1):
    marathon():
    setEnabled():
    setCategory("omnite-extraction-burner"):
    setIngredients({"angels-ore3", 5}):
    setResults("copper-ore"):extend()