def find_x_mas(grid):
    rows, cols = len(grid), len(grid[0])
    count = 0
  
    patterns = [
        ('M', 'A', 'S', 'M', 'S'),
        ('S', 'A', 'M', 'S', 'M'),
        ('M', 'A', 'S', 'S', 'M'),
        ('S', 'A', 'M', 'M', 'S')
    ]

    for r in range(1, rows - 1):
        for c in range(1, cols - 1):
            for p in patterns:
                if (
                    grid[r - 1][c - 1] == p[0] and
                    grid[r][c] == p[1] and
                    grid[r + 1][c + 1] == p[2] and
                    grid[r - 1][c + 1] == p[3] and
                    grid[r + 1][c - 1] == p[4]
                ):
                    count += 1
                    break

    return count

with open("input.txt") as file:
    lines = file.readlines()

word_search = [list(line) for line in lines]

print(find_x_mas(word_search))