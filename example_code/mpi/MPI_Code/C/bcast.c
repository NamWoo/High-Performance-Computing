#include "stdio.h"
#include <mpi.h>
int main()
{
  int i, nrank,nprocs, ROOT=0;
  int buf[4]={0,}, buf2[4]={0,};
  MPI_Request req;

  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&nrank);
  MPI_Comm_size(MPI_COMM_WORLD,&nprocs);
  if(nrank==ROOT) buf[0]=5, buf[1]=6, buf[2]=7, buf[3]=8;
  if(nrank==nprocs-1) buf2[0]=50, buf2[1]=60, buf2[2]=70, buf2[3]=80;
  printf("rank=%d, Before(buf): %d  %d  %d  %d\n",nrank,buf[0],buf[1],buf[2],buf[3]);
  MPI_Ibcast(buf2,4,MPI_INT,nprocs-1,MPI_COMM_WORLD,&req);
  MPI_Bcast(buf,4,MPI_INT, ROOT,MPI_COMM_WORLD);
  printf("rank=%d, After(buf): %d  %d  %d  %d\n",nrank,buf[0],buf[1],buf[2],buf[3]);
  MPI_Wait(&req,MPI_STATUS_IGNORE);
  printf("rank=%d, AFTER(BUF2): %d  %d  %d  %d\n",nrank,buf2[0],buf2[1],buf2[2],buf2[3]);
  MPI_Finalize();
  return 0;
}
