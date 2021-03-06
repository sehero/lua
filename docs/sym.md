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
local Sym = the.class(require "col")

function Sym:_init(txt,pos)
  self:super(txt,pos)
  self.counts = {}
  self.most   = 0
  self.mode   = nil
  self._ent   = nil 
  self.nk     = 0
end

function Sym:__tostring()
  return string.format("Sym(%s,%s,%s)", 
                       self.txt,self.mode, self.most) end

function Sym:mid()  return self.mode end
function Sym:var()  return self:ent() end
function Sym:show() return self:mid() end

function Sym:add (x,     seen)
  if x ~= the.ch.skip then 
    self._ent = nil 
    self.n    = self.n + 1
    if not self.counts[x] then
      self.counts[x] = 0 
      self.nk = self.nk + 1
    end
    seen = self.counts[x] + 1
    self.counts[x] = seen 
    if seen > self.most then
      self.most, self.mode = seen, x end 
  end
  return x
end

function Sym:sub (x,     seen,n)
  if x ~= the.ch.skip then 
    n = self.counts[x]
    if n and n > 0 then
      self.n    = self.n - 1
      self._ent = nil 
      self.counts[x] = self.counts[x] - 1 end 
  end
  return x
end

function Sym:strange(x)
  return (self.counts[x] or 0) / self.n < self.odd
end

function Sym:ent(    e,p)
  if self._ent == nil then 
    e = 0
    for _,f in pairs(self.counts) do
      if f > 0 then
        p = f/self.n
        e = e - p* math.log(p,2) end end
    self._ent = e 
  end
  return self._ent 
end

function Sym:dist(x,y)
  if x == the.ch.skip and y == the.ch.skip then
    return 1
  else
    return x==y and 0 or 1 end
end

function Sym:div(rows,y,    t,syms,x,yval,lt,z)
  t, syms = {}, {}
  for _,row in pairs(rows) do
    x    = row.cells[ self.pos ]
    yval = y(row)
    if x ~= the.ch.skip then 
      if not syms[x] then
        syms[x]= {about= self,
                  x    = {lo=x, hi=x},
                  y    = {ratio=0, var=0, stats=Sym()}}
        t[ #t+1 ] = syms[x]
      end
      syms[x].y.stats:add( yval ) end 
  end
  for _,here in pairs(t) do
    local stats  = here.y.stats
    here.y.var   = stats:var()
    here.y.ratio = stats.n/#rows
  end
  return t
end

return Sym

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

