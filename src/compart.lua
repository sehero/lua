local the  = require "the"
local lib  = require "lib"
local Part = require "part"

local Compart = the.class()

function Compart:_init(t, rank,part)
  self.state = {}
  self.meta = {}
  self.order = {}
  rank = {stock=1,s=1,a=3,aux=3,f=2,flow=2}
  for k,parts in pairs(t) do 
    for name,init in pairs(parts) do
      if type(init)=='number' then
        part = Part(name,init)
      else
        part = init
      end
      part.rank = rank[k] or 0
      self.state[part.name] = part.val 
      self.order[#self.order+1]  = part end 
  end 
  self.order = lib.sort(self.order, (function (x,y) return
    x.rank==y.rank and x.name<y.name or x.rank<y.rank end))
  print(table.concat(lib.map(self.order,"name")," | "))
  self:run()
end

function Compart:report(first,u,v)
  say= function(lst) 
         print(
           table.concat(
             lib.map(self.order, 
               function(part)
                 return lst[part.name] end),
             " | ")) end
  delta = function(x,y,   z) 
             z= {}
             for k,v1 in pairs(x) do
               v2 = y[k]
               z[#z+1] = v1~=v2 and v1 or "" 
             end
             return z end 
  if   first
  then say(u)
  else the.o(delta(u,v)) --say(delta(u,v)) --delta(u,v)) 
  end
end

function Compart:run(max,dt)
   max  = max or 30
   dt   = dt  or 1
   t,b4 = 0, lib.copy(self.state) 
   first = true
   while(t<max) do
     now = lib.copy(b4)
     self:report(first, b4, now)
     self:step(dt,t, b4, now)
     for _,x in pairs(self.order) do 
       now[x.name] = x:ok( now[x.name] ) 
     end
     first = false
     b4    = now
     t     = t + dt
   end
end

return Compart
