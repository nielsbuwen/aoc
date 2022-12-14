local Class = require 'class'
local Grid = Class.Grid

function Grid:init(data, width, height, offset_x, offset_y)
    self.data = data
    self.width = width
    self.height = height
    self.offset_x = offset_x or 0
    self.offset_y = offset_y or 0
end

function Grid.empty(fill, width, height, offset_x, offset_y)
    local data = {}

    for i = 1, width * height do
        data[i] = fill or i
    end
    return Grid(data, width, height, offset_x, offset_y)
end

function Grid.range(fill, left, right, bottom, top)
    return Grid.empty(fill, right - left + 1, top - bottom + 1, left - 1, bottom - 1)
end

function Grid.from_file(file, converter)
    local data = {}
    local width
    converter = converter or function(i) return i end

    local y = 0
    for line in io.lines(file) do
        y = y + 1
        for cell in line:gmatch '.' do
            data[#data + 1] = converter(cell)
        end

        width = #line
    end

    return Grid(data, width, y)
end

function Grid:__tostring()
    local parts = {}
    local row = {}

    for _, cell in ipairs(self.data) do
        row[#row + 1] = tostring(cell)

        if #row == self.width then
            parts[#parts + 1] = table.concat(row)
            row = {}
        end
    end

    return table.concat(parts, "\n")
end

function Grid:__call(x, y, value)
    if not y then
        y = x.y
        x = x.x
    end

    x = x - self.offset_x
    y = y - self.offset_y

    if x < 1 or x > self.width or y < 1 or y > self.height then
        return nil
    end

    local index = x + self.width * (y - 1)
    if value == nil then
        return self.data[index]
    end
    self.data[index] = value
end

function Grid:find(finder)
    if not type(finder) == 'function' then
        local value = finder
        finder = function(v) return v == value end
    end

    local mod = self.width
    for i, cell in ipairs(self.data) do
        if finder == (cell) then
            return self.offset_x + (i - 1) % mod + 1, self.offset_y + (i - 1) // mod + 1
        end
    end
end

function Grid:left()
    return self.offset_x + 1
end

function Grid:right()
    return self.offset_x + self.width
end

function Grid:top()
    return self.offset_y + self.height
end

function Grid:bottom()
    return self.offset_y + 1
end

return Grid
