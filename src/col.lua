--[[

# [Col.lua](../src/col.lua)

Data comes in rows and columns. 
Column contents are summarized in `Cols`.

`Col`s have

- a count `n` of the number of things seen to date
- (optional) a `pos`ition (some integer).
- (optional) a name (stored in `txt`)
    - if that name starts with "`<`" then this column is a goal to be minimized. 
    - If so, this column has a weight `w` of -1.
    - Otherwise it has a weight of 1
-  Also, `Col` can check for anomalies; i.e. if some number has less that an `odd`
   percent chance of belonging to his summary.

Subtypes of `Col` include
[`Num`](num.md) 
and
[`Sym`](sym.md) for numeric and symbolic
columns, respectively.


--]]

local the = require "the"
local Col = the.class()

function Col:_init(txt,pos)
  self.n   = 0  
  self.txt = txt or "" 
  self.pos = pos or 0  
  self.odd = the.data.odd -- defaults to 1%
  self.w = string.find(self.txt,the.ch.less) and -1 or 1
end
-- Method for bulk addition of many items.
function Col:adds(l) 
  for k,v in pairs(l) do self:add(v) end 
  return self
end

return Col
