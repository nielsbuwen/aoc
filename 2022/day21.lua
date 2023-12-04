local List = {}
List.__index = List

function List.attach(tab)
    return setmetatable(tab or {}, List)
end

function List:map(f)
    local result = {}
    for _, v in ipairs(self) do
        result[#result + 1] = f(v)
    end
    return List.attach(result)
end

function List:__tostring()
    return '[' .. table.concat(self:map(tostring), ', ') .. ']'
end

local Dict = {}
Dict.__index = Dict

function Dict.attach(tab)
    return setmetatable(tab or {}, Dict)
end

function Dict:keys()
    local keys = {}
    for k, _ in pairs(self) do
        keys[#keys + 1] = k
    end
    return keys
end

function Dict:__tostring()
    local parts = {}
    for k, v in pairs(self) do
        parts[#parts + 1] = string.format("%s=%s", k, v)
    end
    table.sort(parts)
    return '{' .. table.concat(parts, ', ') .. '}'
end

-----------------------------------------------------------------------

local function sort_topologically(graph)
    local mark = {}
    local order = List.attach()
    local unmarked = {}

    for k, _ in pairs(graph) do
        unmarked[k] = true
    end

    local function visit(node)
        if mark[node] == 'permanent' then
            return
        end

        if mark[node] == 'temporary' then
            error("cycle")
        end

        mark[node] = 'temporary'
        unmarked[node] = nil

        local ex = graph[node]

        if type(ex) == 'table' and ex.op then
            visit(ex.left)
            visit(ex.right)
        end

        mark[node] = 'permanent'

        if type(ex) == 'table' and ex.op then
            order[#order + 1] = node
        end
    end

    while next(unmarked) do
        visit(next(unmarked))
    end

    return order
end

-----------------------------------------------------------------------

local Var = {}
Var.__index = Var

function Var.x()
    return setmetatable({variable='x'}, Var)
end

function Var.constant(value)
    return setmetatable({value=value}, Var)
end

function Var.arithmetic(left, op, right)
    return setmetatable({left=left, op=op, right=right}, Var)
end

function Var:__tostring()
    if self.variable then return self.variable end
    if self.value then return tostring(self.value) end
    return string.format('(%s %s %s)', self.left, self.op, self.right)
end

local function arithmetic(a, b, op)
    if type(a) ~= "table" then
        a = Var.constant(a)
    end

    if type(b) ~= "table" then
        b = Var.constant(b)
    end

    return Var.arithmetic(a, op, b)
end

function Var.__add(a, b)
    return arithmetic(a, b, '+')
end

function Var.__sub(a, b)
    return arithmetic(a, b, '-')
end

function Var.__mul(a, b)
    return arithmetic(a, b, '*')
end

function Var.__idiv(a, b)
    return arithmetic(a, b, '//')
end

--------------------------------------------------------------------------

local expressions = Dict.attach()

for line in io.lines('input21.txt') do
    local node, left, op, right = line:match '(%a+): (%a+) ([+*/-]) (%a+)'
    local expression

    if node then
        expression = Dict.attach{left=left, op=op, right=right}
    else
        node, left = line:match '(%a+): (%d+)'
        expression = tonumber(left)
    end

    expressions[node] = expression
end

expressions.humn = Var.x()
expressions.root.op = '='

local OPS = {
    ['+'] = function(l, r) return l + r end,
    ['*'] = function(l, r) return l * r end,
    ['/'] = function(l, r) return l // r end,
    ['-'] = function(l, r) return l - r end,
}

local INVERSE = {
    ['+'] = OPS['-'],
    ['-'] = OPS['+'],
    ['//'] = OPS['*'],
    ['*'] = OPS['/'],
}

local function solve(ex, result)
    print(ex, "must be", result)

    if ex.op then
        local op = INVERSE[ex.op]
        if ex.right.value then
            return solve(ex.left, op(result, ex.right.value))
        elseif ex.left.value then
            if ex.op == '-' then
                return solve(ex.right, -op(result, -ex.left.value))
            end
            return solve(ex.right, op(result, ex.left.value))
        end
    end

    if ex.variable == 'x' then return result end
end

OPS['='] = function(l, r) return solve(l, r) end

for _, key in ipairs(sort_topologically(expressions)) do
    local expression = expressions[key]
    local left = expressions[expression.left]
    local right = expressions[expression.right]

    expressions[key] = OPS[expression.op](left, right)
end

print(expressions.root)
