$width = 101
$height = 103

function UpdatePosition {
    param (
        [int[]]$position,
        [int[]]$velocity
    )
    $newX = ($position[0] + $velocity[0]) % $width
    $newY = ($position[1] + $velocity[1]) % $height
    if ($newX -lt 0) { $newX += $width }
    if ($newY -lt 0) { $newY += $height }
    return @($newX, $newY)
}

$robots = @()
$inputData = Get-Content "input.txt"
foreach ($line in $inputData) {
    if ($line -match "p=(\d+),(\d+) v=(-?\d+),(-?\d+)") {
        $robots += @{
            p = [int[]]($matches[1], $matches[2])
            v = [int[]]($matches[3], $matches[4])
        }
    }
}

for ($i = 0; $i -lt 100; $i++) {
    foreach ($robot in $robots) {
        $robot.p = UpdatePosition $robot.p $robot.v
    }
}

$quadrantCounts = [int[]](0, 0, 0, 0)
foreach ($robot in $robots) {
    $x = $robot.p[0]
    $y = $robot.p[1]
    if ($x -ne [math]::Floor($width / 2) -and $y -ne [math]::Floor($height / 2)) {
        if ($x -lt [math]::Floor($width / 2) -and $y -lt [math]::Floor($height / 2)) {
            $quadrantCounts[0]++
        } elseif ($x -ge [math]::Floor($width / 2) -and $y -lt [math]::Floor($height / 2)) {
            $quadrantCounts[1]++
        } elseif ($x -lt [math]::Floor($width / 2) -and $y -ge [math]::Floor($height / 2)) {
            $quadrantCounts[2]++
        } elseif ($x -ge [math]::Floor($width / 2) -and $y -ge [math]::Floor($height / 2)) {
            $quadrantCounts[3]++
        }
    }
}

$safetyFactor = $quadrantCounts[0] * $quadrantCounts[1] * $quadrantCounts[2] * $quadrantCounts[3]
Write-Output "Safety Factor: $safetyFactor"