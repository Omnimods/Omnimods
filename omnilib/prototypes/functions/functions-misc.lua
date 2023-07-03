omni.sciencepacks = {"automation-science-pack","logistic-science-pack","chemical-science-pack","military-science-pack", "production-science-pack","utility-science-pack"}

if mods["omnimatter_crystal"] and mods["omnimatter_science"] then
    table.insert(omni.sciencepacks,3,"omni-pack")
end

if mods["bobtech"] then
    table.insert(omni.sciencepacks,7,"advanced-logistic-science-pack")
end

omni.lib.primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997, 1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123, 1129, 1151, 1153, 1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231, 1237, 1249, 1259, 1277, 1279, 1283, 1289, 1291, 1297, 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373, 1381, 1399, 1409, 1423, 1427, 1429, 1433, 1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499, 1511, 1523, 1531, 1543, 1549, 1553, 1559, 1567, 1571, 1579, 1583, 1597, 1601, 1607, 1609, 1613, 1619, 1621, 1627, 1637, 1657, 1663, 1667, 1669, 1693, 1697, 1699, 1709, 1721, 1723, 1733, 1741, 1747, 1753, 1759, 1777, 1783, 1787, 1789, 1801, 1811, 1823, 1831, 1847, 1861, 1867, 1871, 1873, 1877, 1879, 1889, 1901, 1907, 1913, 1931, 1933, 1949, 1951, 1973, 1979, 1987, 1993, 1997, 1999, 2003, 2011, 2017, 2027, 2029, 2039, 2053, 2063, 2069, 2081, 2083, 2087, 2089, 2099, 2111, 2113, 2129, 2131, 2137, 2141, 2143, 2153, 2161, 2179, 2203, 2207, 2213, 2221, 2237, 2239, 2243, 2251, 2267, 2269, 2273, 2281, 2287, 2293, 2297, 2309, 2311, 2333, 2339, 2341, 2347, 2351, 2357, 2371, 2377, 2381, 2383, 2389, 2393, 2399, 2411, 2417, 2423, 2437, 2441, 2447, 2459, 2467, 2473, 2477, 2503, 2521, 2531, 2539, 2543, 2549, 2551, 2557, 2579, 2591, 2593, 2609, 2617, 2621, 2633, 2647, 2657, 2659, 2663, 2671, 2677, 2683, 2687, 2689, 2693, 2699, 2707, 2711, 2713, 2719, 2729, 2731, 2741, 2749, 2753, 2767, 2777, 2789, 2791, 2797, 2801, 2803, 2819, 2833, 2837, 2843, 2851, 2857, 2861, 2879, 2887, 2897, 2903, 2909, 2917, 2927, 2939, 2953, 2957, 2963, 2969, 2971, 2999, 3001, 3011, 3019, 3023, 3037, 3041, 3049, 3061, 3067, 3079, 3083, 3089, 3109, 3119, 3121, 3137, 3163, 3167, 3169, 3181, 3187, 3191, 3203, 3209, 3217, 3221, 3229, 3251, 3253, 3257, 3259, 3271, 3299, 3301, 3307, 3313, 3319, 3323, 3329, 3331, 3343, 3347, 3359, 3361, 3371, 3373, 3389, 3391, 3407, 3413, 3433, 3449, 3457, 3461, 3463, 3467, 3469, 3491, 3499, 3511, 3517, 3527, 3529, 3533, 3539, 3541, 3547, 3557, 3559, 3571, 3581, 3583, 3593, 3607, 3613, 3617, 3623, 3631, 3637, 3643, 3659, 3671, 3673, 3677, 3691, 3697, 3701, 3709, 3719, 3727, 3733, 3739, 3761, 3767, 3769, 3779, 3793, 3797, 3803, 3821, 3823, 3833, 3847, 3851, 3853, 3863, 3877, 3881, 3889, 3907, 3911, 3917, 3919, 3923, 3929, 3931, 3943, 3947, 3967, 3989, 4001, 4003, 4007, 4013, 4019, 4021, 4027, 4049, 4051, 4057, 4073, 4079, 4091, 4093, 4099, 4111, 4127, 4129, 4133, 4139, 4153, 4157, 4159, 4177, 4201, 4211, 4217, 4219, 4229, 4231, 4241, 4243, 4253, 4259, 4261, 4271, 4273, 4283, 4289, 4297, 4327, 4337, 4339, 4349, 4357, 4363, 4373, 4391, 4397, 4409, 4421, 4423, 4441, 4447, 4451, 4457, 4463, 4481, 4483, 4493, 4507, 4513, 4517, 4519, 4523, 4547, 4549, 4561, 4567, 4583, 4591, 4597, 4603, 4621, 4637, 4639, 4643, 4649, 4651, 4657, 4663, 4673, 4679, 4691, 4703, 4721, 4723, 4729, 4733, 4751, 4759, 4783, 4787, 4789, 4793, 4799, 4801, 4813, 4817, 4831, 4861, 4871, 4877, 4889, 4903, 4909, 4919, 4931, 4933, 4937, 4943, 4951, 4957, 4967, 4969, 4973, 4987, 4993, 4999, 5003, 5009, 5011, 5021, 5023, 5039, 5051, 5059, 5077, 5081, 5087, 5099, 5101, 5107, 5113, 5119, 5147, 5153, 5167, 5171, 5179, 5189, 5197, 5209, 5227, 5231, 5233, 5237, 5261, 5273, 5279, 5281, 5297, 5303, 5309, 5323, 5333, 5347, 5351, 5381, 5387, 5393, 5399, 5407, 5413, 5417, 5419, 5431, 5437, 5441, 5443, 5449, 5471, 5477, 5479, 5483, 5501, 5503, 5507, 5519, 5521, 5527, 5531, 5557, 5563, 5569, 5573, 5581, 5591, 5623, 5639, 5641, 5647, 5651, 5653, 5657, 5659, 5669, 5683, 5689, 5693, 5701, 5711, 5717, 5737, 5741, 5743, 5749, 5779, 5783, 5791, 5801, 5807, 5813, 5821, 5827, 5839, 5843, 5849, 5851, 5857, 5861, 5867, 5869, 5879, 5881, 5897, 5903, 5923, 5927, 5939, 5953, 5981, 5987, 6007, 6011, 6029, 6037, 6043, 6047, 6053, 6067, 6073, 6079, 6089, 6091, 6101, 6113, 6121, 6131, 6133, 6143, 6151, 6163, 6173, 6197, 6199, 6203, 6211, 6217, 6221, 6229, 6247, 6257, 6263, 6269, 6271, 6277, 6287, 6299, 6301, 6311, 6317, 6323, 6329, 6337, 6343, 6353, 6359, 6361, 6367, 6373, 6379, 6389, 6397, 6421, 6427, 6449, 6451, 6469, 6473, 6481, 6491, 6521, 6529, 6547, 6551, 6553, 6563, 6569, 6571, 6577, 6581, 6599, 6607, 6619, 6637, 6653, 6659, 6661, 6673, 6679, 6689, 6691, 6701, 6703, 6709, 6719, 6733, 6737, 6761, 6763, 6779, 6781, 6791, 6793, 6803, 6823, 6827, 6829, 6833, 6841, 6857, 6863, 6869, 6871, 6883, 6899, 6907, 6911, 6917, 6947, 6949, 6959, 6961, 6967, 6971, 6977, 6983, 6991, 6997, 7001, 7013, 7019, 7027, 7039, 7043, 7057, 7069, 7079, 7103, 7109, 7121, 7127, 7129, 7151, 7159, 7177, 7187, 7193, 7207, 7211, 7213, 7219, 7229, 7237, 7243, 7247, 7253, 7283, 7297, 7307, 7309, 7321, 7331, 7333, 7349, 7351, 7369, 7393, 7411, 7417, 7433, 7451, 7457, 7459, 7477, 7481, 7487, 7489, 7499, 7507, 7517, 7523, 7529, 7537, 7541, 7547, 7549, 7559, 7561, 7573, 7577, 7583, 7589, 7591, 7603, 7607, 7621, 7639, 7643, 7649, 7669, 7673, 7681, 7687, 7691, 7699, 7703, 7717, 7723, 7727, 7741, 7753, 7757, 7759, 7789, 7793, 7817, 7823, 7829, 7841, 7853, 7867, 7873, 7877, 7879, 7883, 7901, 7907, 7919, 7927, 7933, 7937, 7949, 7951, 7963, 7993, 8009, 8011, 8017, 8039, 8053, 8059, 8069, 8081, 8087, 8089, 8093, 8101, 8111, 8117, 8123, 8147, 8161, 8167, 8171, 8179, 8191, 8209, 8219, 8221, 8231, 8233, 8237, 8243, 8263, 8269, 8273, 8287, 8291, 8293, 8297, 8311, 8317, 8329, 8353, 8363, 8369, 8377, 8387, 8389, 8419, 8423, 8429, 8431, 8443, 8447, 8461, 8467, 8501, 8513, 8521, 8527, 8537, 8539, 8543, 8563, 8573, 8581, 8597, 8599, 8609, 8623, 8627, 8629, 8641, 8647, 8663, 8669, 8677, 8681, 8689, 8693, 8699, 8707, 8713, 8719, 8731, 8737, 8741, 8747, 8753, 8761, 8779, 8783, 8803, 8807, 8819, 8821, 8831, 8837, 8839, 8849, 8861, 8863, 8867, 8887, 8893, 8923, 8929, 8933, 8941, 8951, 8963, 8969, 8971, 8999, 9001, 9007, 9011, 9013, 9029, 9041, 9043, 9049, 9059, 9067, 9091, 9103, 9109, 9127, 9133, 9137, 9151, 9157, 9161, 9173, 9181, 9187, 9199, 9203, 9209, 9221, 9227, 9239, 9241, 9257, 9277, 9281, 9283, 9293, 9311, 9319, 9323, 9337, 9341, 9343, 9349, 9371, 9377, 9391, 9397, 9403, 9413, 9419, 9421, 9431, 9433, 9437, 9439, 9461, 9463, 9467, 9473, 9479, 9491, 9497, 9511, 9521, 9533, 9539, 9547, 9551, 9587, 9601, 9613, 9619, 9623, 9629, 9631, 9643, 9649, 9661, 9677, 9679, 9689, 9697, 9719, 9721, 9733, 9739, 9743, 9749, 9767, 9769, 9781, 9787, 9791, 9803, 9811, 9817, 9829, 9833, 9839, 9851, 9857, 9859, 9871, 9883, 9887, 9901, 9907, 9923, 9929, 9931, 9941, 9949, 9967, 9973,10007}
omni.lib.prime_range = {1,1}
omni.lib.prime = {}

