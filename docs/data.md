<a class=sehero name=top> 
<img align=right width=280 src="https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/2c218305-10f7-4dc5-b98c-8944ea7c6b98/d92z77z-85f30213-a950-43e6-93aa-ca906c6b4aac.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvMmMyMTgzMDUtMTBmNy00ZGM1LWI5OGMtODk0NGVhN2M2Yjk4XC9kOTJ6Nzd6LTg1ZjMwMjEzLWE5NTAtNDNlNi05M2FhLWNhOTA2YzZiNGFhYy5qcGcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.BY_xZ9vtOug8jM-lzpvybhtGb2rItxHbWs1sDGlNEAY">
<h1><a href="/README.md#top">SE for super heroes: an AI approach</a></h1> 
<p> <a
href="https://github.com/sehero/lua/blob/master/LICENSE">license</a> :: <a
href="https://github.com/sehero/lua/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/sehero/lua/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/sehero/lua/issues">issues</a> :: <a
href="https://github.com/sehero/lua/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/sehero/lua/blob/master/CONTACT.md#top">contact</a> </p><p> 
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-lua-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet"><br>
<a href="https://zenodo.org/badge/latestdoi/263210595"><img src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a><br>
<img src="https://img.shields.io/badge/platform-mac,*nux-informational"><br>
<a href="https://travis-ci.org/github/sehero/lua"><img 
src="https://travis-ci.org/sehero/lua.svg?branch=master"></a><br>  
</p>
local the = require "the"
local lib  = require "lib"
local csv  = require "csv"
local Row  = require "row"
local Cols = require "cols"
local Data = the.class()

```
`Data` stores `rows` as well as `cols` that summarize the
columns of that rows.
```lua
--------- --------- -------- ---------- ---------  ---------  
```
## Creation and Updates
```lua

function Data:_init(head)
  self.p       = the.data.p 
  self.rows    = {}
  self.cols    = nil
  self.samples = the.data.samples
  self.some    = lib.cache(function (k)
                     return  self.cols:some(k) end)
  if head then self:header(head) end
end
function Data:show(x, t)
  return the.ooo(lib.map(self.some[x],
              function (z) return z:show() end))
end


function Data:header(t) 
  self.cols = Cols(t) 
end

function Data:add(t,   row)
  row = t.cells and t or Row(t) 
  self.cols:add(row.cells)
  self.rows[#self.rows+1] = row
end

function Data:read(f)
  for row in csv(f) do
    if   self.cols 
    then self:add(row) 
    else self:header(row) end end
  return self
end

function Data:clone(rows,  clone)
  clone = Data( 
         lib.map(self.cols.all, 
                 function (z) return z.txt end))
  if rows then
    for j,row in pairs(rows) do 
      clone:add(row) end 

  end
  return clone
end

--------- --------- -------- ---------- ---------  ---------  
```
## Querying
Get klass columm.
```lua
function Data:klass() 
  return self.some.klass[1] end

```
Get klass value from a row.
```lua
function Data:klassVal(row) 
  local klass=self:klass()
  return row.cells[klass.pos]
end

--------- --------- -------- ---------- ---------  ---------  
```
## Domination
```lua

function Data:doms(cols)
  for _,row in pairs(self.rows) do
    row.dom = 0
    for i = 1,self.samples do
      if row:dominates( lib.any(self.rows), cols) then
        row.dom = row.dom + 1/self.samples end end end
end

--------- --------- -------- ---------- ---------  ---------  
```
## Distances
Get the `dist` between two rows.
```lua
function Data:dist(r1,r2,cols,p,   n,d,d0,x,y)
  d,n  = 0,the.tiny
  p    = p or self.p or the.data.p
  cols = cols or self.some.x
  for _,c in pairs(cols) do
    n  = n+1
    d0 = c:dist( r1.cells[c.pos], r2.cells[c.pos] )
    d  = d + d0^self.p
  end
  return  (d/n)^self.p
end

function Data:near(r,cols,rows,   f)
  f= (function (s) 
        return {dist=self:dist(r,s,cols), row=s} end)
  return lib.sort(lib.map(rows,f), "dist")
end

```
Find a row that is closest to me.
```lua
function Data:closest(row,cols,  t) 
  t= self:near(row, cols, self.rows)
  return t[2].row
end

```
Find a row that is most far away from `row`.
```lua
function Data:furthest(row, cols,  t) 
  t= self:near(row, cols, self.rows)
  return t[#t].row
end

```
Find a row that is, say, `f=90%` away from `row`. 
```lua
function Data:distant(row,cols,rows,f,   t)
  t= self:near(row, cols, self.rows)
  return t[ math.floor((#t)*f) ].row
end

function Data:strange(row,cols)
  cols = cols or self.some.x
  for _,col in pairs(cols) do
    if col:strange(row.cells[col.pos]) then return true end
  end
  return false
end

return Data
```


## Copyright

(c) 2020, Tim Menzies

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

