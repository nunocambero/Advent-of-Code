#include <iostream>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <sstream>
#include <string>
#include <algorithm>
#include <fstream>

using namespace std;

bool isCorrectOrder(const vector<int>& update, const unordered_map<int, unordered_set<int>>& rules) {
    unordered_map<int, int> positions;
    for (int i = 0; i < update.size(); ++i) {
        positions[update[i]] = i;
    }
    for (const auto& rule : rules) {
        int before = rule.first;
        for (int after : rule.second) {
            if (positions.count(before) && positions.count(after) && positions[before] > positions[after]) {
                return false;
            }
        }
    }
    return true;
}

int main() {
    ifstream inputFile("C:\\Users\\Nuño\\Advent of Code\\2024\\Day 5\\input.txt");
    if (!inputFile.is_open()) {
        cerr << "Failed to open the file." << endl;
        return 1;
    }

    string line;
    unordered_map<int, unordered_set<int>> rules;
    vector<vector<int>> updates;
    bool readingRules = true;

    while (getline(inputFile, line)) {
        if (line.empty()) {
            readingRules = false;
            continue;
        }
        stringstream ss(line);
        if (readingRules) {
            int x, y;
            char sep;
            ss >> x >> sep >> y;
            rules[x].insert(y);
        } else {
            vector<int> update;
            int page;
            while (ss >> page) {
                if (ss.peek() == ',') ss.ignore();
                update.push_back(page);
            }
            updates.push_back(update);
        }
    }

    inputFile.close();

    int sum = 0;
    for (const auto& update : updates) {
        if (isCorrectOrder(update, rules)) {
            sum += update[update.size() / 2];
        }
    }

    cout << "Sum: " << sum << endl;
    return 0;
}
