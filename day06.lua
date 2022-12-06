Set = require 'set'
local input = io.lines("input06.txt")()


local function find_consecutive_unique(string, n)
    for i = 1, #string - n + 1 do
    local a = Set.from_string(input:sub(i, i + n - 1))

        if #a == n then
            return i + n - 1
        end
    end

    return -1
end

print("marker", find_consecutive_unique(input, 4))
print("marker", find_consecutive_unique(input, 14))