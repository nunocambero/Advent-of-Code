#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE* f = fopen("input.txt", "r");

    char content[30000];
    fread(content, 1, 30000, f);

    int len = strlen(content);

    int sum = 0;
    for (int i = 0; i < len - 4; i++) {
        if (strncmp(content + i, "mul(", 4) == 0) {
            i += 4;
            int x = 0;
            int y = 0;
            while (content[i] >= '0' && content[i] <= '9') {
               x *= 10;
               x += content[i] - '0';
               i ++;
            }
            if (content[i] == ',') {
                i ++;
                while (content[i] >= '0' && content[i] <= '9') {
                    y *= 10;
                    y += content[i] - '0';
                    i ++;
                }
            }
            if (content[i] != ')') {
                x = 0;
            }
            sum += x * y;
        }
    }

    printf("%d\n", sum);
}