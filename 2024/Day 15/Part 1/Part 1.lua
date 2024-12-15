local content = io.open("input.txt"):read("*all")
local warehouse_str, movements_str = content:match("^(.-)\n\n(.*)$")

local warehouse = {}
for line in warehouse_str:gmatch("[^\n]+") do
    local row = {}
    for char in line:gmatch(".") do
        table.insert(row, char)
    end
    table.insert(warehouse, row)
end

local movements = {}
for char in movements_str:gmatch(".") do
    table.insert(movements, char)
end

local function find_robot()
    for i, row in ipairs(warehouse) do
        for j, char in ipairs(row) do
            if char == "@" then
                return i, j
            end
        end
    end
end

local function move_robot(robot_i, robot_j, direction)
    local di, dj = 0, 0
    if direction == "^" then
        di = -1
    elseif direction == "v" then
        di = 1
    elseif direction == "<" then
        dj = -1
    elseif direction == ">" then
        dj = 1
    end

    local new_i, new_j = robot_i + di, robot_j + dj

    if warehouse[new_i][new_j] == "." then
        warehouse[robot_i][robot_j] = "."
        warehouse[new_i][new_j] = "@"
        return new_i, new_j
    elseif warehouse[new_i][new_j] == "O" then
        local next_i, next_j = new_i + di, new_j + dj
        local can_push = true

        while warehouse[next_i] and warehouse[next_i][next_j] == "O" do
            next_i, next_j = next_i + di, next_j + dj
        end

        if not (warehouse[next_i] and warehouse[next_i][next_j] == ".") then
            can_push = false
        end

        if can_push then
            local move_i, move_j = next_i - di, next_j - dj
            while warehouse[move_i] and warehouse[move_i][move_j] == "O" do
                warehouse[move_i + di][move_j + dj] = "O"
                warehouse[move_i][move_j] = "."
                move_i, move_j = move_i - di, move_j - dj
            end
            warehouse[robot_i][robot_j] = "."
            warehouse[new_i][new_j] = "@"
            return new_i, new_j
        end
    end

    return robot_i, robot_j
end

local robot_i, robot_j = find_robot()
for _, movement in ipairs(movements) do
    robot_i, robot_j = move_robot(robot_i, robot_j, movement)
end

local total = 0
for i, row in ipairs(warehouse) do
    for j, char in ipairs(row) do
        if char == "O" then
            total = total + (100 * (i - 1) + j - 1)
        end
    end
end

print(total)