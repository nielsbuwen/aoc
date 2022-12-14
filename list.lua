local Class = require 'class'
local List = Class.List

function List:init(...)
    for i, v in ipairs({...}) do
        self[i] = v
    end
end

function List:map(f)
    local mapped = List()

    for i, v in ipairs(self) do
        mapped[i] = f(v)
    end

    return mapped
end

function List:max()
    local max = -1e999

    for _, v in ipairs(self) do
        if v > max then max = v end
    end

    return max
end

function List:min()
    local min = 1e999

    for _, v in ipairs(self) do
        if v < min then min = v end
    end

    return min
end

function List:find(needle)
    for i, v in ipairs(self) do
        if v == needle then return i end
    end
end

local function identity(x) return x end

function List:shallow_copy()
    return self:map(identity)
end

function List:__tostring()
    return "[" .. table.concat(self:map(tostring), ", ") .. "]"
end

return List
