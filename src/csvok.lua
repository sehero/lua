local the = require "the"
require "ok"

local csv=require("csv")

ok {csv = function (m)
  m=0
  for line in csv(the.csv .. 'weather4.csv') do
    m = m + #line
  end
  assert(m==60)
end} 
