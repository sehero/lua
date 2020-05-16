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

# [Col.lua](../src/col.lua)

Data comes in rows and columns. 
Column contents are summarized in `Cols`.

`Col`s have

- a count `n` of the number of things seen to date
- (optional) a `pos`ition (some integer).
- (optional) a name (stored in `txt`)
    - if that name starts with `<` then this column is a goal to be minimized. 
    - If so, this column has a weight `w` of -1.
    - Otherwise it has a weight of 1
-  Also, `Col` can check for anomalies; i.e. if some number has less that an `odd`
   percent chance of belonging to his summary.

Subtypes of `Col` include
[`Num`](num.md) 
and
[`Sym`](sym.md) for numeric and symbolic
columns, respectively.


```lua

local the = require "the"
local Col = the.class()

function Col:_init(txt,pos)
  self.n   = 0  
  self.txt = txt or "" 
  self.pos = pos or 0  
  self.w   = string.find(self.txt, the.ch.less) and -1 or 1
  self.odd = the.data.odd -- defaults to 1%
end

```
Method for bulk addition of many items.
```lua

function Col:adds(l) 
  for k,v in pairs(l) do self:add(v) end 
  return self
end

return Col
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

