function Solvable {
	param (
		[int64]$sum,
		[int64[]]$numbers,
		[int]$index
	)
	if ($index -eq 0) {
		return $numbers[$index] -eq $sum
	}

	if ($index -lt 0 -or $sum -lt 0) {
		return $false
	}

	$num = $numbers[$index]
	$timeSolvable = $false
	if ($sum % $num -eq 0) {
		$timeSolvable = Solvable -sum ($sum / $num) -numbers $numbers -index ($index - 1)
	}

	return (Solvable -sum ($sum - $num) -numbers $numbers -index ($index - 1)) -or $timeSolvable
}

$inputFile = "input.txt"
$inputData = Get-Content -Path $inputFile

$totalSum = 0

foreach ($line in $inputData) {
	$parts = $line -split ':'
	$sum = [int64]$parts[0]
	$numbers = $parts[1] -split ' ' | ForEach-Object { [int64]$_ }
	$result = Solvable -sum $sum -numbers $numbers -index ($numbers.Length - 1)

	if ($result) {
		$totalSum += $sum
	}
}

Write-Output "Total Sum of Solvable Lines: $totalSum"