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
local lib  = require("lib")
local Num  = require("num")
local Sym  = require("sym")
local Cols = the.class()

```
`Cols` is a place to store summaries 
of `Num`s or `Sym` columns.
```lua
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

