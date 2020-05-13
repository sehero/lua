local the = require "the"
local Col = the.class()

function Col:_init(txt,pos)
  self.txt = txt or ""
  self.pos = pos or 0
  self.w   = string.find(self.txt, the.ch.less) and -1 or 1
  self.n   = 0
end

function Col:adds(l) 
  for k,v in pairs(l) do self:add(v) end 
  return self
end

return Col
