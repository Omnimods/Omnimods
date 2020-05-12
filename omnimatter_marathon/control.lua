local round_up = function(nr)
	local dec = nr-math.floor(nr)
	if dec > 0 then
		return math.floor(nr)+1
	else
		return math.floor(nr)
	end
end

local cnst_string = settings.startup["omnimarathon_constant"].value

local modified_recipe = {}

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
local digit_length = function(int)
	local i = 0
	
	while int*math.pow(10,i)-math.floor(int*math.pow(10,i))> 0 do
		i=i+1
	end
	return i-1
end

local const = {}

if string.find(cnst_string,"/") then
	const = split(cnst_string,"/")
	const=const[1]/const[2]
elseif string.find(cnst_string,".") then
	const=tonumber(cnst_string)
else
	const=tonumber(cnst_string)
end



script.on_event(defines.events.on_player_created, function(event)
if game.difficulty_settings.recipe_difficulty == defines.difficulty_settings.recipe_difficulty.expensive and settings.startup["omnimarathon_exponential"].value then
	local iteminsert = game.players[event.player_index].insert
	local nr = round_up((round_up(math.pow(1.7,1+const))-1)/2)*2
	iteminsert{name="burner-mining-drill", count=nr}
	nr = round_up(math.pow(2,1+const))-1
	iteminsert{name="stone-furnace", count=nr}
	if game.active_mods["omnimatter"] then
		nr = round_up(math.pow(1.5,1+const))-1
		iteminsert{name="burner-omnitractor", count=nr}
	end
	if game.active_mods["angelsrefining"] then
		nr = round_up(math.pow(1.3,1+const))-1
		iteminsert{name="burner-ore-crusher", count=nr}
	end
	if game.active_mods["aai-industry"] then
		if #game.players == 1 then
			iteminsert{name="burner-lab", count=1}
		end
	end
end
end)