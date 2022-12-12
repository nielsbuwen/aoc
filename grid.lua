local Class = require 'class'
local Grid = Class.Grid

function Grid:init(data, width, height)
    self.data = data
    self.width = width
    self.height = height
end

function Grid.empty(fill, width, height)
    data = {}

    for i = 1, width * height do
        data[i] = fill or i
    end
    return Grid(data, width, height)
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
            return (i - 1) % mod + 1, (i - 1) // mod + 1
        end
    end
end

return Grid
