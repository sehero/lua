local the  = require "the"
local Part  = the.class()

function Part:_init(name,init,lo,hi)
  self.lo   = lo or 0
  self.hi   = hi or 100
  self.name = name
  self.val  = init or lo
end

function Part:ok(v) 
  return math.max(self.lo, math.min(self.hi, v)) end

return  Part
