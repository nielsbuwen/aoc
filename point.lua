local Class = require 'class'
local Point = Class.Point

function Point:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Point:__eq(other)
    return self.x == other.x and self.y == other.y
end

function Point:__add(other)
    return Point(self.x + other.x, self.y + other.y)
end

function Point:__sub(other)
    return Point(self.x - other.x, self.y - other.y)
end

function Point:length_squared()
    return self.x ^ 2 + self.y ^ 2
end

function Point:copy()
    return Point(self.x, self.y)
end

local function unit(length)
    if length == 0 then return 0 end

    return length // math.abs(length)
end

function Point:independent_unit()
    return Point(unit(self.x), unit(self.y))
end

function Point:length()
    return math.sqrt(self:length_squared())
end

function Point:__tostring()
    return string.format("(%d, %d)", self.x, self.y)
end

return Point
