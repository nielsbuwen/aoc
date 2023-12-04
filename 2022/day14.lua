local Point = require 'point'
local Grid = require 'grid'

local paths = {}

local sand_origin = Point(500, 0)
local bottom_left = sand_origin:copy()
local top_right = sand_origin:copy()

for line in io.lines('input14.txt') do
    local path = {}
    for x, y in line:gmatch '(%d+),(%d+)' do
        local point = Point(tonumber(x), tonumber(y))
        path[#path + 1] = point

        if point.x < bottom_left.x then bottom_left.x = point.x end
        if point.x > top_right.x then top_right.x = point.x end
        if point.y < bottom_left.y then bottom_left.y = point.y end
        if point.y > top_right.y then top_right.y = point.y end
    end
    paths[#paths + 1] = path
end

local function build_grid(paths, with_bottom)
    local depth = top_right.y

    if with_bottom then depth = depth + 2 end

    local grid = Grid.range('.', sand_origin.x - depth * 2, sand_origin.x + depth * 2, 0, depth)

    for _, path in ipairs(paths) do
        for i = 2, #path do
            local start = path[i - 1]
            local stop = path[i]
            local dir = (stop - start):independent_unit()
            grid(start, nil, '#')
            while start ~= stop do
                start = start + dir
                grid(start, nil, '#')
            end
        end
    end

    if with_bottom then
        for i = grid:left(), grid:right() do
            grid(i, grid:top(), '#')
        end
    end

    return grid
end

local DOWN = Point(0, 1)
local LEFT = Point(-1, 1)
local RIGHT = Point(1, 1)
local DIRECTIONS = {DOWN, LEFT, RIGHT}

local function fall_sand(g, sand)
    for _, direction in ipairs(DIRECTIONS) do
        local new_position = sand + direction

        if g(new_position) == nil then
            return nil, nil
        end

        if g(new_position) == '.' or g(new_position) == '~' then
            return new_position, true
        end
    end

    return sand, false
end

local function spawn_sand(g, at)
    local sand = at:copy()
    local falling = true

    while falling do
        sand, falling = fall_sand(g, sand)

        if sand == at then
            g(sand, nil, 'o')
            return nil
        end

        if sand then
            g(sand, nil, '~')
        end
    end

    if falling == false then
        g(sand, nil, 'o')
        return true
    end

    return false
end

local function fill_sand(g, at, bottom)
    local rested = true
    local sand = 0

    while rested do
        sand = sand + 1
        rested = spawn_sand(g, at, bottom)

        if rested == nil then return sand end
    end

    return sand - 1
end

local grid = build_grid(paths, false)
local filled = fill_sand(grid, sand_origin)
spawn_sand(grid, sand_origin)
print(grid)
print("filled", filled)

print()
print()

grid = build_grid(paths, true)

filled = fill_sand(grid, sand_origin, grid:top() + 1)


print(grid)
print("filled", filled)