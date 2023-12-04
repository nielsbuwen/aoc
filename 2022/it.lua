function iter(it, tab, key)
    if tab == nil then
        if type(it) == 'function' then
            return enumerate(it)
        end
        return pairs(it)
    end

    return it, tab, key
end

function enumerate(it, start)
    return function(it, key)
        value = it()
        if value == nil then return nil end
        return key + 1, value
    end, it, start or 1
end

function map(func, it, tab, key)
    it, tab, key = iter(it, tab, key)

    return function(tab, key)
        key, value = it(tab, key)
        if value == nil then return nil end
        return key, func(value)
    end, tab, key
end

function tmap(lookup, it, tab, key)
    it, tab, key = iter(it, tab, key)

    return function(tab, key)
        key, value = it(tab, key)
        if value == nil then return nil end
        return key, lookup[value]
        end, tab, key
end

function reduce(binary, initial, it, tab, key)
    it, tab, key = iter(it, tab, key)

    if initial == nil then
        key, initial = it(tab, key)
    end

    for _, value in it, tab, key do
        initial = binary(initial, value)
    end

    return initial
end

function add(x, y) return x + y end

function mul(x, y) return x * y end

function sum(it, tab, key) return reduce(add, 0, it, tab, key) end

function product(it, tab, key) return reduce(mul, 1, it, tab, key) end

function maximum(it, tab, key) return reduce(math.max, 0, it, tab, key) end

local sentinel = {}

function split_by(separator, it, tab, key)
    it, tab, key = iter(it, tab, key)
    local count = 0
    local done = false

    return function()
        if done then return nil end
        local group = {}

        for k, value in it, tab, key do
            key = k
            if value == separator then
                count = count + 1

                if #group > 0 then
                    return count, group
                end
            else
                group[#group + 1] = value
            end
        end
        done = true

        if #group == 0 then return nil end
        return count + 1, group
    end
end

return _G
