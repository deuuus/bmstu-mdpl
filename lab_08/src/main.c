#include <stdio.h>
#include "stdlib.h"
#include <string.h>

void asm_strcpy(char *dst, char *src, size_t len);

size_t asm_strlen(const char *str)
{
    size_t len = 0;
    __asm__(".intel_syntax noprefix\n\t"
            "xor rcx, rcx\n\t"
            "not rcx\n\t"
            "mov al, 0\n\t"
            "mov rdi, %1\n\t"
            "repne scasb\n\t"
            "not rcx\n\t"
            "dec rcx\n\t"
            "mov %0, rcx\n\t"
            : "=r"(len)
            : "r"(str) 
            : "rcx", "rdi", "al"
           );
    return len;
}

void test_strlen(void)
{
    char test_1[] = "";
    printf("TEST1: string = ''\n");
    printf("Library result: %zu\nAsm_strlen result: %zu\n", strlen(test_1), asm_strlen(test_1));
    printf("TEST1: ");
    strlen(test_1) == asm_strlen(test_1) ? printf("PASSED\n\n") : printf("FAILED\n\n");

    char test_2[] = "A";
    printf("TEST2: string = A\n");
    printf("Library result: %zu\nAsm_strlen result: %zu\n", strlen(test_2), asm_strlen(test_2));
    printf("TEST2: ");
    strlen(test_2) == asm_strlen(test_2) ? printf("PASSED\n\n") : printf("FAILED\n\n");

    char test_3[] = "ABCDEF";
    printf("TEST3: string = ABCDEF\n");
    printf("Library result: %zu\nAsm_strlen result: %zu\n", strlen(test_3), asm_strlen(test_3));
    printf("TEST3: ");
    strlen(test_3) == asm_strlen(test_3) ? printf("PASSED\n\n") : printf("FAILED\n\n");

    char test_4[] = "AB CD";
    printf("TEST4: string = AB CD\n");
    printf("Library result: %zu\nAsm_strlen result: %zu\n", strlen(test_4), asm_strlen(test_4));
    printf("TEST4: ");
    strlen(test_4) == asm_strlen(test_4) ? printf("PASSED\n\n") : printf("FAILED\n\n");
}

void test_strcpy(void)
{
    {
        char test_1d[] = "ABC";
        char test_s[] = "D";
        char test_2d[] = "ABC";
        printf("TEST1: dst_str = ABC, src_str = D, len = sizeof(src_str)\n");
        asm_strcpy(test_1d, test_s, sizeof(test_s));
        strcpy(test_2d, test_s);
        printf("Library result: %s\nAsm_ctrcpy_result: %s\n", test_2d, test_1d);
        printf("TEST1: ");
        !strcmp(test_1d, test_2d) ? printf("PASSED\n\n") : printf("FAILED\n\n");
    }

    {
        char test_1d[] = "ABC";
        char test_s[] = "DE";
        char test_2d[] = "ABC";
        printf("TEST2: dst_str = ABC, src_str = DE, len = sizeof(src_str)\n");
        asm_strcpy(test_1d, test_s, sizeof(test_s));
        strcpy(test_2d, test_s);
        printf("Library result: %s\nAsm_ctrcpy_result: %s\n", test_2d, test_1d);
        printf("TEST2: ");
        !strcmp(test_1d, test_2d) ? printf("PASSED\n\n") : printf("FAILED\n\n");
    }

    {
        char test_1[] = "ABCDEF";
        char test_2[] = "ABCDEF";
        printf("TEST3: dst_str = ABCDEF, src_str = dst_src + 3, len = 3\n");
        asm_strcpy(test_1, test_1 + 3, 3 + 1);
        strcpy(test_2, test_2 + 3);
        printf("Library result: %s\nAsm_ctrcpy_result: %s\n", test_1, test_2);
        printf("TEST3: ");
        !strcmp(test_1, test_2) ? printf("PASSED\n\n") : printf("FAILED\n\n");
    }

}

int main(void)
{
    test_strlen();
    test_strcpy();
    return EXIT_SUCCESS;
}