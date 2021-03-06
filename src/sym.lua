local the = require "the"
local lib = require "lib"
local Range = require "range"
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

function Sym:div(rows,y,    t,syms)
  t, syms = {}, {}
  for _,row in pairs(rows) do
    local xval = row.cells[ self.pos ]
    local yval = y(row)
    if xval ~= the.ch.skip then 
      if not syms[xval] then
        syms[xval]= Range(self.txt, self.pos,xval)
        syms[xval].y.stats = Sym()
        t[ #t+1 ] = syms[xval]
      end
      syms[xval].y.stats:add( yval ) end 
  end
  for _,here in pairs(t) do
    local stats  = here.y.stats
    here.y.var   = stats:var()
    here.y.ratio = stats.n/#rows
  end
  return t
end

return Sym
