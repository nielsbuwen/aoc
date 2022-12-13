local function parse_list(code)
    local i = 1
    local result = {{}}

    while i <= #code do
        local char = code:sub(i, i)

        if char == '[' then
            i = i + 1
            result[#result + 1] = {}
        elseif char == ']' then
            i = i + 1
            local inner = table.remove(result)
            table.insert(result[#result], inner)
        elseif char == ',' then
            i = i + 1
        else
            local number_start, number_end = code:find('%d+', i)
            table.insert(result[#result], tonumber(code:sub(number_start, number_end)))
            i = number_end + 1
        end
    end

    return result[1][1]
end

function table.find(hay, needle)
    for i, value in ipairs(hay) do
        if needle == value then
            return i
        end
    end
end

local function print_list(x)
    if type(x) == 'number' then io.write(x) return end

    io.write('[')

    for i, v in ipairs(x) do
        if type(v) == 'table' then
            print_list(v)
        else
            io.write(v)
        end
        if i < #x then
            io.write(',')
        end
    end

    io.write(']')
end

local function is_right_order(left, right)
    if type(left) == type(right) then
        if type(left) == 'number' then
            if left == right then return nil end
            return left < right
        end

        local bound = math.min(#left, #right)

        for i = 1, bound do
            local inner = is_right_order(left[i], right[i])

            if inner ~= nil then return inner end
        end

        if #left == #right then return nil end

        return #left < #right
    elseif type(left) == 'number' then
        return is_right_order({left}, right)
    else
        return is_right_order(left, {right})
    end
end


local packets = {}

for line in io.lines('input13.txt') do
    if line ~= '' then
        packets[#packets + 1] = parse_list(line)
    end
end

local ordered = 0

for i = 1, #packets, 2 do
    local left = packets[i]
    local right = packets[i + 1]

    if is_right_order(left, right) then
        ordered = ordered + (i + 1) // 2
    end
end

print("ordered", ordered)

local divider_two = {{2}}
local divider_six = {{6}}

table.insert(packets, divider_two)
table.insert(packets, divider_six)

table.sort(packets, is_right_order)

print("decoder key", table.find(packets, divider_two) * table.find(packets, divider_six))