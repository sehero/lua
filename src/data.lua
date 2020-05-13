local the = require "the"
local lib  = require "lib"
local csv  = require "csv"
local Row  = require "row"
local Cols = require "cols"
local Data = the.class()

-- `Data` stores `rows` as well as `cols` that summarize the
-- columns of that rows.
--------- --------- -------- ---------- ---------  ---------  
-- ## Creation and Updates

function Data:_init(head)
  self.p       = the.data.p 
  self.rows    = {}
  self.cols    = nil
  self.samples = the.data.samples
  self.some    = lib.cache(function (k)
                     return  self.cols:some(k) end)
  if head then self:header(head) end
end
function Data:show(x, t)
  return the.ooo(lib.map(self.some[x],
              function (z) return z:show() end))
end


function Data:header(t) 
  self.cols = Cols(t) 
end

function Data:add(t,   row)
  row = t.cells and t or Row(t) 
  self.cols:add(row.cells)
  self.rows[#self.rows+1] = row
end

function Data:read(f)
  for row in csv(f) do
    if   self.cols 
    then self:add(row) 
    else self:header(row) end end
end

function Data:clone(rows,  clone)
  clone = Data( 
         lib.map(self.cols.all, 
                 function (z) return z.txt end))
  if rows then
    for j,row in pairs(rows) do 
      clone:add(row) end 

  end
  return clone
end

--------- --------- -------- ---------- ---------  ---------  
-- ## Querying
-- Get klass columm.
function Data:klass() 
  return self.some.klass[1] end

-- Get klass value from a row.
function Data:klassVal(row) 
  local klass=self:klass()
  return row.cells[klass.pos]
end

--------- --------- -------- ---------- ---------  ---------  
-- ## Domination

function Data:doms(cols)
  for _,row in pairs(self.rows) do
    row.dom = 0
    for i = 1,self.samples do
      if row:dominates( lib.any(self.rows), cols) then
        row.dom = row.dom + 1/self.samples end end end
end

--------- --------- -------- ---------- ---------  ---------  
-- ## Distances
-- Get the `dist` between two rows.
function Data:dist(r1,r2,cols,p,   n,d,d0,x,y)
  d,n  = 0,the.tiny
  p    = p or self.p or the.data.p
  cols = cols or self.some.x
  for _,c in pairs(cols) do
    n  = n+1
    d0 = c:dist( r1.cells[c.pos], r2.cells[c.pos] )
    d  = d + d0^self.p
  end
  return  (d/n)^self.p
end

function Data:near(r,cols,rows,   f)
  f= (function (s) 
        return {dist=self:dist(r,s,cols), row=s} end)
  return lib.sort(lib.map(rows,f), "dist")
end

-- Find a row that is closest to me.
function Data:closest(row,cols,  t) 
  t= self:near(row, cols, self.rows)
  return t[2].row
end

-- Find a row that is most far away from `row`.
function Data:furthest(row, cols,  t) 
  t= self:near(row, cols, self.rows)
  return t[#t].row
end

-- Find a row that is, say, `f=90%` away from `row`. 
function Data:distant(row,cols,rows,f,   t)
  t= self:near(row, cols, self.rows)
  return t[ math.floor((#t)*f) ].row
end

return Data
