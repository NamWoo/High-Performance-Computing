#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define N 1000
#define ITERMAX 100

double Vecsum(double X[][N],int j);
double Vecprod(double X[][N],int j);

double WallTime()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME,&tp);
    return ((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}


int main(void)
{
  int i,j,it;
  double A[N], B[N][N],C[N][N],D[N][N];
  double stime,etime;
  double dtime,flops;

  for(i=0;i<N;i++){
    for(j=0;j<N;j++){
      B[i][j]=(double)(rand())/RAND_MAX;
      C[i][j]=(double)(rand())/RAND_MAX;
      D[i][j]=(double)(rand())/RAND_MAX;
    }
  }

  stime=WallTime();
  for(it=0;it<ITERMAX;it++){
    for(j=0;j<N;j++){
      A[j]=Vecsum(B,j)+Vecprod(C,j)*Vecsum(D,j);
    }
    if(it%100==0) printf("%f, %f, %f, %f\n",A[0],B[0][0],C[0][0],D[0][0]);
  }
  etime=WallTime();
  dtime=etime-stime;
  flops=(1.0e-6*(ITERMAX)*N*(3.0*N+2))/dtime;
  printf("loop time = %12.5f seconds\n",dtime);
  printf("loops runs at %15.5f MFLOPS\n",flops);
  return 0;
}

double Vecsum(double X[][N],int j)
{
  int i;
  double tmp;
  tmp=X[0][j];
  for(i=1;i<N;i++)
    tmp = tmp+X[j][i];
  return tmp;
}

double Vecprod(double X[][N],int j)
{
  int i;
  double tmp;
  tmp=X[0][j];
  for(i=1;i<N;i++)
    tmp=tmp+X[j][i];
  return tmp;
}
