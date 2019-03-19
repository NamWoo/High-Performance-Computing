#include <stdio.h>
#include "mpi.h"
int main()
{
  int i, myrank, ibuf[20]={0,};
  MPI_Datatype inewtype;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0) for(i=0;i<20;i++) ibuf[i]=i+1;
  MPI_Type_contiguous(3,MPI_INT,&inewtype);
  MPI_Type_commit(&inewtype);
  MPI_Bcast(ibuf,3,inewtype,0,MPI_COMM_WORLD);
  printf("%d: ibuf=",myrank);
  for(i=0;i<20;i++) printf(" %d",ibuf[i]);
  MPI_Type_free(&inewtype);
  printf("\n");
  MPI_Finalize();
  return 0;
}
