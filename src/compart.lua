local the  = require "the"
local lib  = require "lib"

local Compart = the.class()

function Compart:_init(t)
  self.state = {}
  self.order = {}
  for k,v in pairs(t) do 
    self:spec(k,v)
    self.state[v.name] = v 
    self.order[#self.order + 1] = v
  end
  self.order = self:sort(self.order)
  self:run()
end

function Compart:spec(x,v)
  local rank = {{ "s", "stock"},{"a","aux"}, {"f","flow"}}
  for rank,pair in pairs(rank) do
    if x == pair[1] then 
      v.rank = rank
      v.what = pair[2] 
      break end end
end

function Compart:sort(t) 
  return lib.sort(self.order, function (x,y)
    return x.rank==y.rank and x.name<y.name or x.rank<y.rank
  end)
end

function Compart:report(first,u,v)
  say= function(z,w) 
         print(table.concat(lib.map(z,w)," | ")) end
  delta = function(x,y,   z) 
             z= {}
             for k,v1 in pairs(x) do
               v2 = y[k]
               z[#z+1] = v1==v2 and "   " or v2 end 
             return z end
  if   first
  then say(u,"name"); say(u, "val")
  else say(delta(u,v),"val") 
  end
end

function Compart:run(max,dt)
   max  = max or 30
   dt   = dt  or 1
   t,b4 = 0, self.state 
   first = true
   while(t<max) do
    now = lib.copy(b4)
    self:report(first, b4,now)
    self:step(dt,t, b4, now)
    for _,v in pairs(self.state) do v:restrain() end
    first = false
    b4    = now
    t     = t + dt
   end
end

return Compart
