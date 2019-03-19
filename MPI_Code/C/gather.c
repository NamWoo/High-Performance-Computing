#include <stdio.h>
#include "mpi.h"
int main()
{
  int isend,irecv[4]={0,},recvdata[4]={0,},nprocs,nrank;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&nrank);
  MPI_Comm_size(MPI_COMM_WORLD,&nprocs);
  isend=nrank+1;
  printf("rank: %d, isend:%d\n",nrank,isend);
  MPI_Gather(&isend,1,MPI_INT,irecv,1,MPI_INT,0,MPI_COMM_WORLD);
  if(nrank==0) printf("rank:%d  irecv=%d  %d  %d  %d\n",nrank,irecv[0],irecv[1],irecv[2],irecv[3]);
  isend *=10;
  if(nrank==nprocs-1){
    recvdata[nrank]=isend;
    MPI_Gather(MPI_IN_PLACE,1,MPI_INT,recvdata,1,MPI_INT,nprocs-1,MPI_COMM_WORLD);
  } else {
    MPI_Gather(&isend,1,MPI_INT,recvdata,1,MPI_INT,nprocs-1,MPI_COMM_WORLD);
  }
  if(nrank==nprocs-1) printf("RECVDATA:%d  %d  %d  %d\n",recvdata[0], recvdata[1], recvdata[2], recvdata[3]);
  MPI_Finalize();
  return 0;
}
