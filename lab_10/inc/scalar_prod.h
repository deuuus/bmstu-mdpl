#include <stdio.h>
#include <assert.h>
#include <time.h>

typedef float vector_t[4];

float c_scalar_prod(const vector_t *a, const vector_t *b);
float asm_scalar_prod(const vector_t *a, const vector_t *b);

#define REPEATS 10000000
void testing(void);
void time_measuring(void);