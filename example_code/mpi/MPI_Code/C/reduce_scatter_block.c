#include <stdio.h>
#include <mpi.h>
int main()
{ 
  int myrank,sendbuf[3]={1,2,3}, recvbuf,RECVBUF1[3]={1,2,3};
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  MPI_Reduce_scatter_block(sendbuf,&recvbuf,1,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
  printf("myrank: %d,  recvbuf=%d\n",myrank,recvbuf);

  MPI_Reduce_scatter_block(MPI_IN_PLACE,RECVBUF1,1,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
  printf("myrank: %d,  RECVBUF=%d\n",myrank,RECVBUF1[0]);
  MPI_Finalize();
  return 0;
}
