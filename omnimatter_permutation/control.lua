require("controlFunctions")
script.on_event("increase-input-fluid-rec", function(event)
    change_fluid_recipe(event,"ingredient",1)
end)
script.on_event("decrease-input-fluid-rec", function(event)
    change_fluid_recipe(event,"ingredient",-1)
end)
script.on_event("increase-output-fluid-rec", function(event)
    change_fluid_recipe(event,"result",1)
end)
script.on_event("decrease-output-fluid-rec", function(event)
    change_fluid_recipe(event,"result",-1)
end)
function change_fluid_recipe(event,kind,val)
    local player = game.players[event.player_index]
    if player.selected and player.selected.type == "assembling-machine" then
        local building = player.selected
        if building then 
            local rec = building.get_recipe()
            if rec and string.find(rec.name,"omniperm") then
                local progress = building.crafting_progress
                local bonus = building.bonus_progress
                local finished = building.products_finished
                local s,e = string.find(rec.name,"omniperm")
                local v = split(string.sub(rec.name,e+2,string.len(rec.name)),"-")
                local name = string.sub(rec.name,1,s-2)
                
                local perm = global.omni.perm[name]
                if perm[kind]>1 then
                    local fluidBoxes = {}
                    
                    for i=1,#building.fluidbox do
                        fluidBoxes[i]=clone(building.fluidbox[i])
                    end
                    
                    local ing = v[1]
                    local res = v[2]
                    if kind=="ingredient" then
                        ing=(ing+val-1-math.min(0,ing+val-1)*perm.ingredient)%perm.ingredient+1
                    else
                        res=(res+val-1-math.min(0,res+val-1)*perm.result)%perm.result+1        
                    end
                    
                    
                    
                    local rec = name.."-omniperm-"..ing.."-"..res
                    local newrec = game.recipe_prototypes[name.."-omniperm-"..ing.."-"..res]
                    
                    local boxCount = 1
                    for _, kind in pairs({"ingredients","products"}) do
                        for _,ingres in pairs(newrec[kind]) do
                            if ingres.type == "fluid" then
                                for i=1,#fluidBoxes do
                                    if fluidBoxes[i] and fluidBoxes[i].name == ingres.name then
                                        building.fluidbox[boxCount]=fluidBoxes[i]
                                        break
                                    end
                                end
                                boxCount=boxCount+1
                            end
                        end
                    end
                    
                    building.set_recipe(rec)
                    building.crafting_progress=progress
                    building.bonus_progress=bonus
                    building.products_finished=finished
                else
                    local opposite = "result"
                    if kind=="result" then opposite="ingredient" end
                    player.print{"message.wrong-type",{"recipe-name."..name},kind,opposite}
                end
            elseif rec then
                player.print{"message.not-omniperm-recipe"}
            else
                player.print{"message.no-recipe"}
            end
        end
    end
end


function acquireData(game)
    local perm = {}
    for _, rec in pairs(game.recipe_prototypes) do
        if string.find(rec.name,"omniperm") then
            local s,e = string.find(rec.name,"omniperm")
            local v = split(string.sub(rec.name,e+2,string.len(rec.name)),"-")
            local name = string.sub(rec.name,1,s-2)
            if not perm[name] then perm[name]={ingredient=1,result=1} end
            if tonumber(v[1])>perm[name].ingredient then perm[name].ingredient = tonumber(v[1]) end
            if tonumber(v[2])>perm[name].result then perm[name].result = tonumber(v[2]) end
        end
    end
    global.omni.perm=perm
end
script.on_configuration_changed( function(conf)
    if not global.omni then global.omni={} end
    acquireData(game)
    global.omni.need_update=true
end)

script.on_init( function(conf)
    global.omni = {}
    acquireData(game)
    global.omni.need_update=false
end)
script.on_event(defines.events.on_tick, function(event)
    if global.omni.need_update then
        acquireData(game)
        global.omni.need_update=false
    end
end)