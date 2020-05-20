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
  chop=   { m = .5,
            epsilon  =  .05,
            bigger   = 1.05,
            tooFew   = 10,
            min      = .5,
            maxDepth = 10,
            cohen = .2},
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
