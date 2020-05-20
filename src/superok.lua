local the=require "the"
local lib=require "lib"
require "ok"

local Super = require "super"

ok{ id=function(   s,lst)
  lst = {}
  for i=0,1,0.05 do 
    lst[#lst+1] = {i, i//.3 /10} end
  s = Super(lst,true)
  s = s:div(lst) 
  the.o(s)
  for _,xy in pairs(lst) do
    print(xy[1], xy[2]) end
end }

ok{ id=function(   r,s,lst)
  lst = {}
  for i=1,1000 do
    r= math.random()
    lst[#lst+1]={r,r}
  end
  s = Super(lst,true)
  s = s:div(lst) 
  the.o(s)
  --for _,xy in pairs(lst) do
    --print(lib.f4(xy[1]), lib.f4(xy[2])) end
end }
