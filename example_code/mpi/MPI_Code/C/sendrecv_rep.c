#include <stdio.h>
#include <mpi.h>
int main()
{
  int myrank, a,inext,iprev,i;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  a=myrank+1;
  inext=myrank+1,  iprev=myrank-1;
  if(myrank==0) iprev=3;
  if(myrank==3) inext=0;
  for(i=0;i<4;i++)
    if(myrank==i) printf("Before myrank: %d, a=%d\n",myrank,a);
  
  MPI_Sendrecv_replace(&a,1,MPI_INT, inext, 0, iprev, 0, MPI_COMM_WORLD,MPI_STATUS_IGNORE);
  for(i=0;i<4;i++)
    if(myrank==i) printf("After myrank: %d, a=%d\n",myrank,a);
  MPI_Finalize();
  return 0;
}
