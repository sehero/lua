local the   = require "the"
local lib   = require "lib"
local Num   = require "num"
local Sym   = require "sym"
local Super = the.class()

function Super:_init(lst, debug)
  print("lst",#lst)
  local cohen   = the.chop.cohen
  self.maxDepth = the.chop.maxDepth
  self.bigger   = the.chop.bigger
  self.tooFew   = the.chop.tooFew
  self.xs     = Num():adds(lst, function(z) return z[1] end)
  self.ys     = Sym():adds(lst, function(z) return z[2] end)
  self.smallEffect = self.xs:var()*cohen
  self.tooFew      = (#lst)^the.chop.tooFew 
  self.debug       = debug
  if debug then print("\n"..10) end
end

function Super:div(lst)
  local out = {}
  lst = lib.sort(lst, function(x,y) return x[1]<y[1] end)
  self:div1(lst, 1, #lst, self.xs, self.ys, out, 1)
  return out
end

function Super:div1(lst,lo,hi,x,y,out,lvl)
  local cut,xr,yr,xl,yl
  self:trace(lst, lo, hi, lvl)
  if lvl <= self.maxDepth and (hi-lo) > 2*self.tooFew then
    cut,xr,yr,xl,yl = self:cut(lst,lo,hi,x,y)
  end
  if cut then
    self:div1(lst,    lo, cut, xl, yl, out, lvl+1)
    self:div1(lst, cut+1,  hi, xr, yr, out, lvl+1) 
  else
    if hi < #lst then
      out[#out+1] = lst[hi][1] end end
end

function Super:trace(lst, lo, hi, lvl)
  local f,s
  if self.debug then
    local f = function(z) return lib.f2( lst[z][2] ) end
    s = lo.. ":" ..hi .. " = " .. f(lo) .. ":" .. f(hi)
    print(string.rep("|.. ",lvl-1) ..  s) end
end

local copy = lib.mopy

function Super:cut(lst,lo,hi,xr,yr)
  local xr1,yr1,xl1,yl1,cut,best,xl,yl,x,y
  xl,yl = Num(), Sym() 
  best  = yr:var()
  for i = lo,hi do
    -- steal from the right, give to the left
    x = xr:sub( xl:add( lst[i][1] ))
    y = yr:sub( yl:add( lst[i][2] ))
    if xl.n >= self.tooFew and -- avoid splits of small size
       xr.n >= self.tooFew and -- avoid splits of small size
       x ~= lst[i+1][1] and -- cant split on same value
       xr.mu - xl.mu > self.smallEffect and -- ignore tiny deltas
       yl:xpect(yr)*self.bigger < best -- got a better best?
    then
       best,cut = yl:xpect(yr), i
       xr1      = copy(xr)
       xl1      = copy(xl)
       yr1      = copy(yr)
       yl1      = copy(yl) end
  end 
  return cut, xr1, yr1, xl1, yl1
end

return Super
