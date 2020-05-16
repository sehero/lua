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
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/sehero/lua"><img 
src="https://travis-ci.org/sehero/lua.svg?branch=master"></a>
<a href="https://zenodo.org/badge/latestdoi/263210595"><img src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a></p>
local the = require "the"
local csv, csvWant, csvTake, select
   
```
Return an iterator that returns all non-blank
lines, divided into cells (coerced to numbers,
if need be), with all white space and comments removed.
Also, 
skip over any column whose name starts with `the.ch.skip`
character (which defaults to `?`).
Example usage:
  
    csv = require("csv")
    
    for line in csv("data.csv") do
      print(line)
    end
```lua
--
```
Note that:
```lua
--
```
- File processing is incremental (one
  line at a time) without loading the file into RAM. 
- This iterator reads from `file` or, if that is absent,
  from standard input. 
```lua


function csv(file,     want,stream,tmp,row)
  stream = file and io.input(file) or io.input()
  tmp    = io.read()
  return function()
    if tmp then
      tmp = tmp:gsub("[\t\r ]*","") -- no whitespace
      row = split(tmp)
      tmp = io.read()
      if #row > 0 then 
        want = want or csvWant(row) -- only do first time
        return csvTake(want,row) 
      end
    else
      io.close(stream) end end   
end


```
## Support 
```lua

```
Determine what we want. 
```lua
function csvWant(row,    out,put)
  out, put = {},0
  for get,txt in pairs(row) do
    if string.sub(txt,1,1) ~= the.ch.skip then
      put      = put + 1
      out[put] = get 
  end end
  return out
end

```
Take what we `want`
(and while we are here, coerce any 
number strings to numbers).
```lua
function csvTake(want,row,     out,cell)
  out = {}
  for put,get in pairs(want) do 
    cell     = row[get]
    cell     = tonumber(cell) or cell -- coercian
    out[put] = cell end
  return out
end

```
Low-level function: Split the string `s` on some seperatpr `sep` 
(which defaults to ",") into a return list.
```lua
function split(s,     sep,out)
  out, sep = {}, sep or ","
  for y in string.gmatch(s, "([^" ..sep.. "]+)") do 
    out[#out+1] = y end
  return out
end

-------------
```
## Export control 
```lua
return csv

```
## Author 
Tim Menzies, April 2020.

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

