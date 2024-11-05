function omni.lib.add_unlock_recipe(techname, recipe, force)
    local found = false
    if data.raw.technology[techname] and (data.raw.recipe[recipe] or force) then
        if data.raw.technology[techname].effects then
            for _,eff in pairs(data.raw.technology[techname].effects) do
                if eff.type == "unlock-recipe" and eff.recipe == recipe then
                    found = true
                    break
                end
            end
        else
            data.raw.technology[techname].effects = {}
        end
        if not found then
            table.insert(data.raw.technology[techname].effects,{type="unlock-recipe",recipe = recipe})
            if data.raw.recipe[recipe] then
                data.raw.recipe[recipe].enabled = false
            end
            return
        end
    else
        --log("cannot add recipe to "..techname.." as it doesn't exist")
    end
end

function omni.lib.remove_unlock_recipe(techname, recipe)
    local res = {}
    if data.raw.technology[techname] then
        for _,eff in pairs(data.raw.technology[techname].effects or {}) do
            if eff.type == "unlock-recipe" and eff.recipe ~= recipe then
                res[#res+1]=eff
            end
        end
        data.raw.technology[techname].effects=res
    end
end

function omni.lib.replace_unlock_recipe(techname, recipe,new)
    local res = {}
    for _,eff in pairs(data.raw.technology[techname].effects) do
        if eff.type == "unlock-recipe" and eff.recipe == recipe then
            eff.recipe=new
        end
    end
    --data.raw.technology[techname].effects=res
end

function omni.lib.add_science_pack(techname, pack)
    if data.raw.technology[techname] and type(pack) == "string" then
        for __,sp in pairs(data.raw.technology[techname].unit.ingredients) do
            for _,ing in pairs(sp) do
                if ing == pack then
                    goto found
                end
            end
        end
        table.insert(data.raw.technology[techname].unit.ingredients,{ pack, 1})

        ::found::
    else
        log("Cannot find "..techname..", ignoring it.")
    end
end

function omni.lib.remove_science_pack(techname,pack)
    if data.raw.technology[techname] and data.raw.technology[techname].unit and data.raw.technology[techname].unit.ingredients then
        for i,ing in pairs(data.raw.technology[techname].unit.ingredients) do
            if ing[1] == pack then
                table.remove(data.raw.technology[techname].unit.ingredients, i)
            end
        end
    else
        log("Can not find tech "..techname.." to replace science pack "..pack)
    end
end

function omni.lib.replace_science_pack(techname, old, new)
    if data.raw.technology[techname] and data.raw.technology[techname].unit and data.raw.technology[techname].unit.ingredients then
        for _, ing in pairs(data.raw.technology[techname].unit.ingredients) do
            if ing[1] == old then
                ing[1] = new
            end
        end
    else
        log(techname.." cannot be found, replacement of "..old.." with "..new.." has failed.")
    end
end

--Add a prerequisite to a tech, force will jump checks if that prereq exists.
function omni.lib.add_prerequisite(techname, req, force)
    local found = nil
    --check that the table exists, or create a blank one
    if data.raw.technology[techname] then
        if not data.raw.technology[techname].prerequisites then
            data.raw.technology[techname].prerequisites = {}
        end
    end
    if type(req) == "table" then
        for _,r in pairs(req) do
            if data.raw.technology[r] or force then
                for _,prereq in pairs(data.raw.technology[techname].prerequisites) do
                    if prereq == r then found = 1 end
                end
                if not found then
                    table.insert(data.raw.technology[techname].prerequisites,r)
                else
                    --log("Prerequisite "..r.." already exists")
                end
                found = nil
            end
        end
    elseif req and (data.raw.technology[req] or force) then
        if data.raw.technology[techname] then
            for i,prereq in pairs(data.raw.technology[techname].prerequisites) do
                if prereq == req then found = 1 end
            end
            if not found then
                table.insert(data.raw.technology[techname].prerequisites,req)
            else
                --log("Prerequisite "..req.." already exists")
            end
        else
            log(techname.." does not exist, please check spelling.")
        end
    else
        log("There is no prerequisities to add to "..techname)
    end
end

--Removes the specified prequisite from a technology. Returns true if successful
function omni.lib.remove_prerequisite(techname,prereq)
    local tech = data.raw.technology[techname]
    local found = nil
    if tech and tech.prerequisites then
        local pr={}
        for _,req in pairs(tech.prerequisites) do
            if req ~= prereq then
                pr[#pr+1]=req
            else
                found = true
            end
        end
        tech.prerequisites = pr
        return found
    else
        log("Can not find tech "..techname.." to remove prerequisite "..prereq)
        return nil
    end
end

-- Replaces old with new. If new is already a prerequisite, old gets just removed and a warning gets logged
function omni.lib.replace_prerequisite(techname, old, new)
    if data.raw.technology[techname] and data.raw.technology[techname].prerequisites then
        local found = omni.lib.remove_prerequisite(techname, old)
        if found then
            omni.lib.add_prerequisite(techname, new)
        else
            log("Tech "..old.." is not a prerequisite of"..techname..". Replacement with "..new.." canceled.")
        end
    else
        log("Can not find tech "..techname.." to replace prerequisite "..old.." with "..new)
    end
end

function omni.lib.set_prerequisite(techname, req)
    if data.raw.technology[techname] then
        if type(req) == "table" then
            data.raw.technology[techname].prerequisites = req
        else
            data.raw.technology[techname].prerequisites = {req}
        end
    else
        log("Can not find tech "..techname.." to set prerequisite "..req)
    end
end