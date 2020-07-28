if mods["aai-industry-sp0"] then
  industry.add_tech("omniwaste")
  
  RecGen:create("omnimatter_water","water-extraction"):
    setIcons("__base__/graphics/icons/fluid/water.png"):
    setIngredients({type = "fluid", name = "omnic-waste", amount = 200}):
    setResults({type = "fluid", name = "water", amount=150}):
    setCategory("omniphlog"):
    setSubgroup("omni-fluids"):
    setEnergy(5):
    setEnabled(false):
    setTechName("omniwaste"):
    extend()
end



