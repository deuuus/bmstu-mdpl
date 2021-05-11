#include "fpu.h"

void sin_cmp(void)
{
    printf("\nSIN_CMP\n");

    printf("\nsin(pi)\n\n");
    printf("Lib sin(3.14) = %.3g\n", sin(3.14));
    printf("Lib sin(3.141596) = %.3g\n", sin(3.141596));

    //#ifndef X87
    double res = 0;
    __asm__(".intel_syntax noprefix\n\t"
        "fldpi\n\t"
        "fsin\n\t"
        "fstp %0\n\t"
        : "=&m"(res));
    printf("Asm sin(3.14) = %.3g\n", res);
   // #endif

    printf("\nsin(pi / 2)\n\n");
    printf("Lib sin(3.14 / 2) = %.3g\n", sin(3.14 / 2.));
    printf("Lib sin(3.141596 / 2) = %.3g\n", sin(3.141596 / 2.));

    res = 1.0;
    __asm__(".intel_syntax noprefix\n\t"
            "fldpi\n\t"
            "fld1\n\t"
            "fld1\n\t"
            "faddp\n\t"
            "fdivp\n\t"
            "fsin\n\t"
            "fstp %0\n\t"
    :"=m"(res));
    printf("Asm sin(3.141596 / 2) = %.3g\n", res);
}