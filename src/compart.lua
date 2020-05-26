local the  = require "the"
local lib  = require "lib"
local Part = require "part"

local Compart = the.class()

function Compart:_init(t, verbose, w,rank,part)
  self.w = 5
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
  for _,x in pairs(self.order) do self:say(x.name) end; 
  print("")
  for _,x in pairs(self.order) do self:say("","-") end
  print("")
  self:run()
end

function Compart:say(x,c)
  io.write(lib.lpad(x,self.w,c) .. " | ")
end

function Compart:report(first, b4,now)
  for  _,part in pairs(self.order) do
    local v1 = b4[ part.name]
    local v2 = now[part.name]
    if   first
    then self:say(v1)
    else self:say((v1==v2) and " ." or v2)
    end
  end
end

function Compart:run(max,dt,    t,b4,now,first)
   max  = max or 30
   dt   = dt  or 1
   t,b4 = 0, lib.copy(self.state) 
   first = true
   while(t<max) do
     now = lib.copy(b4)
     self:step(dt,t, b4, now)
     for _,x in pairs(self.order) do 
       now[x.name] = x:ok( now[x.name] ) 
     end
     self:report(first,b4,now)
     print("")
     first = false
     b4    = now
     t     = t + dt
   end
   return now
end

return Compart
