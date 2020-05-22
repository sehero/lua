local Num    = require("num")
local Ranges = require("the").class()

function Ranges:_init()
  self.ratios = Num()
  self.vars   = Num()
  self.sorted = false
  self._all ={}
end

function Ranges:adds(ranges)
  for _,range in pairs(ranges) do
    self.sorted = false
    self._all[ #self._all+1 ] = range
    self.ratios:add( range.y.ratio )
    self.vars:add(   range.y.var )
  end
end

function Ranges:all()
  if not self.sorted then
    self.sorted = true
    for _,range in pairs(self._all) do
      local ratio = self.ratios:norm(range.y.ratio)
      local var   = 1- self.vars:norm(range.y.var)
      range.score = ((ratio^2 + var^2)/2) ^ 0.5
    end
    table.sort(self._all,
             function (x,y) return x.score>y.score end)
  end
  return self._all
end

return Ranges
