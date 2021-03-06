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

local function o(t,pre,    indent,fmt)
  pre=pre or ""
  indent = indent or 0
  if indent < 10 then
    for k, v in pairs(t) do
      if not (type(k)=='string' and k:match("^_")) then
        fmt = pre .. string.rep("|  ", indent) .. k .. ": "
        if type(v) == "table" then
          print(fmt)
          o(v, pre, indent+1)
        else
          print(fmt .. tostring(v)) end end end end
end

return {
  o    =  o,
  oo   =  (function (t) print(table.concat(t,", ")) end),
  ooo  =  (function (t) return table.concat(t,", ") end),
  class=  require("ml").class,
  csv  =  "../test/data/raw/",
  ignore= "?",
  sep=    ",",
  tiny=   1/math.maxinteger,
  fmap=   { n   = 128,
            far = .9,
            min = .5
          },
  data =  { p      = 2,
             sample = 128,
             odd    = .01,
             data   = .5,
             far    = .9},
  rand=   { seed = 1}, 
  ok=     { pass= 0, 
            fail= 0},
  ch=     { klass= "!",
            less = "<",
            more = ">",
            skip = "?",
            num  = "$",
            sym  = ":"
          },
  some =  { max  = 256,
            magic = 2.564},
  sample= { b      = 200,
            most   = 512,
            epsilon= 1.01,
            fmtstr = "%20s",
            fmtnum = "%5.3f",
            cliffs = .147
            -- cliff's small,medium,large = .147,.33,.474
            },
  tree=   { min = 4},
  nb =    { k=1,m=2},
  chop=   { bigger   = 1.05,
            tooFew   = 0.5,
            maxDepth = 1,
            cohen = .3},
  num=    { conf  = 95,
            small = .38, -- small,medium = 0.38,1
            first = 3, 
            last  = 96,
            criticals = { -- Critical values for ttest
              [95] = {[ 3]=3.182,[ 6]=2.447,[12]=2.179,
                      [24]=2.064,[48]=2.011,[96]=1.985},
              [99] = {[ 3]=5.841,[ 6]=3.707,[12]=3.055,
                      [24]=2.797,[48]=2.682,[96]=2.625}}}
} 

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

