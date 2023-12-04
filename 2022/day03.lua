Set = require 'set'
iter = require 'iter'
require 'str'

local function priority(typ)
    local byte = string.byte(typ)

    if typ <= 'Z' then
        return byte - 38
    end

    return byte - 96
end


local misplaced_sum = 0
local badge_sum = 0

for _, chunk in iter.chunked(3, io.lines('input03.txt')) do
    local badge

    for _, line in ipairs(chunk) do
        local first, second = line:split_at(#line / 2)
        local common_items = Set.from_string(first) & Set.from_string(second)
        misplaced_sum = misplaced_sum + priority(common_items:top())

        local all = Set.from_string(line)
        badge = all & (badge or all)
    end

    badge_sum = badge_sum + priority(badge:top())
end


print("misplaces sum", misplaced_sum)
print("badge sum", badge_sum)
