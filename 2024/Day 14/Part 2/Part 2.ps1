$WIDTH = 101
$HEIGHT = 103

$px = @()
$vx = @()
$py = @()
$vy = @()
$n = 0

function positive_mod {
    param ($x, $m)
    return ($x % $m) -lt 0 ? ($x % $m) + $m : $x % $m
}

function distance {
    param ($x1, $y1, $x2, $y2)
    return [math]::Sqrt(($x2 - $x1) * ($x2 - $x1) + ($y2 - $y1) * ($y2 - $y1))
}

function get_mean_dist {
    $sum = 0.0
    $count = 0

    for ($i = 0; $i -lt $n; $i++) {
        for ($j = $i + 1; $j -lt $n; $j++) {
            $sum += distance $px[$i] $py[$i] $px[$j] $py[$j]
            $count++
        }
    }

    return $sum / $count
}

$seconds = 0
$dist1 = 0.0
$dist2 = 0.0

$name = "C:\Users\Nuño\Advent of Code\2024\Day 14\Part 2\input.txt"
Get-Content $name | ForEach-Object {
    if ($_ -match "p=(\d+),(\d+) v=(\d+),(\d+)") {
        $px += [int]$matches[1]
        $py += [int]$matches[2]
        $vx += [int]$matches[3]
        $vy += [int]$matches[4]
        $n++
    }
}

$dist2 = get_mean_dist

do {
    $dist1 = $dist2
    $seconds++
    for ($i = 0; $i -lt $n; $i++) {
        $px[$i] = positive_mod ($px[$i] + $vx[$i]) $WIDTH
        $py[$i] = positive_mod ($py[$i] + $vy[$i]) $HEIGHT
    }
    $dist2 = get_mean_dist
} while ($dist2 -gt $dist1 * 0.6)

$bool = @()
for ($i = 0; $i -lt $WIDTH; $i++) {
    $bool += ,@(0) * $HEIGHT
}

for ($i = 0; $i -lt $n; $i++) {
    $bool[$px[$i]][$py[$i]] = 1
}

for ($j = 0; $j -lt $HEIGHT; $j++) {
    for ($i = 0; $i -lt $WIDTH; $i++) {
        if ($bool[$i][$j] -eq 1) {
            Write-Host -NoNewline "#"
        } else {
            Write-Host -NoNewline "."
        }
    }
    Write-Host ""
}

Write-Host $seconds