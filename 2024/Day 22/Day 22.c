#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <limits.h>

static inline int step(int n) {
    n = ((n << 6) ^ n) % 16777216;
    n = ((n >> 5) ^ n) % 16777216;
    n = (((n << 11) & INT_MAX) ^ n) % 16777216;
    return n;
}

int main() {
    unsigned long long ans1 = 0;

    FILE* inp = fopen("input.txt", "r");
    if (inp == NULL) {
        perror("Failed to open input file");
        return EXIT_FAILURE;
    }

    int d[130321] = {0};
    int seen_now[130321];

    char buf[20];

    while (fscanf(inp, "%s", buf) == 1) {
        int n = atoi(buf);
        int window = 0;
        for (int i = 0; i < 4; ++i) {
            int n_ = step(n);
            window = (window * 19 + (n_ % 10) - (n % 10) + 9) % 130321;
            n = n_;
        }

        memset(seen_now, 0, sizeof(seen_now));

        for (int i = 0; i < 1997; ++i) {
            if (i == 1996) {
                ans1 += (unsigned long long)n;
            }
            if (seen_now[window] == 0) {
                d[window] += n % 10;
                seen_now[window] = 1;
            }

            int n_ = step(n);
            window = (window * 19 + (n_ % 10) - (n % 10) + 9) % 130321;
            n = n_;
        }
    }

    fclose(inp);

    int ans2 = 0;
    for (int i = 0; i < 130321; ++i) {
        if (d[i] > ans2) {
            ans2 = d[i];
        }
    }
    printf("part 1: %llu\n", ans1);
    printf("part 2: %i\n", ans2);

    return 0;
}