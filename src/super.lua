Super = the.class()

function Super:_init(lst,pause)
  cohen     = the.chop.cohen
  self.eps  = the.chop.epsilon
  self.big  = the.chop.bigger
  self.min  = the.chop.min
  self.xs = Num()
  self.ys = Sym()
  for _,xy in pairs(lst) do 
    self.xs:add(xy[1]) 
    self.ys:add(xy[2]) 
  end
  self.tiny = self.ys.sd*cohen
  self.min  = (#xy)^self.min 
  self.lst  = lib.sort(lst, function (x,y) return x[1] < y[1] end)
end

function Super:div(lst,lo,hi,x,y,out)
  local cut,xr,yr,xl,yl = self:cut(lst,lo,hi,x,y)
  if cut then
    self:div(lst, lo,   cut, xl, yl)
    self:div(lst, cut+1, hi, xr, yr)
  else
    if hi < #lst then
      out[#out+1] = lst[hi][1] end end
end

local function copy2(x,y) return lib.copy(x), lib.copy(y) end

function Super:cut(lst,lo,hi,xr,yr)
  local xr1,yr1,xl1,yl1,cut,best,xl,yl,x,y
  if hi-lo < 2*self.min then return nil end
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
