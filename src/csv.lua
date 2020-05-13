local the = require "the"
local csv, csvWant, csvTake, select
   
-- Return an iterator that returns all non-blank
-- lines, divided into cells (coerced to numbers,
-- if need be), with all white space and comments removed.
-- Also, 
-- skip over any column whose name starts with `the.ch.skip`
-- character (which defaults to `?`).
-- Example usage:
--   
--     csv = require("csv")
--     
--     for line in csv("data.csv") do
--       print(line)
--     end
--
-- Note that:
--
-- - File processing is incremental (one
--   line at a time) without loading the file into RAM. 
-- - This iterator reads from `file` or, if that is absent,
--   from standard input. 


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


-- ## Support 

-- Determine what we want. 
function csvWant(row,    out,put)
  out, put = {},0
  for get,txt in pairs(row) do
    if string.sub(txt,1,1) ~= the.ch.skip then
      put      = put + 1
      out[put] = get 
  end end
  return out
end

-- Take what we `want`
-- (and while we are here, coerce any 
-- number strings to numbers).
function csvTake(want,row,     out,cell)
  out = {}
  for put,get in pairs(want) do 
    cell     = row[get]
    cell     = tonumber(cell) or cell -- coercian
    out[put] = cell end
  return out
end

-- Low-level function: Split the string `s` on some seperatpr `sep` 
-- (which defaults to ",") into a return list.
function split(s,     sep,out)
  out, sep = {}, sep or ","
  for y in string.gmatch(s, "([^" ..sep.. "]+)") do 
    out[#out+1] = y end
  return out
end

-------------
-- ## Export control 
return csv

-- ## Author 
-- Tim Menzies, April 2020.
