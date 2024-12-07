def find_word(grid, word):
    def search(x, y, dx, dy):
        for k in range(len(word)):
            if not (0 <= x + k * dx < len(grid) and 0 <= y + k * dy < len(grid[0])):
                return False
            if grid[x + k * dx][y + k * dy] != word[k]:
                return False
        return True

    directions = [(1, 0), (0, 1), (1, 1), (1, -1), (-1, 0), (0, -1), (-1, -1), (-1, 1)]
    count = 0
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            for dx, dy in directions:
                if search(i, j, dx, dy):
                    count += 1
    return count

file = open("C:\\Users\\Nuño\\Advent of Code\\2024\\Day 4\\input.txt")
lines = file.read().split("\n")
count = 0

grid = [list(line) for line in lines]

print(find_word(grid, "XMAS"))
file.close()