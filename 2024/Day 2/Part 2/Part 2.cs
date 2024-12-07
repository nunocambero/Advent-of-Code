using System;
using System.Linq;

namespace Day2
{
    class Program
    {
        static void Main(string[] args)
        {
            string filePath = "C:\\Users\\Nuño\\Advent of Code\\2024\\Day 2\\input.txt";
            if (!System.IO.File.Exists(filePath))
            {
                Console.WriteLine("File not found");
                return;
            }
            string[] lines = System.IO.File.ReadAllLines(filePath);
            int safeRegisters = 0;
            foreach (string line in lines)
            {
                int[] nums = line.Split(' ').Select(int.Parse).ToArray();
                if (nums.Length < 2) continue;
                bool isSafe = true;
                bool isIncreasing = true;
                bool isDecreasing = true;
                for (int i = 0; i < nums.Length - 1; i++)
                {
                    if (Math.Abs(nums[i] - nums[i + 1]) > 3)
                    {
                        isSafe = false;
                        break;
                    }
                    if (nums[i] >= nums[i + 1]) isIncreasing = false;
                    if (nums[i] <= nums[i + 1]) isDecreasing = false;
                }
                if (!isIncreasing && !isDecreasing) isSafe = false;
                if (!isSafe)
                {
                    bool canBeSafe = false;
                    for (int i = 0; i < nums.Length; i++)
                    {
                        var tempNums = nums.Where((_, index) => index != i).ToArray();
                        bool tempIncreasing = true;
                        bool tempDecreasing = true;
                        for (int j = 0; j < tempNums.Length - 1; j++)
                        {
                            if (Math.Abs(tempNums[j] - tempNums[j + 1]) > 3)
                            {
                                tempIncreasing = false;
                                tempDecreasing = false;
                                break;
                            }
                            if (tempNums[j] >= tempNums[j + 1]) tempIncreasing = false;
                            if (tempNums[j] <= tempNums[j + 1]) tempDecreasing = false;
                        }
                        if (tempIncreasing || tempDecreasing)
                        {
                            canBeSafe = true;
                            break;
                        }
                    }
                    isSafe = canBeSafe;
                }
                if (isSafe) safeRegisters++;
            }
            Console.WriteLine($"Safe Registers: {safeRegisters}");
        }
    }
}