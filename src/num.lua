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

function Num:strange(x)
  print("\nnum",x,self:like(x),self.mu,self.sd)
  z=  Num.z(x,self.mu, self.sd) 
  return z< self.odd or z >= 1-self.odd
end

do
  local zcurve = {0}
  local zinc   = 512
  local dx     = 8/zinc
  for i = 2,zinc do
    zcurve[i] = zcurve[i-1] + dx*lib.norm(-4+i*dx,0,1)  
  end

  function Num.z(x,mu,sd)
    local  i = (((x - mu)/sd  - -4) / 8 * zinc) // 1
    if     i > zinc then return 1 
    elseif i < 1    then return 0 
    else            return zcurve[i] end end
end

function Num:like(x,   z,denom,num)
  return lib.norm(x, self.mu, self.sd)
end

return Num
