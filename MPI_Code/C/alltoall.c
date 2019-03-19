#include <stdio.h>
#include <mpi.h>
int main()
{
  int isend[3],irecv[3];
  int i,nprocs,myrank;
  MPI_Init(NULL,NULL);
  MPI_Comm_size(MPI_COMM_WORLD,&nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  for(i=0;i<nprocs;i++) isend[i]=1+i+nprocs*myrank;
  printf("myrank:%d  isend=%d  %d  %d\n",myrank,isend[0],isend[1],isend[2]);
  MPI_Alltoall(isend,1,MPI_INT, irecv,1,MPI_INT,MPI_COMM_WORLD);
  printf("myrank:%d  irecv=%d  %d  %d\n",myrank,irecv[0],irecv[1],irecv[2]);

  for(i=0;i<3;i++) irecv[i]=isend[i];
  MPI_Alltoall(MPI_IN_PLACE,1,MPI_INTEGER,irecv,1,MPI_INTEGER,MPI_COMM_WORLD);
  printf("MYRANK:%d  IRECV=%d  %d  %d\n",myrank,irecv[0],irecv[1],irecv[2]);
  MPI_Finalize();
  return 0;
}