for i=2,#omni.lib.primes do
    for j=omni.lib.primes[i-1]+1,omni.lib.primes[i] do
        omni.lib.prime_range[j]=i
    end
end

omni.lib.ore_tints = {--can add to the tint table with table.insert(omni.lib.ore_tints,["ore-name"]={tints})
    --based on tint
    ["iron"]      = {r = 0.415, g = 0.525, b = 0.580}, -- vanilla
    ["copper"]    = {r = 0.803, g = 0.388, b = 0.215}, -- vanilla
    ["coal"]      = {r = 0    , g = 0    , b = 0    }, -- vanilla
    ["stone"]     = {r = 0.690, g = 0.611, b = 0.427}, -- vanilla
    ["uranium"]   = {r = 0    , g = 0.7  , b = 0    }, -- vanilla
    ["omnite"]    = {r = 0.396, g = 0    , b = 0.729}, -- omni
    ["tin"]       = {r = 0.85 , g = 0.85 , b = 0.85 }, --made a bit darker, normally all 0.95, barely distinguishable from quartz tho. map_color = {r = 0.600, g = 0.600, b = 0.600}
    ["lead"]      = {r = 0.5  , g = 0.5  , b = 0.5  }, --map_color = {r=0.0, g=0.0, b=0.50}
    ["titanium"]  = {r = 0.8  , g = 0.55 , b = 0.7  }, --map_color = {r=0.610, g=0.325, b=0.500}
    ["silicon"]   = {r = 1    , g = 1    , b = 1    }, --map_color = {r = 1, g = 1, b = 1}
    ["quartz"]    = {r = 1    , g = 1    , b = 1    }, --map_color = {r = 1, g = 1, b = 1}
    ["nickel"]    = {r = 0.54 , g = 0.8  , b = 0.75 }, --map_color = {r=0.4, g=0.8, b=0.6}
    ["zinc"]      = {r = 0.34 , g = 0.9  , b = 0.81 }, --map_color = {r=0.5, g=1, b=1}
    ["silver"]    = {r = 0.875, g = 0.975, b = 1    }, --map_color = {r=0.7, g=0.9, b=0.9}
    ["gold"]      = {r = 1    , g = 0.75 , b = 0    }, --map_color = {r=1, g=0.7, b=0}
    ["tungsten"]  = {r = 0.75 , g = 0.5  , b = 0.25 }, --map_color = {r = 0.5, g = 0.0, b = 0.0}
    ["manganese"] = {r = 1    , g = 1    , b = 1    },
    ["chrome"]    = {r = 1    , g = 1    , b = 1    },
    ["platinum"]  = {r = 1    , g = 1    , b = 1    },
    ["thorium"]   = {r = 1    , g = 1    , b = 0.25 }, --map_color = {r = 0.75, g = 1, b = 0.25}
    ["cobalt"]    = {r = 0.3  , g = 0.53 , b = 0.77 }, --map_color = {r=0.18, g=0.35, b=0.53}
    ["aluminium"] = {r = 0.777, g = 0.7  , b = 0.333}, --map_color = {r=0.777, g=0.7, b=0.333}
    ["sulfur"]    = {r = 0.8  , g = 0.75 , b = 0.1  }, --map_color = {r=1, g=1, b=0}
    ["bauxite"]   = {r = 0.777, g = 0.7  , b = 0.333}, --<-- map_color only
    ["rutile"]    = {r = 0.8  , g = 0.55 , b = 0.7  }, --map_color = {r=0.610, g=0.325, b=0.500}
    ["gems"]      = {r = 0.25 , g = 1    , b = 0.25 }, --<-- map_color only
    ["raw-imersite"] = {r = 1 , g = 0.5     , b = 1    }, --<-- map_color only
    ["raw-rare-metals"] = {r = 0.6, g = 0.3, b = 1  }, --<-- map_color only
    ["raw-borax"] = {r = 0.917, g = 0.917, b = 0.917}, --<-- map_color only
    ["niobium"]   = {r = 0.403, g = 0.6,   b = 0.701}, --<-- map_color only
    ["chromium"]  = {r = 0.784, g = 0.231, b = 0.1  }, --<-- map_color only
    ["phosphate-rock"] = {r = 0.998, g = 0.998, b = 0.998}, --<-- map_color only
    ["kerogen"]   = {r = 0.590, g = 0.511, b = 0.357}, -- vanilla
}

