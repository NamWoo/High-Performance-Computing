#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#define N 10000

double WallTime()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME,&tp);
    return ((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}

int main(void)
{
  int i,j,ITERMAX=1000;
  const float c=0.125;
  double a[N][N],b[N][N],aa[N],bb[N];
  double stime, etime;
  double dtime;
 
  for(i=0;i<N;i++){
    for(j=0;j<N;j++){
      a[i][j]=(double)(rand())/RAND_MAX;
      b[i][j]=(double)(rand())/RAND_MAX;
    }
    aa[i]=(double)(rand())/RAND_MAX;
    bb[i]=(double)(rand())/RAND_MAX;
  }

  stime=WallTime();
  for(j=0;j<ITERMAX;j++){
    for(i=0;i<N;i++){
      if(ITERMAX !=0){
        aa[i]=aa[i]+bb[i]*c;
      }else{
        aa[i]=aa[i]-bb[i]*c;
      }
    }
  }
  etime=WallTime();
  dtime=etime-stime;
  printf("Loop Invariant condition(No Opt) : %12.5f\n",dtime);


  stime=WallTime();
// TODO
  etime=WallTime();
  dtime=etime-stime;
  printf("Loop Invariant condition(Opt) : %12.5f\n",dtime);

  stime=WallTime();
  for(i=0;i<N;i++){
    for(j=0;j<N;j++){
      if(j<i) a[i][j]=a[i][j]+b[i][j]*c;
      else    a[i][j]=a[i][j]-b[i][j]*c;
    }
  }
  etime=WallTime();
  dtime=etime-stime;
  printf("Loop Index dependent condition(No Opt) : %12.5f\n",dtime);


  stime=WallTime();
// TODO
  etime=WallTime();
  dtime=etime-stime;
  printf("Loop index dependent condition(Opt) : %12.5f\n",dtime);

  return 0;
}

