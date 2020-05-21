local copy = require("lib").mcopy
local Range = require("the").class()

function Range:init(about,ystats,lo,hi)
  self.about = about
  self.x = {lo=lo, hi=hi or lo}
  self.y = {ratio=0, var=0, stats=copy(ystats)}
end

function Range:relevant(row)
  local v = row.cells[ self.about.pos ]
  return v >= self.x.lo and v <= self.x.hi
end

return Range
