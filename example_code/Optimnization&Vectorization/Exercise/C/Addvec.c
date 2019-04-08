#include <stdio.h>
#include <sys/time.h>
#include <stdlib.h>
#include <math.h>
#define N 10000000
#define ITERMAX 100

inline double cpuTimer()
{
    struct timeval tp;
    gettimeofday(&tp, NULL);
    return ((double)tp.tv_sec + (double)tp.tv_usec * 1.e-6);
}
int main(void)
{
  int i,it;
  double a[N],b[N],c[N];
  double stime, etime;
  double dtime;
 
  for(i=0;i<N;i++){
    a[i]=(double)(rand())/RAND_MAX;
    b[i]=(double)(rand())/RAND_MAX;
  }

  stime=cpuTimer();
  for(it=0;it<ITERMAX;it++){
    for(i=0;i<N;i++)
      c[i]=a[i]+b[i];
  }
  etime=cpuTimer();
  dtime=etime-stime;
  printf("Elapsed Time : %12.5f\n",dtime);
  printf("c[1] : %f\n",c[0]);

  return 0;
}

