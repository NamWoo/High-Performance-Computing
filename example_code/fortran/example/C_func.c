// File Name : C_func.c
#include <stdio.h>
typedef struct {
    int amount;
    float value;
} newtype;

void c(newtype *nt, int arr[3][2], float *a, float *b, char msg[])
{
    printf(" %d %f\n", nt->amount, nt->value);
    printf(" %d %d %d\n",arr[0][1], arr[1][0], arr[1][1]);
    printf(" %s \n",msg);
    *b = 2*(*a);
}

