#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#define N 1024
#define ND (N+1)

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
 
  for(i=0;i<N;i++){
    for(j=0;j<N;j++){
      a[i][j]=(double)(rand())/RAND_MAX;
      b[i][j]=(double)(rand())/RAND_MAX;
      c[i][j]=0.0;
    }
  }

  stime=WallTime();
  for(i=0;i<N;i++){
    for(j=0;j<N-3;j=j+4){
      c0=0.0, c1=0.0, c2=0.0, c3=0.0;
      for(k=0;k<N;k++){
        tmp=a[i][k];
        c0=c0+tmp*b[k][j];
        c1=c1+tmp*b[k][j+1];
        c2=c2+tmp*b[k][j+2];
        c3=c3+tmp*b[k][j+3];
      }
      c[i][j]=c[i][j]+c0;
      c[i][j+1]=c[i][j+1]+c1;
      c[i][j+2]=c[i][j+2]+c2;
      c[i][j+3]=c[i][j+3]+c3;
    }
  }
  etime=WallTime();
  dtime=etime-stime;
  printf("%f\n",c[1][1]);
  printf("Unroll+Padding(Opt) : %12.5f\n",dtime);
  return 0;
}

