<a class=sehero name=top> 
<img align=right width=280 src="doc/etc/img/spiderman.png">
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
local the   = require "the"
local bchop = require("lib").bchop
local Some  = the.class(require "col")

function Some:_init(txt,pos)
  self:super(txt,pos)
  self.kept   = {}
  self.max    = the.some.max
  self.magic  = the.some.magic
  self.sorted = false
end

function Some:add(x)
  if x ~= the.ch.skip then
    self.n = self.n + 1
    x = tonumber(x)
    if #self.kept < self.max then
      self.sorted = false
      self.kept[ #self.kept + 1 ] = x
    elseif math.random() < self.max/self.n then
      self:all()[ bchop(self.kept, x) ] = x end 
   end
   return x
end

function Some:show() 
  return (self.w<0 and"<"or">")..tostring(self:mid()) end

function Some:__tostring()
  return string.format("Some(%s,%s)", 
                       self:mid(), self:iqr()) end

function Some:at(i)    
  return self:all()[i // 1] end

function Some:mid(j,k) 
  return self:per(.5,j,k) end

function Some:strange(x,    n)
  n = self:norm(x)
  return n <= self.odd or n >= 1-self.odd end

function Some:norm(x)  
  return bchop( self:all(), x) / #self.has end

function Some:iqr(j,k) 
  return self:per(.75,j,k) - self:per(.25,j,k) end

function Some:var(j,k) 
  return (self:per(.9,j,k) - self:per(.1,j,k))/self.magic end

function Some:per(p,j,k)
  j = j or 1
  k = k or #self.kept
  return  self:at( j + p*(k-j) )
end

function Some:all()
  if not self.sorted then table.sort(self.kept) end
  self.sorted = true
  return self.kept
end

return Some 

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

