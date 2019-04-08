#include <stdio.h>
#include <mpi.h>
int main()
{
  int isend[6]={0,}, isndcnt[3]={1,2,3}, idisp[3]={0,1,3};
  int rcvcnt,myrank,i;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  rcvcnt=myrank+1;
  if(myrank==0){
    isend[0]=1,  isend[1]=2,  isend[2]=2;
    isend[3]=3,  isend[4]=3,  isend[5]=3;
  }
  printf("rank: %d  isend=",myrank);
  for(i=0;i<6;i++) printf("  %d",isend[i]);
  printf("\n");
  if(myrank==0){
    MPI_Scatterv(isend,isndcnt,idisp,MPI_INT,MPI_IN_PLACE,rcvcnt,MPI_INT,0,MPI_COMM_WORLD);
  }
  else{
    MPI_Scatterv(isend,isndcnt,idisp,MPI_INT,&isend[idisp[myrank]],rcvcnt,MPI_INT,0,MPI_COMM_WORLD);
  }
  printf("RANK: %d  ISEND=",myrank);
  for(i=0;i<6;i++) printf("  %d",isend[i]);
  printf("\n");

  MPI_Finalize();
  return 0;
}
