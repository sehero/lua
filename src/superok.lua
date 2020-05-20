local the=require "the"
require "ok"

local Super = require "super"

ok{ id=function(   s,lst)
  lst = {}
  for i=0,1,0.05 do 
    lst[#lst+1] = {i, i//.3 /10} end
  s = Super(lst,true)
  the.o(s)
  --s= s:div(lst) 
  --the.o(s)
end }
