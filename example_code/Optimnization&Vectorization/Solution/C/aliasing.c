#include <stdio.h>
#include <stdlib.h>
#define N 10000
//void func(float* a, float* b, float* c)    {
void func(float* restrict a, float* restrict b, float* restrict c)    {
        int i;
        #pragma ivdep
        for(i=0; i<N; i++)
                a[i]=b[i]+c[i];
}

int main()
{
  int i;
  float a[N],b[N],c[N];

  for(i=0;i<N;i++){
    b[i]=(float)(rand())/RAND_MAX;
    c[i]=(float)(rand())/RAND_MAX;
  }

//  func(a,b,c);
  func(a+1,a,c);
  printf("%f\n",a[0]);  
}
