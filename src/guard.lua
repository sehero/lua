Gaurd = require("the").class()

function Guard:init(about,lo,hi,xlo,xhi,stats)
  self.about = about
  self.x = {lo=xlo,hi=xhi}
  self.y = {ratio-0,var=0}
  self.stats= stats
end

function Guard:use(row)
  local v = row.cells[ self.about.pos ]
  return v >= self.x.lo and v <= self.x.hi
end

return Guard
