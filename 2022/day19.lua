local Dict = require 'dict'
local Set = require 'set'
local List = require 'list'
local blueprints = {}

for line in io.lines('input19.txt') do
    local blueprint = {}
    local number, recipes = line:match 'Blueprint (%d+):(.+)'
    blueprints[tonumber(number)] = blueprint

    for product, costs in recipes:gmatch ' Each ([^ ]+) robot costs ([^%.]+)' do
        local product_costs = {ore = 0, clay = 0, obsidian = 0}
        blueprint[product] = product_costs

        for amount, material in costs:gmatch '(%d+) ([^ ]+)' do
            product_costs[material] = tonumber(amount)
        end
    end
end


local function empty()
    return Dict{
        ore = 0, clay = 0, obsidian = 0, geodes = 0,
        ore_robots = 1, clay_robots = 0, obsidian_robots = 0, geode_robots = 0,
    }
end

local MATERIALS = {"ore", "clay", "obsidian", "geode"}

local function can_build(blueprint, state, key)
    local cost = blueprint[key]
    return state.ore >= cost.ore and state.clay >= cost.clay and state.obsidian >= cost.obsidian
end

local function build(blueprint, state, material)
    local cost = blueprint[material]
    local copy = Dict{
        ore = state.ore - cost.ore,
        clay = state.clay - cost.clay,
        obsidian = state.obsidian - cost.obsidian,
        geodes = state.geodes,

        ore_robots = state.ore_robots,
        clay_robots = state.clay_robots,
        obsidian_robots = state.obsidian_robots,
        geode_robots = state.geode_robots,
    }

    local robot = material .. '_robots'
    copy[robot] = copy[robot] + 1
    return copy
end

local ORE = 301
local CLAY = ORE * 301
local OBSIDIAN = CLAY * 301
local ORE_ROBOT = OBSIDIAN * 25
local CLAY_ROBOT = ORE_ROBOT * 25
local OBSIDIAN_ROBOT = CLAY_ROBOT * 25
local GEODE_ROBOT = OBSIDIAN_ROBOT * 25

local function hash(state, extra, key)
    local materials = ORE * state.ore + CLAY * state.clay + OBSIDIAN * state.obsidian
    local robots = ORE_ROBOT * state.ore_robots + CLAY_ROBOT * state.clay_robots + OBSIDIAN_ROBOT * state.obsidian_robots + GEODE_ROBOT * state.geode_robots
    return materials + robots + 2 * extra + key
end

local function explore(blueprint, state, max, depth, forbidden, seen, best)
    best = best or 0
    depth = depth or 0

    --[[
    seen = seen or {}
    local geode_hash = hash(state, state.geodes, 0)
    local better_depth = seen[geode_hash]

    if better_depth and better_depth <= depth then
        return best
    end

    seen[geode_hash] = depth

    local depth_hash = hash(state, depth, 1)
    local better_geodes = seen[depth_hash]

    if better_geodes and better_geodes >= state.geodes then
        return best
    end

    seen[depth_hash] = state.geodes
    ]]

    forbidden = forbidden or Set()

    local moves = {}
    for _, material in pairs(MATERIALS) do
        if can_build(blueprint, state, material) and not forbidden[material] then
            moves[#moves + 1] = material
            forbidden:add(material)
        end
    end

    state = Dict{
        ore = state.ore + state.ore_robots,
        clay = state.clay + state.clay_robots,
        obsidian = state.obsidian + state.obsidian_robots,
        geodes = state.geodes + state.geode_robots,

        ore_robots = state.ore_robots,
        clay_robots = state.clay_robots,
        obsidian_robots = state.obsidian_robots,
        geode_robots = state.geode_robots,
    }

    if state.geodes > best then
        best = state.geodes
    end

    if depth + 1 == max then return best end

    for _, material in ipairs(moves) do
        local built = build(blueprint, state, material)
        --io.write(string.rep("  ", depth), " ", material, "  ", tostring(built), "\n")
        best = explore(blueprint, built, max, depth + 1, nil, seen, best)
    end

    if #moves < 4 then
        --io.write(string.rep("  ", depth), " wait  ", tostring(state), "\n")
        best = explore(blueprint, state, max, depth + 1, forbidden, seen, best)
    end

    return best
end

local quality = 0
for i = 1, 0 do
    local best = explore(blueprints[i], empty(), 32)
    print("best", i, best)
    quality = quality + i * best
end
print("total", quality)

--[[
Blueprint 1:
  Each ore robot costs 4 ore.
  Each clay robot costs 2 ore.
  Each obsidian robot costs 3 ore and 14 clay.
  Each geode robot costs 2 ore and 7 obsidian.


-- time 24
-- start ore=0
-- end   ore=1

-- time 23
-- start ore=1
-- end   ore=2

-- time 22
-- start ore=2
-- could build

]]

local function advance(state)
    return Dict{
        ore = state.ore + state.ore_robots,
        clay = state.clay + state.clay_robots,
        obsidian = state.obsidian + state.obsidian_robots,
        geodes = state.geodes + state.geode_robots,

        ore_robots = state.ore_robots,
        clay_robots = state.clay_robots,
        obsidian_robots = state.obsidian_robots,
        geode_robots = state.geode_robots,
    }
end

local blueprint = blueprints[1]
local state = empty()
local forbidden = Set()

for t = 24, 1, -1 do
    print(string.format("-- Minute %02d, Time left %02d --", 25 - t, t))
    print(state)

    for _, material in ipairs(MATERIALS) do
        local hypo = state

        for i = 25 - t, 24, 1 do
            if can_build(blueprint, hypo, material) then
                print("you will be able to build", material, "in minute", i)
                break
            end

            hypo = advance(hypo)
        end
    end

    local can = List()
    for _, material in ipairs(MATERIALS) do
        if can_build(blueprint, state, material) and not forbidden[material] then
            can[#can + 1] = material
            forbidden:add(material)
        end
    end

    state = advance(state)

    if #can == 0 then
        print("you must wait")
    else
        print("you can build a robot for", can)
        if #can < 4 then
            print("or you can wait")
        end

        ::bad::
        io.write("what do? ")
        local action = io.read()

        if action == "wait" then
            if #can == 4 then
                print("it does not make sense to wait now")
                goto bad
            end
        elseif can:find(action) then
            state = build(blueprint, state, action)
            forbidden = Set()
            print("you built a robot for", action)
        else
            print("what?")
            goto bad
        end
    end

    print()
end

print("Done", state)