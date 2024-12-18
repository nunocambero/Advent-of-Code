#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define GRID_SIZE 71
#define MAX_BYTES 1024

int dx[] = {0, 0, -1, 1};
int dy[] = {-1, 1, 0, 0};

typedef struct {
    int x, y;
} Point;

typedef struct {
    Point points[GRID_SIZE * GRID_SIZE];
    int front, rear;
} Queue;

void initQueue(Queue *q) {
    q->front = 0;
    q->rear = 0;
}

void enqueue(Queue *q, int x, int y) {
    q->points[q->rear].x = x;
    q->points[q->rear].y = y;
    q->rear++;
}

Point dequeue(Queue *q) {
    return q->points[q->front++];
}

bool isEmpty(Queue *q) {
    return q->front == q->rear;
}

bool isValid(int x, int y, bool grid[GRID_SIZE][GRID_SIZE], bool visited[GRID_SIZE][GRID_SIZE]) {
    return x >= 0 && x < GRID_SIZE && y >= 0 && y < GRID_SIZE && !grid[y][x] && !visited[y][x];
}

int findShortestPath(bool grid[GRID_SIZE][GRID_SIZE]) {
    Queue q;
    initQueue(&q);

    bool visited[GRID_SIZE][GRID_SIZE] = {false};
    enqueue(&q, 0, 0);
    visited[0][0] = true;

    int steps = 0;
    while (!isEmpty(&q)) {
        int size = q.rear - q.front;
        for (int i = 0; i < size; i++) {
            Point current = dequeue(&q);
            int x = current.x;
            int y = current.y;

            if (x == GRID_SIZE - 1 && y == GRID_SIZE - 1) {
                return steps;
            }

            for (int d = 0; d < 4; d++) {
                int nx = x + dx[d];
                int ny = y + dy[d];
                if (isValid(nx, ny, grid, visited)) {
                    enqueue(&q, nx, ny);
                    visited[ny][nx] = true;
                }
            }
        }
        steps++;
    }
    return -1;
}

bool isPathExists(bool grid[GRID_SIZE][GRID_SIZE]) {
    Queue q;
    initQueue(&q);

    bool visited[GRID_SIZE][GRID_SIZE] = {false};
    enqueue(&q, 0, 0);
    visited[0][0] = true;

    while (!isEmpty(&q)) {
        Point current = dequeue(&q);
        int x = current.x;
        int y = current.y;

        if (x == GRID_SIZE - 1 && y == GRID_SIZE - 1) {
            return true;
        }

        for (int d = 0; d < 4; d++) {
            int nx = x + dx[d];
            int ny = y + dy[d];
            if (isValid(nx, ny, grid, visited)) {
                enqueue(&q, nx, ny);
                visited[ny][nx] = true;
            }
        }
    }
    return false;
}

int main() {
    bool grid[GRID_SIZE][GRID_SIZE] = {false};

    FILE *file = fopen("input.txt", "r");
    if (!file) {
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    int x, y;
    int byteCount = 0;
    Point firstBlockingByte = {-1, -1};
    bool pathExists = true;

    int shortestPathSteps = -1;
    while (fscanf(file, "%d,%d", &x, &y) == 2) {
        grid[y][x] = true;
        byteCount++;

        if (byteCount == MAX_BYTES) {
            shortestPathSteps = findShortestPath(grid);
        }

        pathExists = isPathExists(grid);
        if (!pathExists && firstBlockingByte.x == -1) {
            firstBlockingByte.x = x;
            firstBlockingByte.y = y;
        }
    }

    fclose(file);

    if (shortestPathSteps != -1) {
        printf("Part 1: Minimum steps to the exit: %d\n", shortestPathSteps);
    } else {
        printf("Part 1: No path to the exit after 1024 bytes.\n");
    }

    if (firstBlockingByte.x != -1) {
        printf("Part 2: First blocking byte: %d,%d\n", firstBlockingByte.x, firstBlockingByte.y);
    } else {
        printf("Part 2: No byte blocks the path.\n");
    }

    return 0;
}