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


double madd(double a, double b, double c)
{
  return (a=a+b*c);
}

int main(void)
{
  int i,j;
  const float c=0.125;
  double a[N][N],b[N][N];
  double stime, etime;
  double dtime;
 
  for(i=0;i<N;i++){
    for(j=0;j<N;j++){
      a[i][j]=(double)(rand())/RAND_MAX;
      b[i][j]=(double)(rand())/RAND_MAX;
    }
  }

  stime=WallTime();
// TODO
  etime=WallTime();
  dtime=etime-stime;
  printf("No Inline : %12.5f\n",dtime);


  stime=WallTime();
// TODO
  etime=WallTime();
  dtime=etime-stime;
  printf("Inline : %12.5f\n",dtime);
  return 0;
}

