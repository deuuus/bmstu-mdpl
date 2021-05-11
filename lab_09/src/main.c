#include "fpu.h"

int main(void)
{
    print_32bit_result();
    print_64bit_result();
    #ifndef X87
    print_80bit_result();
    #endif

    sin_cmp();

    return 0;
}