local the = require "the"
local lib = require "lib"
local oo  = the.oo
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

