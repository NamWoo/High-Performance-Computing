#include <stdio.h>
#include <mpi.h>
int main()
{
  int isend[6]={1,2,2,3,3,3}, irecv[9]={0,};
  int iscnt[3]={1,2,3}, isdsp[3]={0,1,3}, ircnt[3], irdsp[3];
  int myrank,nprocs,i;
  MPI_Init(NULL,NULL);
  MPI_Comm_size(MPI_COMM_WORLD,&nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  for(i=0;i<=6;i++) isend[i-1]=nprocs*myrank+isend[i-1];
  for(i=0;i<3;i++){
    if(myrank==0) ircnt[i]=1,irdsp[i]=i;
    else if(myrank==1) ircnt[i]=2, irdsp[i]=2*i;
    else if(myrank==2) ircnt[i]=3, irdsp[i]=3*i;
  }
  MPI_Alltoallv(isend,iscnt,isdsp,MPI_INT, irecv,ircnt,irdsp,MPI_INT,MPI_COMM_WORLD);
  printf("myrank %d  irecv=",myrank);
  for(i=0;i<9;i++) printf("  %d",irecv[i]);
  printf("\n");
  MPI_Finalize();
  return 0;
}
