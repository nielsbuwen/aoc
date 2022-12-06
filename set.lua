local Set = {}
Set.__index = Set

function Set.new(items)
    local set = setmetatable({}, Set)

    for _, item in ipairs(items or {}) do
        set[item] = true
    end

    return set
end

function Set.from_string(str)
    local set = Set.new()

    for char in str:gmatch '.' do
        set[char] = true
    end

    return set
end

function Set:keys()
    local result = {}

    for key in self:iter() do
        result[#result + 1] = key
    end

    return result
end

function Set:__len()
    local len = 0

    for _, _ in pairs(self) do
        len = len + 1
    end

    return len
end

function Set:iter()
    return pairs(self)
end

function Set:add(key)
    self[key] = true
end

function Set:top()
    return next(self)
end

function Set:__band(other)
    local result = Set.new()

    for key in self:iter() do
        result[key] = other[key]
    end

    return result
end

function Set:add_all(other)
    for key in other:iter() do
        self[key] = true
    end
end

function Set:remove_all(other)
    for key in other:iter() do
        self[key] = nil
    end
end

function Set:__bor(other)
    local result = Set.new()

    result:add_all(self)
    result:add_all(other)

    return result
end

function Set:__tostring()
    return '{' .. table.concat(self:keys(), ', ') .. '}'
end

return Set
