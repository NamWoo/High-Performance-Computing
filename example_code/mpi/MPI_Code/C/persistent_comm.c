#include <stdio.h>
#include <mpi.h>
int main()
{
  int myrank, A[5], B[5], i,j;
  MPI_Request ireq[2];
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
  MPI_Send_init(A,5,MPI_INT,1,1,MPI_COMM_WORLD, &ireq[0]);
  MPI_Recv_init(B,5,MPI_INT,0,1,MPI_COMM_WORLD, &ireq[1]);
  for(i=0;i<5;i++){  A[i]=0, B[i]=0; }
  for(i=0;i<10;i++){
    if(myrank==0){
      for(j=0;j<5;j++) A[j]=A[j]+1;
    }
    if(myrank==0 || myrank==1) MPI_Start(&ireq[myrank]);
    // COMPUTING...
    MPI_Waitall(2,ireq,MPI_STATUSES_IGNORE);
   if(myrank==1) printf("i=%d, B= %d %d %d %d %d\n",i,B[0],B[1],B[2],B[3],B[4]);
  }
  MPI_Finalize();
  return 0;
}