function omni.lib.add_ore_tint(icons, ore_name, alpha)
    if type(icons) ~= "table" then
        return icons
    end
    local new_icons = table.deepcopy(icons)
    local resource = data.raw.resource[ore_name]
    if omni.lib.ore_tints[ore_name] then
        new_icons.tint = omni.lib.ore_tints[ore_name] or {r = 1, g = 1, b = 1, a = 1}
    elseif resource and resource.map_color then
        new_icons.tint = {
            r = resource.map_color[1] or resource.map_color.r,
            g = resource.map_color[2] or resource.map_color.g,
            b = resource.map_color[3] or resource.map_color.b
        }
    else
        log("Could not find a saved tint for "..ore_name) 
    end
    if alpha then 
        new_icons.tint = new_icons.tint or {}
        new_icons["tint"]["a"] = alpha
    end
    return new_icons
end

function omni.lib.factorize(nr)
    local primes = {}
    local newval = nr
    local sqr = math.sqrt(nr)
    local range = math.floor(sqr/math.log(sqr)+sqr)
    for i=1, range do
        if newval%omni.lib.primes[i]==0 then
            local amount = 0
            repeat
                amount = amount+1
                newval=newval/omni.lib.primes[i]
            until(newval/omni.lib.primes[i]>math.floor(newval/omni.lib.primes[i]))
            primes[tostring(omni.lib.primes[i])]=amount
        elseif i==range and newval~= 1 then
            primes[tostring(newval)]=1
        elseif newval == 1 then
            break
        else
            primes[tostring(omni.lib.primes[i])]=0
        end
    end
    return primes
