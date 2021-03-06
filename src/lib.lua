local lib={}

local id=0

function lib.id (x)
  if not x._id then id= id + 1; x._id= id end
  return x._id
end

function lib.f0(n) return string.format("%.0f",n) end
function lib.f2(n) return string.format("%.2f",n) end
function lib.f4(n) return string.format("%.4f",n) end

function lib.same(x) return x end

function lib.any(l) return l[math.random(1,#l)] end

function lib.anys(l,n,    t) 
  t,n = {}, n or 128
  for i=1,n do t[#t+1] = lib.any(l) end
  return t
end

local function what2do(t,f)
  if not f                 then return lib.same end
  if type(f) == 'function' then return f end 
  if type(f) == 'string'   then 
    return function (z) return z[f] end  
  end
  local m = getmetable(t)
  return m and m[f] or assert(false,"bad function")
end

function lib.bchop(t,val) 
  local lo,hi=1,#t
  while lo <= hi do
    local mid =(lo+hi) // 2
    if t[mid] > val then hi= mid-1 else lo= mid+1 end
  end
  return math.min(lo,#t)  
end

function lib.map(t,f, out)
  out={}
  f = what2do(t,f)
  if t then for i,v in pairs(t) do out[i] = f(v) end  end
  return out
end

function lib.reject(t,f)
  return lib.select(t, function (z) return not f(z) end) end

function lib.select(t,f, out)
  out={}
  for _,v in pairs(t) do 
    if f(v) then out[#out+1] = v  end end
  return out
end

function lib.time(f,   x,t1,t2)
   local t1 = os.clock()
   x=f()
   local t2= os.clock()
   print(string.format ("TIME : %8.6f secs", t2-t1))
   return x
end

function lib.mopy(t,   m)  
  m = getmetatable(t)
  t = lib.copy(t)
  setmetatable(t,m)
  return t
end

function lib.copy(t)  
  return type(t) ~= 'table' and t or lib.map(t,lib.copy)
end

function lib.sort(t,f)
  if type(f) == "string" then
     return lib.sort(t, function(x,y) return x[f] < y[f] end) 
  elseif not f then
     return lib.sort(t, function(x,y) return x < y end) 
  end
  table.sort(t,f)
  return t
end

function lib.b4(x,lst,y)
  y = y or lst[1]
  for _,z in pairs(lst) do 
    if z>x then break else y=z end end
  return y
end

function lib.rpad(s,n,c)
  c = c or " "
  s = tostring(s)
  return  s .. string.rep(c,n - #s) 
end

function lib.lpad(s,n,c)
  c = c or " "
  s = tostring(s)
  return  string.rep(c,n - #s) .. s
end

function lib.split(s, sep,    t,notsep)
  t, sep = {}, sep or ","
  notsep = "([^" ..sep.. "]+)"
  for y in string.gmatch(s, notsep) do t[#t+1] = y end
  return t
end

function lib.dump(t)
   if type(t) ~= 'table' then return tostring(o) end
   local s = '{ '
   for k,v in pairs(t) do
     s = s ..k..' = ' .. lib.dump(v) .. ','
   end
   return s .. '} '
end

function lib.cache(f)
  return setmetatable({}, {
    __index=function(t,k) t[k]=f(k);return t[k] end})
end

function lib.norm(x, mu, sd)
  mu = mu or 0
  sd = sd or 1
  if x < mu-4*sd then return 0 end 
  if x > mu+4*sd then return 0 end
  return (1 / 
    (sd * math.sqrt(2 * math.pi))) * 
     math.exp(-(((x - mu) * (x - mu)) / (2 * sd^2))) 
end

return lib
