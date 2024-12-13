import fs from 'fs';

function solve(a, b, c, d, e, f) {
    const y = (b * e - a * f) / (b * c - a * d);
    const x = (e - c * y) / a;
    if (a * x + c * y === e && b * x + d * y === f) {
        if (Number.isInteger(x) && Number.isInteger(y) && x>=0 && y >=0) {
            return [x, y]
        } else {
            return null
        }
    } else {
        return null
    }
}

function minimizeCost(Ax, Ay, Bx, By, Px, Py) {
    const result = solve(Ax, Ay, Bx, By, Px, Py);
    
    if (result === null) {
        return null; 
    }

    let [nA, nB] = result;
    
    const cost = 3 * nA + nB;
    return cost;
}


let input = fs.readFileSync('/home/nuno/Advent-of-Code/2024/Day 13/input.txt', 'utf8').trim().split("\n\n");
let totalCost = 0;

const OFFSET = 10000000000000;

for (let machine of input) {
    let A = machine.match(/Button A: X\+(-?\d+), Y\+(-?\d+)/);
    let B = machine.match(/Button B: X\+(-?\d+), Y\+(-?\d+)/);
    let prize = machine.match(/Prize: X=(-?\d+), Y=(-?\d+)/);

    let ax = parseInt(A[1]), ay = parseInt(A[2]);
    let bx = parseInt(B[1]), by = parseInt(B[2]);
    let px = parseInt(prize[1]) + OFFSET, py = parseInt(prize[2]) + OFFSET;

    const cost = minimizeCost(ax, ay, bx, by, px, py);
    
    if (cost !== null) {
        totalCost += cost;
    }
}

console.log("Total Cost: ", totalCost);