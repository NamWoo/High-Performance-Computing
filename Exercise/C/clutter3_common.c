#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#define N 10000000
#define ITERMAX 10

double WallTime()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME,&tp);
    return ((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}

int main(void)
{
  int i,it;
  double A[N],B[N],x,y,z,r,tmp1,tmp2,tmp;
  double stime, etime;
  double dtime;
 
  for(i=0;i<N;i++){
    A[i]=(double)(rand())/RAND_MAX;
    B[i]=(double)(rand())/RAND_MAX;
  }
  
  stime=WallTime();
  for(it=0;it<ITERMAX;it++){
    r=(double)it;
    for(i=0;i<N;i++){
      x=r*sin(A[i])*cos(B[i]);
      y=r*sin(A[i])*sin(B[i]);
      z=r*cos(B[i]);
    }
  }
  etime=WallTime();
  dtime=etime-stime;
  printf("Common_Exp(No Opt) : %12.5f\n",dtime);


  stime=WallTime();
// TODO
  etime=WallTime();
  dtime=etime-stime;
  printf("Common_Exp(Opt) : %12.5f\n",dtime);


  stime=WallTime();
  for(it=0;it<ITERMAX;it++){
    x=1.0*it,    y=2.0*it;
    for(i=0;i<N;i++){
      A[i]=A[i]/sqrt(x*x+y*y);
    }
  }
  etime=WallTime();
  dtime=etime-stime;
  printf("Code Motion(No Opt) : %12.5f\n",dtime);

  stime=WallTime();
// TODO
  etime=WallTime();
  dtime=etime-stime;
  printf("Code Motion(Opt) : %12.5f\n",dtime);

  return 0;
}

