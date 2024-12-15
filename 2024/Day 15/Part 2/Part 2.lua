robot_r, robot_c = -1, -1

function would_hit_wall(cr, cc)
    for _, wall in ipairs(walls) do
        if cr == wall[1] and cc == wall[2] then
            return true
        end
    end
    return false
end

function try_to_move()
    local new_r, new_c = robot_r + dr, robot_c + dc
    if would_hit_wall(new_r, new_c) then
        return
    end
    local box_in_way = nil
    for _, box in ipairs(boxes) do
        if new_r == box[1] and (new_c - box[2] == 0 or new_c - box[2] == 1) then
            box_in_way = box
            break
        end
    end
    if box_in_way == nil then
        robot_r, robot_c = new_r, new_c
        return
    end

    local boxes_can_move = true
    local boxes_to_examine = {box_in_way}
    local boxes_to_move = {}
    while #boxes_to_examine > 0 do
        local box = table.remove(boxes_to_examine, 1)
        if table_contains(boxes_to_move, box) then
            goto continue
        end
        if would_hit_wall(box[1] + dr, box[2] + dc) or would_hit_wall(box[1] + dr, box[2] + dc + 1) then
            boxes_can_move = false
            break
        end
        table.insert(boxes_to_move, box)
        for _, other_box in ipairs(boxes) do
            if table_contains(boxes_to_move, other_box) then
                goto continue
            end
            if box[1] + dr == other_box[1] and (box[2] + dc - other_box[2] == -1 or box[2] + dc - other_box[2] == 0 or box[2] + dc - other_box[2] == 1) then
                table.insert(boxes_to_examine, other_box)
            end
        end
        ::continue::
    end

    if boxes_can_move then
        robot_r, robot_c = new_r, new_c
        for _, box in ipairs(boxes_to_move) do
            box[1] = box[1] + dr
            box[2] = box[2] + dc
        end
    end
end

function table_contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

walls = {}
boxes = {}
directions = ""

found_blank_line = false
r = 0
file = io.open("input.txt", "r")
for line in file:lines() do
    line = line:gsub("\n", "")
    if line == "" then
        found_blank_line = true
        goto continue
    end
    if found_blank_line then
        directions = directions .. line
        goto continue
    end
    c = 0
    for character in line:gmatch(".") do
        if character == "@" then
            robot_r, robot_c = r, c
        end
        if character == "#" then
            table.insert(walls, {r, c})
            table.insert(walls, {r, c + 1})
        end
        if character == "O" then
            table.insert(boxes, {r, c})
        end
        c = c + 2
    end
    r = r + 1
    ::continue::
end
file:close()

for character in directions:gmatch(".") do
    dr, dc = -2, -2
    if character == "^" then
        dr, dc = -1, 0
    end
    if character == "v" then
        dr, dc = 1, 0
    end
    if character == "<" then
        dr, dc = 0, -1
    end
    if character == ">" then
        dr, dc = 0, 1
    end
    if dr == -2 then
        goto continue
    end
    try_to_move()
    ::continue::
end

total = 0
for _, box in ipairs(boxes) do
    total = total + 100 * box[1] + box[2]
end
print(total)