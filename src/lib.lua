local lib={}

function lib.same(x) return x end

function lib.any(l) return l[math.random(1,#l)] end

function lib.anys(l,n,    t) 
  t,n = {}, n or 128
  for i=1,n do t[#t+1] = lib.any(l) end
  return t
end

function lib.map(t,f, out)
  out={}
  f =  f and f or function(z) return z end
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

function lib.copy(t)  
  return type(t) ~= 'table' and t or lib.map(t,lib.copy)
end

function lib.sort(t,f)
  if type(f) == "string" then
    return lib.sort(t, function(x,y) return x[f]<y[f] end) 
  elseif not f then
    return lib.sort(t, function(x,y) return x< y end) 
  end
  table.sort(t,f)
  return t
end

function lib.rpad(s,n)
  s = tostring(s)
  return  s .. string.rep(" ",n - #s) 
end

function lib.lpad(s,n)
  s = tostring(s)
  return  string.rep(" ",n - #s) .. s
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

return lib
