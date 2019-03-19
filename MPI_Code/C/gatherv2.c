#include <stdio.h>
#include <mpi.h>
int main()
{
  int isend[6]={0,}, ircnt[3]={1,2,3}, idisp[3]={0,1,3};
  int i,iscnt,myrank;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  for(i=0;i<myrank+1;i++) isend[i]=myrank+1;
  printf("myrank: %d   isend=",myrank);
  for(i=0;i<6;i++) printf("  %d",isend[i]);
  printf("\n");

  iscnt=myrank+1;
  if(myrank==0) {
    MPI_Gatherv(MPI_IN_PLACE,iscnt,MPI_INT,isend,ircnt,idisp,MPI_INT,0,MPI_COMM_WORLD);
    printf("\nMYRANK: %d   ISEND=",myrank);
    for(i=0;i<6;i++) printf("  %d",isend[i]);
    printf("\n");
  }else MPI_Gatherv(isend,iscnt,MPI_INT,isend,ircnt,idisp,MPI_INT,0,MPI_COMM_WORLD);
  
  MPI_Finalize();
  return 0;
}
