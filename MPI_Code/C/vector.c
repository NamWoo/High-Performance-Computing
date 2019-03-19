#include <stdio.h>
#include <mpi.h>
int main()
{
  int ibuf[20]={0,}, myrank, i;
  MPI_Datatype inewtype;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0) 
    for(i=0;i<20;i++) ibuf[i]=i+1;
  MPI_Type_vector(4,2,3,MPI_INT,&inewtype);
  MPI_Type_commit(&inewtype);
  MPI_Bcast(ibuf,1,inewtype,0,MPI_COMM_WORLD);
  printf("%d,  ibuf=",myrank);
  for(i=0;i<20;i++) printf(" %d",ibuf[i]);
  printf("\n");
  MPI_Type_free(&inewtype);
  MPI_Finalize();
  return 0;
}
