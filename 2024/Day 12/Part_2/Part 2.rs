use std::fs::read_to_string;

fn main() {
    let input = read_input("input.txt");
    let (coord_map, letter_map) = build_maps(&input);
    let mut visited = Vec::new();
    let mut result = 0;

    for (y, line) in input.iter().enumerate() {
        for (x, _) in line.chars().enumerate() {
            let coord = (x as i32, y as i32);
            if visited.contains(&coord) {
                continue;
            }
            let letter = coord_map.iter().find(|&&(c, _)| c == coord).unwrap().1;
            result += calculate_region(x as i32, y as i32, letter, &coord_map, &letter_map, &mut visited);
        }
    }

    println!("Result: {}", result);
}

fn read_input(filename: &str) -> Vec<String> {
    let content = read_to_string(filename).expect("Failed to read file");
    content.lines().map(|line| line.trim().to_string()).collect()
}

fn build_maps(input: &[String]) -> (Vec<((i32, i32), char)>, Vec<(char, Vec<(i32, i32)>)>) {
    let mut coord_map = Vec::new();
    let mut letter_map: Vec<(char, Vec<(i32, i32)>)> = Vec::new();

    for (y, line) in input.iter().enumerate() {
        for (x, c) in line.chars().enumerate() {
            let coord = (x as i32, y as i32);
            coord_map.push((coord, c));
            if let Some(entry) = letter_map.iter_mut().find(|entry| entry.0 == c) {
                entry.1.push(coord);
            } else {
                letter_map.push((c, vec![coord]));
            }
        }
    }

    (coord_map, letter_map)
}

fn calculate_region(
    x: i32,
    y: i32,
    letter: char,
    _coord_map: &Vec<((i32, i32), char)>,
    letter_map: &Vec<(char, Vec<(i32, i32)>)>,
    visited: &mut Vec<(i32, i32)>,
) -> i32 {
    let mut core = Vec::new();
    let mut border = Vec::new();
    border.push((x, y));
    let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)];
    let mut vertical_sides = Vec::new();
    let mut horizontal_sides = Vec::new();

    while let Some((x, y)) = border.pop() {
        if visited.contains(&(x, y)) {
            continue;
        }
        visited.push((x, y));
        if core.contains(&(x, y)) {
            continue;
        }
        core.push((x, y));

        for &(dx, dy) in &directions {
            let new_loc = (x + dx, y + dy);
            let letter_coords = letter_map.iter().find(|&&(l, _)| l == letter).unwrap().1.clone();
            if !letter_coords.contains(&new_loc) {
                if dx == 0 {
                    horizontal_sides.push((y as f32 + (dy as f32 / 2.0), x, dy));
                } else {
                    vertical_sides.push((x as f32 + (dx as f32 / 2.0), y, dx));
                }
            }
            if letter_coords.contains(&new_loc) && !core.contains(&new_loc) {
                border.push(new_loc);
            }
        }
    }

    clean_sides(&mut vertical_sides);
    clean_sides(&mut horizontal_sides);

    let area = core.len() as i32;
    let sides = vertical_sides.len() as i32 + horizontal_sides.len() as i32;
    area * sides
}

fn clean_sides(sides: &mut Vec<(f32, i32, i32)>) {
    sides.sort_by(|a, b| a.partial_cmp(b).unwrap());
    for i in (1..sides.len()).rev() {
        let current = sides[i];
        let previous = sides[i - 1];
        if previous.0 == current.0 && previous.1 == current.1 - 1 && previous.2 == current.2 {
            sides.remove(i);
        }
    }
}