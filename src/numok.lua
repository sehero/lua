local the = require "the"
require "ok"

local Num=require("num")

ok {sd1 = function (m)
  m = Num():adds {9,2,5, 4,12,7, 8,11,9,
                  3,7,4,12, 5,4,10,9,6,9,4}
  assert(m.mu == 7)
  assert(3.06 < m.sd and m.sd < 3.061)
end} 

ok { step = function (   n,t,v)
  t,v = {},{}
  n   = Num()
  math.randomseed(1)
  for i = 1,100 do t[#t+1] = math.random() end
  for i = 1,100 do
    n:add( t[i] )
    v[i] = n:var()
  end
  for i = 100,1,-1 do
    near( v[i],  n:var() )
    n:sub( t[i] )
  end
end}


ok { z = function(e )
    e = 0.005
    near(0      , Num.z(-10, 0, 1))
    near(0.1635 , Num.z( -1, 0, 1),e)
    near(0.5    , Num.z(  0, 0, 1),e)
    near(0.846  , Num.z(  1, 0, 1),e)
    near(0.9772 , Num.z(  2, 0, 1),e)
    near(1      , Num.z( 10, 0, 1),e)
end }
