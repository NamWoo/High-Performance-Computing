#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#define N 1000000
#define ITERMAX 1000

double WallTime()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME,&tp);
    return ((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}

int main(void)
{
  int i,it;
  const float coeff=0.125;
  float a[N],b[N],c[N];
  double stime, etime;
  double dtime;
  double flops;
   
 
  for(i=0;i<N;i++){
    b[i]=(float)(rand())/RAND_MAX;
    c[i]=(float)(rand())/RAND_MAX;
  }

  stime=WallTime();
  for(it=0;it<ITERMAX;it++){
    for(i=0;i<N;i++){
      a[i]=b[i]+coeff*c[i];  
    }
  }
  etime=WallTime();
  dtime=etime-stime;
  flops=(1.0e-6*ITERMAX*2.0*N)/dtime;
  printf("loop time = %12.5f seconds\n",dtime);
  printf("loops runs at %15.5f MFLOPS\n",flops);
  printf("%f, %f, %f\n",a[0],b[0],c[0]);
  return 0;
}

