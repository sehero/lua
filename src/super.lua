Super = the.class()

function Super:_init(a,pause)
  cohen    = the.chop.cohen
  self.min = the.chop.min
  self.max = the.chop.max
  self.big = the.chop.bigger
  self.eps = the.chop.epsilon
  self.xs  = Num():adds(a, function(z) return z[1] end)
  self.ys  = Sym():adds(a, function(z) return z[2] end)
  self.tiny= self.ys.sd*cohen
  self.min = (#xy)^self.min 
  self.lst = lib.sort(a, function(x,y) return x[1]<y[1] end)
end

function Super:div(lst,lo,hi,x,y,out,lvl)
  local cut,xr,yr,xl,yl
  if   lvl <= self.max and 
       hi-lo > 2*self.min 
  then cut,xr,yr,xl,yl = self:cut(lst,lo,hi,x,y)
  end
  if cut then
    self:div(lst, lo,   cut, xl, yl, lvl+1)
    self:div(lst, cut+1, hi, xr, yr, lvl+1) 
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
  for i,xy in pairs(lst) do
    -- steal from the right, give to the left
    x = xr:sub( xl:add( xy[1] ))
    y = yr:sub( yl:add( xy[2] ))
    if xl.n >= self.min and -- avoid splits of small size
       xr.n >= self.min and -- avoid splits of small size
       x ~= lst[i+1][1] and -- cant split on same value
       xr.mu - xl.mu > self.tiny and -- ignore tiny deltas
       yl:xpect(yr)*bigger < best    -- found a better best?
    then
       best,cut = yl:xpect(yr), i
       xr1,yr1  = copy2(xr, yr)          
       xl1,yl1  = copy2(xl, yl) end 
  end 
  return cut, xr1, yr1, xl1, yl1
end

return Super
