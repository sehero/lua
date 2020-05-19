Super = the.class()

function Super:_init(lst,pause)
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

function Super:div(lst,lo,hi,x,y,out)
  local cut,xr,yr,xl,yl = self:cut(lst,lo,hi,x,y)
  if cut then
    self:div(lst,lo, cut,xl,yl)
    self:div(lst,lo+1,hi,xr,yr)
  else
    -- coffee script bounds
    out[#out+1] = lst[hi][1]
  end
end

function Super:cut(lst,lo,hi,xr,yr)
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
      xl1,yl1  = lib.copy(xl), lib.copy(yl) end 
  end 
  return cut, xr1, yr1, xl1, yl1
end


