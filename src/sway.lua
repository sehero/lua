local the  = require "the"
local lib  = require "lib"
local Sway = the.class()

function Sway:_init(data)
  self.n     = the.fmap.n
  self.far   = the.fmap.far
  self.min   = ((#data.rows)^the.fmap.min) // 1
  self.data  = data 
  self.cols  = data.some.y
  self.debug = false
end 

function Sway:select(rows, lvl)
  rows = rows or self.data.rows
  lvl  = lvl or 0
  if self.debug then 
    print( #rows, self.min, string.rep("|.. ",lvl))  
  end
  if #rows < 2*self.min 
  then 
    return rows
  else
    local mu,up,f,tmp
    mu,up = self:project(rows)
    f   = function(r) return (up     and r.x >= mu) or 
                             (not up and r.x <  mu) end
    tmp = lib.select(rows,f)
    if #tmp < #rows then 
      return self:select(tmp, lvl+1) end end 
end

function Sway:project(rows)
  local some,any,faraway,farfaraway,a,b,c,x,sum
  some       = lib.anys(rows, self.n)
  any        = lib.any(some)
  faraway    = self:distant(any,  some)
  farfaraway = self:distant(faraway, some)
  c          = self:dist(faraway, farfaraway)
  sum        = 0
  for _,row in pairs(rows) do
    a        = self:dist(row, faraway)
    b        = self:dist(row, farfaraway)
    x        = (a^2 + c^2 - b^2) / (2*c)
    row.x    = math.max(0, math.min(1, x))
    sum      = sum + row.x
  end
  return sum/#rows, 
         faraway:dominates(farfaraway, self.cols)
end

function Sway:distant(r,some)
  return self.data:distant(r, self.cols, some, self.far) end 

function Sway:dist(r1,r2)
  return self.data:dist(r1, r2, self.cols) end

return Sway