end

function omni.lib.equal(tab1,tab2)
    local v = true
    local c = 0
    if type(tab1)~="table" or type(tab2)~= "table" then  return tab1==tab2 end
    if type(tab1)=="table" then
        for name,val in pairs(tab1) do
            c=c+1
            if tab2[name] == nil then
                return false
            else
                if type(val)=="table" then
                    v=v and omni.lib.equal(val,tab2[name])
                else
                    v= v and val == tab2[name]
                end
            end
        end
    else
        v=v and tab1==tab2
    end
    return v
end

function omni.lib.equalTableIgnore(tab1,tab2,...)
    local arg = {...}
    if type(arg[1])=="table" then arg = arg[1] end
    local v = true
    local c = 0
    for name,val in pairs(tab1) do
        if omni.lib.is_in_table(name,arg) then
            c=c+1
            if tab2[name] == nil then
                return false
            else
                if type(val)=="table" then
                    v=v and omni.lib.equalTableIgnore(val,tab2[name],arg)
                else
                    v= v and val == tab2[name]
                end
            end
        end
    end
    return v
end

function omni.lib.prime.lcm(...)
    local arg = {...}
    local union = table.deepcopy(arg[1])
    for _,p in pairs({"2","3","5"}) do
        for i=2,#arg do
            if arg[i][p] and union[p] then
                if union[p]<arg[i][p] then
                    union[p]=arg[i][p]
                end
            elseif not union[p] then
                union[p]=arg[i][p]
            end
        end
    end
    return union
end

function omni.lib.prime.gcd(...)
    local arg = {...}
    local inter = table.deepcopy(arg[1])
    for _,p in pairs({"2","3","5"}) do
        for i=2,#arg do
            if arg[i][p] and inter[p] then
                if inter[p]>arg[i][p] then
                    inter[p]=arg[i][p]
                end
            else
                inter[p] = 0
            end
        end
    end
    return inter
end

function omni.lib.prime.div(...)
    local arg = {...}
    local div = table.deepcopy(arg[1])
    for _,p in pairs({"2","3","5"}) do
        for i=2,#arg do
            if arg[i][p] and div[p] then
                div[p]=math.max(div[p]-arg[i][p],0)
            end
        end
    end
    return div
end

function omni.lib.prime.mult(...)
    local arg = {...}
    local div = table.deepcopy(arg[1])
    for _,p in pairs({"2","3","5"}) do
        for i=2,#arg do
            if arg[i][p] and div[p] then
                div[p]=div[p]+arg[i][p]
            end
        end
    end
    return div
end

function omni.lib.prime.value(nr)
    local val = 1
    for _,p in pairs({"2","3","5"}) do
        if nr[p] then
            val=val*math.pow(tonumber(p),nr[p])
        end
    end
    return val
end

function omni.lib.union(...)
    local t = {}
    local arg={...}
    for _, tab in pairs(arg) do
        if type(tab) ~= "table" and type(tab) ~= "nil" then
            tab={tab}
        elseif type(tab) == "nil" then
            tab={}
        end
        for name, i in pairs(tab)  do
            if type(name) == "number" then
                table.insert(t,i)
            else
                t[name]=i
            end
        end
    end
    return table.deepcopy(t)
end

-- Two arrays
function omni.lib.iunion(dest, source)
    local base = #dest
    for I=1, #source do
        dest[base+I] = source[I]
    end
    return dest
end

