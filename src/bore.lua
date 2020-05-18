local the=  require "the"
local id =  require("lib").id
local Bore= the.class()
local Sway= require "sway"

function Bore:_init(data)
  local best = data:clone( Sway(data):select() )
  local enough = 3*#best / (#data.rows - #best) 
  local rest = data:clone()
  for _,row in pairs(data.rows) do
    if not best.has[ id(row) ] then
      if best:strange(row, best.some.y) then
        if math.random() > enough then
           rest:add(row) end
      else
        best:add(row) end end end
  print(#data.rows, #best.rows, #rest.rows)
end
  
return Bore
