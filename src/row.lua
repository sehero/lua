local the = require "the"
local Row = the.class()

function Row:_init(cells) 
  self.dom = 0
  self.best = false
  self.cells = cells 
end
  
function Row:dist(other,cols,p,    n,d,x,y,d0) 
  p=p or the.dist.p
  n,d = 0,0
  for pos,col in pairs(cols) do
    n = n +1
    x = self.cells[pos]
    y = other.cells[pos]
    d0= col:dist(x,y)
    d = d + d0^p
  end
  return (d / n) ^ (1/p)
end

function Row:dominates(other,cols,    s1,s2,n,x,y,x1,y1)
   s1,s2,n =  0,0,#cols
   for pos,col in pairs(cols) do
     x  = self.cells[pos]
     y  = other.cells[pos]
     x1 = col:norm(x)
     y1 = col:norm(y)
     s1 = s1 - 10^(col.w*(x1-y1)/n)
     s2 = s2 - 10^(col.w*(y1-x1)/n)
   end
  return s1/n < s2/n 
end

return Row
