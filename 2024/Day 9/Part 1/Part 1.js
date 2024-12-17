import fs from 'fs';

function compactDiskMap(input) {
    let disk = [], num = 0;
    for (let i = 0; i < input.length; i++) {
        if (i % 2 == 0) {
            for (let j = 0; j < input[i]; j++) disk.push(num);
            num++;
        } else for (let j = 0; j < input[i]; j++) disk.push(".");
    }

    for (let i = disk.length - 1; i >= 0; i--) {
        if (disk[i] == "." || disk.indexOf(".") > i) continue;
        disk[disk.indexOf(".")] = disk[i];
        disk[i] = ".";
    }

    let checksum = 0;
    for (let i = 0; i < disk.length; i++)
        if (disk[i] != ".") checksum += i * disk[i];

    return checksum;
}

let input = fs.readFileSync('input.txt', 'utf8').split("").map(x => +x);
console.log(compactDiskMap(input));
