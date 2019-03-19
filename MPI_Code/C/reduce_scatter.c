#include <stdio.h>
#include <mpi.h>
int main()
{
  int sendbuf[6]={1,2,2,3,3,3}, recvbuf[3]={0,}, recvcnt[3]={1,2,3};
  int myrank;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  MPI_Reduce_scatter(sendbuf,recvbuf,recvcnt,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
  printf("myrank: %d recvbuf=%d   %d   %d\n",myrank,recvbuf[0],recvbuf[1],recvbuf[2]);
  MPI_Finalize();
  return 0;
}
