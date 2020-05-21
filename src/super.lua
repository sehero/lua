local the   = require "the"
local lib   = require "lib"
local Super = the.class()

function Super:_init(lst, num,sym,about, debug)
  self.num         = num
  self.sym         = sym
  local cohen      = the.chop.cohen
  self.maxDepth    = the.chop.maxDepth
  self.bigger      = the.chop.bigger
  self.tooFew      = the.chop.tooFew
  self.xs          = self.num():adds(lst, 1) 
  self.ys          = self.sym():adds(lst, 2)
  self.smallEffect = self.xs:var()*cohen
  self.tooFew      = (#lst)^the.chop.tooFew 
  self.debug       = debug
  self.about       = about
  if debug then print("\n"..10) end
end

function Super:div(lst)
  local out = {}
  lst = lib.sort(lst, function(x,y) return x[1]<y[1] end)
  self:div1(lst, 1, #lst, self.xs, self.ys, out, 1)
  return out
end

local copy = lib.mopy

function Super:div1(lst,lo,hi,x,y,out,lvl)
  local cut,xr,yr,xl,yl
  local here = {about= self.about,
                x    = {lo   = lst[lo][1], 
                        hi   = lst[hi][1]},
                y    = {ratio= (hi-lo+1)/#lst,
                        var  = y:var()}} 
  self:trace(lst, lo, hi, lvl)
  if lvl <= self.maxDepth and 
     (hi-lo) > 2*self.tooFew 
  then
     cut,xr,yr,xl,yl = self:cut(lst,lo,hi,x,y)
  end
  if cut then
     self:div1(lst,    lo, cut, xl, yl, out, lvl+1)
     self:div1(lst, cut+1,  hi, xr, yr, out, lvl+1) 
  else
     out[#out+1] = here end
end

local function guard(row,g)
   v= row.cell[ g.about.pos ]
   return v >= g.range.lo and v <= g.range.hi 
end

function Super:cut(lst,lo,hi,xr,yr)
  local xr1,yr1,xl1,yl1,cut,best,xl,yl,x,y
  xl,yl = self.num(), self.sym() 
  best  = yr:var()
  for i = lo,hi do
    -- steal from the right, give to the left
    x = xr:sub( xl:add( lst[i][1] ))
    y = yr:sub( yl:add( lst[i][2] ))
    if xl.n >= self.tooFew and -- avoid small splits
       xr.n >= self.tooFew and -- avoid small splits 
       x ~= lst[i+1][1]    and -- cant split on same value
       xr.mu - xl.mu > self.smallEffect and -- too similar?
       yl:xpect(yr)*self.bigger < best --got a better best?
    then
       best,cut = yl:xpect(yr), i
       xr1, xl1 = copy(xr), copy(xl)
       yr1, yl1 = copy(yr), copy(yl) 
    end 
  end 
  return cut, xr1, yr1, xl1, yl1
end

function Super:trace(lst, lo, hi, lvl)
  local f,s
  if self.debug then
    local f = function(z) return lib.f2( lst[z][2] ) end
    s = lo.. ":" ..hi .. " = " .. f(lo) .. ":" .. f(hi)
    print(string.rep("|.. ",lvl-1) ..  s) end
end

return Super
