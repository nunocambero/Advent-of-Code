local function getStones(stones)
    local newStones = {}
    for stone, amount in pairs(stones) do
        if stone == 0 then
            newStones[1] = (newStones[1] or 0) + amount
        elseif #tostring(stone) % 2 == 0 then
            local val = tostring(stone)
            local l = #val / 2
            local n1 = tonumber(val:sub(1, l))
            local n2 = tonumber(val:sub(l+1))
            newStones[n1] = (newStones[n1] or 0) + amount
            newStones[n2] = (newStones[n2] or 0) + amount
        else
            newStones[stone*2024] = (newStones[stone*2024] or 0) + amount
        end
    end
    return newStones
end

local inp = {}
for n in io.open("input.txt"):read():gmatch("%d+") do
    inp[tonumber(n)] = (inp[tonumber(n)] or 0) + 1
end

for _ = 1, 25 do
    inp = getStones(inp)
end

local sum = 0
for _, v in pairs(inp) do
    sum = sum + v
end
print(sum)