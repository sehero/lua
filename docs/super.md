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

local the   = require "the"
local lib   = require "lib"
local Num   = require "num"
local Sym   = require "sym"
local Super = the.class()

function Super:_init(lst, debug)
  print("lst",#lst)
  local cohen      = the.chop.cohen
  self.maxDepth    = the.chop.maxDepth
  self.bigger      = the.chop.bigger
  self.tooFew      = the.chop.tooFew
  self.xs          = Num():adds(lst, 1) 
  self.ys          = Sym():adds(lst, 2)
  self.smallEffect = self.xs:var()*cohen
  self.tooFew      = (#lst)^the.chop.tooFew 
  self.debug       = debug
  if debug then print("\n"..10) end
end

function Super:div(lst)
  local out = {}
  lst = lib.sort(lst, function(x,y) return x[1]<y[1] end)
  self:div1(lst, 1, #lst, self.xs, self.ys, out, 1)
  return out
end

function Super:div1(lst,lo,hi,x,y,out,lvl)
  local cut,xr,yr,xl,yl
  self:trace(lst, lo, hi, lvl)
  if lvl <= self.maxDepth and 
     (hi-lo) > 2*self.tooFew 
  then
     cut,xr,yr,xl,yl = self:cut(lst,lo,hi,x,y)
  end
  if cut then
     self:div1(lst,    lo, cut, xl, yl, out, lvl+1)
     self:div1(lst, cut+1,  hi, xr, yr, out, lvl+1) 
  else
     if hi < #lst then
       out[#out+1] = lst[hi][1] end end
end

function Super:cut(lst,lo,hi,xr,yr)
  local xr1,yr1,xl1,yl1,cut,best,xl,yl,x,y
  local c = lib.mopy
  xl,yl = Num(), Sym() 
  best  = yr:var()
  for i = lo,hi do
    -- steal from the right, give to the left
    x = xr:sub( xl:add( lst[i][1] ))
    y = yr:sub( yl:add( lst[i][2] ))
    if xl.n >= self.tooFew and -- avoid small splits
       xr.n >= self.tooFew and -- avoid small splits 
       x ~= lst[i+1][1]    and -- cant split on same value
       xr.mu - xl.mu > self.smallEffect and -- too similar?
       yl:xpect(yr)*self.bigger < best -- got a better best?
    then
       best,cut = yl:xpect(yr), i
       xr1, xl1, yr1, yl1 = c(xr), c(xl), c(yr), c(yl) end
  end 
  return cut, xr1, yr1, xl1, yl1
end

function Super:trace(lst, lo, hi, lvl)
  local f,s
  if self.debug then
    local f = function(z) return lib.f2( lst[z][2] ) end
    s = lo.. ":" ..hi .. " = " .. f(lo) .. ":" .. f(hi)
    print(string.rep("|.. ",lvl-1) ..  s) end
end

return Super

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

