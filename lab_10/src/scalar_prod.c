#include "scalar_prod.h"

float c_scalar_prod(const vector_t *a, const vector_t *b)
{
    assert(a && b);
    return (*a)[0] * (*b)[0] + (*a)[1] * (*b)[1] + (*a)[2] * (*b)[2] + (*a)[3] * (*b)[3];
}

float asm_scalar_prod(const vector_t *a, const vector_t *b)
{
    assert(a && b);
    float res = 0;
    __asm__(".intel_syntax noprefix\n\t"
            "movaps xmm0, %1\n\t"
            "movaps xmm1, %2\n\t"
            "mulps xmm0, xmm1\n\t"
            "movhlps xmm1, xmm0\n\t"
            "addps xmm0, xmm1\n\t"
            "movaps xmm1, xmm0\n\t"
            "shufps xmm0, xmm0, 1\n\t"
            "addps xmm0, xmm1\n\t"
            "movss %0, xmm0\n\t"
    :"=&m"(res)
    :"m"(*a), "m"(*b)
    :"xmm0", "xmm1");
    return res;
}

void testing(void)
{
    printf("\n::::::::::::::::::::::::TESTING::::::::::::::::::::::::\n");

    printf("\nTEST 1\n");
    {
        vector_t a = {1, 2, 3, 4};
        vector_t b = {5, 6, 7, 8};

        float true_res = 70;

        printf("%-30s", "C IMPLEMENTATION:");
        c_scalar_prod(&a, &b) == true_res ? printf("PASSED\n") : printf("FAILED\n");

        printf("%-35s", "ASM INSERTION:");
        asm_scalar_prod(&a, &b) == true_res ? printf("PASSED\n\n") : printf("FAILED\n\n");
    }

    printf("\nTEST 2\n");
    {
        vector_t a = {-1, -2, -3, -4};
        vector_t b = {5, 6, 7, 8};

        float true_res = -70;

        printf("%-30s", "C IMPLEMENTATION:");
        c_scalar_prod(&a, &b) == true_res ? printf("PASSED\n") : printf("FAILED\n");

        printf("%-35s", "ASM INSERTION:");
        asm_scalar_prod(&a, &b) == true_res ? printf("PASSED\n\n") : printf("FAILED\n\n");
    }

    printf("\nTEST 3\n");
    {
        vector_t a = {1, -2, 3, -4};
        vector_t b = {0, -6, 7, 8};

        float true_res = 1;

        printf("%-30s", "C IMPLEMENTATION:");
        c_scalar_prod(&a, &b) == true_res ? printf("PASSED\n") : printf("FAILED\n");

        printf("%-35s", "ASM INSERTION:");
        asm_scalar_prod(&a, &b) == true_res ? printf("PASSED\n\n") : printf("FAILED\n\n");
    }
}

void time_measuring(void)
{
    printf("\n::::::::::::::::::TIME MEASURING::::::::::::::::::\n\n");

    clock_t begin, end;
    
    vector_t a = {11, 22, 33, 44};
    vector_t b = {55, 66, 77, 88};

    printf("%-30s", "C IMPLEMENTATION: ");
    begin = clock();
    for (size_t i = 0; i < REPEATS; i++)
        c_scalar_prod(&a, &b);
    end = clock();

    printf("%.3g s\n", (double)(end - begin) / CLOCKS_PER_SEC / REPEATS);

    printf("%-35s", "ASM INSERTION: ");
    begin = clock();
    for (size_t i = 0; i < REPEATS; i++)
        asm_scalar_prod(&a, &b);
    end = clock();

    printf("%.3g s\n", (double)(end - begin) / CLOCKS_PER_SEC / REPEATS);
}