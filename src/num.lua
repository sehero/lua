local the = require "the"
local lib = require "lib"
local Num = the.class(require "col")

function Num:_init(txt,pos)
  self:super(txt,pos)
  self.mu  = 0
  self.m2  = 0
  self.sd  = 0
  self.hi  = math.mininteger
  self.lo  = math.maxinteger
end


function Num:mid()  return self.mu end
function Num:var()  return self.sd end
function Num:show() 
  return (self.w<0 and"<"or">")..tostring(self:mid()) end

function Num:__tostring()
  return string.format("Num(%s,%s)", self.mu, self.sd)
end

function Num:add (x,    d)
  if x ~= the.ch.skip then 
    self.n  = self.n + 1
    x       = tonumber(x)
    d       = x - self.mu
    self.mu = self.mu + d / self.n
    self.m2 = self.m2 + d * (x - self.mu) 
    self.lo = math.min(x, self.lo)
    self.hi = math.max(x, self.hi)
    self.sd = self:sd0()
  end
  return x
end

function Num:sub (x,     d)
  if x ~= the.ch.skip then 
    self.n  = self.n - 1
    x       = tonumber(x)
    d       = x - self.mu
    self.mu = self.mu - d / self.n
    self.m2 = self.m2 - d * (x - self.mu) 
    self.sd = self:sd0()
  end
  return x
end

function Num:sd0()
  if self.n  < 2 then return 0 end
  if self.m2 < 0 then return 0 end
  return (self.m2 / (self.n - 1))^0.5 
end

function Num:dist(x,y)
  if x == the.ch.skip and y == the.ch.skip then
    return 1
  elseif x == the.ch.skip then
    y = self:norm(y)
    x = y < 0.5 and 1 or 0
  elseif y == the.ch.skip then 
    x = self:norm(x)
    y = x < 0.5 and 1 or 0
  else 
    x,y = self:norm(x), self:norm(y)
  end
  return math.abs(x - y)
end

function Num:norm(x)
  if x ~= the.ch.skip then
    x= (x - self.lo) / (self.hi - self.lo + the.tiny)
  end
  return x
end

function Num:strange(x,  z)
  z = Num.z(x, self.mu, self.sd) 
  return z< self.odd or z >= 1-self.odd
end

-- ---------------------------
-- ## Z-curve
-- The `z-curve` is a normal curve with mean of 0 and  standard 
-- deviation of 1. To convery any normal curve into a `z-curve`
-- then subtract `mu` and divide by `sd`.

-- For the same of effeciency, Pre-compute and cache the area under
--  the normal curve from -4\*`sd` to +4\*`sd` (why this
-- range? Well, outside of that range, the y-value of
-- the normal curve is effectively zero).

do
  local zs = {0}  -- zs[1] = 0
  local zn = 512  -- cache "zn" number of entries
  local dx = 8/zn -- generated from -4 to 4
  for i  = 2,zn do -- accumulate the area
    zs[i] = zs[i-1] + dx*lib.norm( -4+i*dx, 0,1)  end

  function Num.z(x,mu,sd,     i)
    -- convect to a z-curve, find `x`'s place in that curve
    i = (((x - mu)/sd  - -4) / 8 * zn) // 1
    if     i > zn then return 1 
    elseif i < 1  then return 0 
    else          return zs[i] end end
end

function Num:like(x,   z,denom,num)
  return lib.norm(x, self.mu, self.sd)
end

local function splitter(out,lo,hi,yall,trivial, eps,bigger)
function Num:splitter(rows,y,cohen,epsilon,bigger,tiny,
                      x,t,lt,all,out)
  t, xy = {}, {}
  yall = Sym(self.txt)
  for _,row in pairs(rows) do
     x = row.cells[self.pos]
    if x ~= the.ch.skip then 
      xy[ #xy+1 ] = {x, y(row) }
      yall:add( y(row) ) end
  end
  min = yall.n^min
  xy  = lib.sort(xy,lt) 
  out = {}
  split(out, 1,#xy,yall,{
end

NumDiv = the.class()

function NumDiv:_init(lst,pause)
  cohen     = the.chop.cohen
  self.eps  = the.chop.epsilon
  self.big  = the.chop.bigger
  self.min  = the.chop.min
  self.xall = Num()
  self.yall = Sym()
  for _,xy in pairs(lst) do 
    self.xall:add(xy[1]) 
    self.yall:add(xy[2]) 
  end
  self.tiny = self.yall.sd*cohen
  self.min  = (#xy)^self.min 
  self.lst  = lib.sort(lst, function (x,y) return x[1] < y[1] end)
end

function NumDiv:div(lst,lo,hi,x,y,out)
  local cut,xr,yr,xl,yl = self:cut(lst,lo,hi,x,y)
  if cut then
    self:div(lst,lo, cut,xr,yr)
    self:div(lst,lo+1,hi,xl,yl)
  else
    -- coffee script bounds
    out[#out+1] = lst[hi][1]
  end
end

function NumDiv:cut(lst,lo,hi,xr,yr)
  if hi-lo < 2*self.min then return nil end
  local xl,yl = Num(), Sym() 
  local xr1,yr1,xl1,yl1,cut,best
  local best  = yr:var()
  for i = lo,hi do
    local x = lst[i][1]
    local y = lst[i][2]
    xl:add(x) ; xr:sub(x)
    yl:add(y) ; yr:sub(y)
    if xl.n >= self.min and yl.n >= self.min  and
       x ~= lst[i+1][1]                       and
       xr.mu - xl.mu > self.tiny              and
       yl:xpect(yr)*bigger < best 
    then
      best,cut = tmp, i
      xr1,yr1  = lib.copy(xr), lib.copy(yr)          
      xl1,yl1  = lib.copy(xl), lib.copy(yl)  end 
  end 
  return cut, xr1, yr1, xl1, yl1
end

return Num
