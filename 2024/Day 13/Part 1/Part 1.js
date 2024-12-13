import fs from 'fs';

let input = fs.readFileSync('/home/nuno/Advent-of-Code/2024/Day 13/input.txt', 'utf8').trim().split("\n\n");
let totalCost = 0;

for (let machine of input) {
    let A = machine.match(/Button A: X\+(-?\d+), Y\+(-?\d+)/);
    let B = machine.match(/Button B: X\+(-?\d+), Y\+(-?\d+)/);
    let prize = machine.match(/Prize: X=(-?\d+), Y=(-?\d+)/);

    let ax = parseInt(A[1]), ay = parseInt(A[2]);
    let bx = parseInt(B[1]), by = parseInt(B[2]);
    let px = parseInt(prize[1]), py = parseInt(prize[2]);

    let minCost = Infinity;

    for (let nA = 0; nA <= 100; nA++) {
        for (let nB = 0; nB <= 100; nB++) {
            let x = nA * ax + nB * bx;
            let y = nA * ay + nB * by;

            if (x === px && y === py) {
                let cost = 3 * nA + nB;
                minCost = Math.min(minCost, cost);
            }
        }
    }

    if (minCost !== Infinity) {
        totalCost += minCost;
    }
}

console.log("Total Cost: ", totalCost);
