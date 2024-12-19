#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <unordered_set>
#include <sstream>
#include <algorithm>
#include <limits>

using namespace std;

unsigned long long countWaysToFormDesign(const string& design, const unordered_set<string>& towelPatterns) {
    int n = design.size();
    vector<unsigned long long> dp(n + 1, 0);
    dp[0] = 1;

    for (int i = 1; i <= n; ++i) {
        for (int j = 0; j < i; ++j) {
            string subPattern = design.substr(j, i - j);
            if (towelPatterns.find(subPattern) != towelPatterns.end()) {
                dp[i] += dp[j];
            }
        }
    }

    return dp[n];
}

int main() {
    ifstream inputFile("input.txt");
    if (!inputFile) {
        cerr << "Error opening input file" << endl;
        return 1;
    }

    string towelPatternsInput;
    getline(inputFile, towelPatternsInput);
    unordered_set<string> towelPatterns;
    stringstream ss(towelPatternsInput);
    string pattern;
    while (getline(ss, pattern, ',')) {
        pattern.erase(remove_if(pattern.begin(), pattern.end(), ::isspace), pattern.end());
        towelPatterns.insert(pattern);
    }

    vector<string> designs;
    string design;
    while (getline(inputFile, design)) {
        if (!design.empty()) {
            designs.push_back(design);
        }
    }

    inputFile.close();

    int possibleDesignsCount = 0;

    unsigned long long totalWays = 0;

    for (const string& design : designs) {
        unsigned long long ways = countWaysToFormDesign(design, towelPatterns);
        if (ways > 0) {
            ++possibleDesignsCount; 
        }
        totalWays += ways; 
    }

    cout << "Part One: Number of possible designs: " << possibleDesignsCount << endl;
    cout << "Part Two: Total number of ways: " << totalWays << endl;

    return 0;
}