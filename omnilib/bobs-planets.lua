local elements = {"Darkness","Fire","Electricity","Life","Light","Ice","Time","Celestial","Metal","Air","Earth","Water"}

local elemental_day = {}
for i,e in pairs({"Darkness","Fire","Electricity","Life","Light","Ice","Time","Celestial","Metal","Air","Earth","Water"}) do
	elemental_day[string.lower(e)]=i
end

local day_count = {{},{},{},{},{},{},{},{},{},{},{}}

for i=0,131 do
	day_count[i%11+1][string.lower(elements[i%12+1])]=i+1
end

local seed = 12
local start_date = {1725,1,6,"ice"}
local days = 683237

local moon={}

local round = function(nr,l)
	local length = l or 0
	return math.floor(nr*math.pow(10,length))/math.pow(10,length)
end
function gcd(m,n)
	    while m ~= 0 do
			m, n = n % m, m;
		end
	return n;
end

function lcm(m,n)
	return m*n/gcd(m,n)
end

math.randomseed(seed)
for i,el in pairs(elements) do
	moon[el]={angle = math.floor(math.random()*360),dist=round(math.pow(1.2,i-1),3)}
	moon[el].period = round(15*math.pow(moon[el].dist,3/2),2)
end
local new_pos={}

function not_identical(moons)
	for _,m in pairs(moons) do
		if m ~= moons[1] then return true end
	end
	return false
end

function check_align(moons,nr,prec)
	if nr>1 then
		for i,el in pairs(elements) do
			if not omni.lib.is_in_table(el,moons) then
				local check = moons
				check[#check+1]=el
				check_align(check,nr-1,prec)
			end
		end
	else
		if not_identical(moons) then
			local mx = 0
			for _, ch1 in pairs(moons) do
				for _, ch2 in pairs(moons) do
					if ch2 ~= ch1 then
						local dist = math.min(math.abs(new_pos[ch1]-new_pos[ch2]),math.abs(180-new_pos[ch1]-new_pos[ch2]))
						if dist > mx then mx=dist end
					end
				end
			end
			if mx < prec then
				local str = moons[1]
				for i=2,#moons do
					str= str..", "..moons[i]
				end
				----log("the moons "..str.." are aligned with an error of "..mx.." degrees")
			end
		end
	end
end
function calc_alignments(date,nr_moons,precision)
	new_pos={}
	local new_days = date[1]*396+date[2]*132+day_count[date[3]][date[4]]
	local diff_days = new_days-days
	for i,el in pairs(elements) do
		new_pos[el] = moon[el].angle + 360/moon[el].period*diff_days
		new_pos[el]=math.floor(new_pos[el]-math.floor(new_pos[el]/360)*360)
	end
	for i,el in pairs(elements) do
		check_align({el},nr_moons,precision)
	end
end

function day_to_date(d)
	local year = math.floor(d/396)
	local tri = math.floor((d-year*396)/132)
	local work = (d % 11)+1
	local elem = string.lower(elements[(d % 12)+1])
	return {year,tri,work,elem}
end

for i=1,1500 do
	local current_day = days+i
	local d = day_to_date(current_day)
	----log(d[1]..":"..d[2]..":"..d[3].."/"..d[4])
	calc_alignments(d,2,5)
	calc_alignments(d,3,10)
	calc_alignments(d,4,12.5)
	calc_alignments(d,5,13.75)
	calc_alignments(d,6,14.375)
	calc_alignments(d,7,5)
	calc_alignments(d,8,5)
	calc_alignments(d,9,5)
	calc_alignments(d,10,5)
	calc_alignments(d,11,5)
	calc_alignments(d,12,5)
end

local da = {1725,1,9,"metal"}
calc_alignments(da,2,5)
calc_alignments(da,3,5)
calc_alignments(da,4,5)
calc_alignments(da,5,5)
calc_alignments(da,6,5)
calc_alignments(da,7,5)
calc_alignments(da,8,5)
calc_alignments(da,9,5)
calc_alignments(da,10,5)
calc_alignments(da,11,5)
calc_alignments(da,12,5)