local Class = require 'class'
local Box = Class.Box

local Point = require 'point'
local Grid = require 'grid'

function Box:init(lower_left, upper_right)
    self.lower_left = lower_left
    self.upper_right = upper_right
end

function Box.from_range(left, right, bottom, top)
    self.lower_left = Point(left, bottom)
    self.upper_right = Point(right, top)
end

function Box:include(point)
    if self.lower_left == nil then
        self.lower_left = point:copy()
        self.upper_right = point:copy()
    end

    if self.lower_left.x > point.x then self.lower_left.x = point.x end
    if self.lower_left.y > point.y then self.lower_left.y = point.y end
    if self.upper_right.x < point.x then self.upper_right.x = point.x end
    if self.upper_right.y < point.y then self.upper_right.y = point.y end
end

function Box:to_grid(fill)
    return Grid.range(fill, self.lower_left.x, self.upper_right.x, self.lower_left.y, self.upper_right.y)
end

return Box
