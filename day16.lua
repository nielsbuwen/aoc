local Set = require 'set'
local system = {}

local edges = Set()
--print("graph {")
for line in io.lines("input16.txt") do
    local valve, rate, way = line:match 'Valve (%w+) has flow rate=(%d+); tunnels? leads? to valves? (.+)'
    local tunnels = {}
    --print(string.format('  %s [label="%s %d"];', valve, valve, rate))
    for tunnel in way:gmatch '%w+' do
        local edge = {valve, tunnel}
        table.sort(edge)
        edge = table.concat(edge)

        if not edges[edge] then
            edges:add(edge)
            --print("", valve, "--", tunnel, ";")

        end
        tunnels[#tunnels + 1] = tunnel
    end

    system[valve] = {valve=valve, rate=tonumber(rate), tunnels=tunnels}
end
--print("}")

local function calculate_distances(start)
    local distances = {[start] = 0}

    local queue = {start}

    while #queue > 0 do
        local node = table.remove(queue)
        for _, tunnel in ipairs(system[node].tunnels) do
            if not distances[tunnel] then
                distances[tunnel] = distances[node] + 1
                table.insert(queue, 1, tunnel)
            end
        end
    end

    return distances
end

local function calculate_gain(remaining, from, to)
    local walk = calculate_distances(from)[to]

    local gain = system[to].rate * (remaining - walk - 1)
    return gain, walk + 1
end

local candidates = {}
for node, config in pairs(system) do
    if config.rate > 0 then
        candidates[#candidates + 1] = node
        print('candidate', node)
    end
end


local stack = {
    {
        time_a = 26,
        node_a = "AA",
        time_b = 26,
        node_b = 'AA',

        steam = 0,
        closed = Set(candidates),
        path = '',
    }
}
local best = 0
local send_elephant = true

while #stack > 0 do
    local state = table.remove(stack)
    local done = true

    local remaining = {}
    for node in pairs(state.closed) do
        remaining[#remaining + 1] = system[node].rate
    end
    table.sort(remaining)

    local optimum = 0
    local t = state.time_a - 1
    for i = #remaining, 1, -1 do
        optimum = optimum + remaining[i] * t
        t = t - 2
    end

    if state.steam + optimum > best then

        for node_a in pairs(state.closed) do
            local gain, walk = calculate_gain(state.time_a, state.node_a, node_a)
            if gain > 0 and walk <= state.time_a then
                local closed = state.closed:copy()
                closed[node_a] = nil
                done = false
                local time_a = state.time_a - walk
                local steam = state.steam + gain

                if send_elephant and state.time_a == state.time_b then
                    for node_b in pairs(closed) do
                        gain, walk = calculate_gain(state.time_b, state.node_b, node_b)
                        if gain > 0 and walk <= state.time_b then
                            local time_b = state.time_b - walk
                            local node_a2 = node_a
                            local time_a2 = time_a

                            local closed_b = closed:copy()
                            closed_b[node_b] = nil

                            if time_b > time_a2 then
                                time_a2, time_b = time_b, time_a2
                                node_a2, node_b = node_b, node_a2
                            end

                            table.insert(stack, {
                                time_a = time_a2,
                                node_a = node_a2,
                                time_b = time_b,
                                node_b = node_b,
                                steam = steam + gain,
                                closed = closed_b,
                            })
                        end
                    end
                else
                    local time_b = state.time_b
                    local node_b = state.node_b

                    if time_b > time_a then
                        time_a, time_b = time_b, time_a
                        node_a, node_b = node_b, node_a
                    end

                    table.insert(stack, {
                        time_a = time_a,
                        node_a = node_a,
                        time_b = time_b,
                        node_b = node_b,
                        steam = steam,
                        closed = closed,
                    })
                end
            end
        end

        if done then
            if state.steam > best then
                best = state.steam
                print('high score', best)
            end
        end

    end
end

print('best', best)