function omni.lib.dif(tab1,tab2)
    local t = {}
    for name,i in pairs(tab1) do
        if (type(name)=="string" and (tab2[name]==nil or not omni.lib.equal(i,tab2[name]))) or not omni.lib.is_in_table(i,tab2) then
            if type(name)=="string" then
                t[name]=table.deepcopy(i)
            else
                t[#t+1]=table.deepcopy(i)
            end
        end
    end
    return table.deepcopy(t)
end

function omni.lib.cutTable(tbl,n)
    local t = {}
    for i=1,n do
        t[#t+1]=tbl[i]
    end
    return t
end

--Strings
function omni.lib.start_with(a,b)
    return string.sub(a,1,string.len(b)) == b
end

function omni.lib.end_with(a,b)
    return string.sub(a,string.len(a)-string.len(b)+1) == b
end

function omni.lib.get_end(a,b)
    return string.sub(a,string.len(a)-b+1,string.len(a))
end

---alpha
---@param alphabet_position number
---@return string
function omni.lib.alpha(alphabet_position)
    local remainder = alphabet_position % 26
    if remainder == 0 then
        remainder = 26
    end
    return string.char(96 + remainder)
end

--mathematics
function omni.lib.round(number)
    return math.floor(number+0.5)
end

--Set tint values for a prototype
function omni.lib.tint(proto, tint)
    local t = {}
    local icons = omni.lib.icon.of(proto)
    if tint.r then t=tint else t={r=tint[1],g=tint[2],b=tint[3],a=tint[4] or 1} end
    for i,icon in pairs(icons) do
        icon.tint = t
    end
    proto.icons = icons
    proto.icon = nil
end

function omni.lib.clone_function(fn)
    local dumped = string.dump(fn)
    local cloned = load(dumped)
    local i = 1
    while true do
        local name = debug.getupvalue(fn, i)
        if not name then
        break
        end
        debug.upvaluejoin(cloned, i, fn, i)
        i = i + 1
    end
    return cloned
end

function omni.lib.capitalize(str)
    return string.upper(string.sub(str,1,1))..string.sub(str,2,string.len(str))
end

--Returns the remainder of the division a/b
--Based on math.fmod() since % breaks if a >> b in lua 5.2 or if numbers get negative
function omni.lib.mod(a,b)
    local m = math.fmod(a, b)
    if ((m > 0) and (tonumber(b) < 0)) or ((m < 0) and (tonumber(b) > 0)) then
        m = m + b
    end
    return m
end

--Returns the greatest common divisor of m and n
function omni.lib.gcd(m,n)
    while m ~= 0 do
        if m~=m then
            error("GCD loop detected, please report with a log file and mod list @ https://discord.gg/xeadqBj")
        end
        m, n = omni.lib.mod(n, m), m
    end
    return n;
end

-- Recursive GCD for.. reasons
function omni.lib.pgcd(...)
    local arg = table.pack(...)
    if #arg > 2 then
        local tmp = table.remove(arg, 1)
        return omni.lib.pgcd(tmp, omni.lib.pgcd(table.unpack(arg)))
    elseif #arg == 2 then
        local a, b = table.unpack(arg)
        repeat
            a, b = b, math.fmod(a, b)
        until b == 0
        return a
    else
        return arg[#arg]
    end
end

--Returns the least common multiple of the given numbers
function omni.lib.lcm(...)
    local arg = {...}
    local val = arg[1]
    for i=2,#arg do
        val = val*arg[i]/omni.lib.gcd(val,arg[i])
    end
    return val
end

function omni.lib.divisors(m)
    local mx = math.floor(math.sqrt(m))
    local div = {1,m}
    for i=2,mx do
        if m%i == 0 then
            div[#div+1]=i
            if i ~= m/i then
                div[#div+1]=m/i
            end
        end
    end
    return div
end

--get the lowest number out of a table
function omni.lib.get_min(m)
    local min = math.huge
    for i = 1, #m  do
        min = min < m[i] and min or m[i]
    end
    return min
end

--checks
function omni.lib.is_number(str)
    return tonumber(str) ~= nil
end

--Checks if a string contains anything within the provided list
function omni.lib.string_contained_list(str, list)
    for i=1, #list do
        if type(list[i])=="table" then
            local found_it = true
            for _,words in pairs(list[i]) do
                found_it = found_it and string.find(str,words)
            end
            if found_it then return true end
        else
            if string.find(str,list[i]) then return true end
        end
    end
    return false
end

function omni.lib.string_contained_entire_list(str, list)
    local found_it = true
    for i=1, #list do
        if type(list[i])=="table" then
            for _,words in pairs(list[i]) do
                found_it = found_it and string.find(str,words)
            end
        else
            found_it = found_it and string.find(str,list[i])
        end
    end
    return found_it
end

function omni.lib.split(inputstr, sep)
    local t={}
    local i=1
    if sep == nil then
        sep = "%s"
    end
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

--Checks if a table contains a specific element
function omni.lib.is_in_table(element, tab)
    if tab then
        for _, t in pairs(tab) do
            if omni.lib.equal(t,element) then return true end
        end
    end
    return false
end

--Remove an element from a table by string
function omni.lib.remove_from_table(element, tab)
    if tab and element then
        for i, t in pairs(tab) do
            if omni.lib.equal(t,element) then 
                table.remove(tab,i)
                break
            end
        end
    end
end

--A function that takes two tables and gives out the elements they have in common
function omni.lib.table_intersection(tab, d)
    local inter={}
    for i=1,#tab do
        if omni.lib.is_in_table(tab[i],d) then inter[#inter+1]=tab[i] end
    end
    if #inter > 0 then return inter else return nil end
end

--Check if tabels are the same
function omni.lib.sub_table_of(t, d)
    local inter={}
    for i=1,#t do
        local found = false
        for j=1,#d do
            if t[i]==d[j] then
                found = true
                break
            end
        end
        if not found then return false end
    end
    return true
end

--Checks if object exists
function omni.lib.does_exist(item)
    for _, p in pairs({"item","mining-tool","gun","ammo","armor","repair-tool","capsule","module","tool","rail-planner","selection-tool","item-with-entity-data","fluid","recipe","technology"}) do
        if data.raw[p][item] then
            if data.raw[p][item] then
                return true
            end
        end
    end
    return false
end

--Add barrels for fluid that are late.
function omni.lib.create_barrel(fluid)
    if type(fluid)=="string" then fluid = data.raw.fluid[fluid] end
    local reg = {}
    -- Alpha used for barrel masks
    local side_alpha = 0.75
    local top_hoop_alpha = 0.75

    --Filled barrel item
    local side_tint = util.get_color_with_alpha(fluid.base_color, side_alpha, true)
    local top_hoop_tint = util.get_color_with_alpha(fluid.flow_color, top_hoop_alpha, true)
    local masks = {
        {icon = "__base__/graphics/icons/fluid/barreling/barrel-side-mask.png", icon_size = 64, tint = side_tint},
        {icon = "__base__/graphics/icons/fluid/barreling/barrel-hoop-top-mask.png", icon_size = 64, tint = top_hoop_tint}
    }

    reg[#reg+1] =   {
        type = "item",
        name = fluid.name.."-barrel",
        localised_name = {"item-name.filled-barrel", fluid.localised_name or {"fluid-name." .. fluid.name}},
        icons = util.combine_icons(omni.lib.icon.of(data.raw.item["empty-barrel"]), masks, {}),
        flags = {},
        subgroup = "fill-barrel",
        order = "b",
        stack_size = 20
    }
    if mods["angelsrefining"] then reg[#reg].subgroup = "angels-fluid-control" end

    --Filling recipe
    masks = {
        {icon = "__base__/graphics/icons/fluid/barreling/barrel-fill.png", icon_size = 64},
        {icon = "__base__/graphics/icons/fluid/barreling/barrel-fill-side-mask.png", icon_size = 64, tint = table.deepcopy(side_tint)},
        {icon = "__base__/graphics/icons/fluid/barreling/barrel-fill-top-mask.png", icon_size = 64, tint = table.deepcopy(top_hoop_tint)}
    }

    reg[#reg+1]={
        type = "recipe",
        name = "fill-"..fluid.name.."-barrel",
        localised_name = {"recipe-name.fill-barrel", fluid.localised_name or {"fluid-name." .. fluid.name}},
        category = "crafting-with-fluid",
        energy_required = 0.2,
        subgroup = "fill-barrel",
        order = "b[fill-"..fluid.name.."-barrel".."]",
        enabled = false,
        icons = util.combine_icons(masks, omni.lib.icon.of(fluid), {scale = 0.5, shift = {-8, -8}}),
        ingredients =
        {
            {type = "fluid", name = fluid.name, amount = 250},
            {type = "item", name = "empty-barrel", amount = 1},
        },
        results=
        {
            {type = "item", name = fluid.name.."-barrel", amount = 1}
        },
        hide_from_stats = true,
        allow_decomposition = false
        }

    if mods["angelsrefining"] then reg[#reg].subgroup = "angels-fluid-control" end
    if angelsmods and angelsmods.trigger and angelsmods.trigger.enable_auto_barreling then reg[#reg].hidden = true end
    omni.lib.add_unlock_recipe("fluid-handling","fill-"..fluid.name.."-barrel", true)

    --Emptying recipe
    masks = {
        {icon = "__base__/graphics/icons/fluid/barreling/barrel-empty.png", icon_size = 64},
        {icon = "__base__/graphics/icons/fluid/barreling/barrel-empty-side-mask.png", icon_size = 64, tint = table.deepcopy(side_tint)},
        {icon = "__base__/graphics/icons/fluid/barreling/barrel-empty-top-mask.png", icon_size = 64, tint = table.deepcopy(top_hoop_tint)}
    }

    reg[#reg+1]=  {
        type = "recipe",
        name = "empty-"..fluid.name.."-barrel",
        localised_name = {"recipe-name.empty-filled-barrel", fluid.localised_name or {"fluid-name." .. fluid.name}},
        category = "crafting-with-fluid",
        energy_required = 0.2,
        subgroup = "empty-barrel",
        order = "c[empty-"..fluid.name.."-barrel".."]",
        enabled = false,
        icons = util.combine_icons(masks, omni.lib.icon.of(fluid), {scale = 0.5, shift = {7, 8}}),
        ingredients =
        {
            {type = "item", name = fluid.name.."-barrel", amount = 1}
        },
        results=
        {
            {type = "fluid", name = fluid.name, amount = 250},
            {type = "item", name = "empty-barrel", amount = 1}
        },
        hide_from_stats = true,
        allow_decomposition = false
    }
    omni.lib.add_unlock_recipe("fluid-handling","empty-" .. fluid.name.."-barrel", true)
    if angelsmods and angelsmods.trigger and angelsmods.trigger.enable_auto_barreling then reg[#reg].hidden = true end
    if mods["angelsrefining"] then reg[#reg].subgroup = "angels-fluid-control" end

    data:extend(reg)
end

local itemproto = {
    "item",
    "mining-tool",
    "gun",
    "ammo",
    "armor",
    "repair-tool",
    "capsule",
    "module",
    "tool",
    "rail-planner",
    "selection-tool",
    "fluid",
    "item-with-entity-data",
    "spidertron-remote",
    "item-with-inventory",
    "item-with-tags"
}

function omni.lib.find_prototype(item)
    if type(item)=="table" then return item elseif type(item)~="string" then return nil end
    for _, p in pairs(itemproto) do
        if data.raw[p][item] then return data.raw[p][item] end
    end
    --log("Could not find "..item.."'s prototype, check it's type.")
    return nil
end

function omni.lib.find_stacksize(item)
    if data.raw.fluid[item] or (type(item)=="table" and item.type=="fluid") then return 50 end
    if type(item)=="table" then return item.stack_size elseif type(item)~="string" then return nil end
    for _, p in pairs(itemproto) do
        if data.raw[p][item] and data.raw[p][item].stack_size then return data.raw[p][item].stack_size end
    end
    log("Could not find "..item.."'s stack size, check it's type.")
end

local entproto = {
    "accumulator",
    "assembling-machine",
    "beacon",
    "beam",
    "boiler",
    "arithmetic-combinator",
    "decider-combinator",
    "electric-pole",
    "furnace",
    "generator",
    "inserter",
    "lab",
    "lamp",
    "loader",
    "locomotive",
    "logistic-container",
    "mining-drill",
    "offshore-pump",
    "pump",
    "solar-panel",
    "turret",
    "spider-vehicle",
    "spider-leg"
}

--returns the item that has the given entity as placable result
function omni.lib.find_placed_by(entityname)
    for _, p in pairs(data.raw.item) do
        if p.place_result == entityname then
            return p.place_result
        end
    end
    --log("Could not find "..entityname.."'s corresponding item prototype.")
    return nil
end

function omni.lib.find_entity_prototype(itemname)
    if type(itemname)=="table" then return itemname elseif type(itemname)~="string" then return nil end
    for _, p in pairs(entproto) do
        if data.raw[p][itemname] then return data.raw[p][itemname] end
    end
    --log("Could not find "..itemname.."'s entity prototype, check it's type.")
    return nil
end

--returns the first recipe it finds
function omni.lib.find_recipe(itemname)
    if type(itemname)=="table" then return itemname elseif type(itemname)~="string" then return nil end
    for _, rec in pairs(data.raw.recipe) do
        if omni.lib.recipe_result_contains(rec.name,itemname) then
            return rec
        end
    end
    --log("Could not find "..itemname.."'s recipe prototype, check it's type.")
    return nil
end

--returns a table of all recipes that have the given result
function omni.lib.find_recipes(itemname)
    if type(itemname)=="table" then return itemname elseif type(itemname)~="string" then return nil end
    local recipes = {}
    for _, rec in pairs(data.raw.recipe) do
        if omni.lib.recipe_result_contains(rec.name,itemname) then
            recipes[#recipes+1] = rec
        end
    end
    --log("Could not find "..itemname.."'s recipe prototype, check it's type.")
    return recipes
end

-----------------------------------------------------------------------------
-- ICON FUNCTIONS --
-----------------------------------------------------------------------------

function omni.lib.add_overlay(it, overlay_type, level)
    -- `it` is the item/recipe table, not the name (can search for it if wrong)
    -- overlay_type is a string for type or an iconspecification table
    -- level is required for extraction, building and compress-fluid and should be a number

    if type(it) == "string" then --parsed whole table not the name...
        it = omni.lib.find_prototype(it)
    end

    local icons = omni.lib.icon.of(it, true)
    if not icons or type(it) ~= "table" then -- Why go on...
        log("Invalid prototype specified")
        return
    end
    local base_size = icons[1] and icons[1].icon_size
    local base_scale = icons[1] and icons[1].scale or 1
    if not base_size then
        base_size = 32
        log("No icon size found for " .. it.name)
    else
        base_size = base_size * base_scale
    end
    level = level or "" -- So we can build our table
    local overlays = { -- Since we normalize for 32px/no mipmap icons below, we only need to set those properties for exceptions
        extraction = { -- omnimatter tiered extraction
            icon = "__omnimatter__/graphics/icons/extraction-"..level..".png"
        },
        building = {
            icon = "__omnimatter_compression__/graphics/compress-"..level.."-32.png"
        },
        compress = { -- compressed item/recipe
            icon = "__omnimatter_compression__/graphics/compress-blank-32.png",
            tint = {
                r = 0.65,
                g = 0,
                b = 0.65,
                a = 1
            },
            scale = 1.5,
            shift = {
                -8,
                8
            }
        },
        uncompress = { -- decompression recipe
            icon = "__omnimatter_compression__/graphics/compress-out-arrow-32.png"
        },
        ["compress-fluid"] = { -- tiered compressed fluids (generator fluids)
            icon = "__omnilib__/graphics/icons/small/lvl"..level..".png",
            icon_size = 64,
            scale = 0.5
        },
        technology = { -- compressed techs
            icon = "__omnimatter_compression__/graphics/compress-tech-128.png",
            icon_size = 128,
            scale = 1.5 * (base_size / 128),
            shift = {
                -32 * (base_size / 128),
                32 * (base_size / 128),
            },
            tint = {
                r = 1,
                g = 1,
                b = 1,
                a = 0.75
            }
        }
    }

    local overlay
    if type(overlay_type) == "string" then
        overlay = overlays[overlay_type]
    elseif type(overlay_type) == "table" then
        overlay = overlay_type
        if overlay.scale then
            overlay.scale = overlay.scale * base_scale
        end
    else
        error("add_overlay: invalid overlay_type specified")
    end

    if icons then --ensure it exists first
        -- Do we require an overlay? This will be placed at the end of the list and thus on top
        if overlay.icon or (overlay[1] and overlay[1].icon) then
            if not overlay[1] then -- iconstable
                overlay.icon_size = overlay.icon_size or 32
                overlay = {overlay}
            end
            icons = util.combine_icons(icons, overlay, {})
        end
        return icons
    end
end

local c=0.9
local dir={W={0,-c},S={0,c},A={-c,0},D={c,0},I={0,-c},K={0,c},J={-c,0},L={c,0},T={0,-c},G={0,c},F={-c,0},H={c,0}}
local inflow={A=true,W=true,S=true,D=true}        --North,East,South,West -->Letters have to be used for the given direction!!!
local passthrough={F=true,T=true,H=true,G=true} --North,East,South,West
--output: I, K, J, L
function omni.lib.assemblingFluidBox(str,hide)
    if str==nil then return nil end
    local code=omni.lib.split(str,".")
    local size = #code
    local box = {}
    for i, row in pairs(code) do
        for j=1, string.len(row) do
            local letter = string.sub(row,j,j)
            if letter ~= "X" then
                local b = {}
                b.pipe_covers = pipecoverspictures()
                b.base_area = 120
                if inflow[letter] then
                    b.production_type = "input"
                    b.base_level = -1
                elseif passthrough[letter] then
                    b.production_type = "input-output"
                else
                    b.production_type = "output"
                    b.base_level = 1
                end
                local pos = {-0.5*(string.len(row)+1)+j,-0.5*(#code+1)+i}
                pos[1]=pos[1]+dir[letter][1]
                pos[2]=pos[2]+dir[letter][2]
                b.pipe_connections = {{ type=b.production_type, position = pos }}
                box[#box+1]=table.deepcopy(b)
            end
        end
    end
    if type(hide) == "boolean" and hide then box.off_when_no_fluid_recipe = true end
    return box
end

function omni.lib.replaceValue(tab,name,val,flags)
    if tab==nil then return val end
    local t= table.deepcopy(tab)
    local n = string.find(name,"%.")
    if n then
        local sb,sbnum = string.sub(name,1,n-1),tonumber(string.sub(name,1,n-1))
        local sb2,sb2num = string.sub(name,2,n-2),tonumber(string.sub(name,2,n-2))

        local newname = string.sub(name,n+1,-1)

        if string.sub(sb,1,1)=="(" and string.sub(sb,-1,-1)==")" then
            if type(t[sb2num or sb2])=="table" then
                t[sb2num or sb2]=omni.lib.replaceValue(tab[sb2num or sb2],newname,val)
            elseif string.find(newname,"%.") then
                local s = omni.lib.split(newname,".")
                for i=2,#s do
                    if tab[s[i]] then
                        if i<#s then
                            local nxt = s[i+1]
                            for j=i+2,#s do
                                nxt=nxt.."."..s[j]
                            end
                            t[s[i]]=omni.lib.replaceValue(tab[s[i]],nxt,val)
                        else
                            t[s[i]]=val
                        end
                    end
                end
            else
                t[newname]=val
            end
        else
            t[sbnum or sb]=omni.lib.replaceValue(tab[sbnum or sb],newname,val)
        end
    else
        t[name]=val
    end
    return t
end

function omni.lib.generatorFluidBox(str,filter,tmp)
    if str==nil then return nil end
    local code=omni.lib.split(str,".")
    local box = {
        base_area = 1,
        height = 2,
        base_level = -1,
        pipe_covers = pipecoverspictures(),
        pipe_connections ={},
        production_type = "input-output"
    }
    for i, row in pairs(code) do
        for j=1, string.len(row) do
            local letter = string.sub(row,j,j)
            if letter ~= "X" then
                local b = {}
                b.pipe_covers = pipecoverspictures()
                b.base_area = 10
                if inflow[letter] then
                    b.production_type = "input"
                    b.base_level = -1
                elseif passthrough[letter] then
                    b.production_type = "input-output"
                else
                    b.production_type = "output"
                    b.base_level = 1
                end
                local pos = {-0.5*(string.len(row)+1)+j,-0.5*(#code+1)+i}
                pos[1]=pos[1]+dir[letter][1]
                pos[2]=pos[2]+dir[letter][2]
                b = { type=b.production_type, position = pos }
                box.pipe_connections[#box.pipe_connections+1]=table.deepcopy(b)
            end
        end
    end
    box.filter = filter
    box.minimum_temperature = tmp
    return box
end

function omni.lib.fluid_box_conversion(kind,str,hide,tmp)
    if str==nil then return nil end
    local box = {}
    if kind == "assembling-machine" or kind=="furnace" then
        if type(hide)=="boolean" then
            box = omni.lib.assemblingFluidBox(str,hide)
        else
            box = omni.lib.assemblingFluidBox(str)
        end
    elseif kind == "generator" then
        if hide then
            box = omni.lib.generatorFluidBox(str,hide,tmp)
        else
            box = omni.lib.generatorFluidBox(str)
        end
    end
    return box
end

--Fuel functions
--returns the fuel value unit
function omni.lib.get_fuel_unit(fv)
    return string.match(fv, "%a+")
end

-- returns the plain fuel value number in J
function omni.lib.get_fuel_number(fv)
    --Catch nil or util crashes
    if type(fv) ~= "string" then return nil end
    --Base game function, returns the fuel number (in J)
    return util.parse_energy(fv)
end

local energy_chars =
{
    k = 10^3,
    K = 10^3,
    M = 10^6,
    G = 10^9,
    T = 10^12,
    P = 10^15,
    E = 10^18,
    Z = 10^21,
    Y = 10^24,
    "k",
    "M",
    "G",
    "T",
    "P",
    "E",
    "Z",
    "Y"
}

--Multiplies the fuel value with mult and returns a formatted value in J or W as applicable
function omni.lib.mult_fuel_value(fv, mult)
    local unit = fv:match("%a+$")
    mult = (mult or 1) * (energy_chars[unit:sub(1,1)] or 1)
    fv = tonumber(fv:match("^[%d%.]+"))
    if fv == 0 then
        return fv .. unit
    end
    fv = math.log(fv * mult, 10)
    return table.concat({
        10^(fv%3),
        energy_chars[math.floor(fv/3)] or "",
        unit:sub(-1)
    })
end