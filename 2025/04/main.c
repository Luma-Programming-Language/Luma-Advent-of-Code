#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ROWS 200
#define MAX_COLS 200

int main() {
  FILE *file = fopen("input.txt", "r");
  if (!file) {
    perror("Error opening file");
    return 1;
  }

  char **grid = (char **)malloc(MAX_ROWS * sizeof(char *));
  for (int i = 0; i < MAX_ROWS; i++) {
    grid[i] = (char *)malloc(MAX_COLS * sizeof(char));
  }

  int rows = 0;
  int cols = 0;
  char line[MAX_COLS + 2];

  while (fgets(line, sizeof(line), file)) {
    int len = strlen(line);
    if (len > 0 && line[len - 1] == '\n') {
      line[len - 1] = '\0';
      len--;
    }
    if (len > 0) {
      strcpy(grid[rows], line);
      if (cols == 0)
        cols = len;
      rows++;
    }
  }
  fclose(file);

  int directions[8][2] = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1},
                          {0, 1},   {1, -1}, {1, 0},  {1, 1}};

  int total_removed = 0;
  int changed = 1;

  while (changed) {
    changed = 0;

    // Allocate to_remove array
    int **to_remove = (int **)malloc(rows * sizeof(int *));
    for (int r = 0; r < rows; r++) {
      to_remove[r] = (int *)calloc(cols, sizeof(int));
    }

    // Find all accessible rolls in this iteration
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] == '@') {
          int neighbor_count = 0;

          for (int d = 0; d < 8; d++) {
            int nr = r + directions[d][0];
            int nc = c + directions[d][1];

            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              if (grid[nr][nc] == '@') {
                neighbor_count++;
              }
            }
          }

          if (neighbor_count < 4) {
            to_remove[r][c] = 1;
            changed = 1;
          }
        }
      }
    }

    // Remove all accessible rolls
    int removed_this_round = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (to_remove[r][c]) {
          grid[r][c] = '.';
          removed_this_round++;
        }
      }
    }

    total_removed += removed_this_round;

    // Free to_remove array
    for (int r = 0; r < rows; r++) {
      free(to_remove[r]);
    }
    free(to_remove);
  }

  printf("Total rolls of paper removed: %d\n", total_removed);

  // Free grid
  for (int i = 0; i < MAX_ROWS; i++) {
    free(grid[i]);
  }
  free(grid);

  return 0;
}
