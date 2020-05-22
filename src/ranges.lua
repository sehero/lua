local Num    = require("num")
local Ranges = require("the").class()

function Ranges:_init()
  self.ratios = Num()
  self.vars   = Num()
  self.sorted = false
  self._all   = {}
end

function Ranges:adds(ranges)
  for _,range in pairs(ranges) do self:add(range) end
end

function Ranges:add(range)
  self.sorted = false
  self._all[ #self._all+1 ] = range
  self.ratios:add( range.y.ratio )
  self.vars:add(   range.y.var )
end

function Ranges:all()
  if not self.sorted then
    self:scored()
    table.sort(self._all, 
               function (x,y) return x.score>y.score end)
  end
  self.sorted = true
  return self._all
end

function Ranges:scored()
  for _,range in pairs(self._all) do
    local good  = self.ratios:norm(range.y.ratio)
    local bad   = self.vars:norm(  range.y.var)
    range.score = (good^2 + (1-bad)^2)^0.5 / 2^0.5 
  end
end 

return Ranges
