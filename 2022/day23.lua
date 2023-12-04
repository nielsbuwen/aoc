local Grid = require 'grid'
local List = require 'list'
local Point = require 'point'
local Set = require 'set'

local S = Point(0, 1)
local SE = Point(1, 1)
local SW = Point(-1, 1)

local N = Point(0, -1)
local NE = Point(1, -1)
local NW = Point(-1, -1)

local W = Point(-1, 0)
local E = Point(1, 0)

local NEIGHBORS = List(N, NE, NW, S, SE, SW, W, NW, SW, E, NE, SE)

local g = Grid.from_file('input23.txt')
local es = g:find_all('#')
local positions = Set()

for _, e in ipairs(es) do
    positions:hash_add(e)
end

local function plan(elves, pos, c)
    local targets = List()
    local movement = 0

    for _, elf in ipairs(elves) do
        local n = pos:hash_has(elf + N)
        local ne = pos:hash_has(elf + NE)
        local nw = pos:hash_has(elf + NW)

        local s = pos:hash_has(elf + S)
        local se = pos:hash_has(elf + SE)
        local sw = pos:hash_has(elf + SW)

        local e = pos:hash_has(elf + E)
        local w = pos:hash_has(elf + W)

        local target = elf

        if n or ne or nw or s or se or sw or e or w then
            local consideration = List(n, ne, nw, s, se, sw, w, nw, sw, e, ne, se)

            for i = c, c + 11, 3 do
                local d = consideration[(i - 1) % 12 + 1]
                local da = consideration[i % 12 + 1]
                local db = consideration[(i + 1) % 12 + 1]
                if not d and not da and not db then
                    target = elf + NEIGHBORS[(i - 1) % 12 + 1]
                    movement = movement + 1
                    break
                end
            end
        end

        targets[#targets + 1] = target
    end

    return targets, movement
end

local function move(elves, pos, planned)
    local count = {}

    for _, p in ipairs(planned) do
        local key = p.x * 1000000 + p.y
        count[key] = (count[key] or 0) + 1
    end

    for i = 1, #elves do
        local p = planned[i]
        local key = p.x * 1000000 + p.y

        if count[key] == 1 then
            local elf = elves[i]
            pos:hash_remove(elf)
            elves[i] = p
            pos:hash_add(p)
        end
    end
end

local d = 1
local round = 0

local display = Grid.empty('.', g.width, g.height)
for _, e in ipairs(es) do
    display(e, nil, '#')
end
print(display)

while true do
    round = round + 1

    local planned, movement = plan(es, positions, d)
    d = d + 3


    if movement == 0 or round == 11 then
        local xs = es:map(function(p) return p.x end)
        local ys = es:map(function(p) return p.y end)

        local width = xs:max() - xs:min() + 1
        local height = ys:max() - ys:min() + 1
        print("round", round, "empty", width * height - #es)

        if movement == 0 then break end
    end

    move(es, positions, planned)

    --[[
    local xs = es:map(function(p) return p.x end)
    local ys = es:map(function(p) return p.y end)

    local width = xs:max() - xs:min() + 1
    local height = ys:max() - ys:min() + 1
    print(string.format("== Round %03d ==", round))
    display = Grid.range('.', xs:min(), xs:max(), ys:min(), ys:max())
    for _, e in ipairs(es) do
        display(e, nil, '#')
    end
    print(display)
    print("empty", width * height - #es)

    print()]]
end

