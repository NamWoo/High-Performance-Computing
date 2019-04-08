#include <stdio.h>
#include "mpi.h"
int main()
{
  int rank,i;
  struct{ int num;  float x; double data[4];} a;
  int blocklengths[3]={1,1,4};
  MPI_Datatype types[3]={MPI_INT, MPI_FLOAT, MPI_DOUBLE};
  MPI_Aint disps[3];
  MPI_Datatype restype;
  
  MPI_Init(NULL,NULL); 
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Get_address(&a.num,&disps[0]);
  MPI_Get_address(&a.x,&disps[1]);
  MPI_Get_address(&a.data,&disps[2]);
  disps[2]-=disps[0];   disps[1]-=disps[0];   disps[0] = (MPI_Aint)MPI_BOTTOM;
  MPI_Type_create_struct(3,blocklengths,disps,types,&restype);
  MPI_Type_commit(&restype);
  if(rank==0){
    a.num=6,   a.x=3.14;
    for(i=0;i<4;i++) a.data[i]=(double)i;
    MPI_Send(&a,1,restype,1,30,MPI_COMM_WORLD);
  }else if(rank==1){
    MPI_Recv(&a,1,restype,0,30,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
    printf("P: %d my a is %d %f %lf %lf %lf %lf\n", rank,a.num, a.x,\
           a.data[0],a.data[1], a.data[2], a.data[3]);
  }
  MPI_Type_free(&restype);
  MPI_Finalize();
  return 0;
}
