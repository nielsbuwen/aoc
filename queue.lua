local Class = require 'class'
local Queue = Class.Queue

function Queue:init(...)
    for _, value in ipairs({...}) do
        self:push(value)
    end
end

function Queue:push(value)
    table.insert(self, value)
end

function Queue:pop()
    return table.remove(self, 1)
end

function Queue:__tostring()
    local parts = {}
    for _, value in ipairs(self) do
        parts[#parts + 1] = value
    end
    return string.format("Queue(%s)", table.concat(parts, ", "))
end

return Queue
