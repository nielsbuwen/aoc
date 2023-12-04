local Set = require 'set'
local Point = require 'point'
local Class = require 'class'

local Rope = Class.Rope

function Rope:init(n)
    self.knots = {}

    for _ = 0, n - 1 do
        table.insert(self.knots, Point(0, 0))
    end
end

function Rope:head()
    return self.knots[1]
end

function Rope:tail()
    return self.knots[#self.knots]
end

function Rope:move(direction)
    self.knots[1] = self.knots[1] + direction

    for knot = 2, #self.knots do
        local separation = self.knots[knot - 1] - self.knots[knot]

        if separation:length_squared() > 2 then
            self.knots[knot] = self.knots[knot] + separation:independent_unit()
        end
    end
end

local function print_board(down_left, up_right, r, v)
    for y = up_right.y, down_left.y, -1 do
        for x = down_left.x, up_right.x do
            local sign

            for i = 0, #r.knots - 1 do
                local knot = r.knots[i + 1]
                if knot.x == x and knot.y == y then
                    sign = i
                    break
                end
            end

            if not sign then
                if v[string.format('(%s, %s)', x, y)] then
                    sign = '#'
                else
                    sign = '.'
                end
            end
            io.write(sign)
        end
        print()
    end
    print()
end

local directions = {
    R=Point(1, 0),
    L=Point(-1, 0),
    U=Point(0, 1),
    D=Point(0, -1)
}

local rope = Rope(10)
local visited = Set()
local top_right = Point(0, 0)
local bottom_left = Point(0, 0)

for line in io.lines('input09.txt') do
    local direction_name, repeats = line:match '(%w) (%d+)'

    for _ = 1, repeats do
        rope:move(directions[direction_name])
        visited:add(tostring(rope:tail()))

        local head = rope:head()
        if head.x > top_right.x then top_right.x = head.x end
        if head.x < bottom_left.x then bottom_left.x = head.x end
        if head.y > top_right.y then top_right.y = head.y end
        if head.y < bottom_left.y then bottom_left.y = head.y end
    end
end

print("range", bottom_left, top_right)
print_board(bottom_left, top_right, rope, visited)
print("visited", #visited)
