var input = await File.ReadAllLinesAsync("input.txt");
 
var regA = long.Parse(input[0][12..]);
var regB = long.Parse(input[1][12..]);
var regC = long.Parse(input[2][12..]);
 
var program = input[4][9..].Split(',').Select(int.Parse).ToArray();
 
Console.WriteLine($"Part 1: {string.Join(',', ParseInstructions())}");
 
var variants = new PriorityQueue<int, long>();
variants.Enqueue(program.Length - 1, 0L);
 
while (variants.TryDequeue(out var offset, out var a))
{
    for (var i = 0; i < 8; i++)
    {
        var nextA = (a << 3) + i;
        regA = nextA;
        var output = ParseInstructions();
 
        if (output.SequenceEqual(program[offset..]))
        {
            if (offset == 0)
            {
                Console.WriteLine($"Part 2: {nextA}");
                return;
            }
            variants.Enqueue(offset - 1, nextA);
        }
    }
}
 
return;
 
List<int> ParseInstructions()
{
    var index = 0;
    var result = new List<int>();
 
    while (index < program.Length - 1)
    {
        var instruction = program[index];
        var opcode = program[index + 1];
        var nextIndex = index + 2;
 
        var combo = opcode switch
        {
            4 => regA,
            5 => regB,
            6 => regC,
            _ => opcode
        };

        Action action = instruction switch
        {
            0 => () => regA /= (long)Math.Pow(2, combo),
            1 => () => regB ^= opcode,
            2 => () => regB = combo % 8,
            3 when regA != 0 => () => nextIndex = opcode,
            4 => () => regB ^= regC,
            5 => () => result.Add((int)(combo % 8)),
            6 => () => regB = regA / (long)Math.Pow(2, combo),
            7 => () => regC = regA / (long)Math.Pow(2, combo),
            _ => () => { }
        };

        action();
        index = nextIndex;
    }
 
    return result;
}