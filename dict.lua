local Class = require 'class'
local Dict = Class.Dict

function Dict:init(tab)
    for k, v in pairs(tab) do
        self[k] = v
    end
end

function Dict:__tostring()
    local parts = {}

    for k, v in pairs(self) do
        parts[#parts + 1] = string.format("%s=%s", k, v)
    end
    table.sort(parts)
    return "{" .. table.concat(parts, ", ") .. "}"
end

return Dict
