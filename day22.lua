local Grid = require 'grid'
local Point = require 'point'
local Class = require 'class'

local Actor = Class.Actor

function Actor:init(grid)
    self.grid = grid
    self.position = Point(grid:find('.'))
    self.direction = Point(1, 0)
end

function Actor:direction_name()
    if self.direction == Point(1, 0) then
        return ">"
    elseif self.direction == Point(-1, 0) then
        return "<"
    elseif self.direction == Point(0, 1) then
        return "v"
    elseif self.direction == Point(0, -1) then
        return "^"
    end
end

function Actor:__str()
    return "Actor %s%s", self:direction_name(), self.position
end

function Actor:print()
    self.grid(self.position, nil, self:direction_name())
    print(self.grid)
    self.grid(self.position, nil, '.')
end

local function no_space(c)
    return c ~= ' '
end

function Actor:move()
    local new_position = self.position + self.direction
    local place = self.grid(new_position)

    if place == '.' then
        self.position = new_position
    elseif place == nil or place == ' ' then
        if self.direction.x == 1 then
            new_position.x = self.grid:find_in_row(new_position.y, no_space)
        elseif self.direction.x == -1 then
            new_position.x = self.grid:rfind_in_row(new_position.y, no_space)
        elseif self.direction.y == 1 then
            new_position.y = self.grid:find_in_column(new_position.x, no_space)
        elseif self.direction.y == -1 then
            new_position.y = self.grid:rfind_in_column(new_position.x, no_space)
        end

        if self.grid(new_position) == '.' then
            self.position = new_position
        end
    end
end

function Actor:turn_left()
    self.direction = Point(self.direction.y, -self.direction.x)
end

function Actor:turn_right()
    self.direction = Point(-self.direction.y, self.direction.x)
end

local g, commands = Grid.from_file('input22.txt', function(c) if c == '_' then return ' ' end return c end)
local actor = Actor(g)


local i = 1

while i < #commands do
    local _, stop, move = commands:find('^(%d+)', i)

    if move then
        i = stop + 1
        for _ = 1, tonumber(move) do
            actor:move()
        end
    else
        local turn = commands:sub(i, i)
        i = i + 1
        if turn == 'R' then
            actor:turn_right()
        else
            actor:turn_left()
        end
    end

end

actor:print()
print(actor.position.y * 1000 + actor.position.x * 4 + math.abs(actor.direction.x + actor.direction.y * 2 - 1))
