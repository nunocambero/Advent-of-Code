$inputFile = "C:\Users\Nuño\Advent of Code\2024\Day 7\input.txt"
$lines = Get-Content $inputFile

function Split-Numbers {
    param (
        [Int64]$x,
        [Int64]$y
    )
    $digits = [math]::Floor([math]::Log10([math]::Abs([double]$y))) + 1
    return [math]::Floor($x / [math]::Pow(10, $digits))
}

function Get-LastNDigits {
    param (
        [Int64]$x,
        [Int64]$n
    )
    $digits = [math]::Floor([math]::Log10([math]::Abs([double]$n))) + 1
    return $x % [math]::Pow(10, $digits)
}

function Solvable {
    param (
        [bigint]$sum,
        [bigint[]]$numbers,
        [int]$index
    )
    if ($index -eq 0) {
        return ($numbers[$index] -eq $sum)
    }

    if ($index -lt 0 -or $sum -lt 0) {
        return $false
    }

    $num = $numbers[$index]
    $timeSolvable = $false
    if ($sum % $num -eq 0) {
        $timeSolvable = Solvable -sum ($sum / $num) -numbers $numbers -index ($index - 1)
    }

    $concatSolvable = $false
    if ((Get-LastNDigits -x $sum -n $num) -eq $num) {
        $concatSolvable = Solvable -sum (Split-Numbers -x $sum -y $num) -numbers $numbers -index ($index - 1)
    }

    return (Solvable -sum ($sum - $num) -numbers $numbers -index ($index - 1)) -or $timeSolvable -or $concatSolvable
}

$totalSum = [bigint]0
foreach ($line in $lines) {
    $parts = $line -split ": "
    $sum = [bigint]$parts[0]
    $numbers = $parts[1] -split " " | ForEach-Object { [bigint]$_ }
    $index = $numbers.Length - 1
    $result = Solvable -sum $sum -numbers $numbers -index $index

    if ($result) {
        $totalSum += $sum
    }
}

Write-Output "Total Sum of Solvable Lines: $totalSum"