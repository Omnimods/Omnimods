
local nr_armour = settings.startup["omnilogistics-nr-armour"].value

local grid = {}

grid[#grid+1] =  {
    type = "equipment-grid",
    name = "primitive-equipment-grid",
    width = 4,
    height = 3,
    equipment_categories = {"omni-armour"}
  }

for i=1, nr_armour do
    local width = 4
    local height = 3
    for j=1,i do
        width=omni.lib.round(width*1.1)+1
        height=omni.lib.round(width*1.125)+1
    end
    grid[#grid+1]={
    type = "equipment-grid",
    name = "omniquipment-grid-"..i,
    width = width,
    height = height,
    equipment_categories = {"omni-armour"}
    }

end

data:extend(grid)
