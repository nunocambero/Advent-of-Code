#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

int main() {
    ifstream file("C:\\Users\\Nuño\\Advent of Code\\2024\\Day 1\\input.txt");
    if (!file.is_open()) {
        cout << "File not found" << endl;
        return 1;
    }
    string line;
    vector<int> numbers1, numbers2;
    while (getline(file, line)) {
        numbers1.push_back(stoi(line.substr(0, line.find(' '))));
        numbers2.push_back(stoi(line.substr(line.find(' ') + 1)));
    }
    file.close();
    int simScore = 0;
    for (int & number1 : numbers1) {
        int count = 0;
        for (int & number2 : numbers2) {
            if (number1 == number2) {
                count++;
            }
        }
        simScore += number1 * count;
    }
    cout << "Similarity score: " << simScore << endl;

    return 0;
}