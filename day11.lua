local Class = require 'class'
local Set = require 'set'
local function number_from_line(l) return l:match '(%d+)'  end


local Mod = Class.Mod

function Mod:init(remainders)
    self.remainders = remainders
end

function Mod.build(number, mods)
    local remainders = {}

    for _, mod in ipairs(mods) do
        remainders[mod] = number % mod
    end

    return Mod(remainders)
end

function Mod:__idiv(other)
    assert(other == 1)
    return self
end

function Mod:__add(other)
    local remainders = {}

    if type(other) == 'number' then
        for k, v in pairs(self.remainders) do
            remainders[k] = (v + other) % k
        end
    else
        for k, v in pairs(self.remainders) do
            remainders[k] = (v + other.remainders[k]) % k
        end
    end

    return Mod(remainders)
end

function Mod:__mod(other)
    return self.remainders[other]
end

function Mod:__mul(other)
    local remainders = {}

    if type(other) == 'number' then
        for k, v in pairs(self.remainders) do
            remainders[k] = (v * other) % k
        end
    else
        for k, v in pairs(self.remainders) do
            remainders[k] = (v * other.remainders[k]) % k
        end
    end

    return Mod(remainders)
end

function Mod:__tostring()
    local s = {}

    for k, v in pairs(self.remainders) do
        s[#s + 1] = string.format("%%%s=%s", k, v)
    end

    return string.format("{%s}", table.concat(s, ", "))
end


local function simulate(rounds, divider)
    local lines = io.lines('input11.txt')

    local monkeys = {}


    for monkey_line in lines do
        local monkey = {items = {}}

        local number = number_from_line(monkey_line)
        monkeys[number + 1] = monkey

        local items = lines()
        for item in items:gmatch('%d+') do
            table.insert(monkey.items, tonumber(item))
        end


        local operator, value = string.match(lines(), 'new = old ([+*]) (.+)')
        local operation

        if operator == '*' and value == 'old' then
            operation = function(item) return item * item end
        elseif operator == '+' and value == 'old' then
            operation = function(item) return item + item end
        elseif operator == '*' then
            local v = tonumber(value)
            operation = function(item) return item * v end
        else
            local v = tonumber(value)
            operation = function(item) return item + v end
        end

        monkey.operation = operation
        monkey.dividend = number_from_line(lines())
        monkey.on_true = number_from_line(lines()) + 1
        monkey.on_false = number_from_line(lines()) + 1
        monkey.inspections = 0

        lines()
    end

    if divider == 1 then
        local mods = Set()

        for _, monkey in ipairs(monkeys) do
            mods:add(monkey.dividend)
        end

        for _, monkey in ipairs(monkeys) do
            for i, item in ipairs(monkey.items) do
                monkey.items[i] = Mod.build(item, mods:keys())
            end
        end
    end

    for _ = 1, rounds do
        for _, monkey in ipairs(monkeys) do
            local items = monkey.items
            monkey.items = {}
            for _, item in ipairs(items) do
                monkey.inspections = monkey.inspections + 1
                item = monkey.operation(item) // divider

                local target
                if item % monkey.dividend == 0 then
                    target = monkeys[monkey.on_true]
                else
                    target = monkeys[monkey.on_false]
                end
                table.insert(target.items, item)
            end
        end
    end

    local inspections = {}

    for i, monkey in ipairs(monkeys) do
        inspections[#inspections + 1] = monkey.inspections
        print(i, monkey.inspections)
    end

    table.sort(inspections)

    local highest = inspections[#inspections]
    local second = inspections[#inspections - 1]
    print("monkey business", highest, second, highest * second)
end

simulate(20, 3)
simulate(10000, 1)