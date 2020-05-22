local copy   = require("lib").mcopy
local f2     = require("lib").f2

local Range  = require("the").class()

function Range:_init(name,pos,lo,hi,ratio,var)
  self.about = {name = name, pos= pos}
  self.x     = {lo   = lo,   hi = hi or lo}
  self.y     = {ratio= ratio or 0, 
                var  = var   or 0}
  self.score = 0
end

function Range:relevant(row)
  local v = row.cells[ self.about.pos ]
  return v >= self.x.lo and v <= self.x.hi
end

function Range:__tostring()
  local x = self.x
  local s = self.about.name .. " = " 
  s = s ..  (x.lo==x.hi and x.lo or  
      "[" ..x.lo.. " .. " ..x.hi.."]")
  s = s .. " {".. f2(self.y.var) .."}"
  s = s .. " * " .. f2(self.y.ratio)
  s = s .. " = " .. f2(self.score)
  return s
end

return Range
