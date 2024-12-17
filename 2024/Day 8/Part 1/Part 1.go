package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	filename := "input.txt"
	var result int64
	part := 1
	var grid [55][55]byte
	var nodes [55][55]byte
	size := 0

	file, err := os.Open(filename)
	if err != nil {
		fmt.Printf("error opening file %s\n", filename)
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		copy(grid[size][:], scanner.Text())
		size++
	}

	for x := 0; x < size; x++ {
		for y := 0; y < size; y++ {
			if grid[x][y] != '.' {
				for x2 := x; x2 < size; x2++ {
					for y2 := 0; y2 < size; y2++ {
						if x2 == x && y2 <= y {
							continue
						}
						if grid[x][y] == grid[x2][y2] {
							slopex := x2 - x
							slopey := y2 - y
							if part == 1 {
								if (x-slopex < size) && (x-slopex >= 0) && (y-slopey < size) && (y-slopey >= 0) {
									nodes[x-slopex][y-slopey] = 1
								}
								if (x2+slopex < size) && (x2+slopex >= 0) && (y2+slopey < size) && (y2+slopey >= 0) {
									nodes[x2+slopex][y2+slopey] = 1
								}
							} else {
								for i := 0; (x-(slopex*i) < size) && (x-(i*slopex) >= 0) && (y-(i*slopey) < size) && (y-(i*slopey) >= 0); i++ {
									nodes[x-(i*slopex)][y-(i*slopey)] = 1
								}
								for i := 1; (x+(slopex*i) < size) && (x+(i*slopex) >= 0) && (y+(i*slopey) < size) && (y+(i*slopey) >= 0); i++ {
									nodes[x+(i*slopex)][y+(i*slopey)] = 1
								}
							}
						}
					}
				}
			}
		}
	}

	for x := 0; x < size; x++ {
		for y := 0; y < size; y++ {
			result += int64(nodes[x][y])
		}
	}
	fmt.Println(result)
}
