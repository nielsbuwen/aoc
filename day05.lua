local function read_arrangement(it)
    local stacks = {}

    for line in it do
        if line == '' then break end

        local stack_index = 1

        for crate in (line .. ' '):gmatch('[ %[][ %a][ %]] ') do
            crate = crate:sub(2, 2)
            stacks[stack_index] = stacks[stack_index] or {}

            if crate ~= ' ' then
                table.insert(stacks[stack_index], 1, crate)
            end

            stack_index = stack_index + 1
        end
    end

    return stacks
end

local function read_movement(it)
    local movements = {}

    for line in it do
        local quantity, from, to = line:match 'move (%d+) from (%d+) to (%d+)'

        table.insert(movements, {
            quantity=tonumber(quantity), from=tonumber(from), to=tonumber(to)
        })
    end

    return movements
end

local function move_9000(source, destination, quantity)
    for _ = 1, quantity do
        table.insert(destination, table.remove(source))
    end
end

local function move_9001(source, destination, quantity)
    local reverse = {}

    for i = 1, quantity do
        table.insert(reverse, table.remove(source))
    end

    for _ = 1, quantity do
        table.insert(destination, table.remove(reverse))
    end
end

local function perform_movement(movements, stacks, mover)
    for _, movement in ipairs(movements) do
        local source = stacks[movement.from]
        local destination = stacks[movement.to]

        mover(source, destination, movement.quantity)
    end
end


local function print_stacks(stacks)
    for i, stack in ipairs(stacks) do
        print(i, table.concat(stack, " "))
    end
end

local lines = io.lines('input05.txt')

local stacks = read_arrangement(lines)
local movements = read_movement(lines)

print_stacks(stacks)
perform_movement(movements, stacks, move_9001)

for _, stack in ipairs(stacks) do
    io.write(stack[#stack])
end
print()
