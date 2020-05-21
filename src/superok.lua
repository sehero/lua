local the=require "the"
local lib=require "lib"
local Num=require "num"
local Sym=require "sym"

local profiler = dofile("../test/profiler.lua"  )

require "ok"

local Super = require "super"

ok{ id=function(   s,lst)
  lst = {}
  for i=0,1,0.05 do 
    lst[#lst+1] = {i, i//.3 /10} end
  s = Super(lst,Num,Sym,true)
  s = s:div(lst) 
  the.o(s)
  --for _,xy in pairs(lst) do print(xy[1], xy[2]) end
end }

function super1(   r,s,lst)
  lst = {}
  for i = 1,10^4 do
    r= math.random(100)
    lst[#lst+1]={r,r//30}
  end
  print("")
  s = Super(lst,Num,Sym,"aa",true)
  s = s:div(lst) 
  print("\n-----------------")
  the.o(s)
end 

--profiler.start()
ok{ super=super1}
--profiler.stop()
--profiler.report() -- Optionally give a file name here for this report

