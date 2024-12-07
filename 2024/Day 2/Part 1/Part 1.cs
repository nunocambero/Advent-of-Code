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
                bool isSafe = true;
                int[] nums = line.Split(' ').Select(int.Parse).ToArray();
                bool isIncreasing = true;
                bool isDecreasing = true;
                for (int i = 0; i < nums.Length - 1; i++)
                {
                    if (Math.Abs(nums[i] - nums[i + 1]) > 3)
                    {
                        isSafe = false;
                        break;
                    }
                    if (nums[i] >= nums[i + 1])
                    {
                        isIncreasing = false;
                    }
                    if (nums[i] <= nums[i + 1])
                    {
                        isDecreasing = false;
                    }
                }
                if (!isIncreasing && !isDecreasing)
                {
                    isSafe = false;
                }
                if (isSafe)
                {
                    safeRegisters++;
                } 
            }
            Console.WriteLine($"Safe Registers: {safeRegisters}");
        }
    }
}