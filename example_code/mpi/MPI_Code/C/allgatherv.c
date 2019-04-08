#include <stdio.h>
#include <mpi.h>
int main()
{
  int i,myrank,tmp;
  int isend[3],irecv[6];
  int iscnt,ircnt[3]={1,2,3}, idisp[3]={0,1,3};
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  for(i=0;i<myrank+1;i++) isend[i]=myrank+1;
  iscnt=myrank+1;
  MPI_Allgatherv(isend,iscnt,MPI_INT,irecv,ircnt,idisp,MPI_INT,MPI_COMM_WORLD);
  printf("myrank: %d    irecv=",myrank); 
  for(i=0;i<6;i++) printf("   %d",irecv[i]);
  printf("\n");

  tmp=(myrank+1)*10;
  if(myrank==0) irecv[0]=tmp;
  if(myrank==1) irecv[1]=irecv[2]=tmp;
  if(myrank==2) irecv[3]=irecv[4]=irecv[5]=tmp;
  MPI_Allgatherv(MPI_IN_PLACE,iscnt,MPI_INT,irecv,ircnt,idisp,MPI_INT,MPI_COMM_WORLD);
  printf("MYRANK: %d    IRECV=",myrank);
  for(i=0;i<6;i++) printf("   %d",irecv[i]);
  printf("\n");


  MPI_Finalize();
  return 0;
}
