#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#define N (10000000+3)
#define ITERMAX 10

double WallTime()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME,&tp);
    return ((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}

int main(void)
{
  int i,ii,it;
  double A[N],B[N],c=12.5;
  double stime, etime;
  double dtime;
 
  for(i=0;i<N;i++){
    A[i]=(double)(rand())/RAND_MAX;
    B[i]=(double)(rand())/RAND_MAX;
  }
  
  stime=WallTime();
  for(it=0;it<ITERMAX;it++){
    for(i=0;i<N;i++){
      A[i]=A[i]+B[i]*c;
    }
  }
  etime=WallTime();
  dtime=etime-stime;
  printf("Unrolling(No Opt) : %12.5f\n",dtime);


  stime=WallTime();
// TODO
  etime=WallTime();
  dtime=etime-stime;
  printf("Unrolling(Opt) : %12.5f\n",dtime);

  return 0;
}

