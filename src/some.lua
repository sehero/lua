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
