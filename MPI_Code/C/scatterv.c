#include <stdio.h>
#include <mpi.h>
int main()
{
  int i, myrank;
  int isend[6]={1,2,2,3,3,3}, irecv[3]={0,};
  int isndcnt[3]={1,2,3}, idisp[3]={0,1,3};
  int rcvcnt;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  rcvcnt=myrank+1;
  MPI_Scatterv(isend,isndcnt,idisp, MPI_INT, irecv, rcvcnt,MPI_INT, 0, MPI_COMM_WORLD);
  printf("rank : %d    irecv=",myrank);
  for(i=0;i<3;i++) printf("%d ",irecv[i]);
  printf("\n");

  for(i=0;i<3;i++) irecv[i]=0;
  if(myrank==0){
    isend[0]=10, isend[1]=20, isend[2]=20;
    isend[3]=30, isend[4]=30, isend[5]=30;
    irecv[0]=isend[0];
    MPI_Scatterv(isend,isndcnt,idisp,MPI_INT,MPI_IN_PLACE,rcvcnt,MPI_INT,0,MPI_COMM_WORLD);
  }
  else{
    MPI_Scatterv(isend,isndcnt,idisp, MPI_INT, irecv, rcvcnt,MPI_INT, 0, MPI_COMM_WORLD);
  }
  printf("RANK : %d    IRECV=",myrank);
  for(i=0;i<3;i++) printf("%d ",irecv[i]);
  printf("\n");

  MPI_Finalize();
  return 0;
}
