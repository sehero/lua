local the  = require "the"
local lib  = require("lib")
local Num  = require("num")
local Sym  = require("sym")
local Cols = the.class()

-- `Cols` is a place to store summaries 
-- of `Num`s or `Sym` columns.
function Cols:_init(t,   col) 
  self.all = {}
  for k,v in pairs(t) do
    col = self:num(v) and Num or Sym
    self.all[k] = col(v,k) end
end

function Cols:show(x, t)
  the.o(self.all[x])
  return the.ooo(lib.map(self.all[x],
              function (z) return z:show() end))
end

function Cols:add(t) 
  for k,v in pairs(t) do 
     self.all[k]:add(v) end 
end

function Cols:some(f,   g,h) 
  g = getmetatable(self)[f]
  h = (function (col) return g(self, col.txt) end)
  return lib.select(self.all, h)
end

local function c(s,k) return string.sub(s,1,1)==the.ch[k] end

function Cols:klass(x) return c(x,"klass") end 
function Cols:goal(x)  return c(x,"less") or c(x,"more") end
function Cols:num(x)   return c(x,"num") or self:goal(x) end
function Cols:y(x)     return self:klass(x) or self:goal(x) end
function Cols:x(x)     return not self:y(x)   end
function Cols:sym(x)   return not self:num(x) end

return Cols
