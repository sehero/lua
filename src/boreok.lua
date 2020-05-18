local the = require "the"
local oo  = the.oo
local Data  = require "data"
require "ok"

local Bore = require "bore"

local function bore1(  all,bore)
  all=Data()
  all:read(the.csv .. 'auto93.csv')
  Bore(all)
end


ok{bore = bore1}
