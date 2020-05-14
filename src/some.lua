local the = require "the"
local binChop = require("lib").binChop
local Some = the.class(require "col")

function Some:_init(txt,pos)
  self:super(txt,pos)
  self._all = {}
  self.max = the.some.max
  self.magic=the.some.magic
  self.sorted = false
end

function Some:add(x)
  if x ~= the.ch.skip then
    self.n = self.n + 1
    x = tonumber(x)
    if #x < self.max then
      self.sorted = false
      self._all[ #self._all + 1 ] = x
    elseif math.rand() < self.max/self.n then
      self.all()[ lst.bsearch(self._all,x) ] = x end 
   end
   return x
end

function Some:show() 
  return (self.w<0 and"<"or">")..tostring(self:mid()) end

function Some:__tostring()
  return string.format("Some(%s,%s)", self:mid(), self:iqr) end

function Some:mid(j,k)  
  return self:per(.5,j,k) end

function Some:var(j,j)  
  return (self:per(.9,j,k) - self:per(.1,j,k))/self.magic end

function Some:iqr(j,k)
  return self:per(.75,j,k) - self:per(.5,j,k) end

function Some:per(p,j,k,  i)
  j = j or 1
  k = k or #self._all
  i = math.floor( j + p*(k-j) )
  return self:all()[ i ]
end

function Some:all()
  if not self.sorted then table.sort(self._all) end
  self.sorted = true
  return self._all
end

return Some 
