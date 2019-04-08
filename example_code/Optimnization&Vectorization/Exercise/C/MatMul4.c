#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#define N 1024
#define ND (N+1)
//#define ND (N)

double WallTime()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME,&tp);
    return ((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}

int main(void)
{
  int i,j,k;
  double c0,c1,c2,c3,tmp;
  double a[ND][ND],b[ND][ND],c[ND][ND];
  double stime, etime;
  double dtime;

   
  for(i=0;i<ND;i++){
    for(j=0;j<ND;j++){
      a[i][j]=(double)(rand())/RAND_MAX;
      b[i][j]=(double)(rand())/RAND_MAX;
      c[i][j]=0.0;
    }
  }

  stime=WallTime();
  for(i=0;i<N;i++){
    for(j=0;j<N;j++){
      for(k=0;k<N;k++){
        c[i][j]=c[i][j]+a[i][k]*b[k][j];
      }
    }
  }
  etime=WallTime();
  dtime=etime-stime;
  printf("%f\n",c[1][1]);
  printf("Padding code(Opt) : %12.5f\n",dtime);

  return 0;
}

