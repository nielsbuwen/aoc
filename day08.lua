local function print_grid(g)
    local total_visible = 0

    for _, row in ipairs(g) do
        for _, t in ipairs(row) do
            if t.visible then
                io.write("(")
                io.write(t.height)
                total_visible = total_visible + 1
                io.write(")")
            else
                io.write(" ")
                io.write(t.height)
                io.write(" ")
            end
        end
        print()
    end
    print()

    return total_visible
end

local function load_grid()
    local grid = {}

    for line in io.lines('input08.txt') do
        local row = {}
        grid[#grid + 1] = row

        for i in line:gmatch '.' do
            row[#row + 1] = {
                height=tonumber(i),
                visible=false,
            }
        end

        grid.width = #row
    end
    grid.height = #grid
    return grid
end

local function update_visibility(tree, highest)
    if tree.height > highest then
        tree.visible = true
        return tree.height
    end

    return highest
end

local function see_horizontally(grid)
    for _, row in ipairs(grid) do
        local highest = -1

        for i = 1, #row do
            highest = update_visibility(row[i], highest)
        end

        highest = -1
        for i = #row, 1, -1 do
            highest = update_visibility(row[i], highest)
        end
    end
end

local function see_vertically(grid)
    for c = 1, grid.width do
        local highest = -1

        for r = 1, grid.height do
            highest = update_visibility(grid[r][c], highest)
        end

        highest = -1
        for r = grid.height, 1, -1 do
            highest = update_visibility(grid[r][c], highest)
        end
    end

end

local function scenic_score(grid, i, j)
    local center = grid[i][j]
    local score = 1

    local view = 0
    for y = i - 1, 1, -1 do
        view = view + 1
        if grid[y][j].height >= center.height then
            break
        end
    end
    score = score * view

    view = 0
    for y = i + 1, grid.height do
        view = view + 1
        if grid[y][j].height >= center.height then
            break
        end
    end
    score = score * view

    view = 0
    for x = j - 1, 1, -1 do
        view = view + 1
        if grid[i][x].height >= center.height then
            break
        end
    end
    score = score * view

    view = 0
    for x = j + 1, grid.width do
        view = view + 1
        if grid[i][x].height >= center.height then
            break
        end
    end
    score = score * view

    return score
end

local forest = load_grid()
see_horizontally(forest)
see_vertically(forest)

local total = print_grid(forest)
print("total", total)


local best = 0
for i = 1, forest.height do
    for j = 1, forest.width do
        local current = scenic_score(forest, i, j)
        if current > best then
            best = current
        end
    end
end
print("best", best)

