#include <stdio.h>
#include <mpi.h>
int main()
{
  int isend,irecv[3]={0,},nrank;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&nrank);
  isend=nrank+1;
  printf("rank: %d, isend: %d\n",nrank,isend);
  MPI_Allgather(&isend,1,MPI_INT,irecv,1,MPI_INT,MPI_COMM_WORLD);
  printf("rank: %d, irecv= %d  %d  %d\n",nrank,irecv[0],irecv[1],irecv[2]);
  printf("\n");
  
  isend=(nrank+1)*10;
  irecv[nrank]=isend;
  MPI_Allgather(MPI_IN_PLACE,1,MPI_INT,irecv, 1,MPI_INT,MPI_COMM_WORLD);
  printf("rank: %d, irecv= %d  %d  %d\n",nrank,irecv[0],irecv[1],irecv[2]);
   MPI_Finalize() ;
  return 0;
}
