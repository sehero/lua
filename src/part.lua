local the  = require "the"
local Part  = the.class()

function Part:_init(name,init,lo,hi)
  self.lo   = lo or 0
  self.hi   = hi or 100
  self.name = name
  self:set(init or lo)
end

function Part:restrain() 
  self.val= math.max(self.lo, 
                     math.min(self.hi, self.val)) end

function Part:__tostring()
  return string.format("%s(%s) in $s..%s = %s",
         self:name(), self.name, self.lo, self.hi, self.val)
end

local Part
