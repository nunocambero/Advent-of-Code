package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strings"
)

type directedPoint struct {
	point     point
	direction direction
}

type direction rune

const (
	north direction = '^'
	east  direction = '>'
	south direction = 'v'
	west  direction = '<'
)

type point struct {
	x int
	y int
}

const (
	wall = '#'
	path = '.'
)

func main() {
	input, err := os.ReadFile("input.txt")
	if err != nil {
		log.Fatalf("failed to read input file: %v", err)
	}
	lines := strings.Split(string(input), "\n")
	reindeer, end, maze := parse(lines)
	bestScore, steps, bestPath := findBestRoute(reindeer, end, maze)
	printMaze(maze, bestPath)

	fmt.Println()
	fmt.Printf("Score: %d | Steps: %d", bestScore, steps)
}

type routeState struct {
	reindeer directedPoint
	steps    []directedPoint
	score    int
}

func findBestRoute(reindeer directedPoint, end point, maze [][]rune) (bestScore int, totalSteps int, bestPath []directedPoint) {
	bestScore = math.MaxInt
	queue := []routeState{{reindeer, []directedPoint{reindeer}, 0}}
	visited := make(map[directedPoint]int)
	bestRoutes := make(map[int][]directedPoint)

	for len(queue) > 0 {
		state := queue[0]
		queue = queue[1:]

		if len(state.steps) > 10000 {
			continue
		}

		if state.score > bestScore {
			continue
		}

		if state.reindeer.point == end {
			if state.score <= bestScore {
				bestRouteTmp := bestRoutes[state.score]
				bestRouteTmp = append(bestRouteTmp, state.steps...)
				bestRoutes[state.score] = bestRouteTmp
				bestScore = state.score
				bestPath = state.steps
				continue
			}
		}

		for _, candidate := range getOffsets(state.reindeer) {
			if maze[candidate.point.y][candidate.point.x] == path {
				score := state.score + 1
				if state.reindeer.direction != candidate.direction {
					score += 1000
				}

				if previous, found := visited[candidate]; found {
					if previous < score {
						continue
					}
				}
				visited[candidate] = score

				newSteps := make([]directedPoint, len(state.steps))
				copy(newSteps, state.steps)

				queue = append(queue, routeState{
					reindeer: candidate,
					steps:    append(newSteps, candidate),
					score:    score})
			}
		}
	}

	buffer := make(map[point]int)
	for _, v := range bestRoutes[bestScore] {
		buffer[v.point]++
	}

	return bestScore, len(buffer), bestPath
}

func getOffsets(reindeer directedPoint) []directedPoint {
	n := directedPoint{point{x: reindeer.point.x + 0, y: reindeer.point.y - 1}, north}
	e := directedPoint{point{x: reindeer.point.x + 1, y: reindeer.point.y + 0}, east}
	s := directedPoint{point{x: reindeer.point.x + 0, y: reindeer.point.y + 1}, south}
	w := directedPoint{point{x: reindeer.point.x - 1, y: reindeer.point.y + 0}, west}

	switch reindeer.direction {
	case north:
		return []directedPoint{n, e, w}
	case east:
		return []directedPoint{e, s, n}
	case south:
		return []directedPoint{s, w, e}
	case west:
		return []directedPoint{w, n, s}
	}

	panic("Reindeer facing unknown direction.")
}

func parse(input []string) (reindeer directedPoint, end point, maze [][]rune) {
	maze = [][]rune{}

	for y, line := range input {
		maze = append(maze, []rune{})
		for x, r := range line {
			switch r {
			case wall:
				maze[y] = append(maze[y], r)
			case path:
				maze[y] = append(maze[y], r)
			case 'S':
				reindeer = directedPoint{point{x, y}, east}
				maze[y] = append(maze[y], path)
			case 'E':
				end = point{x, y}
				maze[y] = append(maze[y], path)
			}
		}
	}

	return reindeer, end, maze
}

func printMaze(maze [][]rune, path []directedPoint) {
	const (
		reset = "\033[0m"
		red   = "\033[31m"
	)

	for _, step := range path {
		maze[step.point.y][step.point.x] = '*'
	}
	for _, row := range maze {
		for _, cell := range row {
			if cell == '*' {
				fmt.Print(red + string(cell) + reset)
			} else {
				fmt.Print(string(cell))
			}
		}
		fmt.Println()
	}
}
