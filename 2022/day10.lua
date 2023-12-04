local machine = {
    register = 1,
    cycle = 1,
    strengths = {},
    screen = {},
}

function machine:noop()
    self:draw()
    self:next()

end

function machine:addx(x)
    self:noop()
    self:draw()
    self.register = self.register + x
    self:next()

end

function machine:draw()
    local pixel = (self.cycle - 1) % 40
    local draw
    local test = self.register
    if pixel == test or pixel == test + 1 or pixel == self.register - 1 then
        draw = '#'
    else
        draw = ' '
    end

    table.insert(self.screen, draw)
end

function machine:next()
    self.cycle = self.cycle + 1


    if self.cycle % 40 == 20 and self.cycle <= 220 then
        table.insert(self.strengths, self.register * self.cycle)
    end

end

for line in io.lines('input10.txt') do
    local instruction, argument = line:match '(%S+) ?(%S*)'
    machine[instruction](machine, argument)
end

local signal_strength = 0

for _, strength in ipairs(machine.strengths) do
    signal_strength = signal_strength + strength
end

print("total signal strength", signal_strength)
local screen_lines = table.concat(machine.screen)

for line in screen_lines:gmatch(string.rep('.', 40)) do
    print(line)
end