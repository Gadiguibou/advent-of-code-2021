local function map(t, f)
    local res = {}
    for k, v in pairs(t) do
        res[k] = f(v)
    end
    return res
end

-- Does not preserve the keys of the original table
local function filter(t, f)
    local res = {}
    for k, v in pairs(t) do
        if f(v) then
            table.insert(res, v)
        end
    end
    return res
end

local function collect(iter)
    local res = {}
    for v in iter do
        table.insert(res, v)
    end
    return res
end

local function parseLine(line)
    local startX, startY, endX, endY = string.match(line, "(%d+),(%d+) %-> (%d+),(%d+)")
    return {{startX + 1, startY + 1}, {endX + 1, endY + 1}}
end

local function printGrid(grid)
    for _, row in pairs(grid) do
        for _, value in pairs(row) do
            io.write(value)
        end
        io.write("\n")
    end
    print()
end

local function applyHorizontalLines(grid, horizontalLinesCoordinates)
    for _, value in pairs(horizontalLinesCoordinates) do
        -- print(value[1][1], value[1][2], value[2][1], value[2][2])
        
        y = value[1][2]

        -- Initialize the row if it does not exist
        if not grid[y] then
            grid[y] = {}
        end

        local startX = math.min(value[1][1], value[2][1])
        local endX = math.max(value[1][1], value[2][1])
        
        -- Increment cells along the line
        for x = startX, endX do
            -- Initialize the cell if it isn't already
            if not grid[y][x] then
                grid[y][x] = 0
            end
            
            grid[y][x] = grid[y][x] + 1
        end
        -- printGrid(grid)
    end
end

local function applyVerticalLines(grid, verticalLinesCoordinates)
    for _, value in pairs(verticalLinesCoordinates) do
        -- print(value[1][1], value[1][2], value[2][1], value[2][2])
        x = value[1][1]

        local startY = math.min(value[1][2], value[2][2])
        local endY = math.max(value[1][2], value[2][2])

        -- Increment cells along the line
        for y = startY, endY do
            -- Initialize the row if it does not exist
            if not grid[y] then
                grid[y] = {}
            end
           
            -- Initialize the cell if it isn't already
            if not grid[y][x] then
                grid[y][x] = 0
            end

            grid[y][x] = grid[y][x] + 1
        end
        -- printGrid(grid)
    end
end

local function applyDiagonalLines(grid, diagonalLinesCoordinates)
    for _, value in pairs(diagonalLinesCoordinates) do
        -- print(value[1][1], value[1][2], value[2][1], value[2][2])
        local startX, startY, endX, endY = value[1][1], value[1][2], value[2][1], value[2][2]

        if startY > endY then
            startX, startY, endX, endY = endX, endY, startX, startY
        end

        if startX < endX then
            local x = startX
            local y = startY
            while x <= endX do
                -- Initialize the row if it does not exist
                if not grid[y] then
                    grid[y] = {}
                end

                -- Initialize the cell if it isn't already
                if not grid[y][x] then
                    grid[y][x] = 0
                end

                grid[y][x] = grid[y][x] + 1

                x = x + 1
                y = y + 1
            end
        else
            local x = startX
            local y = startY
            while x >= endX do
                -- Initialize the row if it does not exist
                if not grid[y] then
                    grid[y] = {}
                end

                -- Initialize the cell if it isn't already
                if not grid[y][x] then
                    grid[y][x] = 0
                end

                grid[y][x] = grid[y][x] + 1

                x = x - 1
                y = y + 1
            end
        end
        -- printGrid(grid)
    end
end

local function countOverlaps(grid)
    local overlapCount = 0

    for _, row in pairs(grid) do
        for _, value in pairs(row) do
            if value > 1 then
                overlapCount = overlapCount + 1
            end
        end
    end

    return overlapCount
end

local function part1(lines)
    local coordinates = map(lines, parseLine)

    local horizontalLinesCoordinates = filter(coordinates, function (coordinate)
        return coordinate[1][2] == coordinate[2][2]
    end)

    local verticalLinesCoordinates = filter(coordinates, function (coordinate)
        return coordinate[1][1] == coordinate[2][1]
    end)

    local grid = {}

    -- Initialize grid with 0s for debugging
    -- for i = 1, 10 do
    --     row = {}
    --     for j = 1, 10 do
    --         row[j] = 0
    --     end
    --     grid[i] = row
    -- end

    applyHorizontalLines(grid, horizontalLinesCoordinates)
    applyVerticalLines(grid, verticalLinesCoordinates)

    return countOverlaps(grid)
end

local function part2(lines)
    local coordinates = map(lines, parseLine)

    local horizontalLinesCoordinates = filter(coordinates, function (coordinate)
        return coordinate[1][2] == coordinate[2][2]
    end)

    local verticalLinesCoordinates = filter(coordinates, function (coordinate)
        return coordinate[1][1] == coordinate[2][1]
    end)

    local diagonalLinesCoordinates = filter(coordinates, function (coordinate)
        return coordinate[1][1] ~= coordinate[2][1] and coordinate[1][2] ~= coordinate[2][2]
    end)

    local grid = {}

    -- Initialize grid with 0s for debugging
    -- for i = 1, 10 do
    --     row = {}
    --     for j = 1, 10 do
    --         row[j] = 0
    --     end
    --     grid[i] = row
    -- end

    applyHorizontalLines(grid, horizontalLinesCoordinates)
    applyVerticalLines(grid, verticalLinesCoordinates)
    applyDiagonalLines(grid, diagonalLinesCoordinates)

    return countOverlaps(grid)
end

-- Exports
return {
    collect = collect,
    map = map,
    filter = filter,
    part1 = part1,
    part2 = part2
}
