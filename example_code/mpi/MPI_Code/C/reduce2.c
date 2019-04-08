#include <stdio.h>
#include <mpi.h>
int main()
{
  int nrank,i;
  double A[3];
  struct ddt{
    double val;
    int rank;
  };
  struct ddt in[3],out[3];
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&nrank);
  if(nrank==0) A[0]=9, A[1]=5, A[2]=2;
  if(nrank==1) A[0]=8, A[1]=6, A[2]=1;
  if(nrank==2) A[0]=7, A[1]=4, A[2]=3;
  for(i=0;i<3;i++) in[i].val=A[i],  in[i].rank=nrank;
  MPI_Reduce(in,out,3,MPI_DOUBLE_INT,MPI_MAXLOC,0,MPI_COMM_WORLD);
  if(nrank==0){
    printf("max val : %.2f  %.2f  %2.f\n",out[0].val, out[1].val, out[2].val);
    printf("max rank: %d  %d  %d\n",out[0].rank, out[1].rank, out[2].rank);
  }
  MPI_Finalize();
  return 0;
}


