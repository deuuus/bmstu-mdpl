#include "fpu.h"

double sum_64bit(double a, double b)
{
    return a + b;
}

double mul_64bit(double a, double b)
{
    return a * b;
}

double _asm_sum_64bit(double a, double b)
{
    double sum = 0.;
    __asm__(".intel_syntax noprefix\n\t"
            "fld %1\n\t"
            "fld %2\n\t"
            "faddp\n\t"
            "fstp %0\n\t"
            : "=&m" (sum)
            : "m" (a), "m" (b)
            );
    return sum;
}

double _asm_mul_64bit(double a, double b)
{
    double mul = 0.;
    __asm__(".intel_syntax noprefix\n\t"
            "fld %1\n\t"
            "fld %2\n\t"
            "fmulp\n\t"
            "fstp %0\n\t"
            : "=&m" (mul)
            : "m" (a), "m" (b)
            );
    return mul;
}

void print_64bit_result(void)
{
    printf("\n64bit:\n");

    double a = 1.232, b = 15e-5, res;
    int repeat = 1000;

    clock_t begin, end, total;

    begin = clock();
    for (int i = 0; i < repeat; i++)
        res += sum_64bit(a, b);
    end = clock();

    total = (double)(end - begin) / CLOCKS_PER_SEC / repeat;

    printf("%s %.3g\n", "(SUM): ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        mul_64bit(a, b);
    end = clock();

    total = (double)(end - begin) / CLOCKS_PER_SEC / repeat;

    printf("%s %.3g\n", "(MUL): ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        res += _asm_sum_64bit(a, b);
    end = clock();

    total = (double)(end - begin) / CLOCKS_PER_SEC / repeat;

    printf("%s %.3g\n", "(SUM) Assembly insertion: ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        _asm_mul_64bit(a, b);
    end = clock();

    total = (double)(end - begin) / CLOCKS_PER_SEC / repeat;

    printf("%s %.3g\n", "(MUL) Assembly insertion: ", total);
}