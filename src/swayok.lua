local the = require "the"
local oo  = the.oo
require "ok"

Data= require "data"
Sway = require "sway"

local function some1(  all,best)
  all=Data()
  all:read(the.csv .. 'auto93.csv')
  print("==========")
  best= all:clone( Sway(all):select() )
  print(all:show("y"))
  print(best:show("y"))
end


ok{some = some1}
