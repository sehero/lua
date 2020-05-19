local the=  require "the"
local Data= require "data"

local Tree     = the.class()

function Tree:_init(data,cols)
  self.all  = data
  self.cols = cols or data.cols
  self.min = the.tree.min
  self.maxDepth = the.tree.maxDepth
  self.debug=false
   
function Tree:split(rows,up, best)
  if #rows <= self.min*2 then return self end




return Tree
