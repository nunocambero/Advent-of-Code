use std::fs;

fn main() {
    let input = fs::read_to_string("input.txt").expect("Failed to read input file");
    let garden: Vec<Vec<char>> = input.lines().map(|line| line.chars().collect()).collect();
    let mut visited = vec![vec![false; garden[0].len()]; garden.len()];
    let mut total_price = 0;

    for i in 0..garden.len() {
        for j in 0..garden[0].len() {
            if !visited[i][j] {
                let (area, perimeter) = explore_region(&garden, &mut visited, i, j, garden[i][j]);
                total_price += area * perimeter;
            }
        }
    }

    println!("Total price: {}", total_price);
}

fn explore_region(garden: &Vec<Vec<char>>, visited: &mut Vec<Vec<bool>>, i: usize, j: usize, plant_type: char) -> (usize, usize) {
    let mut stack = vec![(i, j)];
    let mut area = 0;
    let mut perimeter = 0;
    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)];

    while let Some((x, y)) = stack.pop() {
        if visited[x][y] {
            continue;
        }
        visited[x][y] = true;
        area += 1;

        for &(dx, dy) in &directions {
            let nx = x as isize + dx;
            let ny = y as isize + dy;
            if nx >= 0 && ny >= 0 && nx < garden.len() as isize && ny < garden[0].len() as isize {
                let (nx, ny) = (nx as usize, ny as usize);
                if garden[nx][ny] == plant_type && !visited[nx][ny] {
                    stack.push((nx, ny));
                } else if garden[nx][ny] != plant_type {
                    perimeter += 1;
                }
            } else {
                perimeter += 1;
            }
        }
    }

    (area, perimeter)
}