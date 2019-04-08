#include <stdio.h>
#include <mpi.h>
int main()
{
  int blengths[2]={2,3}, displacements[2]={0,4}, ibuf[20]={0,},myrank,i;
  MPI_Datatype new_type;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  MPI_Type_indexed(2,blengths,displacements,MPI_INT,&new_type);
  MPI_Type_commit(&new_type);
  if(myrank==0)
    for(i=0;i<20;i++) ibuf[i]=i+1;
  MPI_Bcast(ibuf,2,new_type,0,MPI_COMM_WORLD);
  printf("%d   ibuf=",myrank);
  for(i=0;i<20;i++) printf("%d ",ibuf[i]);
  printf("\nd");
  MPI_Type_free(&new_type);
  MPI_Finalize();
  return 0;
}
