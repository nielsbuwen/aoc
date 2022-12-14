local Class = require 'class'
local Point = Class.Point

Point.__scale = 1000000

function Point:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Point:__hash()
    --local s = Point.__scale
    --return self.x * s + self.y
    return tostring(self)
end

function Point.from_string(x, y)
    return Point(tonumber(x), tonumber(y))
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

function Point:manhattan_to(other)
    return math.abs(self.x - other.x) + math.abs(self.y - other.y)
end

return Point
