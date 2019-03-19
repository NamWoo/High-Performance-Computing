#include <stdio.h>
#include "mpi.h"
int main()
{
  int myrank, A[4]={0,},B[4]={0,},inext,iprev, i;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  A[myrank]=myrank+1;
  inext=myrank+1,   iprev=myrank-1;
  if(myrank==0) iprev=3;
  if(myrank==3) inext=0;
  if(myrank==0) printf("Before\n");
  for(i=0;i<4;i++)
    if(myrank==i) printf("Myrank: %d, A=%d %d %d %d\n",myrank,A[0],A[1],A[2],A[3]);
  MPI_Sendrecv(&A[myrank],1,MPI_INT,inext,0,&B[myrank],1,MPI_INT,iprev,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);

  if(myrank==0) printf("After\n");
  for(i=0;i<4;i++)
    if(myrank==i) printf("Myrank: %d, B=%d %d %d %d\n",myrank,B[0],B[1],B[2],B[3]);
  MPI_Finalize();
  return 0;
}
