local the = require "the"
require "ok"

local Some=require("some")
local Num=require("num")

local r=math.random
ok {some1 = function (m,t,s)
  t = {9,2,5,4,12,7,8,11,9, 3,7,4,12,5,4,10,9,6,9,4}
  m = Num():adds(t)
  assert(m.mu == 7)
  assert(3.06 < m.sd and m.sd < 3.061)
  s = Some():adds(t)
  near(s:mid(), m.mu)
  near(s:var(), m.sd, 0.075)
  for i=1,100 do 
    s:adds(t) 
  end
  s:all()
  for i=1,#s.kept-1 do 
    assert(s:at(i) <= s:at(i+1)) 
  end
end} 


