#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <vector>
#include <algorithm>

using namespace std;

int main() {
    ifstream file("C:\\Users\\Universidad\\Advent of Code\\2024\\Day 1\\input.txt");
    if (!file.is_open()) {
        cout << "File not found" << endl;
        return 1;
    }

    vector<int> column1, column2;
    int num1, num2;

    while (file >> num1 >> num2) {
        column1.push_back(num1);
        column2.push_back(num2);
    }

    sort(column1.begin(), column1.end());
    sort(column2.begin(), column2.end());

    int totalDiff = 0;
    for (size_t i = 0; i < column1.size(); ++i) {
        totalDiff += abs(column1[i] - column2[i]);
    }
    cout << "Total difference: " << totalDiff << endl;
    file.close();
    return 0;
}