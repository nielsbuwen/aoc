
local root = {}
local current_directory = root

local function handle_command(cwd, command, argument)
    if command == 'cd' then
        if argument == '/' then
            return root
        else
            return cwd[argument]
        end
    end

    return cwd
end

local function handle_output(cwd, left, right)
    if left == 'dir' then
        cwd[right] = cwd[right] or {['..'] = cwd}
    else
        cwd[right] = tonumber(left)
    end
end



for line in io.lines('input07.txt') do
    local marker, a, b = line:match '(%$?) ?(%S+) ?(%S*)'
    if marker == '$' then
        current_directory = handle_command(current_directory, a, b)
    else
        handle_output(current_directory, a, b)
    end
end

local function pretty(dir, level)
    level = level or 0
    local pad = string.rep("  ", level)
    for k, v in pairs(dir) do
        if k ~= '..' then
            if type(v) == "number" then
                print(string.format("%s%s: %d", pad, k, v))
            else
                print(string.format("%s%s/", pad, k))
                pretty(v, level + 1)
            end
        end
    end
end

pretty(root, 0)

local function aggregate_sizes(cwd, sizes)
    local size = 0
    for k, v in pairs(cwd) do
        if k ~= '..' then
            if type(v) == 'number' then
                size = size + v
            else
                local recurse = aggregate_sizes(v, sizes)
                size = size + recurse
            end
        end
    end

    table.insert(sizes, size)

    return size
end

local sizes = {}
aggregate_sizes(root, sizes)

local total = 0
for _, size in ipairs(sizes) do
    if size < 100000 then
        total = total + size
    end
end

local unused = 70000000 - sizes[#sizes]
local missing = 30000000 - unused

print("unused", unused)
print("missing", missing)
print("total", total)

local best = 70000000

for _, size in ipairs(sizes) do
    if size >= missing and size <= best then
        best = size
    end
end
print("best", best)