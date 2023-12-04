local _Class = {}
_Class.__index = _Class


function _Class:__call(...)
    local instance = setmetatable({}, self)
    instance:init(...)
    return instance
end

function _Class:attach(instance)
    setmetatable(instance)
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

    function class:__str()
        return "<%s instance>", self.name
    end

    function class:__tostring()
        return string.format(self:__str())
    end

    return class
end

return Class
