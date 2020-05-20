<p> <a
href="https://github.com/sehero/lua/blob/master/LICENSE">license</a> :: <a
href="https://github.com/sehero/lua/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/sehero/lua/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/sehero/lua/issues">issues</a> :: <a
href="https://github.com/sehero/lua/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/sehero/lua/blob/master/CONTACT.md#top">contact</a> </p><p> 
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-lua-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/sehero/lua"><img 
src="https://travis-ci.org/sehero/lua.svg?branch=master"></a>
<a href="https://zenodo.org/badge/latestdoi/263210595"><img src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a>
<a href='https://coveralls.io/github/sehero/lua?branch=master'><img src='https://coveralls.io/repos/github/sehero/lua/badge.svg?branch=master' alt='Coverage Status' /></a></p>

local the = require "the"
local lib = require "lib"
local Num = the.class(require "col")

function Num:_init(txt,pos)
  self:super(txt,pos)
  self.mu  = 0
  self.m2  = 0
  self.sd  = 0
  self.hi  = math.mininteger
  self.lo  = math.maxinteger
end


function Num:mid()  return self.mu end
function Num:var()  return self.sd end
function Num:show() 
  return (self.w<0 and"<"or">")..self:mid() end

function Num:__tostring()
  return string.format("Num(%s,%s)", self.mu, self.sd)
end

function Num:add (x,    d)
  if x ~= the.ch.skip then 
    self.n  = self.n + 1
    x       = tonumber(x)
    d       = x - self.mu
    self.mu = self.mu + d / self.n
    self.m2 = self.m2 + d * (x - self.mu) 
    self.lo = math.min(x, self.lo)
    self.hi = math.max(x, self.hi)
    self.sd = self:sd0()
  end
  return x
end

function Num:sub (x,     d)
  if x ~= the.ch.skip then 
    self.n  = self.n - 1
    x       = tonumber(x)
    d       = x - self.mu
    self.mu = self.mu - d / self.n
    self.m2 = self.m2 - d * (x - self.mu) 
    self.sd = self:sd0()
  end
  return x
end

function Num:sd0()
  if self.n  < 2 then return 0 end
  if self.m2 < 0 then return 0 end
  return (self.m2 / (self.n - 1))^0.5 
end

function Num:dist(x,y)
  if x == the.ch.skip and y == the.ch.skip then
    return 1
  elseif x == the.ch.skip then
    y = self:norm(y)
    x = y < 0.5 and 1 or 0
  elseif y == the.ch.skip then 
    x = self:norm(x)
    y = x < 0.5 and 1 or 0
  else 
    x,y = self:norm(x), self:norm(y)
  end
  return math.abs(x - y)
end

function Num:norm(x)
  if x ~= the.ch.skip then
    x= (x - self.lo) / (self.hi - self.lo + the.tiny)
  end
  return x
end

function Num:strange(x,  z)
  z = Num.z(x, self.mu, self.sd) 
  return z< self.odd or z >= 1-self.odd
end

```
---------------------------
## Z-curve
The `z-curve` is a normal curve with mean of 0 and  standard 
deviation of 1. To convery any normal curve into a `z-curve`
then subtract `mu` and divide by `sd`.
```lua

```
For the same of effeciency, Pre-compute and cache the area under
 the normal curve from -4\*`sd` to +4\*`sd` (why this
range? Well, outside of that range, the y-value of
the normal curve is effectively zero).
```lua

do
  local zs = {0}  -- zs[1] = 0
  local zn = 512  -- cache "zn" number of entries
  local dx = 8/zn -- generated from -4 to 4
  for i  = 2,zn do -- accumulate the area
    zs[i] = zs[i-1] + dx*lib.norm( -4+i*dx, 0,1)  end

  function Num.z(x,mu,sd,     i)
    -- convect to a z-curve, find `x`'s place in that curve
    i = (((x - mu)/sd  - -4) / 8 * zn) // 1
    if     i > zn then return 1 
    elseif i < 1  then return 0 
    else          return zs[i] end end
end

function Num:like(x,   z,denom,num)
  return lib.norm(x, self.mu, self.sd)
end

```
function Num:splitter(rows,y)
  t, xy = {}, {}
  yall = Sym(self.txt)
  for _,row in pairs(rows) do
     x = row.cells[self.pos]
    if x ~= the.ch.skip then 
      xy[ #xy+1 ] = {x, y(row) }
      yall:add( y(row) ) end
  end
  min = yall.n^min
  xy  = lib.sort(xy,lt) 
  out = {}
  split(out, 1,#xy,yall,{
end

```lua

return Num
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

