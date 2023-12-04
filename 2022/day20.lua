local List = require 'list'
local Dict = require 'dict'

local coordinates = List()
local pos = 1
for line in io.lines('input20.txt') do
    local current = Dict{value=tonumber(line), pos=pos}
    coordinates[#coordinates + 1] = current

    pos = pos + 1
end


local function swap(c, i, j)
    c[i].pos, c[j].pos = c[j].pos, c[i].pos
    c[i], c[j] = c[j], c[i]
end

local function mix(c, i)
    local move = c[i].value % (#c - 1)

    if move == 0 then return end

    local d = move // math.abs(move)

    while move ~= 0 do
        local j

        if d > 0 then
            if i == #c then
                j = 1
            else
                j = i + 1
            end
        elseif d < 0 then
            if i == 1 then
                j = #c
            else
                j = i - 1

            end
        else
            return
        end

        swap(c, i, j)
        i = j
        move = move - d
    end
end

local function decrypt(c, factor, times)
    local scaled = c:map(function(co) return Dict{value=co.value * factor, pos=co.pos} end)
    local order = scaled:shallow_copy()

    for t = 1, times do
        for _, o in ipairs(order) do
            mix(scaled, o.pos)
        end
        print(string.format("mix %d/%d", t, times))
    end

    return scaled
end

local A = {}
function A:__index(key) return function(e) return e[key] end end
setmetatable(A, A)

local decrypted = decrypt(coordinates, 811589153, 10)

local zero = decrypted:map(A.value):find(0)
local sum = 0

for i = 1000, 3000, 1000 do
    i = (zero + i - 1) % #decrypted + 1
    sum = sum + decrypted[i].value
end
print(sum)