require "ok"

local lib = require "lib"

ok{ any=function(   a,x)
  a={1,2,3,4,5,6,7,8,9,10}
  for i=1,1000 do
    x=lib.any(a)
    assert(x>=a[1] and x<=a[#a])
  end 
end}

ok{ map=function(  t)
  t= {1,2,3,4}
  t=lib.map({1,2,3,4},
            function (x) return x/2 end)
  assert(t[1] == 0.5 and t[#t]==2)
end}

ok{ copy=function(  t,u)
  t= {1,{2,3},4,{{6,7},8}}
  u = lib.copy(t)
  t[4][1][2]  = 100
  assert( 100 ~=  u[4][1][2] )
end}

ok{ sort=function(   t)
  t = {10, 2, 100, 3, -100, 20, 1}
  t = lib.sort(t)
  assert(t[1]  == -100)
  assert(t[#t] ==  100)
  t = lib.sort(t, function(x,y) return x>y end)
  assert(t[1]  ==  100)
  assert(t[#t] == -100)
  t = {{x=100,y=100}, {x=1,y=100},{x=10,y=100}}
  t = lib.sort(t,"x")
  assert(t[1].x == 1)
end}

ok{rpad=function()
  assert(lib.rpad("23",4) == "23  ") end}

ok{rpad=function()
  assert(lib.rpad("23",4) == "23  ") end}

ok{split=function(t)
  t = lib.split("10,20,30,40")
  assert(t[1]  == "10")
  assert(t[#t] == "40")
  assert(#t == 4) 
end}

ok{reject = function(t)
  t = {10,5,20,3}
  t = lib.reject(t, function(z) return z<10 end)
  assert(t[1] == 10)
  assert(t[2] == 20)
end}

ok{ cache = function ( u,n)
  n=0
  u=lib.cache(function(x) n=n+1; return x/2 end)
  for i=1,10 do lib.same(u[i]) end
  for i=1,10 do lib.same(u[i]) end
  for i=1,10 do lib.same(u[i]) end
  assert( n == 10 )
end}
