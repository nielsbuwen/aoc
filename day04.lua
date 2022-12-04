local function fully_contains(start_a, end_a, start_b, end_b)
    return (
            start_a <= start_b and end_a >= end_b
    ) or (
            start_b <= start_a and end_b >= end_a
    )
end

local function partially_overlaps(start_a, end_a, start_b, end_b)
    return (
            start_a <= start_b and start_b <= end_a
    ) or (
            start_a <= end_b and end_b <= end_a
    )
end

local total_containment = 0
local partial_overlap = 0

for line in io.lines('input04.txt') do
    local start_a, end_a, start_b, end_b = line:match '(%d+)-(%d+),(%d+)-(%d+)'
    start_a = tonumber(start_a)
    end_a = tonumber(end_a)
    start_b = tonumber(start_b)
    end_b = tonumber(end_b)

    if fully_contains(start_a, end_a, start_b, end_b) then
        total_containment = total_containment + 1
    elseif partially_overlaps(start_a, end_a, start_b, end_b) then
        partial_overlap = partial_overlap + 1
    end
end

print("total containment", total_containment)
print("any overlap", total_containment + partial_overlap)
