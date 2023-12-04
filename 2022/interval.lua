local Class = require 'class'
local Interval = Class.Interval

function Interval:init(left, right)
    self.left = left
    self.right = right
end

function Interval:union(other)
    return Interval(math.min(self.left, other.left), math.max(self.right, other.right))
end

function Interval:copy()
    return Interval(self.left, self.right)
end

function Interval:size()
    return self.right - self.left + 1
end

function Interval:contains(coordinate)
    return coordinate >= self.left and coordinate <= self.right
end

function Interval:__tostring()
    return string.format('[%d:%d]', self.left, self.right)
end


local Intervals = Class.Intervals

function Intervals:init()
    self.intervals = {}
end 

function Intervals:add(interval)
    while true do
        ::continue::
        for i, existing in ipairs(self.intervals) do
            if (interval.right + 1) >= existing.left and (interval.left - 1) <= existing.right then
                interval = interval:union(existing)
                table.remove(self.intervals, i)
                goto continue
            end
        end
        break
    end

    table.insert(self.intervals, interval)
end

function Intervals:__tostring()
    local parts = {}
    for _, i in ipairs(self.intervals) do parts[#parts + 1] = tostring(i) end
    return '{' .. table.concat(parts, ', ') .. '}'
end


return {Interval, Intervals}
