it = require 'it'

local LOSE = 0
local DRAW = 3
local WIN = 6
local ROCK = 1
local PAPER = 2
local SCISSORS = 3

local POINTS = {
    ['A X'] = ROCK + DRAW,
    ['A Y'] = PAPER + WIN,
    ['A Z'] = SCISSORS + LOSE,
    ['B X'] = ROCK + LOSE,
    ['B Y'] = PAPER + DRAW,
    ['B Z'] = SCISSORS + WIN,
    ['C X'] = ROCK + WIN,
    ['C Y'] = PAPER + LOSE,
    ['C Z'] = SCISSORS + DRAW,

}

local OUTCOME = {
    ['A X'] = LOSE + SCISSORS,
    ['A Y'] = DRAW + ROCK,
    ['A Z'] = WIN + PAPER,
    ['B X'] = LOSE + ROCK,
    ['B Y'] = DRAW + PAPER,
    ['B Z'] = WIN + SCISSORS,
    ['C X'] = LOSE + PAPER,
    ['C Y'] = DRAW + SCISSORS,
    ['C Z'] = WIN + ROCK,
}

for line in io.lines('02.txt') do
    part_one = part_one + POINTS[line]
    part_two = part_two + OUTCOME[line]
end

print("part one", part_one)
print("part two", part_two)