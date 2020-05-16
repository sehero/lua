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
local the  = require "the"
local lib  = require "lib"
local Sway = the.class()

function Sway:_init(data)
  self.n     = the.fmap.n
  self.far   = the.fmap.far
  self.min   = math.floor((#data.rows)^the.fmap.min)

  self.data  = data 
  self.cols  = data.some.y
  self.debug = false
end 

function Sway:select(rows, lvl)
  rows = rows or self.data.rows
  lvl  = lvl or 0
  if self.debug then 
    print( #rows, self.min, string.rep("|.. ",lvl))  
  end
  if   #rows < 2*self.min 
  then return rows
  else
    local mu,up,f,tmp
    mu,up = self:project(rows)
    f     = function(r) return (up     and r.x >= mu) or 
                                (not up and r.x <  mu) end
    tmp   = lib.select(rows,f)
    if #tmp < #rows then 
      return self:select(tmp, lvl+1) end end 
end

function Sway:project(rows)
  local some,any,west,east,a,b,c,x,sum
  some = lib.anys(rows, self.n)
  any  = lib.any(some)
  west = self:distant(any,  some)
  east = self:distant(west, some)
  c    = self:dist(west, east)
  sum  = 0
  for _,row in pairs(rows) do
    a     = self:dist(row, west)
    b     = self:dist(row, east)
    x     = (a^2 + c^2 - b^2) / (2*c)
    row.x = math.max(0, math.min(1, x))
    sum   = sum + row.x
  end
  return sum/#rows, west:dominates(east, self.cols)
end

function Sway:distant(r,some)
  return self.data:distant(r, self.cols, some, self.far) end 

function Sway:dist(r1,r2)
  return self.data:dist(r1, r2, self.cols) end

return Sway

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

