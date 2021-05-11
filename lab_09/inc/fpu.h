#ifndef FPU_H
#define FPU_H

#include <stdio.h>
#include <time.h>
#include <math.h>

float sum_32bit(float a, float b);
float mul_32bit(float a, float b);
float asm_sum_32bit(float a, float b);
float asm_mul_32bit(float a, float b);
void print_32bit_result(void);

double sum_64bit(double a, double b);
double mul_64bit(double a, double b);
double asm_sum_64bit(double a, double b);
double asm_mul_64bit(double a, double b);
void print_64bit_result(void);

long double sum_80bit(long double a, long double b);
long double mul_80bit(long double a, long double b);
long double asm_sum_80bit(long double a, long double b);
long double asm_mul_80bit(long double a, long double b);
void print_80bit_result(void);

void sin_cmp(void);

#endif