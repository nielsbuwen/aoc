local elves = {}
local current_calories = 0


for line in io.lines('01.txt') do
    if line == '' then
        elves[#elves + 1] = current_calories
        current_calories = 0
    else
        current_calories = current_calories + tonumber(line)
    end
end

table.sort(elves)

print("highest", elves[#elves])

local top_three = elves[#elves] + elves[#elves - 1] + elves[#elves - 2]

print("top three", top_three)