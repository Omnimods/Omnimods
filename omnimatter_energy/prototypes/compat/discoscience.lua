---@diagnostic disable: undefined-global
if mods["DiscoScience"] then
    if DiscoScience and DiscoScience.prepareLab then
        DiscoScience.prepareLab(data.raw["lab"]["omnitor-lab"])
    end
end