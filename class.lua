local _Class = {}
_Class.__index = _Class


function _Class:__call(...)
    local instance = setmetatable({}, self)
    instance:init(...)
    return instance
end

function _Class:__tostring()
    return string.format("Class<%s>", self.name)
end

local Class = {}
setmetatable(Class, Class)

function Class:__index(class_name)
    local class = setmetatable({}, _Class)
    class.__index = class
    class.name = class_name

    return class
end

return Class
