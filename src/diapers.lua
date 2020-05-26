local the     = require "the"
local Compart = require "compart"
local Diapers = the.class(Compart)

--[[

  q   +-----+  r  +-----+
 ---->|  C  |---->|  D  |--> s
  ^   +-----+     +-+---+
  |                 |
  +-----------------+ 

    C = stock of clean diapers
    D = stock of dirty diapers
    q = inflow of clean diapers
    r = flow of clean diapers to dirty diapers
    s = out-flow of dirty diapers
--]]

function Diapers:_init()
  self:super({stock = {c=100, d=0}
              ,flow = {q=0,   r=8, s=0}})
end

function Diapers:step(dt,t,u,v)
  local saturday = function(x) return x % 7 == 6 end
  v.c = v.c + dt*(u.q - u.r)
  v.d = v.d + dt*(u.r - u.s)
  v.q = saturday(t) and 70  or 0
  v.s = saturday(t) and u.d or 0
  if t == 27 then --  special case (the day i forget)
      v.s = 0 end
end
 
return Diapers
