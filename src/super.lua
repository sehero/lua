local the   = require "the"
local lib   = require "lib"
local Num   = require "num"
local Sym   = require "sym"
local Super = the.class()

function Super:_init(lst, debug)
  local cohen   = the.chop.cohen
  self.maxDepth = the.chop.maxDepth
  self.bigger   = the.chop.bigger
  self.biggger  = the.chop.bigger
  self.epsilon  = the.chop.epsilon
  self.xs  = Num():adds(lst, function(z) return z[1] end)
  self.ys  = Sym():adds(lst, function(z) return z[2] end)
  self.smallEffect= self.ys:var()*cohen
  self.min   = (#lst)^the.chop.min 
  self.debug = debug
  if debug then print("\n"..10) end
end

function Super:div(lst)
  local out = {}
  lst = lib.sort(lst, function(x,y) return x[1]<y[1] end)
  self:div1(lst, 1, #lst, self.xs, self.ys, out, 0)
  return out
end

function Super:div1(lst,lo,hi,x,y,out,lvl)
  local cut,xr,yr,xl,yl
  if self.debug then
    print("|",string.rep("|.. ",lvl),lo,hi)
  end
  if lvl <= self.maxDepth and (hi-lo) > 2*self.min then
    print(3)
    cut,xr,yr,xl,yl = self:cut(lst,lo,hi,x,y)
  end
  print("cut",cut)
  if cut then
    self:div1(lst,    lo, cut, xl, yl, out, lvl+1)
    self:div1(lst, cut+1,  hi, xr, yr, out, lvl+1) 
  else
    if hi < #lst then
      out[#out+1] = lst[hi][1] end end
end

local function copy2(x,y) 
  return lib.copy(x), lib.copy(y) end

function Super:cut(lst,lo,hi,xr,yr)
  local xr1,yr1,xl1,yl1,cut,best,xl,yl,x,y
  xl,yl = Num(), Sym() 
  best  = yr:var()
  print(">>", lo, hi, best)
  for i = lo,hi do
    -- steal from the right, give to the left
    x = xr:sub( xl:add( lst[i][1] ))
    y = yr:sub( yl:add( lst[i][2] ))
    print("??",x,y)
    if xl.n >= self.min and -- avoid splits of small size
       xr.n >= self.min and -- avoid splits of small size
       x ~= lst[i+1][1] and -- cant split on same value
       xr.mu - xl.mu > self.epsilon and -- ignore tiny deltas
       yl:xpect(yr)*self.bigger < best -- got a better best?
    then
       best,cut = yl:xpect(yr), i
       xr1,yr1  = copy2(xr, yr)          
       xl1,yl1  = copy2(xl, yl) end 
  end 
  return cut, xr1, yr1, xl1, yl1
end

return Super
