local Point = require 'point'
local Box = require 'box'
local mod = require 'interval'
local Set = require 'set'
local Interval = mod[1]
local Intervals = mod[2]

local items = {}
local bounds = Box()
local longest_radius = 0

for line in io.lines('input15.txt') do
    local sensor_x, sensor_y, beacon_x, beacon_y = line:match 'Sensor at x=(-?%d+), y=(-?%d+): closest beacon is at x=(-?%d+), y=(-?%d+)'
    local sensor = Point.from_string(sensor_x, sensor_y)
    local beacon = Point.from_string(beacon_x, beacon_y)
    local radius = sensor:manhattan_to(beacon)

    if radius > longest_radius then longest_radius = radius end
    bounds:include(sensor)
    bounds:include(beacon)

    items[#items + 1] = {sensor=sensor, beacon=beacon, radius=radius}
end

table.sort(items, function (i, j) return i.sensor.x < j.sensor.x end)


local function compute_slice(y)
    local intervals = Intervals()

    for _, item in ipairs(items) do
        local vertical_distance = math.abs(item.sensor.y - y)
        local interval_radius = item.radius - vertical_distance

        if interval_radius >= 0 then
            local interval = Interval(item.sensor.x - interval_radius, item.sensor.x + interval_radius)

            intervals:add(interval)
        end
    end

    return intervals
end

local function count_blocked(intervals, y)
    local beacon_xs = Set()

    for _, item in ipairs(items) do
        local beacon = item.beacon
        if beacon.y == y then
            beacon_xs:add(beacon.x)
        end
    end

    local blocked = 0
    for _, interval in ipairs(intervals.intervals) do
        blocked = blocked + interval:size()

        for x, _ in pairs(beacon_xs) do
            if interval:contains(x) then blocked = blocked - 1 end
        end
    end

    return blocked
end


local test_y = 2000000
local intervals = compute_slice(test_y)
local blocked = count_blocked(intervals, test_y)
print("blocked", blocked)


local max = 4000000
for y = 0, max do
    intervals = compute_slice(y)

    if #intervals.intervals > 1 then
        local left = intervals.intervals[1]
        local x = left.right + 1
        print('\nGap at', x, y, 'with frequency', x * max +y)
        break
    end

    if y % 40000 == 0 then
        io.write(string.format('\rscanning... %3d%% ', y * 100 // max))
        io.flush()
    end
end