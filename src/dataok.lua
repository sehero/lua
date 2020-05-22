local the  = require "the"
local lib  = require "lib"
local Sym  = require "sym"
local Num  = require "num"
local Ranges  = require "ranges"
local Sway = require "sway"
local oo   = the.oo
require "ok"

Data=require "data"

ok{some = function (  d,t)
  d = Data()
  d:read(the.csv .. 'weather4.csv')
  t= d.some.x
  assert( t[ 1].txt == "outlook" )
  assert( t[#t].txt == "wind" )
end}

local function clone(  d,t,d1)
  d = Data()
  d:read(the.csv .. 'weather4.csv')
  d1 = d:clone( d.rows )
  assert(d1.cols.all[1].mode == d.cols.all[1].mode) 
  assert(d1.cols.all[2].sd   == d.cols.all[2].sd) 
end

ok{clone=clone}

local function dist1(f,   row1,d,close,far,d1,d2)
  f = f or 'weather4.csv'
  d = Data()
  d:read(the.csv .. f)
  for i=1,10 do
    row1  = lib.any( d.rows )
    close = d:closest( row1, d.some.x) 
    far   = d:furthest(row1, d.some.x) 
    d1    = d:dist(row1,close)
    d2    = d:dist(row1,far)
    --print("")
    --oo(row1.cells)
    --oo(close.cells)
    --oo(far.cells)
    assert(d1 < d2) end
end

ok{dist1b = function() dist1("weather4.csv") end }
ok{dist1b = function() dist1("diabetes.csv") end }

local function strange(f,  d,s,n)
  f = f or 'weather4.csv'
  d = Data():read(the.csv .. f)
  s = 0 
  the.data.odd = 0.01
  local odds = {}
  for _,row in pairs(d.rows) do
     local k = d:klassVal(row)
     --print(k)
     odds[k] = odds[k] or Sym()
     n = d:strange(row) and 1 or 0
     odds[k]:add(n)
  end
  --for k,v in pairs(odds) do
  --    print(k); the.o(v)
  --end
end

ok { strange1 = function() strange() end }
ok { strange2 = function() strange("diabetes.csv") end }

local function super1(f,   tmp,row1,d,close,far,d1,d2)
  d = Data():read(the.csv .. (f or 'weather4.csv'))
  for _,col in pairs(d.cols:some("x")) do
    print("\n---------------\n--",col.txt, "\n")
    local klass = function(z) return d:klassVal(z) end
    for i,range in pairs( col:div(d.rows, klass) ) do
      print(i, range)
    end
  end
end

ok { super2 = function() super1("diabetes.csv") end }

local function opt(f,   tmp,row1,d,close,far,d1,d2)
  print("\n\n====================\n====================")
  d = Data():read(the.csv .. (f or 'auto93.csv'))
  for _,row in pairs( Sway(d):select() ) do 
     row.best = true 
  end
  local ranges =Ranges()
  for _,col in pairs(d.cols:some("x")) do
    local klass = function(z) return z.best end
    ranges:adds( col:div(d.rows, klass) ) 
  end
  for _,range in pairs( ranges:all()) do
     print(range)
  end
end

ok { opt = opt }
--k { super1 = super1 }
