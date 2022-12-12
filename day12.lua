local Point = require 'point'
local Queue = require 'queue'
local Set = require 'set'
local Grid = require 'grid'

local function can_visit(g, from, to)
    to = g(to)
    from = g(from)

    return to and from and from:byte() <= to:byte() + 1
end

local height_map = Grid.from_file('input12.txt')
local start = Point(height_map:find('S'))
local goal = Point(height_map:find('E'))
height_map(start, nil, 'a')
height_map(goal, nil, 'z')

print("start", start)
print("goal", goal)


local queue = Queue({position = goal, way = 0})
local directions = {Point(1, 0), Point(-1, 0), Point(0, 1), Point(0, -1)}
local visited = Set()
local shortest_hike = height_map.width * height_map.height

while #queue > 0 do
    local current = queue:pop()
    local current_position = current.position
    local current_way = current.way
    if visited:hass(current_position) then goto continue end
    visited:adds(current_position)

    for _, direction in ipairs(directions) do
        local new = current_position + direction
        if can_visit(height_map, current_position, new) then
            queue:push({position = new, way = current_way + 1})
        end
    end

    if current_position == start then
        print("found", current_way)
    elseif height_map(current_position) == 'a' and current_way < shortest_hike then
        shortest_hike = current_way
    end

    ::continue::
end

print("shortest hike", shortest_hike)
