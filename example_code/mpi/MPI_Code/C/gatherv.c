#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
int main()
{
  int i,myrank;
  int isend[3],*irecv;
  int iscnt, ircnt[3]={1,2,3}, idisp[3]={0,1,3};
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0) irecv=(int*)malloc(6*sizeof(int));
  for(i=0;i<myrank+1;i++) isend[i]=myrank+1;
  iscnt=myrank+1;
  MPI_Gatherv(isend, iscnt,MPI_INT, irecv, ircnt,idisp,MPI_INT, 0, MPI_COMM_WORLD);
  if(myrank==0){
    printf("irecv="); for(i=0;i<6;i++) printf("   %d", irecv[i]);
    printf("\n");
  }

  for(i=0;i<myrank+1;i++) isend[i]=(myrank+1)*10;
  if(myrank==0){
    irecv[0]=isend[0];
    MPI_Gatherv(MPI_IN_PLACE,iscnt,MPI_INT,irecv,ircnt,idisp,MPI_INT,0,MPI_COMM_WORLD);
    printf("irecv="); for(i=0;i<6;i++) printf("   %d", irecv[i]);
    printf("\n");
    free(irecv);
  }
  else{
    MPI_Gatherv(isend,iscnt,MPI_INT, irecv,ircnt,idisp,MPI_INT,0,MPI_COMM_WORLD);
  }
  MPI_Finalize();
  return 0;
}
