----log(serpent.block(random_recipes))

local exclusion_list = {"void"}

local check_recipes = random_recipes

local top_value = 500
local roundRndValues = {}
local b,c,d = math.log(5),math.log(3),math.log(2)
for i=0,math.floor(math.log(top_value)/b) do
  local pow5 = math.pow(5,i)
  for j=0,math.floor(math.log(top_value/pow5)/c) do
    local pow3=math.pow(3,j)
    for k=0,math.floor(math.log(top_value/pow5/pow3)/d) do
      roundRndValues[#roundRndValues+1] = pow5*pow3*math.pow(2,k)
    end
  end
end
table.sort(roundRndValues)

local roundRandom = function(nr,round)
  local t = omni.lib.round(nr)
  local newval = t
  for i=1,#roundRndValues-1 do
    if roundRndValues[i]< t and roundRndValues[i+1]>t then
      if t-roundRndValues[i] < roundRndValues[i+1]-t then
        local c = 0
        if roundRndValues[i] ~= t and round == 1 then c=1 end
        newval = roundRndValues[i+c]
      else
        local c = 0
        if roundRndValues[i+1] ~= t and round == -1 then c=-1 end
        newval = roundRndValues[i+1+c]
      end
    end
  end
  return math.max(newval,1)
end
log("start probability style compression")
--log("random recipes")
for _,recipe in pairs(check_recipes) do
  if not omni.lib.is_in_table(recipe,exclusion_list) and not string.find(recipe,"creative") then
    local double = false
    --local store = data.raw.recipe[recipe]
    local rec = table.deepcopy(data.raw.recipe[recipe])
    --grab localisation before standardisation
    local loc=""
    if rec.name then --check it exists before setting it as fallback
      loc={"recipe-name.compressed-recipe",omni.compression.CleanName(rec.name)}
    end
    if rec.localised_name then
      loc = rec.localised_name
    elseif recipe.main_product then --other cases?
      item=omni.lib.find_prototype(recipe.main_product)
      if item and item.localised_name then
        loc = item.localised_name
      else
        loc={"recipe-name.compressed-recipe",omni.compression.CleanName(recipe.main_product)}
      end
    elseif recipe.normal and recipe.normal.main_product then
      item=omni.lib.find_prototype(recipe.normal.main_product)
      if item and item.normal.localised_name then
        loc = item.localised_name
      else
        loc={"recipe-name.compressed-recipe",omni.compression.CleanName(recipe.normal.main_product)}
      end
    end
    --standardise
    if not mods["omnimatter_marathon"] then omni.marathon.standardise(rec) end
    --double check shenanigans are not happening
    rec.ingredients=nil
    rec.ingredient=nil
    rec.result=nil
    rec.results=nil
    local prob = {normal={},expensive={}}
    --prob table should include more details than just the number, the order of items seems to get changed in create_compression_recipes
    for _,dif in pairs({"normal","expensive"}) do
      for i,res in pairs(rec[dif].results) do
        --begin property setting, bring name into the key
        prob[dif][res.name]={style="normal"}
        local amt = res.amount --set default value
        --amount min system
        -- "min-max" parses mininum, sets mm_prob as max/min
        -- "min-chance" parses minimum, sets mp_prob as min*prob
        -- "zero-max" parses maximum only
        -- "chance" parses average yield, sets prob as prob
        if res.amount_min and res.amount_min > 0 then
          amt = res.amount_min
          if res.amount_max then
            prob[dif][res.name].style = "min-max"
            prob[dif][res.name].mm_prob = res.amount_max/amt
          elseif res.probability then --don't know why you would use this, but sure...
            prob[dif][res.name].style = "min-chance"
            prob[dif][res.name].mp_prob = res.probability
          end
        elseif res.amount_min and res.amount_min == 0 then
          if res.amount_max then
            amt = res.amount_max
            prob[dif][res.name].style = "zero-max"
          else
            log("what are you doing with".. rec.name .. "?")
          end
        elseif res.amount and res.probability then --normal style, priority over previous step
          prob[dif][res.name].style = "chance"
          prob[dif][res.name].prob = res.probability
          amt = roundRandom(amt*res.probability,1)
        end
        --set rec
        res.amount = amt
        --prevent shenanigans
        res.amount_min=nil
        res.amount_max=nil
        res.probability=nil
      end
    end
    --parse to compression
    local new_rec = create_compression_recipe(rec)
    --add in manipulation to return the form
    if new_rec then
      for _,dif in pairs({"normal","expensive"}) do
        for i,res in pairs(new_rec[dif].results) do
          local name = string.sub(res.name,12)
          if res.type == "fluid" then
            name = string.sub(res.name,14)
          end
          if prob[dif][name] then
            local prob_tab = prob[dif][name]
            local new_tab = new_rec[dif].results[i]
            --get style
            if prob_tab.style == "min-max" then
              if math.floor(new_tab.amount*prob_tab.mm_prob) > new_tab.amount then --check it actually gets a range
                new_tab.amount_min = new_tab.amount
                new_tab.amount_max = math.floor(new_tab.amount*prob_tab.mm_prob) --always round down
                new_tab.amount = nil --remove standard if min and max exist
              end
            elseif prob_tab.style == "zero-max" then
              new_tab.amount_min = 0
              new_tab.amount_max = new_tab.amount
              new_tab.amount = nil
            elseif prob_tab.style == "min-chance" then
              new_tab.amount_min = new_tab.amount
              new_tab.probability = prob_tab.mp_prob
              new_tab.amount = nil
            elseif prob_tab.style == "chance" then
              new_tab.probability = prob_tab.prob
            end
          end
        end
      end
    else
      log("you fucked up big time with this recipe: "..rec.name)
    end
    if new_rec then
      new_rec.icon_size=32 --i should not need this, considering it is after a standardisation...
      new_rec.localised_name=new_rec.localised_name or loc
      data:extend({new_rec})
    end
  end
end
log("end probability style compression")
