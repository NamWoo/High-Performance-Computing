#include <stdio.h>
#include "mpi.h"
#define ndims 2
int main()
{
  int ibuf[6][7];
  int arr_sizes[ndims]={6,7}, arr_subsizes[ndims]={2,5}, arr_starts[ndims]={1,1};
  int i,j, myrank;
  MPI_Datatype newtype;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0) {
    for(i=0;i<6;i++)
      for(j=0;j<7;j++) ibuf[i][j]=i+2;
  }else{
    for(i=0;i<6;i++)
      for(j=0;j<7;j++) ibuf[i][j]=0;
  }
  MPI_Type_create_subarray(ndims,arr_sizes,arr_subsizes,arr_starts,MPI_ORDER_C, \
                           MPI_INT,&newtype);
  MPI_Type_commit(&newtype);
  MPI_Bcast(ibuf,1,newtype,0,MPI_COMM_WORLD);
  if(myrank==1){
    for(i=0;i<6;i++){
      for(j=0;j<7;j++) printf(" %d",ibuf[i][j]);
      printf("\n");
   }
  }
  MPI_Type_free(&newtype);
  MPI_Finalize();
  return 0;
}
